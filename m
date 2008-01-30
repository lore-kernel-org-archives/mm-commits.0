From: akpm@linux-foundation.org
Subject: + udf-fix-adding-entry-to-a-directory.patch added to -mm tree
Date: Wed, 30 Jan 2008 14:53:09 -0800
Message-ID: <200801302253.m0UMr95I028833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754446AbYA3Wxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 17:53:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     udf: fix adding entry to a directory
has been added to the -mm tree.  Its filename is
     udf-fix-adding-entry-to-a-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
jbd-fix-commit-block-write.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
use-pgoff_t-instead-of-unsigned-long.patch
write_inode_now-avoid-unnecessary-synchronous-write.patch
udf-fix-coding-style-of-superc.patch
udf-remove-some-ugly-macros.patch
udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
udf-check-if-udf_load_logicalvol-failed.patch
udf-convert-macros-related-to-bitmaps-to-functions.patch
udf-move-calculating-of-nr_groups-into-helper-function.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
udf-fix-coding-style.patch
udf-create-common-function-for-tag-checksumming.patch
udf-create-common-function-for-changing-free-space-counter.patch
udf-replace-loops-coded-with-goto-to-real-loops.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
udf-improve-readability-of-udf_load_partition.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-avoid-unnecessary-synchronous-writes.patch
udf-cleanup-directory-offset-handling.patch
udf-fix-adding-entry-to-a-directory.patch
change-udf-maintainer.patch
isofs-implement-dmode-option.patch
mount-options-fix-ext2.patch
mount-options-fix-isofs.patch
mount-options-fix-udf.patch
