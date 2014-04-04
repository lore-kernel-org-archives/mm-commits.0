From: akpm@linux-foundation.org
Subject: [merged] kmemleak-change-some-global-variables-to-int.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:30 -0700
Message-ID: <533f081a.ZsGyboipw+nBqCe5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbaDDT3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: [merged] kmemleak-change-some-global-variables-to-int.patch removed from -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:30 -0700


The patch titled
     Subject: kmemleak: change some global variables to int
has been removed from the -mm tree.  Its filename was
     kmemleak-change-some-global-variables-to-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak: change some global variables to int

They don't have to be atomic_t, because they are simple boolean
toggles.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   80 ++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff -puN mm/kmemleak.c~kmemleak-change-some-global-variables-to-int mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-change-some-global-variables-to-int
+++ a/mm/kmemleak.c
@@ -192,15 +192,15 @@ static struct kmem_cache *object_cache;
 static struct kmem_cache *scan_area_cache;
 
 /* set if tracing memory operations is enabled */
-static atomic_t kmemleak_enabled = ATOMIC_INIT(0);
+static int kmemleak_enabled;
 /* set in the late_initcall if there were no errors */
-static atomic_t kmemleak_initialized = ATOMIC_INIT(0);
+static int kmemleak_initialized;
 /* enables or disables early logging of the memory operations */
-static atomic_t kmemleak_early_log = ATOMIC_INIT(1);
+static int kmemleak_early_log = 1;
 /* set if a kmemleak warning was issued */
-static atomic_t kmemleak_warning = ATOMIC_INIT(0);
+static int kmemleak_warning;
 /* set if a fatal kmemleak error has occurred */
-static atomic_t kmemleak_error = ATOMIC_INIT(0);
+static int kmemleak_error;
 
 /* minimum and maximum address that may be valid pointers */
 static unsigned long min_addr = ULONG_MAX;
@@ -268,7 +268,7 @@ static void kmemleak_disable(void);
 #define kmemleak_warn(x...)	do {		\
 	pr_warning(x);				\
 	dump_stack();				\
-	atomic_set(&kmemleak_warning, 1);	\
+	kmemleak_warning = 1;			\
 } while (0)
 
 /*
@@ -806,7 +806,7 @@ static void __init log_early(int op_type
 	unsigned long flags;
 	struct early_log *log;
 
-	if (atomic_read(&kmemleak_error)) {
+	if (kmemleak_error) {
 		/* kmemleak stopped recording, just count the requests */
 		crt_early_log++;
 		return;
@@ -841,7 +841,7 @@ static void early_alloc(struct early_log
 	unsigned long flags;
 	int i;
 
-	if (!atomic_read(&kmemleak_enabled) || !log->ptr || IS_ERR(log->ptr))
+	if (!kmemleak_enabled || !log->ptr || IS_ERR(log->ptr))
 		return;
 
 	/*
@@ -894,9 +894,9 @@ void __ref kmemleak_alloc(const void *pt
 {
 	pr_debug("%s(0x%p, %zu, %d)\n", __func__, ptr, size, min_count);
 
-	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		create_object((unsigned long)ptr, size, min_count, gfp);
-	else if (atomic_read(&kmemleak_early_log))
+	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_ALLOC, ptr, size, min_count);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc);
@@ -920,11 +920,11 @@ void __ref kmemleak_alloc_percpu(const v
 	 * Percpu allocations are only scanned and not reported as leaks
 	 * (min_count is set to 0).
 	 */
-	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		for_each_possible_cpu(cpu)
 			create_object((unsigned long)per_cpu_ptr(ptr, cpu),
 				      size, 0, GFP_KERNEL);
-	else if (atomic_read(&kmemleak_early_log))
+	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_ALLOC_PERCPU, ptr, size, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc_percpu);
@@ -940,9 +940,9 @@ void __ref kmemleak_free(const void *ptr
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		delete_object_full((unsigned long)ptr);
-	else if (atomic_read(&kmemleak_early_log))
+	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_FREE, ptr, 0, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free);
@@ -960,9 +960,9 @@ void __ref kmemleak_free_part(const void
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		delete_object_part((unsigned long)ptr, size);
-	else if (atomic_read(&kmemleak_early_log))
+	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_FREE_PART, ptr, size, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_part);
@@ -980,11 +980,11 @@ void __ref kmemleak_free_percpu(const vo
 
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		for_each_possible_cpu(cpu)
 			delete_object_full((unsigned long)per_cpu_ptr(ptr,
 								      cpu));
-	else if (atomic_read(&kmemleak_early_log))
+	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_FREE_PERCPU, ptr, 0, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_percpu);
@@ -1000,9 +1000,9 @@ void __ref kmemleak_not_leak(const void
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		make_gray_object((unsigned long)ptr);
-	else if (atomic_read(&kmemleak_early_log))
+	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_NOT_LEAK, ptr, 0, 0);
 }
 EXPORT_SYMBOL(kmemleak_not_leak);
@@ -1020,9 +1020,9 @@ void __ref kmemleak_ignore(const void *p
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		make_black_object((unsigned long)ptr);
-	else if (atomic_read(&kmemleak_early_log))
+	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_IGNORE, ptr, 0, 0);
 }
 EXPORT_SYMBOL(kmemleak_ignore);
@@ -1042,9 +1042,9 @@ void __ref kmemleak_scan_area(const void
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (atomic_read(&kmemleak_enabled) && ptr && size && !IS_ERR(ptr))
+	if (kmemleak_enabled && ptr && size && !IS_ERR(ptr))
 		add_scan_area((unsigned long)ptr, size, gfp);
-	else if (atomic_read(&kmemleak_early_log))
+	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_SCAN_AREA, ptr, size, 0);
 }
 EXPORT_SYMBOL(kmemleak_scan_area);
@@ -1062,9 +1062,9 @@ void __ref kmemleak_no_scan(const void *
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		object_no_scan((unsigned long)ptr);
-	else if (atomic_read(&kmemleak_early_log))
+	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_NO_SCAN, ptr, 0, 0);
 }
 EXPORT_SYMBOL(kmemleak_no_scan);
@@ -1089,7 +1089,7 @@ static bool update_checksum(struct kmeml
  */
 static int scan_should_stop(void)
 {
-	if (!atomic_read(&kmemleak_enabled))
+	if (!kmemleak_enabled)
 		return 1;
 
 	/*
@@ -1630,14 +1630,14 @@ static ssize_t kmemleak_write(struct fil
 		return ret;
 
 	if (strncmp(buf, "clear", 5) == 0) {
-		if (atomic_read(&kmemleak_enabled))
+		if (kmemleak_enabled)
 			kmemleak_clear();
 		else
 			__kmemleak_do_cleanup();
 		goto out;
 	}
 
-	if (!atomic_read(&kmemleak_enabled)) {
+	if (!kmemleak_enabled) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1726,14 +1726,14 @@ static DECLARE_WORK(cleanup_work, kmemle
 static void kmemleak_disable(void)
 {
 	/* atomically check whether it was already invoked */
-	if (atomic_cmpxchg(&kmemleak_error, 0, 1))
+	if (cmpxchg(&kmemleak_error, 0, 1))
 		return;
 
 	/* stop any memory operation tracing */
-	atomic_set(&kmemleak_enabled, 0);
+	kmemleak_enabled = 0;
 
 	/* check whether it is too early for a kernel thread */
-	if (atomic_read(&kmemleak_initialized))
+	if (kmemleak_initialized)
 		schedule_work(&cleanup_work);
 
 	pr_info("Kernel memory leak detector disabled\n");
@@ -1775,9 +1775,10 @@ void __init kmemleak_init(void)
 	int i;
 	unsigned long flags;
 
+	kmemleak_early_log = 0;
+
 #ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
 	if (!kmemleak_skip_disable) {
-		atomic_set(&kmemleak_early_log, 0);
 		kmemleak_disable();
 		return;
 	}
@@ -1795,12 +1796,11 @@ void __init kmemleak_init(void)
 
 	/* the kernel is still in UP mode, so disabling the IRQs is enough */
 	local_irq_save(flags);
-	atomic_set(&kmemleak_early_log, 0);
-	if (atomic_read(&kmemleak_error)) {
+	if (kmemleak_error) {
 		local_irq_restore(flags);
 		return;
 	} else
-		atomic_set(&kmemleak_enabled, 1);
+		kmemleak_enabled = 1;
 	local_irq_restore(flags);
 
 	/*
@@ -1844,9 +1844,9 @@ void __init kmemleak_init(void)
 				      log->op_type);
 		}
 
-		if (atomic_read(&kmemleak_warning)) {
+		if (kmemleak_warning) {
 			print_log_trace(log);
-			atomic_set(&kmemleak_warning, 0);
+			kmemleak_warning = 0;
 		}
 	}
 }
@@ -1858,9 +1858,9 @@ static int __init kmemleak_late_init(voi
 {
 	struct dentry *dentry;
 
-	atomic_set(&kmemleak_initialized, 1);
+	kmemleak_initialized = 1;
 
-	if (atomic_read(&kmemleak_error)) {
+	if (kmemleak_error) {
 		/*
 		 * Some error occurred and kmemleak was disabled. There is a
 		 * small chance that kmemleak_disable() was called immediately
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator.patch
linux-next.patch

