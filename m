Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A67C1A239D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011345; cv=none; b=sqGB/LZ0S9+azuiVamL3mrXvMDfw4XA7BP9awm+vxFCIEWt/GX+v5W0KqfwAF26DLBf1v66/rzvxjvXv5vMZibm5wuHqe8Bz3sYlss4v0pQNyLvdPjunZ0Tn+NbaDvbrt38mEktC7ME9C1Ad+RDY5FUEILITYxGJmYKty6MwkiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011345; c=relaxed/simple;
	bh=ZK5gZXJ+eMwNiV3r57CTEndRPRQKXN7yhHG2KIzwrjU=;
	h=Date:To:From:Subject:Message-Id; b=IAlm8UH0cTQJvR1mOKYqej9giBS1VkzMpJPAV0ORVndd0Whd4W4UwE4pEFCETjDYlY2BFGTUNcHIDiIAlieua0s5GaoqmwB/M+eKBBLNYjH0FTM3DkDJq4PmhpZHo1LrjsoqurccbUIjeiFPHhxuPuRE8jm2YQ3dXipQdYbL0Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=140hJZtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="140hJZtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7785FC4CEE4;
	Mon, 12 May 2025 00:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011344;
	bh=ZK5gZXJ+eMwNiV3r57CTEndRPRQKXN7yhHG2KIzwrjU=;
	h=Date:To:From:Subject:From;
	b=140hJZtpObRvdFkNTO1uOt4nl6tpQy8/iOcsovxFKTn9T0VLOOlaZkMt9AcRqv9w+
	 9rAKtRV7WXPEdaUHvfShUlGifgBe5HnEQfSczQalEP/D2ILPqNbCknoi7WDGhoiPBG
	 d6tHQEBBlMGU95yvM4VSPL1eO6gmKVxark+v/j1Y=
Date: Sun, 11 May 2025 17:55:43 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,tglx@linutronix.de,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,jlayton@kernel.org,felix.moessbauer@siemens.com,brauner@kernel.org,adrian.ratiu@collabora.com,adobriyan@gmail.com,superman.xpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-fix-the-issue-of-proc_mem_open-returning-null.patch removed from -mm tree
Message-Id: <20250512005544.7785FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: fix the issue of proc_mem_open returning NULL
has been removed from the -mm tree.  Its filename was
     proc-fix-the-issue-of-proc_mem_open-returning-null.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Penglei Jiang <superman.xpt@gmail.com>
Subject: proc: fix the issue of proc_mem_open returning NULL
Date: Thu, 3 Apr 2025 23:33:57 -0700

proc_mem_open() can return an errno, NULL, or mm_struct*.  If it fails to
acquire mm, it returns NULL, but the caller does not check for the case
when the return value is NULL.

The following conditions lead to failure in acquiring mm:

  - The task is a kernel thread (PF_KTHREAD)
  - The task is exiting (PF_EXITING)

Changes:

  - Add documentation comments for the return value of proc_mem_open().
  - Add checks in the caller to return -ESRCH when proc_mem_open()
    returns NULL.

Link: https://lkml.kernel.org/r/20250404063357.78891-1-superman.xpt@gmail.com
Reported-by: syzbot+f9238a0a31f9b5603fef@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000f52642060d4e3750@google.com
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Adrian Ratiu <adrian.ratiu@collabora.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: Jeff layton <jlayton@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c       |   12 +++++++++---
 fs/proc/task_mmu.c   |   12 ++++++------
 fs/proc/task_nommu.c |    4 ++--
 3 files changed, 17 insertions(+), 11 deletions(-)

--- a/fs/proc/base.c~proc-fix-the-issue-of-proc_mem_open-returning-null
+++ a/fs/proc/base.c
@@ -827,7 +827,13 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
-
+/*
+ * proc_mem_open() can return errno, NULL or mm_struct*.
+ *
+ *   - Returns NULL if the task has no mm (PF_KTHREAD or PF_EXITING)
+ *   - Returns mm_struct* on success
+ *   - Returns error code on failure
+ */
 struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode)
 {
 	struct task_struct *task = get_proc_task(inode);
@@ -854,8 +860,8 @@ static int __mem_open(struct inode *inod
 {
 	struct mm_struct *mm = proc_mem_open(inode, mode);
 
-	if (IS_ERR(mm))
-		return PTR_ERR(mm);
+	if (IS_ERR_OR_NULL(mm))
+		return mm ? PTR_ERR(mm) : -ESRCH;
 
 	file->private_data = mm;
 	return 0;
--- a/fs/proc/task_mmu.c~proc-fix-the-issue-of-proc_mem_open-returning-null
+++ a/fs/proc/task_mmu.c
@@ -212,8 +212,8 @@ static int proc_maps_open(struct inode *
 
 	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(priv->mm)) {
-		int err = PTR_ERR(priv->mm);
+	if (IS_ERR_OR_NULL(priv->mm)) {
+		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
 
 		seq_release_private(inode, file);
 		return err;
@@ -1325,8 +1325,8 @@ static int smaps_rollup_open(struct inod
 
 	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(priv->mm)) {
-		ret = PTR_ERR(priv->mm);
+	if (IS_ERR_OR_NULL(priv->mm)) {
+		ret = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
 
 		single_release(inode, file);
 		goto out_free;
@@ -2069,8 +2069,8 @@ static int pagemap_open(struct inode *in
 	struct mm_struct *mm;
 
 	mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(mm))
-		return PTR_ERR(mm);
+	if (IS_ERR_OR_NULL(mm))
+		return mm ? PTR_ERR(mm) : -ESRCH;
 	file->private_data = mm;
 	return 0;
 }
--- a/fs/proc/task_nommu.c~proc-fix-the-issue-of-proc_mem_open-returning-null
+++ a/fs/proc/task_nommu.c
@@ -260,8 +260,8 @@ static int maps_open(struct inode *inode
 
 	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(priv->mm)) {
-		int err = PTR_ERR(priv->mm);
+	if (IS_ERR_OR_NULL(priv->mm)) {
+		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
 
 		seq_release_private(inode, file);
 		return err;
_

Patches currently in -mm which might be from superman.xpt@gmail.com are


