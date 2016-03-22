From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-add-kcov-code-coverage-fix.patch removed
 from -mm tree
Date: Tue, 22 Mar 2016 13:57:34 -0700
Message-ID: <56f1b1be.cf6EFYLMAokYW0Tt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbcCVU5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-kcov-code-coverage-fix
has been removed from the -mm tree.  Its filename was
     kernel-add-kcov-code-coverage-fix.patch

This patch was dropped because it was folded into kernel-add-kcov-code-coverage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-add-kcov-code-coverage-fix

make task_struct.kcov_mode have type `enum kcov_mode'.

Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcov.h  |    8 ++++++++
 include/linux/sched.h |    3 ++-
 kernel/kcov.c         |    8 --------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff -puN include/linux/kcov.h~kernel-add-kcov-code-coverage-fix include/linux/kcov.h
--- a/include/linux/kcov.h~kernel-add-kcov-code-coverage-fix
+++ a/include/linux/kcov.h
@@ -10,6 +10,14 @@ struct task_struct;
 void kcov_task_init(struct task_struct *t);
 void kcov_task_exit(struct task_struct *t);
 
+enum kcov_mode {
+	/*
+	 * Tracing coverage collection mode.
+	 * Covered PCs are collected in a per-task buffer.
+	 */
+	KCOV_MODE_TRACE = 1,
+};
+
 #else
 
 static inline void kcov_task_init(struct task_struct *t) {}
diff -puN include/linux/sched.h~kernel-add-kcov-code-coverage-fix include/linux/sched.h
--- a/include/linux/sched.h~kernel-add-kcov-code-coverage-fix
+++ a/include/linux/sched.h
@@ -51,6 +51,7 @@ struct sched_param {
 #include <linux/resource.h>
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
+#include <linux/kcov.h>
 #include <linux/task_io_accounting.h>
 #include <linux/latencytop.h>
 #include <linux/cred.h>
@@ -1823,7 +1824,7 @@ struct task_struct {
 #endif /* CONFIG_TRACING */
 #ifdef CONFIG_KCOV
 	/* Coverage collection mode enabled for this task (0 if disabled). */
-	int		kcov_mode;
+	enum kcov_mode kcov_mode;
 	/* Size of the kcov_area. */
 	unsigned	kcov_size;
 	/* Buffer for coverage collection. */
diff -puN kernel/kcov.c~kernel-add-kcov-code-coverage-fix kernel/kcov.c
--- a/kernel/kcov.c~kernel-add-kcov-code-coverage-fix
+++ a/kernel/kcov.c
@@ -13,14 +13,6 @@
 #include <linux/uaccess.h>
 #include <linux/kcov.h>
 
-enum kcov_mode {
-	/*
-	 * Tracing coverage collection mode.
-	 * Covered PCs are collected in a per-task buffer.
-	 */
-	KCOV_MODE_TRACE = 1,
-};
