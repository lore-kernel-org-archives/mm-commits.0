From: akpm@linux-foundation.org
Subject: + kmemleak-change-some-global-variables-to-int.patch added to -mm tree
Date: Fri, 21 Mar 2014 14:30:13 -0700
Message-ID: <532caf65.58UlOS+KB8KZdOIX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaCUVaO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Mar 2014 17:30:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: + kmemleak-change-some-global-variables-to-int.patch added to -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com
From: akpm@linux-foundation.org
Date: Fri, 21 Mar 2014 14:30:13 -0700


The patch titled
     Subject: kmemleak: change some global variables to int
has been added to the -mm tree.  Its filename is
     kmemleak-change-some-global-variables-to-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemleak-change-some-global-variables-to-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-change-some-global-variables-to-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak: change some global variables to int

They don't have to be atomic_t, because they are simple boolean
toggles.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   78 ++++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

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
@@ -267,7 +267,7 @@ static void kmemleak_disable(void);
 #define kmemleak_warn(x...)	do {		\
 	pr_warning(x);				\
 	dump_stack();				\
-	atomic_set(&kmemleak_warning, 1);	\
+	kmemleak_warning = 1;			\
 } while (0)
 
 /*
@@ -805,7 +805,7 @@ static void __init log_early(int op_type
 	unsigned long flags;
 	struct early_log *log;
 
-	if (atomic_read(&kmemleak_error)) {
+	if (kmemleak_error) {
 		/* kmemleak stopped recording, just count the requests */
 		crt_early_log++;
 		return;
@@ -840,7 +840,7 @@ static void early_alloc(struct early_log
 	unsigned long flags;
 	int i;
 
-	if (!atomic_read(&kmemleak_enabled) || !log->ptr || IS_ERR(log->ptr))
+	if (!kmemleak_enabled || !log->ptr || IS_ERR(log->ptr))
 		return;
 
 	/*
@@ -893,9 +893,9 @@ void __ref kmemleak_alloc(const void *pt
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
@@ -919,11 +919,11 @@ void __ref kmemleak_alloc_percpu(const v
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
@@ -939,9 +939,9 @@ void __ref kmemleak_free(const void *ptr
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
@@ -959,9 +959,9 @@ void __ref kmemleak_free_part(const void
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
@@ -979,11 +979,11 @@ void __ref kmemleak_free_percpu(const vo
 
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
@@ -999,9 +999,9 @@ void __ref kmemleak_not_leak(const void
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
@@ -1019,9 +1019,9 @@ void __ref kmemleak_ignore(const void *p
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
@@ -1041,9 +1041,9 @@ void __ref kmemleak_scan_area(const void
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
@@ -1061,9 +1061,9 @@ void __ref kmemleak_no_scan(const void *
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
@@ -1088,7 +1088,7 @@ static bool update_checksum(struct kmeml
  */
 static int scan_should_stop(void)
 {
-	if (!atomic_read(&kmemleak_enabled))
+	if (!kmemleak_enabled)
 		return 1;
 
 	/*
@@ -1626,7 +1626,7 @@ static ssize_t kmemleak_write(struct fil
 		goto out;
 	}
 
-	if (!atomic_read(&kmemleak_enabled)) {
+	if (!kmemleak_enabled) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1714,14 +1714,14 @@ static DECLARE_WORK(cleanup_work, kmemle
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
@@ -1763,9 +1763,10 @@ void __init kmemleak_init(void)
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
@@ -1783,12 +1784,11 @@ void __init kmemleak_init(void)
 
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
@@ -1832,9 +1832,9 @@ void __init kmemleak_init(void)
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
@@ -1846,9 +1846,9 @@ static int __init kmemleak_late_init(voi
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
kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch
kmemleak-remove-redundant-code.patch
kmemleak-change-some-global-variables-to-int.patch
kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator.patch
linux-next.patch

