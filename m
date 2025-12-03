Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAD82D24A0
	for <mm-commits@vger.kernel.org>; Wed,  3 Dec 2025 22:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764799944; cv=none; b=OjxnGy+EWg+45R5aAuMIMkLLXpC51n1NN5Hfp+hiyg8bM5A9/UbBj3XSBLXQlAwEBsGx/q2E8qgJ9F03LKqxTQLzwKIUf5HTI5fPggUjRGLs6P1HocFtxtHDTwH4hJnFe43sB4/PncT7Wn7dGgNgeyU0PNMlTY51LmmP2Is7LY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764799944; c=relaxed/simple;
	bh=8ICmq/zbQAfq8/qKRKJxroZDU6DLQnitc2t9CsuAlgM=;
	h=Date:To:From:Subject:Message-Id; b=BBLgeK7jQ26HPHJQHUrnKnHGpQGxPfAz2b0XVGczB+7+xLKxemYK0sfrv62YVhl1WYZB5t4dPB+bxQc5bINUdOIZ+2O0TMiqJQY26547giy1FboBjvMFFqCj0qwNuDElYXFOBo8Jj3rkFmgzfSksZ3SkdwlRdQTVIQ2KOFWTWwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d3xXBtvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d3xXBtvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5739BC116C6;
	Wed,  3 Dec 2025 22:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764799943;
	bh=8ICmq/zbQAfq8/qKRKJxroZDU6DLQnitc2t9CsuAlgM=;
	h=Date:To:From:Subject:From;
	b=d3xXBtvCDdcR43dvTvMDI0jtm+MVhzRx2QU86TMYjIntvpfygsjKIDIXoZ4ISodwO
	 8veztMbdFHlZotGaBg/TzGZa0od61fAl/w+CJuHrZHlyzvqyqH9QjQkGsGOOH+jlYH
	 0/lhXLScKwk7LSJJYrUgwBamvB+PYi19zC41m5OM=
Date: Wed, 03 Dec 2025 14:12:22 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,david.hunter.linux@gmail.com,albinbabuvarghese20@gmail.com,eraykrdg1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state.patch added to mm-nonmm-unstable branch
Message-Id: <20251203221223.5739BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert remaining read-only checks to ocfs2_emergency_state
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Subject: ocfs2: convert remaining read-only checks to ocfs2_emergency_state
Date: Wed, 3 Dec 2025 06:34:26 +0300

Now that the centralized `ocfs2_emergency_state()` helper is available,
refactor remaining filesystem-wide checks for `ocfs2_is_soft_readonly` and
`ocfs2_is_hard_readonly` to use this new function.

To ensure strict consistency with the previous behavior and guarantee no
functional changes, the call sites continue to explicitly return -EROFS
when the emergency state is detected.  This standardizes the check logic
while preserving the existing error handling flow.

Link: https://lkml.kernel.org/r/3421641b54ad6b6e4ffca052351b518eacc1bd08.1764728893.git.eraykrdg1@gmail.com
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    2 +-
 fs/ocfs2/file.c           |    8 ++++----
 fs/ocfs2/inode.c          |    3 +--
 fs/ocfs2/move_extents.c   |    2 +-
 fs/ocfs2/resize.c         |    4 ++--
 fs/ocfs2/super.c          |    2 +-
 6 files changed, 10 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/buffer_head_io.c~ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state
+++ a/fs/ocfs2/buffer_head_io.c
@@ -434,7 +434,7 @@ int ocfs2_write_super_or_backup(struct o
 	BUG_ON(buffer_jbd(bh));
 	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
+	if (unlikely(ocfs2_emergency_state(osb))) {
 		ret = -EROFS;
 		mlog_errno(ret);
 		goto out;
--- a/fs/ocfs2/file.c~ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state
+++ a/fs/ocfs2/file.c
@@ -179,7 +179,7 @@ static int ocfs2_sync_file(struct file *
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	err = file_write_and_wait_range(file, start, end);
@@ -209,7 +209,7 @@ int ocfs2_should_update_atime(struct ino
 	struct timespec64 now;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return 0;
 
 	if ((inode->i_flags & S_NOATIME) ||
@@ -1949,7 +1949,7 @@ static int __ocfs2_change_file_space(str
 	handle_t *handle;
 	unsigned long long max_off = inode->i_sb->s_maxbytes;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	inode_lock(inode);
@@ -2713,7 +2713,7 @@ static loff_t ocfs2_remap_file_range(str
 		return -EINVAL;
 	if (!ocfs2_refcount_tree(osb))
 		return -EOPNOTSUPP;
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	/* Lock both files against IO */
--- a/fs/ocfs2/inode.c~ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state
+++ a/fs/ocfs2/inode.c
@@ -1623,8 +1623,7 @@ static int ocfs2_filecheck_repair_inode_
 	trace_ocfs2_filecheck_repair_inode_block(
 		(unsigned long long)bh->b_blocknr);
 
-	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
-	    ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(sb)))) {
 		mlog(ML_ERROR,
 		     "Filecheck: cannot repair dinode #%llu "
 		     "on readonly filesystem\n",
--- a/fs/ocfs2/move_extents.c~ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state
+++ a/fs/ocfs2/move_extents.c
@@ -909,7 +909,7 @@ static int ocfs2_move_extents(struct ocf
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	inode_lock(inode);
--- a/fs/ocfs2/resize.c~ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state
+++ a/fs/ocfs2/resize.c
@@ -276,7 +276,7 @@ int ocfs2_group_extend(struct inode * in
 	u32 first_new_cluster;
 	u64 lgd_blkno;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	if (new_clusters < 0)
@@ -466,7 +466,7 @@ int ocfs2_group_add(struct inode *inode,
 	u16 cl_bpc;
 	u64 bg_ptr;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	main_bm_inode = ocfs2_get_system_file_inode(osb,
--- a/fs/ocfs2/super.c~ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state
+++ a/fs/ocfs2/super.c
@@ -2487,7 +2487,7 @@ static int ocfs2_handle_error(struct sup
 		rv = -EIO;
 	} else { /* default option */
 		rv = -EROFS;
-		if (sb_rdonly(sb) && (ocfs2_is_soft_readonly(osb) || ocfs2_is_hard_readonly(osb)))
+		if (sb_rdonly(sb) && ocfs2_emergency_state(osb))
 			return rv;
 
 		pr_crit("OCFS2: File system is now read-only.\n");
_

Patches currently in -mm which might be from eraykrdg1@gmail.com are

ocfs2-add-ocfs2_emergency_state-helper-and-apply-to-setattr.patch
ocfs2-convert-remaining-read-only-checks-to-ocfs2_emergency_state.patch

