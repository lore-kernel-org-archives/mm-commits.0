From: akpm@linux-foundation.org
Subject: + udf-cleanup-directory-offset-handling.patch added to -mm tree
Date: Wed, 30 Jan 2008 14:53:07 -0800
Message-ID: <200801302253.m0UMr713028830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544AbYA3Wxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 17:53:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     udf: cleanup directory offset handling
has been added to the -mm tree.  Its filename is
     udf-cleanup-directory-offset-handling.patch

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
Subject: udf: cleanup directory offset handling
From: Jan Kara <jack@suse.cz>

Position in directory returned by readdir is offset of directory entry divided
by four (don't ask me why).  Make this conversion only when reading f_pos from
userspace / writing it there and internally work in bytes.  It makes things
more easily readable and also fixes a bug (we forgot to divide length of the
entry by 4 when advancing f_pos in udf_add_entry()).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/directory.c |    7 +++----
 fs/udf/inode.c     |    8 ++++----
 fs/udf/namei.c     |   39 +++++++++++++++++----------------------
 3 files changed, 24 insertions(+), 30 deletions(-)

diff -puN fs/udf/directory.c~udf-cleanup-directory-offset-handling fs/udf/directory.c
--- a/fs/udf/directory.c~udf-cleanup-directory-offset-handling
+++ a/fs/udf/directory.c
@@ -95,7 +95,7 @@ struct fileIdentDesc *udf_fileident_read
 		if (!fi)
 			return NULL;
 
-		*nf_pos += ((fibh->eoffset - fibh->soffset) >> 2);
+		*nf_pos += fibh->eoffset - fibh->soffset;
 
 		memcpy((uint8_t *)cfi, (uint8_t *)fi,
 		       sizeof(struct fileIdentDesc));
@@ -157,7 +157,7 @@ struct fileIdentDesc *udf_fileident_read
 	if (!fi)
 		return NULL;
 
-	*nf_pos += ((fibh->eoffset - fibh->soffset) >> 2);
+	*nf_pos += fibh->eoffset - fibh->soffset;
 
 	if (fibh->eoffset <= dir->i_sb->s_blocksize) {
 		memcpy((uint8_t *)cfi, (uint8_t *)fi,
@@ -197,8 +197,7 @@ struct fileIdentDesc *udf_fileident_read
 				  cfi->lengthFileIdent +
 				  le16_to_cpu(cfi->lengthOfImpUse) + 3) & ~3;
 
-			*nf_pos += (fi_len - (fibh->eoffset - fibh->soffset))
-					>> 2;
+			*nf_pos += fi_len - (fibh->eoffset - fibh->soffset);
 			fibh->eoffset = fibh->soffset + fi_len;
 		} else {
 			memcpy((uint8_t *)cfi, (uint8_t *)fi,
diff -puN fs/udf/inode.c~udf-cleanup-directory-offset-handling fs/udf/inode.c
--- a/fs/udf/inode.c~udf-cleanup-directory-offset-handling
+++ a/fs/udf/inode.c
@@ -219,8 +219,8 @@ struct buffer_head *udf_expand_dir_adini
 	struct extent_position epos;
 
 	struct udf_fileident_bh sfibh, dfibh;
-	loff_t f_pos = udf_ext0_offset(inode) >> 2;
-	int size = (udf_ext0_offset(inode) + inode->i_size) >> 2;
+	loff_t f_pos = udf_ext0_offset(inode);
+	int size = udf_ext0_offset(inode) + inode->i_size;
 	struct fileIdentDesc cfi, *sfi, *dfi;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
@@ -256,11 +256,11 @@ struct buffer_head *udf_expand_dir_adini
 	mark_buffer_dirty_inode(dbh, inode);
 
 	sfibh.soffset = sfibh.eoffset =
-			(f_pos & ((inode->i_sb->s_blocksize - 1) >> 2)) << 2;
+			f_pos & (inode->i_sb->s_blocksize - 1);
 	sfibh.sbh = sfibh.ebh = NULL;
 	dfibh.soffset = dfibh.eoffset = 0;
 	dfibh.sbh = dfibh.ebh = dbh;
-	while ((f_pos < size)) {
+	while (f_pos < size) {
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL,
 					 NULL, NULL, NULL);
diff -puN fs/udf/namei.c~udf-cleanup-directory-offset-handling fs/udf/namei.c
--- a/fs/udf/namei.c~udf-cleanup-directory-offset-handling
+++ a/fs/udf/namei.c
@@ -160,14 +160,13 @@ static struct fileIdentDesc *udf_find_en
 	struct extent_position epos = {};
 	struct udf_inode_info *dinfo = UDF_I(dir);
 
-	size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
-	f_pos = (udf_ext0_offset(dir) >> 2);
+	size = udf_ext0_offset(dir) + dir->i_size;
+	f_pos = udf_ext0_offset(dir);
 
-	fibh->soffset = fibh->eoffset =
-		(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh->soffset = fibh->eoffset = f_pos & (dir->i_sb->s_blocksize - 1);
 	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	else if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
@@ -189,7 +188,7 @@ static struct fileIdentDesc *udf_find_en
 		return NULL;
 	}
 
-	while ((f_pos < size)) {
+	while (f_pos < size) {
 		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc,
 					&elen, &offset);
 		if (!fi) {
@@ -342,7 +341,7 @@ static struct fileIdentDesc *udf_add_ent
 	loff_t f_pos;
 	int flen;
 	char *nameptr;
-	loff_t size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
+	loff_t size = udf_ext0_offset(dir) + dir->i_size;
 	int nfidlen;
 	uint8_t lfi;
 	uint16_t liu;
@@ -370,14 +369,13 @@ static struct fileIdentDesc *udf_add_ent
 
 	nfidlen = (sizeof(struct fileIdentDesc) + namelen + 3) & ~3;
 
-	f_pos = (udf_ext0_offset(dir) >> 2);
+	f_pos = udf_ext0_offset(dir);
 
-	fibh->soffset = fibh->eoffset =
-			(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh->soffset = fibh->eoffset = f_pos & (dir->i_sb->s_blocksize - 1);
 	dinfo = UDF_I(dir);
 	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	else if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
@@ -405,7 +403,7 @@ static struct fileIdentDesc *udf_add_ent
 		goto add;
 	}
 
-	while ((f_pos < size)) {
+	while (f_pos < size) {
 		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc,
 					&elen, &offset);
 
@@ -484,7 +482,7 @@ add:
 		epos.bh = NULL;
 		fibh->soffset -= udf_ext0_offset(dir);
 		fibh->eoffset -= udf_ext0_offset(dir);
-		f_pos -= (udf_ext0_offset(dir) >> 2);
+		f_pos -= udf_ext0_offset(dir);
 		if (fibh->sbh != fibh->ebh)
 			brelse(fibh->ebh);
 		brelse(fibh->sbh);
@@ -537,8 +535,7 @@ add:
 		block = eloc.logicalBlockNum + ((elen - 1) >>
 						dir->i_sb->s_blocksize_bits);
 		fibh->ebh = udf_bread(dir,
-				f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-				1, err);
+				f_pos >> dir->i_sb->s_blocksize_bits, 1, err);
 		if (!fibh->ebh) {
 			brelse(epos.bh);
 			brelse(fibh->sbh);
@@ -775,7 +772,7 @@ static int empty_dir(struct inode *dir)
 	struct fileIdentDesc *fi, cfi;
 	struct udf_fileident_bh fibh;
 	loff_t f_pos;
-	loff_t size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
+	loff_t size = udf_ext0_offset(dir) + dir->i_size;
 	int block;
 	kernel_lb_addr eloc;
 	uint32_t elen;
@@ -783,14 +780,12 @@ static int empty_dir(struct inode *dir)
 	struct extent_position epos = {};
 	struct udf_inode_info *dinfo = UDF_I(dir);
 
-	f_pos = (udf_ext0_offset(dir) >> 2);
-
-	fibh.soffset = fibh.eoffset =
-			(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	f_pos = udf_ext0_offset(dir);
+	fibh.soffset = fibh.eoffset = f_pos & (dir->i_sb->s_blocksize - 1);
 
 	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh.sbh = fibh.ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	else if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
@@ -812,7 +807,7 @@ static int empty_dir(struct inode *dir)
 		return 0;
 	}
 
-	while ((f_pos < size)) {
+	while (f_pos < size) {
 		fi = udf_fileident_read(dir, &f_pos, &fibh, &cfi, &epos, &eloc,
 					&elen, &offset);
 		if (!fi) {
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
