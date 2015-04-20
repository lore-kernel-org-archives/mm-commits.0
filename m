From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:18:49 -0700
Message-ID: <55355119.X2unfdtma2XAA5SS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbDTTM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add helper to find existent block on metadata file
has been removed from the -mm tree.  Its filename was
     nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: add helper to find existent block on metadata file

Add a new metadata file function, nilfs_mdt_find_block(), which finds
an existent block on a metadata file in a given range of blocks.  This
function skips continuous hole blocks efficiently by using
nilfs_bmap_seek_key().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/mdt.h |    3 ++
 2 files changed, 57 insertions(+)

diff -puN fs/nilfs2/mdt.c~nilfs2-add-helper-to-find-existent-block-on-metadata-file fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-add-helper-to-find-existent-block-on-metadata-file
+++ a/fs/nilfs2/mdt.c
@@ -261,6 +261,60 @@ int nilfs_mdt_get_block(struct inode *in
 }
 
 /**
+ * nilfs_mdt_find_block - find and get a buffer on meta data file.
+ * @inode: inode of the meta data file
+ * @start: start block offset (inclusive)
+ * @end: end block offset (inclusive)
+ * @blkoff: block offset
+ * @out_bh: place to store a pointer to buffer_head struct
+ *
+ * nilfs_mdt_find_block() looks up an existing block in range of
+ * [@start, @end] and stores pointer to a buffer head of the block to
+ * @out_bh, and block offset to @blkoff, respectively.  @out_bh and
+ * @blkoff are substituted only when zero is returned.
+ *
+ * Return Value: On success, it returns 0. On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOENT - no block was found in the range
+ */
+int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
+			 unsigned long end, unsigned long *blkoff,
+			 struct buffer_head **out_bh)
+{
+	__u64 next;
+	int ret;
+
+	if (unlikely(start > end))
+		return -ENOENT;
+
+	ret = nilfs_mdt_read_block(inode, start, true, out_bh);
+	if (!ret) {
+		*blkoff = start;
+		goto out;
+	}
+	if (unlikely(ret != -ENOENT || start == ULONG_MAX))
+		goto out;
+
+	ret = nilfs_bmap_seek_key(NILFS_I(inode)->i_bmap, start + 1, &next);
+	if (!ret) {
+		if (next <= end) {
+			ret = nilfs_mdt_read_block(inode, next, true, out_bh);
+			if (!ret)
+				*blkoff = next;
+		} else {
+			ret = -ENOENT;
+		}
+	}
+out:
+	return ret;
+}
+
+/**
  * nilfs_mdt_delete_block - make a hole on the meta data file.
  * @inode: inode of the meta data file
  * @block: block offset
diff -puN fs/nilfs2/mdt.h~nilfs2-add-helper-to-find-existent-block-on-metadata-file fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~nilfs2-add-helper-to-find-existent-block-on-metadata-file
+++ a/fs/nilfs2/mdt.h
@@ -78,6 +78,9 @@ int nilfs_mdt_get_block(struct inode *,
 			void (*init_block)(struct inode *,
 					   struct buffer_head *, void *),
 			struct buffer_head **);
+int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
+			 unsigned long end, unsigned long *blkoff,
+			 struct buffer_head **out_bh);
 int nilfs_mdt_delete_block(struct inode *, unsigned long);
 int nilfs_mdt_forget_block(struct inode *, unsigned long);
 int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

