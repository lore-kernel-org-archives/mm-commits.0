From: akpm@linux-foundation.org
Subject: [merged] mm-percpuc-fix-panic-triggered-by-bug_on-falsely.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:26:41 -0800
Message-ID: <58519cf1.ob1SAPR44GmhdikO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45542 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756371AbcLNT0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, cl@linux.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu.c: fix panic triggered by BUG_ON() falsely
has been removed from the -mm tree.  Its filename was
     mm-percpuc-fix-panic-triggered-by-bug_on-falsely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zijun_hu <zijun_hu@htc.com>
Subject: mm/percpu.c: fix panic triggered by BUG_ON() falsely

As shown by pcpu_build_alloc_info(), the number of units within a percpu
group is deduced by rounding up the number of CPUs within the group to
@upa boundary/ Therefore, the number of CPUs isn't equal to the units's if
it isn't aligned to @upa normally.  However, pcpu_page_first_chunk() uses
BUG_ON() to assert that one number is equal to the other roughly, so a
panic is maybe triggered by the BUG_ON() incorrectly.

In order to fix this issue, the number of CPUs is rounded up then compared
with units's and the BUG_ON() is replaced with a warning and return of an
error code as well, to keep system alive as much as possible.

Link: http://lkml.kernel.org/r/57FCF07C.2020103@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN mm/percpu.c~mm-percpuc-fix-panic-triggered-by-bug_on-falsely mm/percpu.c
--- a/mm/percpu.c~mm-percpuc-fix-panic-triggered-by-bug_on-falsely
+++ a/mm/percpu.c
@@ -2093,6 +2093,8 @@ int __init pcpu_page_first_chunk(size_t
 	size_t pages_size;
 	struct page **pages;
 	int unit, i, j, rc;
+	int upa;
+	int nr_g0_units;
 
 	snprintf(psize_str, sizeof(psize_str), "%luK", PAGE_SIZE >> 10);
 
@@ -2100,7 +2102,12 @@ int __init pcpu_page_first_chunk(size_t
 	if (IS_ERR(ai))
 		return PTR_ERR(ai);
 	BUG_ON(ai->nr_groups != 1);
-	BUG_ON(ai->groups[0].nr_units != num_possible_cpus());
+	upa = ai->alloc_size/ai->unit_size;
+	nr_g0_units = roundup(num_possible_cpus(), upa);
+	if (unlikely(WARN_ON(ai->groups[0].nr_units != nr_g0_units))) {
+		pcpu_free_alloc_info(ai);
+		return -EINVAL;
+	}
 
 	unit_pages = ai->unit_size >> PAGE_SHIFT;
 
@@ -2111,21 +2118,22 @@ int __init pcpu_page_first_chunk(size_t
 
 	/* allocate pages */
 	j = 0;
-	for (unit = 0; unit < num_possible_cpus(); unit++)
+	for (unit = 0; unit < num_possible_cpus(); unit++) {
+		unsigned int cpu = ai->groups[0].cpu_map[unit];
 		for (i = 0; i < unit_pages; i++) {
-			unsigned int cpu = ai->groups[0].cpu_map[unit];
 			void *ptr;
 
 			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE);
 			if (!ptr) {
 				pr_warn("failed to allocate %s page for cpu%u\n",
-					psize_str, cpu);
+						psize_str, cpu);
 				goto enomem;
 			}
 			/* kmemleak tracks the percpu allocations separately */
 			kmemleak_free(ptr);
 			pages[j++] = virt_to_page(ptr);
 		}
+	}
 
 	/* allocate vm area, map the pages and copy static data */
 	vm.flags = VM_ALLOC;
_

Patches currently in -mm which might be from zijun_hu@htc.com are


