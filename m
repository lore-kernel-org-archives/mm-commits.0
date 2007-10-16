From: akpm@linux-foundation.org
Subject: - maps2-uninline-some-functions-in-the-page-walker.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:10 -0700
Message-ID: <200710162136.l9GLaAu6018539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933879AbXJPVg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: uninline some functions in the page walker
has been removed from the -mm tree.  Its filename was
     maps2-uninline-some-functions-in-the-page-walker.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: uninline some functions in the page walker
From: Matt Mackall <mpm@selenic.com>

This patch series introduces /proc/pid/pagemap and /proc/kpagemap, which allow
detailed run-time examination of process memory usage at a page granularity.

The first several patches whip the page-walking code introduced for
/proc/pid/smaps and clear_refs into a more generic form, the next couple make
those interfaces optional, and the last two introduce the new interfaces, also
optional.

This respin adds simple, expandable headers to both pagemap and kpagemap as
suggested by Nikita.  I haven't moved pagewalk.c from lib/ to mm/ as suggested
by Nick as I still think lib is a better fit for its automatic conditional
linking.


This patch:

Uninline some functions in the page walker

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/proc/task_mmu.c~maps2-uninline-some-functions-in-the-page-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-uninline-some-functions-in-the-page-walker
+++ a/fs/proc/task_mmu.c
@@ -284,7 +284,7 @@ static void clear_refs_pte_range(struct 
 	cond_resched();
 }
 
-static inline void walk_pmd_range(struct pmd_walker *walker, pud_t *pud,
+static void walk_pmd_range(struct pmd_walker *walker, pud_t *pud,
 				  unsigned long addr, unsigned long end)
 {
 	pmd_t *pmd;
@@ -299,7 +299,7 @@ static inline void walk_pmd_range(struct
 	}
 }
 
-static inline void walk_pud_range(struct pmd_walker *walker, pgd_t *pgd,
+static void walk_pud_range(struct pmd_walker *walker, pgd_t *pgd,
 				  unsigned long addr, unsigned long end)
 {
 	pud_t *pud;
@@ -323,11 +323,11 @@ static inline void walk_pud_range(struct
  * Recursively walk the page table for the memory area in a VMA, calling
  * a callback for every bottom-level (PTE) page table.
  */
-static inline void walk_page_range(struct vm_area_struct *vma,
-				   void (*action)(struct vm_area_struct *,
-						  pmd_t *, unsigned long,
-						  unsigned long, void *),
-				   void *private)
+static void walk_page_range(struct vm_area_struct *vma,
+			    void (*action)(struct vm_area_struct *,
+					   pmd_t *, unsigned long,
+					   unsigned long, void *),
+			    void *private)
 {
 	unsigned long addr = vma->vm_start;
 	unsigned long end = vma->vm_end;
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
maps2-add-proc-kpagemap-interface.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
lib-sortc-optimization.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
