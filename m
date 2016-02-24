From: akpm@linux-foundation.org
Subject: + kernel-add-kcov-code-coverage-clean-up-code.patch added to -mm
 tree
Date: Wed, 24 Feb 2016 14:17:00 -0800
Message-ID: <56ce2bdc.JqRVnxVy7KNUux2U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbcBXWRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Feb 2016 17:17:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: clean up code
has been added to the -mm tree.  Its filename is
     kernel-add-kcov-code-coverage-clean-up-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-kcov-code-coverage-clean-up-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-kcov-code-coverage-clean-up-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kcov: clean up code

Address several issues in the original kcov submission
(based on Andrew comments):

1. Introduce KCOV_MODE_DISABLED, use it instead of 0.
2. Rename kcov.rc to kcov.refcount (rc can be confused with
   'return code').
3. Give name to ioctl argument (size/unused instead of arg).
4. Check that trace buffer size does not overflow on 32-bit
   arches (preventive since currently only x86_64 is supported).
5. Return ENOTTY instead of EINVAL for unknown ioctls.
6. Add comments to struct kcov fields.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcov.h |    2 ++
 kernel/kcov.c        |   38 +++++++++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff -puN include/linux/kcov.h~kernel-add-kcov-code-coverage-clean-up-code include/linux/kcov.h
--- a/include/linux/kcov.h~kernel-add-kcov-code-coverage-clean-up-code
+++ a/include/linux/kcov.h
@@ -11,6 +11,8 @@ void kcov_task_init(struct task_struct *
 void kcov_task_exit(struct task_struct *t);
 
 enum kcov_mode {
+	/* Coverage collection is not enabled yet. */
+	KCOV_MODE_DISABLED = 0,
 	/*
 	 * Tracing coverage collection mode.
 	 * Covered PCs are collected in a per-task buffer.
diff -puN kernel/kcov.c~kernel-add-kcov-code-coverage-clean-up-code kernel/kcov.c
--- a/kernel/kcov.c~kernel-add-kcov-code-coverage-clean-up-code
+++ a/kernel/kcov.c
@@ -27,12 +27,15 @@ struct kcov {
 	 *  - opened file descriptor
 	 *  - task with enabled coverage (we can't unwire it from another task)
 	 */
-	atomic_t		rc;
+	atomic_t		refcount;
 	/* The lock protects mode, size, area and t. */
 	spinlock_t		lock;
 	enum kcov_mode		mode;
+	/* Size of arena (in long's for KCOV_MODE_TRACE). */
 	unsigned		size;
+	/* Coverage buffer shared with user space. */
 	void			*area;
+	/* Task for which we collect coverage, or NULL. */
 	struct task_struct	*t;
 };
 
@@ -78,12 +81,12 @@ EXPORT_SYMBOL(__sanitizer_cov_trace_pc);
 
 static void kcov_get(struct kcov *kcov)
 {
-	atomic_inc(&kcov->rc);
+	atomic_inc(&kcov->refcount);
 }
 
 static void kcov_put(struct kcov *kcov)
 {
-	if (atomic_dec_and_test(&kcov->rc)) {
+	if (atomic_dec_and_test(&kcov->refcount)) {
 		vfree(kcov->area);
 		kfree(kcov);
 	}
@@ -91,7 +94,7 @@ static void kcov_put(struct kcov *kcov)
 
 void kcov_task_init(struct task_struct *t)
 {
-	t->kcov_mode = 0;
+	t->kcov_mode = KCOV_MODE_DISABLED;
 	t->kcov_size = 0;
 	t->kcov_area = NULL;
 	t->kcov = NULL;
@@ -130,7 +133,7 @@ static int kcov_mmap(struct file *filep,
 
 	spin_lock(&kcov->lock);
 	size = kcov->size * sizeof(unsigned long);
-	if (kcov->mode == 0 || vma->vm_pgoff != 0 ||
+	if (kcov->mode == KCOV_MODE_DISABLED || vma->vm_pgoff != 0 ||
 	    vma->vm_end - vma->vm_start != size) {
 		res = -EINVAL;
 		goto exit;
@@ -159,7 +162,7 @@ static int kcov_open(struct inode *inode
 	kcov = kzalloc(sizeof(*kcov), GFP_KERNEL);
 	if (!kcov)
 		return -ENOMEM;
-	atomic_set(&kcov->rc, 1);
+	atomic_set(&kcov->refcount, 1);
 	spin_lock_init(&kcov->lock);
 	filep->private_data = kcov;
 	return nonseekable_open(inode, filep);
@@ -175,20 +178,26 @@ static int kcov_ioctl_locked(struct kcov
 			     unsigned long arg)
 {
 	struct task_struct *t;
+	unsigned long size, unused;
 
 	switch (cmd) {
 	case KCOV_INIT_TRACE:
 		/*
 		 * Enable kcov in trace mode and setup buffer size.
 		 * Must happen before anything else.
+		 */
+		if (kcov->mode != KCOV_MODE_DISABLED)
+			return -EBUSY;
+		/*
 		 * Size must be at least 2 to hold current position and one PC.
+		 * Later we allocate size * sizeof(unsigned long) memory,
+		 * that must not overflow.
 		 */
-		if (arg < 2 || arg > INT_MAX)
+		size = arg;
+		if (size < 2 || size > INT_MAX / sizeof(unsigned long))
 			return -EINVAL;
-		if (kcov->mode != 0)
-			return -EBUSY;
+		kcov->size = size;
 		kcov->mode = KCOV_MODE_TRACE;
-		kcov->size = arg;
 		return 0;
 	case KCOV_ENABLE:
 		/*
@@ -198,7 +207,9 @@ static int kcov_ioctl_locked(struct kcov
 		 * at task exit or voluntary by KCOV_DISABLE. After that it can
 		 * be enabled for another task.
 		 */
-		if (arg != 0 || kcov->mode == 0 || kcov->area == NULL)
+		unused = arg;
+		if (unused != 0 || kcov->mode == KCOV_MODE_DISABLED ||
+		    kcov->area == NULL)
 			return -EINVAL;
 		if (kcov->t != NULL)
 			return -EBUSY;
@@ -216,7 +227,8 @@ static int kcov_ioctl_locked(struct kcov
 		return 0;
 	case KCOV_DISABLE:
 		/* Disable coverage for the current task. */
-		if (arg != 0 || current->kcov != kcov)
+		unused = arg;
+		if (unused != 0 || current->kcov != kcov)
 			return -EINVAL;
 		t = current;
 		if (WARN_ON(kcov->t != t))
@@ -226,7 +238,7 @@ static int kcov_ioctl_locked(struct kcov
 		kcov_put(kcov);
 		return 0;
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	}
 }
 
_

Patches currently in -mm which might be from dvyukov@google.com are

kernel-add-kcov-code-coverage.patch
kernel-add-kcov-code-coverage-clean-up-code.patch

