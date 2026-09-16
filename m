Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775544ACC6C
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 22:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598535; cv=none; b=KumYAHCUdCIH9ovbeXfzxUsC6f2a6FGtU/ECdY4yMAF+/fo2dIMXV7WOYxOI9TV/FWqXqFWHL2qKPqlaoRby5NfXJh7xFb7I8mBtV1CrZeHiH2kUFdIrYEtDEcjfvMXRaGGFqB8s2n7J8MI7Nq4N58x43uw6xkIPUw6FuPjku64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598535; c=relaxed/simple;
	bh=QTXrmeMIj51qVLFg61aYfl+k4gMEo4wQ/p6wEJNNbL8=;
	h=Date:To:From:Subject:Message-Id; b=lUMwhHaEeTOpf26hRFc0FeDpsyYc2X1jFpH8aKCOQ5h8m1v/65/F7AsldB/5x3rSbLbX4ZEXEbF6huykvbwz+V+UZ3bQxjoLKMmwYcvEYIq0FgY+cmsOhrQxnLUeoJKNuANiNVZRcGsd8Vf50k25SKV7p/GHiZtyWxP7FYY/9IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=npPa9XLW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="npPa9XLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCCD1F00898;
	Wed, 16 Sep 2026 22:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598518;
	bh=7ix5HpKb9OwaozojvVmnaJZEKuoDUTtaOzB1Fn5AP4Y=;
	h=Date:To:From:Subject;
	b=npPa9XLWPzeEZwc+RFMsTyEN3t5jvcVo8CPIV1IvXbRMrw4JIdkFXC3+ZAUAGVVeS
	 RvRlZEXCTHVjTSBC5/7NIYww3hUUl3aI7UhJih321vlZApqYIrXywcnBZhdSupVXHu
	 AvYvXer54fjvZxxaRaEqAJAmj6CZiy3Pj15AXmKw=
Date: Wed, 16 Sep 2026 15:41:58 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-collapse-add-collapseh-for-the-collapse-interface.patch removed from -mm tree
Message-Id: <20260916224158.CFCCD1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/collapse: add collapse.h for the collapse interface
has been removed from the -mm tree.  Its filename was
     mm-collapse-add-collapseh-for-the-collapse-interface.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/collapse: add collapse.h for the collapse interface
Date: Thu, 10 Sep 2026 13:02:24 +0100

khugepaged.c holds both the users of collapse and the machinery that
performs it.  The daemon's scan loop, the sysfs tunables, MADV_COLLAPSE's
entry point and the collapse itself all sit in one file and reach into
each other freely.  Nothing marks where a user ends and the engine begins.

Start drawing that line.

Add mm/collapse.h for what the two sides have to agree on:

  - enum scan_result - what the engine hands back;
  - struct collapse_control - the state a request carries.

And two constants move with them:

  - KHUGEPAGED_MAX_PTES_LIMIT -> COLLAPSE_MAX_PTES_LIMIT;
  - KHUGEPAGED_MIN_MTHP_ORDER -> COLLAPSE_MIN_MTHP_ORDER.

Neither is a fact about the daemon, so both lose the KHUGEPAGED_ prefix.

No functional change.

Assisted-by: LLM
Link: https://lore.kernel.org/20260910120238.2529819-5-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 MAINTAINERS     |    1 
 mm/collapse.h   |   64 +++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c |   79 +++++++---------------------------------------
 3 files changed, 78 insertions(+), 66 deletions(-)

--- a/MAINTAINERS~mm-collapse-add-collapseh-for-the-collapse-interface
+++ a/MAINTAINERS
@@ -17433,6 +17433,7 @@ F:	Documentation/admin-guide/mm/transhug
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
+F:	mm/collapse.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
diff --git a/mm/collapse.h a/mm/collapse.h
new file mode 100644
--- /dev/null
+++ a/mm/collapse.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __MM_COLLAPSE_H
+#define __MM_COLLAPSE_H
+
+#include <linux/mm.h>
+#include <linux/nodemask.h>
+#include <linux/pgtable.h>
+#include <linux/types.h>
+
+#define COLLAPSE_MAX_PTES_LIMIT		(HPAGE_PMD_NR - 1)
+#define COLLAPSE_MIN_MTHP_ORDER		2
+
+enum scan_result {
+	SCAN_FAIL,
+	SCAN_SUCCEED,
+	SCAN_NO_PTE_TABLE,
+	SCAN_PMD_MAPPED,
+	SCAN_EXCEED_NONE_PTE,
+	SCAN_EXCEED_SWAP_PTE,
+	SCAN_EXCEED_SHARED_PTE,
+	SCAN_PTE_NON_PRESENT,
+	SCAN_PTE_UFFD,
+	SCAN_PTE_MAPPED_HUGEPAGE,
+	SCAN_LACK_REFERENCED_PAGE,
+	SCAN_PAGE_NULL,
+	SCAN_SCAN_ABORT,
+	SCAN_PAGE_COUNT,
+	SCAN_PAGE_LRU,
+	SCAN_PAGE_LOCK,
+	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
+	SCAN_PAGE_COMPOUND,
+	SCAN_ANY_PROCESS,
+	SCAN_VMA_NULL,
+	SCAN_VMA_CHECK,
+	SCAN_ADDRESS_RANGE,
+	SCAN_DEL_PAGE_LRU,
+	SCAN_ALLOC_HUGE_PAGE_FAIL,
+	SCAN_CGROUP_CHARGE_FAIL,
+	SCAN_TRUNCATED,
+	SCAN_PAGE_HAS_PRIVATE,
+	SCAN_STORE_FAILED,
+	SCAN_COPY_MC,
+	SCAN_PAGE_FILLED,
+	SCAN_PAGE_DIRTY_OR_WRITEBACK,
+};
+
+struct collapse_control {
+	bool is_khugepaged;
+
+	/* Num pages scanned per node */
+	u32 node_load[MAX_NUMNODES];
+
+	/* Num pages scanned (see khugepaged_pages_to_scan) */
+	unsigned int progress;
+
+	/* nodemask for allocation fallback */
+	nodemask_t alloc_nmask;
+
+	/* Each bit marks a PTE the scan accepted as a collapse source */
+	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+};
+
+#endif	/* __MM_COLLAPSE_H */
--- a/mm/khugepaged.c~mm-collapse-add-collapseh-for-the-collapse-interface
+++ a/mm/khugepaged.c
@@ -26,44 +26,10 @@
 #include <linux/cleanup.h>
 
 #include <asm/tlb.h>
+#include "collapse.h"
 #include "internal.h"
-#include "page_alloc.h"
 #include "mm_slot.h"
-
-enum scan_result {
-	SCAN_FAIL,
-	SCAN_SUCCEED,
-	SCAN_NO_PTE_TABLE,
-	SCAN_PMD_MAPPED,
-	SCAN_EXCEED_NONE_PTE,
-	SCAN_EXCEED_SWAP_PTE,
-	SCAN_EXCEED_SHARED_PTE,
-	SCAN_PTE_NON_PRESENT,
-	SCAN_PTE_UFFD,
-	SCAN_PTE_MAPPED_HUGEPAGE,
-	SCAN_LACK_REFERENCED_PAGE,
-	SCAN_PAGE_NULL,
-	SCAN_SCAN_ABORT,
-	SCAN_PAGE_COUNT,
-	SCAN_PAGE_LRU,
-	SCAN_PAGE_LOCK,
-	SCAN_PAGE_ANON,
-	SCAN_PAGE_LAZYFREE,
-	SCAN_PAGE_COMPOUND,
-	SCAN_ANY_PROCESS,
-	SCAN_VMA_NULL,
-	SCAN_VMA_CHECK,
-	SCAN_ADDRESS_RANGE,
-	SCAN_DEL_PAGE_LRU,
-	SCAN_ALLOC_HUGE_PAGE_FAIL,
-	SCAN_CGROUP_CHARGE_FAIL,
-	SCAN_TRUNCATED,
-	SCAN_PAGE_HAS_PRIVATE,
-	SCAN_STORE_FAILED,
-	SCAN_COPY_MC,
-	SCAN_PAGE_FILLED,
-	SCAN_PAGE_DIRTY_OR_WRITEBACK,
-};
+#include "page_alloc.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
@@ -91,7 +57,6 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
-#define KHUGEPAGED_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
 unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
@@ -101,24 +66,6 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_s
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
-#define KHUGEPAGED_MIN_MTHP_ORDER	2
-
-struct collapse_control {
-	bool is_khugepaged;
-
-	/* Num pages scanned per node */
-	u32 node_load[MAX_NUMNODES];
-
-	/* Num pages scanned (see khugepaged_pages_to_scan) */
-	unsigned int progress;
-
-	/* nodemask for allocation fallback */
-	nodemask_t alloc_nmask;
-
-	/* Each bit marks a PTE the scan accepted as a collapse source */
-	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
-};
-
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -267,7 +214,7 @@ static ssize_t max_ptes_none_store(struc
 	unsigned long max_ptes_none;
 
 	err = kstrtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
@@ -292,7 +239,7 @@ static ssize_t max_ptes_swap_store(struc
 	unsigned long max_ptes_swap;
 
 	err  = kstrtoul(buf, 10, &max_ptes_swap);
-	if (err || max_ptes_swap > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_swap = max_ptes_swap;
@@ -318,7 +265,7 @@ static ssize_t max_ptes_shared_store(str
 	unsigned long max_ptes_shared;
 
 	err  = kstrtoul(buf, 10, &max_ptes_shared);
-	if (err || max_ptes_shared > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_shared = max_ptes_shared;
@@ -378,19 +325,19 @@ static unsigned int collapse_max_ptes_no
 	if (is_pmd_order(order))
 		return max_ptes_none;
 	/*
-	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
+	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
 	 * scale the maximum number of PTEs to the order of the collapse.
 	 */
-	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
+	if (max_ptes_none == COLLAPSE_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
 	/*
-	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
+	 * For mTHP collapse of values other than 0 or COLLAPSE_MAX_PTES_LIMIT,
 	 * emit a warning and return 0.
 	 */
 	if (max_ptes_none)
 		pr_warn_once("mTHP collapse does not support max_ptes_none"
 		     " values other than 0 or %u, defaulting to 0.\n",
-		     KHUGEPAGED_MAX_PTES_LIMIT);
+		     COLLAPSE_MAX_PTES_LIMIT);
 	return 0;
 }
 
@@ -476,7 +423,7 @@ int __init khugepaged_init(void)
 		return -ENOMEM;
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
-	khugepaged_max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+	khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
 
@@ -1571,8 +1518,8 @@ next_order:
 		 * any smaller order enabled. When at the smallest order
 		 * we must always move to the next offset.
 		 */
-		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
-			(enabled_orders & GENMASK(order - 1, 0))) {
+		if (order > COLLAPSE_MIN_MTHP_ORDER &&
+		    (enabled_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
 		}
@@ -1636,7 +1583,7 @@ static enum scan_result collapse_scan_pm
 	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
-		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+		max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
 
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
a.patch

