From: akpm@linux-foundation.org
Subject: +
 fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 14:53:28 -0700
Message-ID: <53ed2fd8.B0FrujrfnnHSibek%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:56836 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaHNVx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:29 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so380390oif.4
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: unify/simplify do_maps_open() and numa_maps_open()
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch

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
@@ -1517,20 +1517,8 @@ static const struct seq_operations proc_
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
earlyprintk-re-enable-earlyprintk-calling-early_param.patch
fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch
linux-next.patch

