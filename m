From: akpm@linux-foundation.org
Subject: [merged] proc-report-file-anon-bit-in-proc-pid-pagemap.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:00 -0700
Message-ID: <20120601193400.89E43A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43398 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865Ab2FATjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:39:14 -0400
Received: by eeit10 with SMTP id t10so140860eei.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:39:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, riel@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: report file/anon bit in /proc/pid/pagemap
has been removed from the -mm tree.  Its filename was
     proc-report-file-anon-bit-in-proc-pid-pagemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: proc: report file/anon bit in /proc/pid/pagemap

This is an implementation of Andrew's proposal to extend the pagemap file
bits to report what is missing about tasks' working set.

The problem with the working set detection is multilateral.  In the criu
(checkpoint/restore) project we dump the tasks' memory into image files
and to do it properly we need to detect which pages inside mappings are
really in use.  The mincore syscall I though could help with this did not.
 First, it doesn't report swapped pages, thus we cannot find out which
parts of anonymous mappings to dump.  Next, it does report pages from page
cache as present even if they are not mapped, and it doesn't make that has
not been cow-ed.

Note, that issue with swap pages is critical -- we must dump swap pages to
image file.  But the issues with file pages are optimization -- we can
take all file pages to image, this would be correct, but if we know that a
page is not mapped or not cow-ed, we can remove them from dump file.  The
dump would still be self-consistent, though significantly smaller in size
(up to 10 times smaller on real apps).

Andrew noticed, that the proc pagemap file solved 2 of 3 above issues --
it reports whether a page is present or swapped and it doesn't report not
mapped page cache pages.  But, it doesn't distinguish cow-ed file pages
from not cow-ed.

I would like to make the last unused bit in this file to report whether the
page mapped into respective pte is PageAnon or not.

[comment stolen from Pavel Emelyanov's v1 patch]

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    2 -
 fs/proc/task_mmu.c           |   46 ++++++++++++++++++++-------------
 2 files changed, 30 insertions(+), 18 deletions(-)

diff -puN Documentation/vm/pagemap.txt~proc-report-file-anon-bit-in-proc-pid-pagemap Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~proc-report-file-anon-bit-in-proc-pid-pagemap
+++ a/Documentation/vm/pagemap.txt
@@ -16,7 +16,7 @@ There are three components to pagemap:
     * Bits 0-4   swap type if swapped
     * Bits 5-54  swap offset if swapped
     * Bits 55-60 page shift (page size = 1<<page shift)
-    * Bit  61    reserved for future use
+    * Bit  61    page is file-page or shared-anon
     * Bit  62    page swapped
     * Bit  63    page present
 
diff -puN fs/proc/task_mmu.c~proc-report-file-anon-bit-in-proc-pid-pagemap fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-report-file-anon-bit-in-proc-pid-pagemap
+++ a/fs/proc/task_mmu.c
@@ -700,6 +700,7 @@ struct pagemapread {
 
 #define PM_PRESENT          PM_STATUS(4LL)
 #define PM_SWAP             PM_STATUS(2LL)
+#define PM_FILE             PM_STATUS(1LL)
 #define PM_NOT_PRESENT      PM_PSHIFT(PAGE_SHIFT)
 #define PM_END_OF_BUFFER    1
 
@@ -733,22 +734,33 @@ static int pagemap_pte_hole(unsigned lon
 	return err;
 }
 
-static u64 swap_pte_to_pagemap_entry(pte_t pte)
+static void pte_to_pagemap_entry(pagemap_entry_t *pme,
+		struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
-	swp_entry_t e = pte_to_swp_entry(pte);
-	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
-}
+	u64 frame, flags;
+	struct page *page = NULL;
 
-static void pte_to_pagemap_entry(pagemap_entry_t *pme, pte_t pte)
-{
-	if (is_swap_pte(pte))
-		*pme = make_pme(PM_PFRAME(swap_pte_to_pagemap_entry(pte))
-				| PM_PSHIFT(PAGE_SHIFT) | PM_SWAP);
-	else if (pte_present(pte))
-		*pme = make_pme(PM_PFRAME(pte_pfn(pte))
-				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
-	else
+	if (pte_present(pte)) {
+		frame = pte_pfn(pte);
+		flags = PM_PRESENT;
+		page = vm_normal_page(vma, addr, pte);
+	} else if (is_swap_pte(pte)) {
+		swp_entry_t entry = pte_to_swp_entry(pte);
+
+		frame = swp_type(entry) |
+			(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
+		flags = PM_SWAP;
+		if (is_migration_entry(entry))
+			page = migration_entry_to_page(entry);
+	} else {
 		*pme = make_pme(PM_NOT_PRESENT);
+		return;
+	}
+
+	if (page && !PageAnon(page))
+		flags |= PM_FILE;
+
+	*pme = make_pme(PM_PFRAME(frame) | PM_PSHIFT(PAGE_SHIFT) | flags);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -815,7 +827,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 		if (vma && (vma->vm_start <= addr) &&
 		    !is_vm_hugetlb_page(vma)) {
 			pte = pte_offset_map(pmd, addr);
-			pte_to_pagemap_entry(&pme, *pte);
+			pte_to_pagemap_entry(&pme, vma, addr, *pte);
 			/* unmap before userspace copy */
 			pte_unmap(pte);
 		}
@@ -869,11 +881,11 @@ static int pagemap_hugetlb_range(pte_t *
  * For each page in the address space, this file contains one 64-bit entry
  * consisting of the following:
  *
- * Bits 0-55  page frame number (PFN) if present
+ * Bits 0-54  page frame number (PFN) if present
  * Bits 0-4   swap type if swapped
- * Bits 5-55  swap offset if swapped
+ * Bits 5-54  swap offset if swapped
  * Bits 55-60 page shift (page size = 1<<page shift)
- * Bit  61    reserved for future use
+ * Bit  61    page is file-page or shared-anon
  * Bit  62    page swapped
  * Bit  63    page present
  *
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

