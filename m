From: akpm@linux-foundation.org
Subject: +
 proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:42:18 -0700
Message-ID: <53fd1b5a.VLeKDp56GzXkiPqq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:48668 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaHZXmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:42:20 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so3023983oig.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:42:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gerg@uclinux.org, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/maps: replace proc_maps_private->pid with "struct inode *inode"
has been added to the -mm tree.  Its filename is
     proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc/maps: replace proc_maps_private->pid with "struct inode *inode"

m_start() can use get_proc_task() instead, and "struct inode *"
provides more potentially useful info, see the next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h   |    2 +-
 fs/proc/task_mmu.c   |    4 ++--
 fs/proc/task_nommu.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/internal.h~proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode fs/proc/internal.h
--- a/fs/proc/internal.h~proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode
+++ a/fs/proc/internal.h
@@ -268,7 +268,7 @@ extern int proc_remount(struct super_blo
  * task_[no]mmu.c
  */
 struct proc_maps_private {
-	struct pid *pid;
+	struct inode *inode;
 	struct task_struct *task;
 	struct mm_struct *mm;
 #ifdef CONFIG_MMU
diff -puN fs/proc/task_mmu.c~proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode
+++ a/fs/proc/task_mmu.c
@@ -164,7 +164,7 @@ static void *m_start(struct seq_file *m,
 	if (last_addr == -1UL)
 		return NULL;
 
-	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
+	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
@@ -231,7 +231,7 @@ static int proc_maps_open(struct inode *
 	if (!priv)
 		return -ENOMEM;
 
-	priv->pid = proc_pid(inode);
+	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
 	if (IS_ERR(priv->mm)) {
 		int err = PTR_ERR(priv->mm);
diff -puN fs/proc/task_nommu.c~proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode
+++ a/fs/proc/task_nommu.c
@@ -212,7 +212,7 @@ static void *m_start(struct seq_file *m,
 	loff_t n = *pos;
 
 	/* pin the task and mm whilst we play with them */
-	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
+	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
@@ -275,7 +275,7 @@ static int maps_open(struct inode *inode
 	if (!priv)
 		return -ENOMEM;
 
-	priv->pid = proc_pid(inode);
+	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
 	if (IS_ERR(priv->mm)) {
 		int err = PTR_ERR(priv->mm);
_

Patches currently in -mm which might be from oleg@redhat.com are

prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
earlyprintk-re-enable-earlyprintk-calling-early_param.patch
fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch
proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch
proc-maps-make-vm_is_stack-logic-namespace-friendly.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

