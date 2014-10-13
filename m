From: akpm@linux-foundation.org
Subject: [merged]
 proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:24 -0700
Message-ID: <543c1770.7s3VKKvBbWv2ApfY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gerg@uclinux.org, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/maps: replace proc_maps_private->pid with "struct inode *inode"
has been removed from the -mm tree.  Its filename was
     proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -276,7 +276,7 @@ static int maps_open(struct inode *inode
 	if (!priv)
 		return -ENOMEM;
 
-	priv->pid = proc_pid(inode);
+	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
 	if (IS_ERR(priv->mm)) {
 		int err = PTR_ERR(priv->mm);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

