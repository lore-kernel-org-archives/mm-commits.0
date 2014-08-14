From: akpm@linux-foundation.org
Subject: + proc-introduce-proc_mem_open.patch added to -mm tree
Date: Thu, 14 Aug 2014 14:53:29 -0700
Message-ID: <53ed2fd9.DUkHD1l+j09kkfzV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:49246 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaHNVxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:30 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so32049igd.0
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: introduce proc_mem_open()
has been added to the -mm tree.  Its filename is
     proc-introduce-proc_mem_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-introduce-proc_mem_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-introduce-proc_mem_open.patch

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
Subject: proc: introduce proc_mem_open()

Extract the mm_access() code from __mem_open() into the new helper,
proc_mem_open(), the next patch will add another caller.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |   36 +++++++++++++++++++++---------------
 fs/proc/internal.h |    2 ++
 2 files changed, 23 insertions(+), 15 deletions(-)

diff -puN fs/proc/base.c~proc-introduce-proc_mem_open fs/proc/base.c
--- a/fs/proc/base.c~proc-introduce-proc_mem_open
+++ a/fs/proc/base.c
@@ -632,29 +632,35 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
-static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
+
+struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode)
 {
-	struct task_struct *task = get_proc_task(file_inode(file));
-	struct mm_struct *mm;
+	struct task_struct *task = get_proc_task(inode);
+	struct mm_struct *mm = ERR_PTR(-ESRCH);
 
-	if (!task)
-		return -ESRCH;
+	if (task) {
+		mm = mm_access(task, mode);
+		put_task_struct(task);
+
+		if (!IS_ERR_OR_NULL(mm)) {
+			/* ensure this mm_struct can't be freed */
+			atomic_inc(&mm->mm_count);
+			/* but do not pin its memory */
+			mmput(mm);
+		}
+	}
+
+	return mm;
+}
 
-	mm = mm_access(task, mode);
-	put_task_struct(task);
+static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
+{
+	struct mm_struct *mm = proc_mem_open(inode, mode);
 
 	if (IS_ERR(mm))
 		return PTR_ERR(mm);
 
-	if (mm) {
-		/* ensure this mm_struct can't be freed */
-		atomic_inc(&mm->mm_count);
-		/* but do not pin its memory */
-		mmput(mm);
-	}
-
 	file->private_data = mm;
-
 	return 0;
 }
 
diff -puN fs/proc/internal.h~proc-introduce-proc_mem_open fs/proc/internal.h
--- a/fs/proc/internal.h~proc-introduce-proc_mem_open
+++ a/fs/proc/internal.h
@@ -278,6 +278,8 @@ struct proc_maps_private {
 #endif
 };
 
+struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode);
+
 extern const struct file_operations proc_pid_maps_operations;
 extern const struct file_operations proc_tid_maps_operations;
 extern const struct file_operations proc_pid_numa_maps_operations;
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

