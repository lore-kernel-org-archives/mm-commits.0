From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:00 -0700
Message-ID: <543c1758.hQ+KXEC+PHv26G0k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: shift mm_access() from m_start() to proc_maps_open()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/task_mmu.c: shift mm_access() from m_start() to proc_maps_open()

A simple test-case from Kirill Shutemov

	cat /proc/self/maps >/dev/null
	chmod +x /proc/self/net/packet
	exec /proc/self/net/packet

makes lockdep unhappy, cat/exec take seq_file->lock + cred_guard_mutex in
the opposite order.

It's a false positive and probably we should not allow "chmod +x" on proc
files. Still I think that we should avoid mm_access() and cred_guard_mutex
in sys_read() paths, security checking should happen at open time. Besides,
this doesn't even look right if the task changes its ->mm between m_stop()
and m_start().

Add the new "mm_struct *mm" member into struct proc_maps_private and change
proc_maps_open() to initialize it using proc_mem_open(). Change m_start() to
use priv->mm if atomic_inc_not_zero(mm_users) succeeds or return NULL (eof)
otherwise.

The only complication is that proc_maps_open() users should additionally do
mmdrop() in fop->release(), add the new proc_map_release() helper for that.

Note: this is the user-visible change, if the task execs after open("maps")
the new ->mm won't be visible via this file. I hope this is fine, and this
matches /proc/pid/mem bahaviour.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    1 +
 fs/proc/task_mmu.c |   37 ++++++++++++++++++++++++++++---------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff -puN fs/proc/internal.h~fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open fs/proc/internal.h
--- a/fs/proc/internal.h~fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open
+++ a/fs/proc/internal.h
@@ -270,6 +270,7 @@ extern int proc_remount(struct super_blo
 struct proc_maps_private {
 	struct pid *pid;
 	struct task_struct *task;
+	struct mm_struct *mm;
 #ifdef CONFIG_MMU
 	struct vm_area_struct *tail_vma;
 #endif
diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open
+++ a/fs/proc/task_mmu.c
@@ -165,9 +165,9 @@ static void *m_start(struct seq_file *m,
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_access(priv->task, PTRACE_MODE_READ);
-	if (!mm || IS_ERR(mm))
-		return mm;
+	mm = priv->mm;
+	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
+		return NULL;
 	down_read(&mm->mmap_sem);
 
 	tail_vma = get_gate_vma(mm);
@@ -240,9 +240,28 @@ static int proc_maps_open(struct inode *
 		return -ENOMEM;
 
 	priv->pid = proc_pid(inode);
+	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR(priv->mm)) {
+		int err = PTR_ERR(priv->mm);
+
+		seq_release_private(inode, file);
+		return err;
+	}
+
 	return 0;
 }
 
+static int proc_map_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct proc_maps_private *priv = seq->private;
+
+	if (priv->mm)
+		mmdrop(priv->mm);
+
+	return seq_release_private(inode, file);
+}
+
 static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
@@ -398,14 +417,14 @@ const struct file_operations proc_pid_ma
 	.open		= pid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 const struct file_operations proc_tid_maps_operations = {
 	.open		= tid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 /*
@@ -680,14 +699,14 @@ const struct file_operations proc_pid_sm
 	.open		= pid_smaps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 const struct file_operations proc_tid_smaps_operations = {
 	.open		= tid_smaps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 /*
@@ -1544,13 +1563,13 @@ const struct file_operations proc_pid_nu
 	.open		= pid_numa_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 const struct file_operations proc_tid_numa_maps_operations = {
 	.open		= tid_numa_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 #endif /* CONFIG_NUMA */
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

