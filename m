From: akpm@linux-foundation.org
Subject: [merged] mm-convert-pr_warning-to-pr_warn.patch removed from -mm
 tree
Date: Mon, 21 Mar 2016 11:39:51 -0700
Message-ID: <56f03ff7.pLwaPy/wdKYU7S0N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbcCUT41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert pr_warning to pr_warn
has been removed from the -mm tree.  Its filename was
     mm-convert-pr_warning-to-pr_warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm: convert pr_warning to pr_warn

There are a mixture of pr_warning and pr_warn uses in mm.  Use pr_warn
consistently.

Miscellanea:

o Coalesce formats
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Tejun Heo <tj@kernel.org>	[percpu]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    5 ++---
 mm/kmemleak.c |   14 +++++++-------
 mm/percpu.c   |   15 +++++++--------
 3 files changed, 16 insertions(+), 18 deletions(-)

diff -puN mm/hugetlb.c~mm-convert-pr_warning-to-pr_warn mm/hugetlb.c
--- a/mm/hugetlb.c~mm-convert-pr_warning-to-pr_warn
+++ a/mm/hugetlb.c
@@ -2665,7 +2665,7 @@ void __init hugetlb_add_hstate(unsigned
 	unsigned long i;
 
 	if (size_to_hstate(PAGE_SIZE << order)) {
-		pr_warning("hugepagesz= specified twice, ignoring\n");
+		pr_warn("hugepagesz= specified twice, ignoring\n");
 		return;
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
@@ -2701,8 +2701,7 @@ static int __init hugetlb_nrpages_setup(
 		mhp = &parsed_hstate->max_huge_pages;
 
 	if (mhp == last_mhp) {
-		pr_warning("hugepages= specified twice without "
-			   "interleaving hugepagesz=, ignoring\n");
+		pr_warn("hugepages= specified twice without interleaving hugepagesz=, ignoring\n");
 		return 1;
 	}
 
diff -puN mm/kmemleak.c~mm-convert-pr_warning-to-pr_warn mm/kmemleak.c
--- a/mm/kmemleak.c~mm-convert-pr_warning-to-pr_warn
+++ a/mm/kmemleak.c
@@ -276,7 +276,7 @@ static void kmemleak_disable(void);
  * Print a warning and dump the stack trace.
  */
 #define kmemleak_warn(x...)	do {		\
-	pr_warning(x);				\
+	pr_warn(x);				\
 	dump_stack();				\
 	kmemleak_warning = 1;			\
 } while (0)
@@ -543,7 +543,7 @@ static struct kmemleak_object *create_ob
 
 	object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
 	if (!object) {
-		pr_warning("Cannot allocate a kmemleak_object structure\n");
+		pr_warn("Cannot allocate a kmemleak_object structure\n");
 		kmemleak_disable();
 		return NULL;
 	}
@@ -764,7 +764,7 @@ static void add_scan_area(unsigned long
 
 	area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
 	if (!area) {
-		pr_warning("Cannot allocate a scan area\n");
+		pr_warn("Cannot allocate a scan area\n");
 		goto out;
 	}
 
@@ -1515,7 +1515,7 @@ static void start_scan_thread(void)
 		return;
 	scan_thread = kthread_run(kmemleak_scan_thread, NULL, "kmemleak");
 	if (IS_ERR(scan_thread)) {
-		pr_warning("Failed to create the scan thread\n");
+		pr_warn("Failed to create the scan thread\n");
 		scan_thread = NULL;
 	}
 }
@@ -1874,8 +1874,8 @@ void __init kmemleak_init(void)
 	scan_area_cache = KMEM_CACHE(kmemleak_scan_area, SLAB_NOLEAKTRACE);
 
 	if (crt_early_log > ARRAY_SIZE(early_log))
-		pr_warning("Early log buffer exceeded (%d), please increase "
-			   "DEBUG_KMEMLEAK_EARLY_LOG_SIZE\n", crt_early_log);
+		pr_warn("Early log buffer exceeded (%d), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE\n",
+			crt_early_log);
 
 	/* the kernel is still in UP mode, so disabling the IRQs is enough */
 	local_irq_save(flags);
@@ -1960,7 +1960,7 @@ static int __init kmemleak_late_init(voi
 	dentry = debugfs_create_file("kmemleak", S_IRUGO, NULL, NULL,
 				     &kmemleak_fops);
 	if (!dentry)
-		pr_warning("Failed to create the debugfs kmemleak file\n");
+		pr_warn("Failed to create the debugfs kmemleak file\n");
 	mutex_lock(&scan_mutex);
 	start_scan_thread();
 	mutex_unlock(&scan_mutex);
diff -puN mm/percpu.c~mm-convert-pr_warning-to-pr_warn mm/percpu.c
--- a/mm/percpu.c~mm-convert-pr_warning-to-pr_warn
+++ a/mm/percpu.c
@@ -1033,8 +1033,8 @@ fail_unlock:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 fail:
 	if (!is_atomic && warn_limit) {
-		pr_warning("PERCPU: allocation failed, size=%zu align=%zu atomic=%d, %s\n",
-			   size, align, is_atomic, err);
+		pr_warn("PERCPU: allocation failed, size=%zu align=%zu atomic=%d, %s\n",
+			size, align, is_atomic, err);
 		dump_stack();
 		if (!--warn_limit)
 			pr_info("PERCPU: limit reached, disable warning\n");
@@ -1723,7 +1723,7 @@ static int __init percpu_alloc_setup(cha
 		pcpu_chosen_fc = PCPU_FC_PAGE;
 #endif
 	else
-		pr_warning("PERCPU: unknown allocator %s specified\n", str);
+		pr_warn("PERCPU: unknown allocator %s specified\n", str);
 
 	return 0;
 }
@@ -2016,9 +2016,8 @@ int __init pcpu_embed_first_chunk(size_t
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
 	if (max_distance > VMALLOC_TOTAL * 3 / 4) {
-		pr_warning("PERCPU: max_distance=0x%zx too large for vmalloc "
-			   "space 0x%lx\n", max_distance,
-			   VMALLOC_TOTAL);
+		pr_warn("PERCPU: max_distance=0x%zx too large for vmalloc space 0x%lx\n",
+			max_distance, VMALLOC_TOTAL);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 		/* and fail if we have fallback */
 		rc = -EINVAL;
@@ -2100,8 +2099,8 @@ int __init pcpu_page_first_chunk(size_t
 
 			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE);
 			if (!ptr) {
-				pr_warning("PERCPU: failed to allocate %s page "
-					   "for cpu%u\n", psize_str, cpu);
+				pr_warn("PERCPU: failed to allocate %s page for cpu%u\n",
+					psize_str, cpu);
 				goto enomem;
 			}
 			/* kmemleak tracks the percpu allocations separately */
_

Patches currently in -mm which might be from joe@perches.com are

kernel-convert-pr_warning-to-pr_warn.patch

