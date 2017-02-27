From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-add-event-for-exit-notification.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:26:38 -0800
Message-ID: <58b48b7e.uO3UmrShQ8fDu+xo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: add event for exit() notification
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-add-event-for-exit-notification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: add event for exit() notification

Allow userfaultfd monitor track termination of the processes that have
memory backed by the uffd.

[rppt@linux.vnet.ibm.com: add comment]
  Link: http://lkml.kernel.org/r/20170202135448.GB19804@rapoport-lnxLink: http://lkml.kernel.org/r/1485542673-24387-4-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   28 ++++++++++++++++++++++++++++
 include/linux/userfaultfd_k.h    |    7 +++++++
 include/uapi/linux/userfaultfd.h |    5 ++++-
 kernel/exit.c                    |    2 ++
 4 files changed, 41 insertions(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-add-event-for-exit-notification fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-add-event-for-exit-notification
+++ a/fs/userfaultfd.c
@@ -774,6 +774,34 @@ void userfaultfd_unmap_complete(struct m
 	}
 }
 
+void userfaultfd_exit(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma = mm->mmap;
+
+	/*
+	 * We can do the vma walk without locking because the caller
+	 * (exit_mm) knows it now has exclusive access
+	 */
+	while (vma) {
+		struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
+
+		if (ctx && (ctx->features & UFFD_FEATURE_EVENT_EXIT)) {
+			struct userfaultfd_wait_queue ewq;
+
+			userfaultfd_ctx_get(ctx);
+
+			msg_init(&ewq.msg);
+			ewq.msg.event = UFFD_EVENT_EXIT;
+
+			userfaultfd_event_wait_completion(ctx, &ewq);
+
+			ctx->features &= ~UFFD_FEATURE_EVENT_EXIT;
+		}
+
+		vma = vma->vm_next;
+	}
+}
+
 static int userfaultfd_release(struct inode *inode, struct file *file)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
diff -puN include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-add-event-for-exit-notification include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-add-event-for-exit-notification
+++ a/include/linux/userfaultfd_k.h
@@ -72,6 +72,8 @@ extern int userfaultfd_unmap_prep(struct
 extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 
+extern void userfaultfd_exit(struct mm_struct *mm);
+
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
@@ -136,6 +138,11 @@ static inline void userfaultfd_unmap_com
 					      struct list_head *uf)
 {
 }
+
+static inline void userfaultfd_exit(struct mm_struct *mm)
+{
+}
+
 #endif /* CONFIG_USERFAULTFD */
 
 #endif /* _LINUX_USERFAULTFD_K_H */
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-add-event-for-exit-notification include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-add-event-for-exit-notification
+++ a/include/uapi/linux/userfaultfd.h
@@ -18,7 +18,8 @@
  * means the userland is reading).
  */
 #define UFFD_API ((__u64)0xAA)
-#define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |		\
+#define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_EXIT |		\
+			   UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
 			   UFFD_FEATURE_EVENT_REMOVE |	\
 			   UFFD_FEATURE_EVENT_UNMAP |		\
@@ -112,6 +113,7 @@ struct uffd_msg {
 #define UFFD_EVENT_REMAP	0x14
 #define UFFD_EVENT_REMOVE	0x15
 #define UFFD_EVENT_UNMAP	0x16
+#define UFFD_EVENT_EXIT		0x17
 
 /* flags for UFFD_EVENT_PAGEFAULT */
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
@@ -161,6 +163,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_MISSING_HUGETLBFS		(1<<4)
 #define UFFD_FEATURE_MISSING_SHMEM		(1<<5)
 #define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
+#define UFFD_FEATURE_EVENT_EXIT			(1<<7)
 	__u64 features;
 
 	__u64 ioctls;
diff -puN kernel/exit.c~userfaultfd-non-cooperative-add-event-for-exit-notification kernel/exit.c
--- a/kernel/exit.c~userfaultfd-non-cooperative-add-event-for-exit-notification
+++ a/kernel/exit.c
@@ -45,6 +45,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/tracehook.h>
 #include <linux/fs_struct.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/init_task.h>
 #include <linux/perf_event.h>
 #include <trace/events/sched.h>
@@ -547,6 +548,7 @@ static void exit_mm(void)
 	enter_lazy_tlb(mm, current);
 	task_unlock(current);
 	mm_update_next_owner(mm);
+	userfaultfd_exit(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))
 		exit_oom_victim();
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are


