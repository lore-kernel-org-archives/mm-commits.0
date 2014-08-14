From: akpm@linux-foundation.org
Subject: +
 fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 14:53:40 -0700
Message-ID: <53ed2fe4.oFaUkheAPTPAUtbD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:35339 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaHNVxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:41 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so380852oig.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_nommu.c: shift mm_access() from m_start() to proc_maps_open()
has been added to the -mm tree.  Its filename is
     fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch

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
Subject: fs/proc/task_nommu.c: shift mm_access() from m_start() to proc_maps_open()

Copy-and-paste the changes from "fs/proc/task_mmu.c: shift mm_access()
from m_start() to proc_maps_open()" into task_nommu.c.

Change maps_open() to initialize priv->mm using proc_mem_open(), m_start()
can rely on atomic_inc_not_zero(mm_users) like task_mmu.c does.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

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
 
@@ -274,9 +274,28 @@ static int maps_open(struct inode *inode
 		return -ENOMEM;
 
 	priv->pid = proc_pid(inode);
+	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR(priv->mm)) {
+		int err = PTR_ERR(priv->mm);
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
@@ -291,13 +310,13 @@ const struct file_operations proc_pid_ma
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

