From: akpm@linux-foundation.org
Subject: [merged]
 mm-meminit-free-pages-in-large-chunks-where-possible.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:46:26 -0700
Message-ID: <559adb12.pov2uAW20W7bdOLM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbbGFTq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, penberg@kernel.org, robinmholt@gmail.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: free pages in large chunks where possible
has been removed from the -mm tree.  Its filename was
     mm-meminit-free-pages-in-large-chunks-where-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: meminit: free pages in large chunks where possible

Parallel struct page frees pages one at a time. Try free pages as single
large pages where possible.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Nate Zimmer <nzimmer@sgi.com>
Tested-by: Waiman Long <waiman.long@hp.com>
Tested-by: Daniel J Blueman <daniel@numascale.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Nate Zimmer <nzimmer@sgi.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   55 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-free-pages-in-large-chunks-where-possible mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-free-pages-in-large-chunks-where-possible
+++ a/mm/page_alloc.c
@@ -1062,6 +1062,25 @@ void __defer_init __free_pages_bootmem(s
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+static void __defermem_init deferred_free_range(struct page *page,
+					unsigned long pfn, int nr_pages)
+{
+	int i;
+
+	if (!page)
+		return;
+
+	/* Free a large naturally-aligned chunk if possible */
+	if (nr_pages == MAX_ORDER_NR_PAGES &&
+	    (pfn & (MAX_ORDER_NR_PAGES-1)) == 0) {
+		__free_pages_boot_core(page, pfn, MAX_ORDER-1);
+		return;
+	}
+
+	for (i = 0; i < nr_pages; i++, page++, pfn++)
+		__free_pages_boot_core(page, pfn, 0);
+}
+
 /* Initialise remaining memory on a node */
 void __defermem_init deferred_init_memmap(int nid)
 {
@@ -1092,6 +1111,9 @@ void __defermem_init deferred_init_memma
 	for_each_mem_pfn_range(i, nid, &walk_start, &walk_end, NULL) {
 		unsigned long pfn, end_pfn;
 		struct page *page = NULL;
+		struct page *free_base_page = NULL;
+		unsigned long free_base_pfn = 0;
+		int nr_to_free = 0;
 
 		end_pfn = min(walk_end, zone_end_pfn(zone));
 		pfn = first_init_pfn;
@@ -1102,7 +1124,7 @@ void __defermem_init deferred_init_memma
 
 		for (; pfn < end_pfn; pfn++) {
 			if (!pfn_valid_within(pfn))
-				continue;
+				goto free_range;
 
 			/*
 			 * Ensure pfn_valid is checked every
@@ -1111,32 +1133,53 @@ void __defermem_init deferred_init_memma
 			if ((pfn & (MAX_ORDER_NR_PAGES - 1)) == 0) {
 				if (!pfn_valid(pfn)) {
 					page = NULL;
-					continue;
+					goto free_range;
 				}
 			}
 
 			if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
 				page = NULL;
-				continue;
+				goto free_range;
 			}
 
 			/* Minimise pfn page lookups and scheduler checks */
 			if (page && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0) {
 				page++;
 			} else {
+				nr_pages += nr_to_free;
+				deferred_free_range(free_base_page,
+						free_base_pfn, nr_to_free);
+				free_base_page = NULL;
+				free_base_pfn = nr_to_free = 0;
+
 				page = pfn_to_page(pfn);
 				cond_resched();
 			}
 
 			if (page->flags) {
 				VM_BUG_ON(page_zone(page) != zone);
-				continue;
+				goto free_range;
 			}
 
 			__init_single_page(page, pfn, zid, nid);
-			__free_pages_boot_core(page, pfn, 0);
-			nr_pages++;
+			if (!free_base_page) {
+				free_base_page = page;
+				free_base_pfn = pfn;
+				nr_to_free = 0;
+			}
+			nr_to_free++;
+
+			/* Where possible, batch up pages for a single free */
+			continue;
+free_range:
+			/* Free the current block of pages to allocator */
+			nr_pages += nr_to_free;
+			deferred_free_range(free_base_page, free_base_pfn,
+								nr_to_free);
+			free_base_page = NULL;
+			free_base_pfn = nr_to_free = 0;
 		}
+
 		first_init_pfn = max(end_pfn, first_init_pfn);
 	}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

