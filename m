Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A709C1442F4
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 06:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161819; cv=none; b=uYOPBHr2eMft78yVnGJe9mgZHpdRxKcitufI1Srm+Yxwp7eBYi/fA522U9fy6tQyGjFrN+GtKPO6aeEDbOVkMWzotxnYyte75zChEXFidxsZ6tg3K18C+MVAT8ZW/ls2G3xDfwUpjZUOIOrR8vntY23hiNGhPFK/AAaEq5bLQZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161819; c=relaxed/simple;
	bh=bMfMxx5ntSHgF8E4BEpkOWjtvF8QmkBm/04G7BLvx80=;
	h=Date:To:From:Subject:Message-Id; b=jcepGGc2Z19Qmo8DYeV4KzW2mTKoeC0T0iqAZw/tvYquEnHZ9Bhe9kEVsm3PpTsrLzdxdEtGO2NjWfM/pxwOozMxuF9X3dNsJHyVXP/HSzJODEbvhNy1ialJvCR25bG+jL3dnhfCkJuvrRbVKL0fWLaZrEB2TsHnwJY93/WBMPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLsnKvgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLsnKvgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5BDC116B1;
	Fri,  5 Jul 2024 06:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720161819;
	bh=bMfMxx5ntSHgF8E4BEpkOWjtvF8QmkBm/04G7BLvx80=;
	h=Date:To:From:Subject:From;
	b=HLsnKvgHSSM3Es7Nu5NA4N7rbwhimGNNEAOyJ6hbYBh+K/XEHnEIYi8BL4+tKCt+g
	 fADheMgoDuiT09TA/Cr82AjB3xk0l/JGyYOZ/4W73i9RfILuqMqy7rmL3E18nXFyr8
	 PcR9xIAPqU9fECHceWC0wLpNSxjEd6j3pujpafJ8=
Date: Thu, 04 Jul 2024 23:43:38 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,llfamsec@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-bounds-checking-to-ocfs2_check_dir_entry.patch removed from -mm tree
Message-Id: <20240705064339.6D5BDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add bounds checking to ocfs2_check_dir_entry()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-bounds-checking-to-ocfs2_check_dir_entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: lei lu <llfamsec@gmail.com>
Subject: ocfs2: add bounds checking to ocfs2_check_dir_entry()
Date: Wed, 26 Jun 2024 18:44:33 +0800

This adds sanity checks for ocfs2_dir_entry to make sure all members of
ocfs2_dir_entry don't stray beyond valid memory region.

Link: https://lkml.kernel.org/r/20240626104433.163270-1-llfamsec@gmail.com
Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-add-bounds-checking-to-ocfs2_check_dir_entry
+++ a/fs/ocfs2/dir.c
@@ -294,13 +294,16 @@ out:
  * bh passed here can be an inode block or a dir data block, depending
  * on the inode inline data flag.
  */
-static int ocfs2_check_dir_entry(struct inode * dir,
-				 struct ocfs2_dir_entry * de,
-				 struct buffer_head * bh,
+static int ocfs2_check_dir_entry(struct inode *dir,
+				 struct ocfs2_dir_entry *de,
+				 struct buffer_head *bh,
+				 char *buf,
+				 unsigned int size,
 				 unsigned long offset)
 {
 	const char *error_msg = NULL;
 	const int rlen = le16_to_cpu(de->rec_len);
+	const unsigned long next_offset = ((char *) de - buf) + rlen;
 
 	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
@@ -308,9 +311,11 @@ static int ocfs2_check_dir_entry(struct
 		error_msg = "rec_len % 4 != 0";
 	else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
 		error_msg = "rec_len is too small for name_len";
-	else if (unlikely(
-		 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
-		error_msg = "directory entry across blocks";
+	else if (unlikely(next_offset > size))
+		error_msg = "directory entry overrun";
+	else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
+		 next_offset != size)
+		error_msg = "directory entry too close to end";
 
 	if (unlikely(error_msg != NULL))
 		mlog(ML_ERROR, "bad entry in directory #%llu: %s - "
@@ -352,16 +357,17 @@ static inline int ocfs2_search_dirblock(
 	de_buf = first_de;
 	dlimit = de_buf + bytes;
 
-	while (de_buf < dlimit) {
+	while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
 
 		de = (struct ocfs2_dir_entry *) de_buf;
 
-		if (de_buf + namelen <= dlimit &&
+		if (de->name + namelen <= dlimit &&
 		    ocfs2_match(namelen, name, de)) {
 			/* found a match - just to be sure, do a full check */
-			if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
+			if (!ocfs2_check_dir_entry(dir, de, bh, first_de,
+						   bytes, offset)) {
 				ret = -1;
 				goto bail;
 			}
@@ -1138,7 +1144,7 @@ static int __ocfs2_delete_entry(handle_t
 	pde = NULL;
 	de = (struct ocfs2_dir_entry *) first_de;
 	while (i < bytes) {
-		if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
+		if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
 			status = -EIO;
 			mlog_errno(status);
 			goto bail;
@@ -1635,7 +1641,8 @@ int __ocfs2_add_entry(handle_t *handle,
 		/* These checks should've already been passed by the
 		 * prepare function, but I guess we can leave them
 		 * here anyway. */
-		if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start,
+					   size, offset)) {
 			retval = -ENOENT;
 			goto bail;
 		}
@@ -1774,7 +1781,8 @@ static int ocfs2_dir_foreach_blk_id(stru
 		}
 
 		de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
-		if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
+		if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
+					   i_size_read(inode), ctx->pos)) {
 			/* On error, skip the f_pos to the end. */
 			ctx->pos = i_size_read(inode);
 			break;
@@ -1867,7 +1875,8 @@ static int ocfs2_dir_foreach_blk_el(stru
 		while (ctx->pos < i_size_read(inode)
 		       && offset < sb->s_blocksize) {
 			de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
-			if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
+			if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
+						   sb->s_blocksize, offset)) {
 				/* On error, skip the f_pos to the
 				   next block. */
 				ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
@@ -3339,7 +3348,7 @@ static int ocfs2_find_dir_space_id(struc
 	struct super_block *sb = dir->i_sb;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_dir_entry *de, *last_de = NULL;
-	char *de_buf, *limit;
+	char *first_de, *de_buf, *limit;
 	unsigned long offset = 0;
 	unsigned int rec_len, new_rec_len, free_space;
 
@@ -3352,14 +3361,16 @@ static int ocfs2_find_dir_space_id(struc
 	else
 		free_space = dir->i_sb->s_blocksize - i_size_read(dir);
 
-	de_buf = di->id2.i_data.id_data;
+	first_de = di->id2.i_data.id_data;
+	de_buf = first_de;
 	limit = de_buf + i_size_read(dir);
 	rec_len = OCFS2_DIR_REC_LEN(namelen);
 
 	while (de_buf < limit) {
 		de = (struct ocfs2_dir_entry *)de_buf;
 
-		if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de,
+					   i_size_read(dir), offset)) {
 			ret = -ENOENT;
 			goto out;
 		}
@@ -3441,7 +3452,8 @@ static int ocfs2_find_dir_space_el(struc
 			/* move to next block */
 			de = (struct ocfs2_dir_entry *) bh->b_data;
 		}
-		if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize,
+					   offset)) {
 			status = -ENOENT;
 			goto bail;
 		}
_

Patches currently in -mm which might be from llfamsec@gmail.com are


