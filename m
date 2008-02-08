From: akpm@linux-foundation.org
Subject: - udf-fix-adding-entry-to-a-directory.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:55 -0800
Message-ID: <200802082017.m18KHaB6010840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbYBHUqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:46:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: fix adding entry to a directory
has been removed from the -mm tree.  Its filename was
     udf-fix-adding-entry-to-a-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: fix adding entry to a directory
From: Jan Kara <jack@suse.cz>

When adding directory entry to a directory, we have to properly increase
length of the last extent.  Handle this similarly as extending regular files -
make extents always have size multiple of block size (it will be truncated
down to proper size in udf_clear_inode()).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/inode.c |    2 +-
 fs/udf/namei.c |   19 ++++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff -puN fs/udf/inode.c~udf-fix-adding-entry-to-a-directory fs/udf/inode.c
--- a/fs/udf/inode.c~udf-fix-adding-entry-to-a-directory
+++ a/fs/udf/inode.c
@@ -289,7 +289,7 @@ struct buffer_head *udf_expand_dir_adini
 	eloc.logicalBlockNum = *block;
 	eloc.partitionReferenceNum =
 				iinfo->i_location.partitionReferenceNum;
-	elen = inode->i_size;
+	elen = inode->i_sb->s_blocksize;
 	iinfo->i_lenExtents = elen;
 	epos.bh = NULL;
 	epos.block = iinfo->i_location;
diff -puN fs/udf/namei.c~udf-fix-adding-entry-to-a-directory fs/udf/namei.c
--- a/fs/udf/namei.c~udf-fix-adding-entry-to-a-directory
+++ a/fs/udf/namei.c
@@ -395,7 +395,6 @@ static struct fileIdentDesc *udf_add_ent
 		}
 
 		block = dinfo->i_location.logicalBlockNum;
-
 	} else {
 		block = udf_get_lb_pblock(dir->i_sb, dinfo->i_location, 0);
 		fibh->sbh = fibh->ebh = NULL;
@@ -474,6 +473,14 @@ static struct fileIdentDesc *udf_add_ent
 	}
 
 add:
+	if (dinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
+		elen = (elen + sb->s_blocksize - 1) & ~(sb->s_blocksize - 1);
+		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+			epos.offset -= sizeof(short_ad);
+		else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+			epos.offset -= sizeof(long_ad);
+		udf_write_aext(dir, &epos, eloc, elen, 1);
+	}
 	f_pos += nfidlen;
 
 	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB &&
@@ -491,15 +498,9 @@ add:
 		if (!fibh->sbh)
 			return NULL;
 		epos.block = dinfo->i_location;
-		eloc.logicalBlockNum = block;
-		eloc.partitionReferenceNum =
-				dinfo->i_location.partitionReferenceNum;
-		elen = dir->i_sb->s_blocksize;
 		epos.offset = udf_file_entry_alloc_offset(dir);
-		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-			epos.offset += sizeof(short_ad);
-		else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-			epos.offset += sizeof(long_ad);
+		/* Load extent udf_expand_dir_adinicb() has created */
+		udf_current_aext(dir, &epos, &eloc, &elen, 1);
 	}
 
 	if (sb->s_blocksize - fibh->eoffset >= nfidlen) {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
