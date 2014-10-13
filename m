From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:20 -0700
Message-ID: <543c176c.7P+d+UINa1Xn4tKd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gerg@uclinux.org, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_nommu.c: shift mm_access() from m_start() to proc_maps_open()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/task_nommu.c: shift mm_access() from m_start() to proc_maps_open()

Copy-and-paste the changes from "fs/proc/task_mmu.c: shift mm_access()
from m_start() to proc_maps_open()" into task_nommu.c.

Change maps_open() to initialize priv->mm using proc_mem_open(), m_start()
can rely on atomic_inc_not_zero(mm_users) like task_mmu.c does.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff -puN fs/proc/task_nommu.c~fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open
+++ a/fs/proc/task_nommu.c
@@ -216,11 +216,11 @@ static void *m_start(struct seq_file *m,
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_access(priv->task, PTRACE_MODE_READ);
-	if (!mm || IS_ERR(mm)) {
+	mm = priv->mm;
+	if (!mm || !atomic_inc_not_zero(&mm->mm_users)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
-		return mm;
+		return NULL;
 	}
 	down_read(&mm->mmap_sem);
 
@@ -270,14 +270,34 @@ static int maps_open(struct inode *inode
 {
 	struct proc_maps_private *priv;
 
-	priv = __seq_open_private(file, ops, sizeof(struct proc_maps_private));
+	priv = __seq_open_private(file, ops, sizeof(*priv));
 	if (!priv)
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
 
+
+static int map_release(struct inode *inode, struct file *file)
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
 static int pid_maps_open(struct inode *inode, struct file *file)
 {
 	return maps_open(inode, file, &proc_pid_maps_ops);
@@ -292,13 +312,13 @@ const struct file_operations proc_pid_ma
 	.open		= pid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= map_release,
 };
 
 const struct file_operations proc_tid_maps_operations = {
 	.open		= tid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= map_release,
 };
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

