From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:17:56 -0700
Message-ID: <543c1754.rrDFBlc68fTSqoLy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: unify/simplify do_maps_open() and numa_maps_open()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/task_mmu.c: unify/simplify do_maps_open() and numa_maps_open()

do_maps_open() and numa_maps_open() are overcomplicated, they could use
__seq_open_private().  Plus they do the same, just sizeof(*priv)

Change them to use a new simple helper, proc_maps_open(ops, psize).  This
simplifies the code and allows us to do the next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   44 +++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open
+++ a/fs/proc/task_mmu.c
@@ -231,23 +231,23 @@ static void m_stop(struct seq_file *m, v
 		put_task_struct(priv->task);
 }
 
+static int proc_maps_open(struct inode *inode, struct file *file,
+			const struct seq_operations *ops, int psize)
+{
+	struct proc_maps_private *priv = __seq_open_private(file, ops, psize);
+
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pid = proc_pid(inode);
+	return 0;
+}
+
 static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
-	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+	return proc_maps_open(inode, file, ops,
+				sizeof(struct proc_maps_private));
 }
 
 static void
@@ -1526,20 +1526,8 @@ static const struct seq_operations proc_
 static int numa_maps_open(struct inode *inode, struct file *file,
 			  const struct seq_operations *ops)
 {
-	struct numa_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->proc_maps.pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+	return proc_maps_open(inode, file, ops,
+				sizeof(struct numa_maps_private));
 }
 
 static int pid_numa_maps_open(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

