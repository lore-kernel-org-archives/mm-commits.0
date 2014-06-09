From: akpm@linux-foundation.org
Subject: [merged] mm-convert-some-level-less-printks-to-pr_.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:41:36 -0700
Message-ID: <53960df0./R6EFEME0UJltLVp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mitchelh@codeaurora.org

Subject: [merged] mm-convert-some-level-less-printks-to-pr_.patch removed from -mm tree
To: mitchelh@codeaurora.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:36 -0700


The patch titled
     Subject: mm: convert some level-less printks to pr_*
has been removed from the -mm tree.  Its filename was
     mm-convert-some-level-less-printks-to-pr_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: mm: convert some level-less printks to pr_*

printk is meant to be used with an associated log level.  There are some
instances of printk scattered around the mm code where the log level is
missing.  Add a log level and adhere to suggestions by
scripts/checkpatch.pl by moving to the pr_* macros.

Also add the typical pr_fmt definition so that print statements can be
easily traced back to the modules where they occur, correlated one with
another, etc.  This will require the removal of some (now redundant)
prefixes on a few print statements.

Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bounce.c |    7 +++++--
 mm/mempolicy.c |    5 ++++-
 mm/mmap.c      |   21 ++++++++++++---------
 mm/nommu.c     |    5 ++++-
 mm/vmscan.c    |    5 ++++-
 5 files changed, 29 insertions(+), 14 deletions(-)

diff -puN block/bounce.c~mm-convert-some-level-less-printks-to-pr_ block/bounce.c
--- a/block/bounce.c~mm-convert-some-level-less-printks-to-pr_
+++ a/block/bounce.c
@@ -3,6 +3,8 @@
  * - Split from highmem.c
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/swap.h>
@@ -15,6 +17,7 @@
 #include <linux/hash.h>
 #include <linux/highmem.h>
 #include <linux/bootmem.h>
+#include <linux/printk.h>
 #include <asm/tlbflush.h>
 
 #include <trace/events/block.h>
@@ -34,7 +37,7 @@ static __init int init_emergency_pool(vo
 
 	page_pool = mempool_create_page_pool(POOL_SIZE, 0);
 	BUG_ON(!page_pool);
-	printk("bounce pool size: %d pages\n", POOL_SIZE);
+	pr_info("pool size: %d pages\n", POOL_SIZE);
 
 	return 0;
 }
@@ -86,7 +89,7 @@ int init_emergency_isa_pool(void)
 				       mempool_free_pages, (void *) 0);
 	BUG_ON(!isa_page_pool);
 
-	printk("isa bounce pool size: %d pages\n", ISA_POOL_SIZE);
+	pr_info("isa pool size: %d pages\n", ISA_POOL_SIZE);
 	return 0;
 }
 
diff -puN mm/mempolicy.c~mm-convert-some-level-less-printks-to-pr_ mm/mempolicy.c
--- a/mm/mempolicy.c~mm-convert-some-level-less-printks-to-pr_
+++ a/mm/mempolicy.c
@@ -65,6 +65,8 @@
    kernel is not always grateful with that.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
@@ -91,6 +93,7 @@
 #include <linux/ctype.h>
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
+#include <linux/printk.h>
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
@@ -2645,7 +2648,7 @@ void __init numa_policy_init(void)
 		node_set(prefer, interleave_nodes);
 
 	if (do_set_mempolicy(MPOL_INTERLEAVE, 0, &interleave_nodes))
-		printk("numa_policy_init: interleaving failed\n");
+		pr_err("%s: interleaving failed\n", __func__);
 
 	check_numabalancing_enable();
 }
diff -puN mm/mmap.c~mm-convert-some-level-less-printks-to-pr_ mm/mmap.c
--- a/mm/mmap.c~mm-convert-some-level-less-printks-to-pr_
+++ a/mm/mmap.c
@@ -6,6 +6,8 @@
  * Address space accounting code	<alan@lxorguk.ukuu.org.uk>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
@@ -37,6 +39,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/notifier.h>
 #include <linux/memory.h>
+#include <linux/printk.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -361,20 +364,20 @@ static int browse_rb(struct rb_root *roo
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
 		if (vma->vm_start < prev) {
-			printk("vm_start %lx prev %lx\n", vma->vm_start, prev);
+			pr_info("vm_start %lx prev %lx\n", vma->vm_start, prev);
 			bug = 1;
 		}
 		if (vma->vm_start < pend) {
-			printk("vm_start %lx pend %lx\n", vma->vm_start, pend);
+			pr_info("vm_start %lx pend %lx\n", vma->vm_start, pend);
 			bug = 1;
 		}
 		if (vma->vm_start > vma->vm_end) {
-			printk("vm_end %lx < vm_start %lx\n",
+			pr_info("vm_end %lx < vm_start %lx\n",
 				vma->vm_end, vma->vm_start);
 			bug = 1;
 		}
 		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma)) {
-			printk("free gap %lx, correct %lx\n",
+			pr_info("free gap %lx, correct %lx\n",
 			       vma->rb_subtree_gap,
 			       vma_compute_subtree_gap(vma));
 			bug = 1;
@@ -388,7 +391,7 @@ static int browse_rb(struct rb_root *roo
 	for (nd = pn; nd; nd = rb_prev(nd))
 		j++;
 	if (i != j) {
-		printk("backwards %d, forwards %d\n", j, i);
+		pr_info("backwards %d, forwards %d\n", j, i);
 		bug = 1;
 	}
 	return bug ? -1 : i;
@@ -423,17 +426,17 @@ static void validate_mm(struct mm_struct
 		i++;
 	}
 	if (i != mm->map_count) {
-		printk("map_count %d vm_next %d\n", mm->map_count, i);
+		pr_info("map_count %d vm_next %d\n", mm->map_count, i);
 		bug = 1;
 	}
 	if (highest_address != mm->highest_vm_end) {
-		printk("mm->highest_vm_end %lx, found %lx\n",
+		pr_info("mm->highest_vm_end %lx, found %lx\n",
 		       mm->highest_vm_end, highest_address);
 		bug = 1;
 	}
 	i = browse_rb(&mm->mm_rb);
 	if (i != mm->map_count) {
-		printk("map_count %d rb %d\n", mm->map_count, i);
+		pr_info("map_count %d rb %d\n", mm->map_count, i);
 		bug = 1;
 	}
 	BUG_ON(bug);
@@ -3280,7 +3283,7 @@ static struct notifier_block reserve_mem
 static int __meminit init_reserve_notifier(void)
 {
 	if (register_hotmemory_notifier(&reserve_mem_nb))
-		printk("Failed registering memory add/remove notifier for admin reserve");
+		pr_err("Failed registering memory add/remove notifier for admin reserve\n");
 
 	return 0;
 }
diff -puN mm/nommu.c~mm-convert-some-level-less-printks-to-pr_ mm/nommu.c
--- a/mm/nommu.c~mm-convert-some-level-less-printks-to-pr_
+++ a/mm/nommu.c
@@ -13,6 +13,8 @@
  *  Copyright (c) 2007-2010 Paul Mundt <lethal@linux-sh.org>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/vmacache.h>
@@ -32,6 +34,7 @@
 #include <linux/syscalls.h>
 #include <linux/audit.h>
 #include <linux/sched/sysctl.h>
+#include <linux/printk.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
@@ -1246,7 +1249,7 @@ error_free:
 	return ret;
 
 enomem:
-	printk("Allocation of length %lu from process %d (%s) failed\n",
+	pr_err("Allocation of length %lu from process %d (%s) failed\n",
 	       len, current->pid, current->comm);
 	show_free_areas(0);
 	return -ENOMEM;
diff -puN mm/vmscan.c~mm-convert-some-level-less-printks-to-pr_ mm/vmscan.c
--- a/mm/vmscan.c~mm-convert-some-level-less-printks-to-pr_
+++ a/mm/vmscan.c
@@ -11,6 +11,8 @@
  *  Multiqueue VM started 5.8.00, Rik van Riel.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/gfp.h>
@@ -43,6 +45,7 @@
 #include <linux/sysctl.h>
 #include <linux/oom.h>
 #include <linux/prefetch.h>
+#include <linux/printk.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -480,7 +483,7 @@ static pageout_t pageout(struct page *pa
 		if (page_has_private(page)) {
 			if (try_to_free_buffers(page)) {
 				ClearPageDirty(page);
-				printk("%s: orphaned page\n", __func__);
+				pr_info("%s: orphaned page\n", __func__);
 				return PAGE_CLEAN;
 			}
 		}
_

Patches currently in -mm which might be from mitchelh@codeaurora.org are

origin.patch
linux-next.patch

