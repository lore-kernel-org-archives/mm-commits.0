From: akpm@linux-foundation.org
Subject: + mm-percpu-use-pr_fmt-to-prefix-output.patch added to -mm tree
Date: Mon, 07 Mar 2016 10:55:37 -0800
Message-ID: <56ddcea9.TWJP09JrKCbVFa1V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbcCGSzi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2016 13:55:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: percpu: use pr_fmt to prefix output
has been added to the -mm tree.  Its filename is
     mm-percpu-use-pr_fmt-to-prefix-output.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-percpu-use-pr_fmt-to-prefix-output.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-percpu-use-pr_fmt-to-prefix-output.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm: percpu: use pr_fmt to prefix output

Use the normal mechanism to make the logging output consistently "percpu:
" instead of a mix of "PERCPU: " and "percpu: "

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-km.c |    4 ++--
 mm/percpu.c    |   20 +++++++++++---------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/percpu-km.c~mm-percpu-use-pr_fmt-to-prefix-output mm/percpu-km.c
--- a/mm/percpu-km.c~mm-percpu-use-pr_fmt-to-prefix-output
+++ a/mm/percpu-km.c
@@ -95,7 +95,7 @@ static int __init pcpu_verify_alloc_info
 
 	/* all units must be in a single group */
 	if (ai->nr_groups != 1) {
-		pr_crit("percpu: can't handle more than one groups\n");
+		pr_crit("can't handle more than one group\n");
 		return -EINVAL;
 	}
 
@@ -103,7 +103,7 @@ static int __init pcpu_verify_alloc_info
 	alloc_pages = roundup_pow_of_two(nr_pages);
 
 	if (alloc_pages > nr_pages)
-		pr_warn("percpu: wasting %zu pages per chunk\n",
+		pr_warn("wasting %zu pages per chunk\n",
 			alloc_pages - nr_pages);
 
 	return 0;
diff -puN mm/percpu.c~mm-percpu-use-pr_fmt-to-prefix-output mm/percpu.c
--- a/mm/percpu.c~mm-percpu-use-pr_fmt-to-prefix-output
+++ a/mm/percpu.c
@@ -53,6 +53,8 @@
  *   setup the first chunk containing the kernel static percpu area
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitmap.h>
 #include <linux/bootmem.h>
 #include <linux/err.h>
@@ -1033,11 +1035,11 @@ fail_unlock:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 fail:
 	if (!is_atomic && warn_limit) {
-		pr_warn("PERCPU: allocation failed, size=%zu align=%zu atomic=%d, %s\n",
+		pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
 			size, align, is_atomic, err);
 		dump_stack();
 		if (!--warn_limit)
-			pr_info("PERCPU: limit reached, disable warning\n");
+			pr_info("limit reached, disable warning\n");
 	}
 	if (is_atomic) {
 		/* see the flag handling in pcpu_blance_workfn() */
@@ -1538,8 +1540,8 @@ int __init pcpu_setup_first_chunk(const
 
 #define PCPU_SETUP_BUG_ON(cond)	do {					\
 	if (unlikely(cond)) {						\
-		pr_emerg("PERCPU: failed to initialize, %s", #cond);	\
-		pr_emerg("PERCPU: cpu_possible_mask=%*pb\n",		\
+		pr_emerg("failed to initialize, %s\n", #cond);		\
+		pr_emerg("cpu_possible_mask=%*pb\n",			\
 			 cpumask_pr_args(cpu_possible_mask));		\
 		pcpu_dump_alloc_info(KERN_EMERG, ai);			\
 		BUG();							\
@@ -1723,7 +1725,7 @@ static int __init percpu_alloc_setup(cha
 		pcpu_chosen_fc = PCPU_FC_PAGE;
 #endif
 	else
-		pr_warn("PERCPU: unknown allocator %s specified\n", str);
+		pr_warn("unknown allocator %s specified\n", str);
 
 	return 0;
 }
@@ -2016,7 +2018,7 @@ int __init pcpu_embed_first_chunk(size_t
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
 	if (max_distance > VMALLOC_TOTAL * 3 / 4) {
-		pr_warn("PERCPU: max_distance=0x%zx too large for vmalloc space 0x%lx\n",
+		pr_warn("max_distance=0x%zx too large for vmalloc space 0x%lx\n",
 			max_distance, VMALLOC_TOTAL);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 		/* and fail if we have fallback */
@@ -2025,7 +2027,7 @@ int __init pcpu_embed_first_chunk(size_t
 #endif
 	}
 
-	pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
+	pr_info("Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
 		PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
 		ai->dyn_size, ai->unit_size);
 
@@ -2099,7 +2101,7 @@ int __init pcpu_page_first_chunk(size_t
 
 			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE);
 			if (!ptr) {
-				pr_warn("PERCPU: failed to allocate %s page for cpu%u\n",
+				pr_warn("failed to allocate %s page for cpu%u\n",
 					psize_str, cpu);
 				goto enomem;
 			}
@@ -2139,7 +2141,7 @@ int __init pcpu_page_first_chunk(size_t
 	}
 
 	/* we're ready, commit */
-	pr_info("PERCPU: %d %s pages/cpu @%p s%zu r%zu d%zu\n",
+	pr_info("%d %s pages/cpu @%p s%zu r%zu d%zu\n",
 		unit_pages, psize_str, vm.addr, ai->static_size,
 		ai->reserved_size, ai->dyn_size);
 
_

Patches currently in -mm which might be from joe@perches.com are

mm-convert-pr_warning-to-pr_warn.patch
mm-coalesce-split-strings.patch
mm-convert-printkkern_level-to-pr_level.patch
mm-percpu-use-pr_fmt-to-prefix-output.patch
checkpatch-exclude-asm-volatile-from-complex-macro-check.patch
kernel-convert-pr_warning-to-pr_warn.patch

