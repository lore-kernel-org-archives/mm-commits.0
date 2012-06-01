From: akpm@linux-foundation.org
Subject: [merged] proc-remove-mm_for_maps.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:49 -0700
Message-ID: <20120601193349.DDA53A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:32783 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:52 -0400
Received: by wgbdt11 with SMTP id dt11so140395wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, hughd@google.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove mm_for_maps()
has been removed from the -mm tree.  Its filename was
     proc-remove-mm_for_maps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: proc: remove mm_for_maps()

mm_for_maps() is a simple wrapper for mm_access(), and the name is
misleading, so just remove it and use mm_access() directly.

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c       |    7 +------
 fs/proc/internal.h   |    2 --
 fs/proc/task_mmu.c   |    4 ++--
 fs/proc/task_nommu.c |    2 +-
 4 files changed, 4 insertions(+), 11 deletions(-)

diff -puN fs/proc/base.c~proc-remove-mm_for_maps fs/proc/base.c
--- a/fs/proc/base.c~proc-remove-mm_for_maps
+++ a/fs/proc/base.c
@@ -199,11 +199,6 @@ static int proc_root_link(struct dentry 
 	return result;
 }
 
-struct mm_struct *mm_for_maps(struct task_struct *task)
-{
-	return mm_access(task, PTRACE_MODE_READ);
-}
-
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 {
 	int res = 0;
@@ -243,7 +238,7 @@ out:
 
 static int proc_pid_auxv(struct task_struct *task, char *buffer)
 {
-	struct mm_struct *mm = mm_for_maps(task);
+	struct mm_struct *mm = mm_access(task, PTRACE_MODE_READ);
 	int res = PTR_ERR(mm);
 	if (mm && !IS_ERR(mm)) {
 		unsigned int nwords = 0;
diff -puN fs/proc/internal.h~proc-remove-mm_for_maps fs/proc/internal.h
--- a/fs/proc/internal.h~proc-remove-mm_for_maps
+++ a/fs/proc/internal.h
@@ -31,8 +31,6 @@ struct vmalloc_info {
 	unsigned long	largest_chunk;
 };
 
-extern struct mm_struct *mm_for_maps(struct task_struct *);
-
 #ifdef CONFIG_MMU
 #define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
 extern void get_vmalloc_info(struct vmalloc_info *vmi);
diff -puN fs/proc/task_mmu.c~proc-remove-mm_for_maps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-remove-mm_for_maps
+++ a/fs/proc/task_mmu.c
@@ -125,7 +125,7 @@ static void *m_start(struct seq_file *m,
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_for_maps(priv->task);
+	mm = mm_access(priv->task, PTRACE_MODE_READ);
 	if (!mm || IS_ERR(mm))
 		return mm;
 	down_read(&mm->mmap_sem);
@@ -919,7 +919,7 @@ static ssize_t pagemap_read(struct file 
 	if (!pm.buffer)
 		goto out_task;
 
-	mm = mm_for_maps(task);
+	mm = mm_access(task, PTRACE_MODE_READ);
 	ret = PTR_ERR(mm);
 	if (!mm || IS_ERR(mm))
 		goto out_free;
diff -puN fs/proc/task_nommu.c~proc-remove-mm_for_maps fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-remove-mm_for_maps
+++ a/fs/proc/task_nommu.c
@@ -223,7 +223,7 @@ static void *m_start(struct seq_file *m,
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_for_maps(priv->task);
+	mm = mm_access(priv->task, PTRACE_MODE_READ);
 	if (!mm || IS_ERR(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
shmem-replace_page-must-flush_dcache-and-others.patch
fs-move-file_remove_suid-to-fs-inodec.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch

