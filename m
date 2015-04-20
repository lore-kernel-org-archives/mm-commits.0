From: akpm@linux-foundation.org
Subject: [merged] kernel-forkc-new-function-for-max_threads.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:19:41 -0700
Message-ID: <5535514d.CriBf6ydfPJwmvLe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbbDTTNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, linux@roeck-us.net, mingo@kernel.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: new function for max_threads
has been removed from the -mm tree.  Its filename was
     kernel-forkc-new-function-for-max_threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: kernel/fork.c: new function for max_threads

PAGE_SIZE is not guaranteed to be equal to or less than 8 times the
THREAD_SIZE.

E.g.  architecture hexagon may have page size 1M and thread size 4096. 
This would lead to a division by zero in the calculation of max_threads.

With this patch the buggy code is moved to a separate function
set_max_threads.  The error is not fixed.

After fixing the problem in a separate patch the new function can be
reused to adjust max_threads after adding or removing memory.

Argument mempages of function fork_init() is removed as totalram_pages is
an exported symbol.

The creation of separate patches for refactoring to a new function and for
fixing the logic was suggested by Ingo Molnar.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c   |    4 ++--
 kernel/fork.c |   34 +++++++++++++++++++++-------------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff -puN init/main.c~kernel-forkc-new-function-for-max_threads init/main.c
--- a/init/main.c~kernel-forkc-new-function-for-max_threads
+++ a/init/main.c
@@ -91,7 +91,7 @@
 static int kernel_init(void *);
 
 extern void init_IRQ(void);
-extern void fork_init(unsigned long);
+extern void fork_init(void);
 extern void radix_tree_init(void);
 #ifndef CONFIG_DEBUG_RODATA
 static inline void mark_rodata_ro(void) { }
@@ -645,7 +645,7 @@ asmlinkage __visible void __init start_k
 #endif
 	thread_info_cache_init();
 	cred_init();
-	fork_init(totalram_pages);
+	fork_init();
 	proc_caches_init();
 	buffer_init();
 	key_init();
diff -puN kernel/fork.c~kernel-forkc-new-function-for-max_threads kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-new-function-for-max_threads
+++ a/kernel/fork.c
@@ -253,7 +253,26 @@ EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init __weak arch_task_cache_init(void) { }
 
-void __init fork_init(unsigned long mempages)
+/*
+ * set_max_threads
+ */
+static void set_max_threads(void)
+{
+	/*
+	 * The default maximum number of threads is set to a safe
+	 * value: the thread structures can take up at most one
+	 * eighth of the memory.
+	 */
+	max_threads = totalram_pages / (8 * THREAD_SIZE / PAGE_SIZE);
+
+	/*
+	 * we need to allow at least 20 threads to boot a system
+	 */
+	if (max_threads < 20)
+		max_threads = 20;
+}
+
+void __init fork_init(void)
 {
 #ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 #ifndef ARCH_MIN_TASKALIGN
@@ -268,18 +287,7 @@ void __init fork_init(unsigned long memp
 	/* do the arch specific task caches init */
 	arch_task_cache_init();
 
-	/*
-	 * The default maximum number of threads is set to a safe
-	 * value: the thread structures can take up at most one
-	 * eighth of the memory.
-	 */
-	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
