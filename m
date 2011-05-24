From: akpm@linux-foundation.org
Subject: [folded] mm-nommu-sort-mm-mmap-list-properly-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 16:51:38 -0700
Message-ID: <201105242351.p4ONpc50023596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932094Ab1EXXwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, namhyung@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm-nommu-sort-mm-mmap-list-properly-fix
has been removed from the -mm tree.  Its filename was
     mm-nommu-sort-mm-mmap-list-properly-fix.patch

This patch was dropped because it was folded into mm-nommu-sort-mm-mmap-list-properly.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-nommu-sort-mm-mmap-list-properly-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid duplicating __vma_link_list().

Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++++
 mm/mmap.c     |   23 -----------------------
 mm/nommu.c    |   24 ------------------------
 mm/util.c     |   24 ++++++++++++++++++++++++
 4 files changed, 28 insertions(+), 47 deletions(-)

diff -puN mm/internal.h~mm-nommu-sort-mm-mmap-list-properly-fix mm/internal.h
--- a/mm/internal.h~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/internal.h
@@ -66,6 +66,10 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
+/* mm/util.c */
+void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct rb_node *rb_parent);
+
 #ifdef CONFIG_MMU
 extern long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
diff -puN mm/mmap.c~mm-nommu-sort-mm-mmap-list-properly-fix mm/mmap.c
--- a/mm/mmap.c~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/mmap.c
@@ -398,29 +398,6 @@ find_vma_prepare(struct mm_struct *mm, u
 	return vma;
 }
 
-static inline void
-__vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
-		struct vm_area_struct *prev, struct rb_node *rb_parent)
-{
-	struct vm_area_struct *next;
-
-	vma->vm_prev = prev;
-	if (prev) {
-		next = prev->vm_next;
-		prev->vm_next = vma;
-	} else {
-		mm->mmap = vma;
-		if (rb_parent)
-			next = rb_entry(rb_parent,
-					struct vm_area_struct, vm_rb);
-		else
-			next = NULL;
-	}
-	vma->vm_next = next;
-	if (next)
-		next->vm_prev = vma;
-}
-
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
diff -puN mm/nommu.c~mm-nommu-sort-mm-mmap-list-properly-fix mm/nommu.c
--- a/mm/nommu.c~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/nommu.c
@@ -672,30 +672,6 @@ static void protect_vma(struct vm_area_s
 #endif
 }
 
-/* borrowed from mm/mmap.c */
-static inline void
-__vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
-		struct vm_area_struct *prev, struct rb_node *rb_parent)
-{
-	struct vm_area_struct *next;
-
-	vma->vm_prev = prev;
-	if (prev) {
-		next = prev->vm_next;
-		prev->vm_next = vma;
-	} else {
-		mm->mmap = vma;
-		if (rb_parent)
-			next = rb_entry(rb_parent,
-					struct vm_area_struct, vm_rb);
-		else
-			next = NULL;
-	}
-	vma->vm_next = next;
-	if (next)
-		next->vm_prev = vma;
-}
-
 /*
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * and tree and add to the address space's page tree also if not an anonymous
diff -puN mm/util.c~mm-nommu-sort-mm-mmap-list-properly-fix mm/util.c
--- a/mm/util.c~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/util.c
@@ -6,6 +6,8 @@
 #include <linux/sched.h>
 #include <asm/uaccess.h>
 
+#include "internal.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/kmem.h>
 
@@ -215,6 +217,28 @@ char *strndup_user(const char __user *s,
 }
 EXPORT_SYMBOL(strndup_user);
 
+void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct rb_node *rb_parent)
+{
+	struct vm_area_struct *next;
+
+	vma->vm_prev = prev;
+	if (prev) {
+		next = prev->vm_next;
+		prev->vm_next = vma;
+	} else {
+		mm->mmap = vma;
+		if (rb_parent)
+			next = rb_entry(rb_parent,
+					struct vm_area_struct, vm_rb);
+		else
+			next = NULL;
+	}
+	vma->vm_next = next;
+	if (next)
+		next->vm_prev = vma;
+}
+
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
alpha-hook-up-gpiolib-support-fix.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

