From: akpm@linux-foundation.org
Subject: - fix-possible-leakage-of-blocks-in-udf.patch removed from -mm tree
Date: Fri, 01 Jun 2007 22:44:16 -0700
Message-ID: <200706020544.l525iKGC011749@smtp2.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbXFBFol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 2 Jun 2007 01:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     udf: Fix possible leakage of blocks
has been removed from the -mm tree.  Its filename was
     fix-possible-leakage-of-blocks-in-udf.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: udf: Fix possible leakage of blocks
From: Jan Kara <jack@suse.cz>

It is wrong to call udf_discard_prealloc() from udf_clear_inode() as at that
time inode changes won't be written any more which can lead to leakage of
blocks, use of free blocks or improperly aligned extents.

Also udf_discard_prealloc() does two exactly match i_size.  We move the latter
functionality to udf_truncate_tail_extent(), call udf_discard_prealloc() when
last reference to a file is dropped and call udf_truncate_tail_extent() when
inode is being removed from inode cach (udf_drop_inode() call).  We cannot
call udf_truncate_tail_extent() earlier as subsequent open+write would find
the last block of the file mapped and happily write to the end of it, although
the last extent says it's shorter.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/inode.c    |    8 +++--
 fs/udf/super.c    |    1 
 fs/udf/truncate.c |   70 +++++++++++++++++++++++++++++++++++++-------
 fs/udf/udfdecl.h  |    2 +
 4 files changed, 68 insertions(+), 13 deletions(-)

diff -puN fs/udf/inode.c~fix-possible-leakage-of-blocks-in-udf fs/udf/inode.c
--- a/fs/udf/inode.c~fix-possible-leakage-of-blocks-in-udf
+++ a/fs/udf/inode.c
@@ -100,14 +100,18 @@ no_delete:
 	clear_inode(inode);
 }
 
-void udf_clear_inode(struct inode *inode)
+void udf_drop_inode(struct inode *inode)
 {
 	if (!(inode->i_sb->s_flags & MS_RDONLY)) {
 		lock_kernel();
-		udf_discard_prealloc(inode);
+		udf_truncate_tail_extent(inode);
 		unlock_kernel();
 	}
+	generic_drop_inode(inode);
+}
 
+void udf_clear_inode(struct inode *inode)
+{
 	kfree(UDF_I_DATA(inode));
 	UDF_I_DATA(inode) = NULL;
 }
diff -puN fs/udf/super.c~fix-possible-leakage-of-blocks-in-udf fs/udf/super.c
--- a/fs/udf/super.c~fix-possible-leakage-of-blocks-in-udf
+++ a/fs/udf/super.c
@@ -162,6 +162,7 @@ static const struct super_operations udf
 	.write_inode		= udf_write_inode,
 	.delete_inode		= udf_delete_inode,
 	.clear_inode		= udf_clear_inode,
+	.drop_inode		= udf_drop_inode,
 	.put_super		= udf_put_super,
 	.write_super		= udf_write_super,
 	.statfs			= udf_statfs,
diff -puN fs/udf/truncate.c~fix-possible-leakage-of-blocks-in-udf fs/udf/truncate.c
--- a/fs/udf/truncate.c~fix-possible-leakage-of-blocks-in-udf
+++ a/fs/udf/truncate.c
@@ -61,7 +61,11 @@ static void extent_trunc(struct inode * 
 	}
 }
 
-void udf_discard_prealloc(struct inode * inode)
+/*
+ * Truncate the last extent to match i_size. This function assumes
+ * that preallocation extent is already truncated.
+ */
+void udf_truncate_tail_extent(struct inode *inode)
 {
 	struct extent_position epos = { NULL, 0, {0, 0}};
 	kernel_lb_addr eloc;
@@ -71,7 +75,7 @@ void udf_discard_prealloc(struct inode *
 	int adsize;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB ||
-		inode->i_size == UDF_I_LENEXTENTS(inode))
+	    inode->i_size == UDF_I_LENEXTENTS(inode))
 		return;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_SHORT)
@@ -79,25 +83,69 @@ void udf_discard_prealloc(struct inode *
 	else if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
-		adsize = 0;
-
-	epos.block = UDF_I_LOCATION(inode);
+		BUG();
 
 	/* Find the last extent in the file */
 	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1)
 	{
 		etype = netype;
 		lbcount += elen;
-		if (lbcount > inode->i_size && lbcount - elen < inode->i_size)
-		{
-			WARN_ON(lbcount - inode->i_size >= inode->i_sb->s_blocksize);
+		if (lbcount > inode->i_size) {
+			if (lbcount - inode->i_size >= inode->i_sb->s_blocksize)
+				printk(KERN_WARNING "udf_truncate_tail_extent()"
+					": Too long extent after EOF in inode "
+					"%u: i_size: %Ld lbcount: %Ld extent "
+					"%u+%u\n",
+					(unsigned)inode->i_ino,
+					(long long)inode->i_size,
+					(long long)lbcount,
+					(unsigned)eloc.logicalBlockNum,
+					(unsigned)elen);
 			nelen = elen - (lbcount - inode->i_size);
 			epos.offset -= adsize;
 			extent_trunc(inode, &epos, eloc, etype, elen, nelen);
 			epos.offset += adsize;
-			lbcount = inode->i_size;
+			if (udf_next_aext(inode, &epos, &eloc, &elen, 1) != -1)
+				printk(KERN_ERR "udf_truncate_tail_extent(): "
+					"Extent after EOF in inode %u.\n",
+					(unsigned)inode->i_ino);
+			break;
 		}
 	}
+	/* This inode entry is in-memory only and thus we don't have to mark
+	 * the inode dirty */
+	UDF_I_LENEXTENTS(inode) = inode->i_size;
+	brelse(epos.bh);
+}
+
+void udf_discard_prealloc(struct inode * inode)
+{
+	struct extent_position epos = { NULL, 0, {0, 0}};
+	kernel_lb_addr eloc;
+	uint32_t elen;
+	uint64_t lbcount = 0;
+	int8_t etype = -1, netype;
+	int adsize;
+
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB ||
+		inode->i_size == UDF_I_LENEXTENTS(inode))
+		return;
+
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_SHORT)
+		adsize = sizeof(short_ad);
+	else if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_LONG)
+		adsize = sizeof(long_ad);
+	else
+		adsize = 0;
+
+	epos.block = UDF_I_LOCATION(inode);
+
+	/* Find the last extent in the file */
+	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1)
+	{
+		etype = netype;
+		lbcount += elen;
+	}
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 		epos.offset -= adsize;
 		lbcount -= elen;
@@ -118,9 +166,9 @@ void udf_discard_prealloc(struct inode *
 			mark_buffer_dirty_inode(epos.bh, inode);
 		}
 	}
+	/* This inode entry is in-memory only and thus we don't have to mark
+	 * the inode dirty */
 	UDF_I_LENEXTENTS(inode) = lbcount;
-
-	WARN_ON(lbcount != inode->i_size);
 	brelse(epos.bh);
 }
 
diff -puN fs/udf/udfdecl.h~fix-possible-leakage-of-blocks-in-udf fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~fix-possible-leakage-of-blocks-in-udf
+++ a/fs/udf/udfdecl.h
@@ -103,6 +103,7 @@ extern struct buffer_head * udf_bread(st
 extern void udf_truncate(struct inode *);
 extern void udf_read_inode(struct inode *);
 extern void udf_delete_inode(struct inode *);
+extern void udf_drop_inode(struct inode *);
 extern void udf_clear_inode(struct inode *);
 extern int udf_write_inode(struct inode *, int);
 extern long udf_block_map(struct inode *, sector_t);
@@ -146,6 +147,7 @@ extern void udf_free_inode(struct inode 
 extern struct inode * udf_new_inode (struct inode *, int, int *);
 
 /* truncate.c */
+extern void udf_truncate_tail_extent(struct inode *);
 extern void udf_discard_prealloc(struct inode *);
 extern void udf_truncate_extents(struct inode *);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fix-possible-leakage-of-blocks-in-udf.patch
ext2-fix-a-comment-when-ext2_release_file-is-called.patch
