Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDA02914
	for <mm-commits@vger.kernel.org>; Sun,  6 Apr 2025 23:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743983785; cv=none; b=QEu7p6CvppXOoexSQuuyWcRN5cCQbPm4MSN4XuNlFYtYYrJFa21luBl9kgN9PDUfkBA2FAwJcf2YTZ74f5NoYrbTq0HD6C8LpmDISgiq4IX72cltC6cq2EGAgPQx0ohih4olkpgw8dmUGfyQor86iBM56FQh+InZbkQwYMqCd38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743983785; c=relaxed/simple;
	bh=vHezJfCuf4JaC8q/dsvdHpUYyuCyw5gPMB0WhZP2tyU=;
	h=Date:To:From:Subject:Message-Id; b=LX6B2HM0EQsPIhvbbaot9uDEjBu7VKEbd6rdWxNwzOgLvBYLtgKjf4SIFcWGT/5vjMiKzOo7B7G2/sj1rOqdGIfKLEkm3O8aYANjYYSE9CTM1Swi/AsZHg9Z+4wEmZeHUR4TBXQJdB2K8VK1xUwuohTavrWrlgW4mUfemWuVrik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N+bNlJoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+bNlJoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D191C4CEE3;
	Sun,  6 Apr 2025 23:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743983785;
	bh=vHezJfCuf4JaC8q/dsvdHpUYyuCyw5gPMB0WhZP2tyU=;
	h=Date:To:From:Subject:From;
	b=N+bNlJoPdrU5AC1p6jk/6WZwjhjHGLQ/5h1UnERn0+PFKMPkvERPNkBbVbH4CbQJ8
	 tv8j5jEBcF5iI8wx7Js28YjOv3TX7h9eQmOerRTkmLnQP7SJzDgO+TwYN+04xdkRg1
	 KZ3+jznrnVkeAGFfZWU7k/CtBanI4Fdxi5pirlG4=
Date: Sun, 06 Apr 2025 16:56:24 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,tglx@linutronix.de,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,jlayton@kernel.org,felix.moessbauer@siemens.com,brauner@kernel.org,adrian.ratiu@collabora.com,adobriyan@gmail.com,superman.xpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-the-issue-of-proc_mem_open-returning-null.patch added to mm-nonmm-unstable branch
Message-Id: <20250406235625.3D191C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: fix the issue of proc_mem_open returning NULL
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-fix-the-issue-of-proc_mem_open-returning-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-fix-the-issue-of-proc_mem_open-returning-null.patch

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

proc-fix-the-issue-of-proc_mem_open-returning-null.patch

