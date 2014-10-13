From: akpm@linux-foundation.org
Subject: [merged] proc-introduce-proc_mem_open.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:17:58 -0700
Message-ID: <543c1756.orMX3zwJf9HdVSge%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: introduce proc_mem_open()
has been removed from the -mm tree.  Its filename was
     proc-introduce-proc_mem_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

