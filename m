From: akpm@linux-foundation.org
Subject: + mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
 added to -mm tree
Date: Wed, 29 Apr 2015 14:19:29 -0700
Message-ID: <55414ae1.Ob0RuQOsM7dQId6V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbbD2VTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 17:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, daniel@numascale.com, dave.hansen@intel.com, holt@sgi.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, penberg@kernel.org, robinmholt@gmail.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: only set page reserved in the memblock region
has been added to the -mm tree.  Its filename is
     mm-meminit-only-set-page-reserved-in-the-memblock-region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-only-set-page-reserved-in-the-memblock-region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: mm: meminit: only set page reserved in the memblock region

Currently each page struct is set as reserved upon initialization.  This
patch leaves the reserved bit clear and only sets the reserved bit when it
is known the memory was allocated by the bootmem allocator.  This makes it
easier to distinguish between uninitialised struct pages and reserved
struct pages in later patches.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Nate Zimmer <nzimmer@sgi.com>
Tested-by: Waiman Long <waiman.long@hp.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/nobootmem.c     |    3 +++
 mm/page_alloc.c    |   17 ++++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-meminit-only-set-page-reserved-in-the-memblock-region include/linux/mm.h
--- a/include/linux/mm.h~mm-meminit-only-set-page-reserved-in-the-memblock-region
+++ a/include/linux/mm.h
@@ -1631,6 +1631,8 @@ extern void free_highmem_page(struct pag
 extern void adjust_managed_page_count(struct page *page, long count);
 extern void mem_init_print_info(const char *str);
 
+extern void reserve_bootmem_region(unsigned long start, unsigned long end);
+
 /* Free the reserved page into the buddy system, so it gets managed. */
 static inline void __free_reserved_page(struct page *page)
 {
diff -puN mm/nobootmem.c~mm-meminit-only-set-page-reserved-in-the-memblock-region mm/nobootmem.c
--- a/mm/nobootmem.c~mm-meminit-only-set-page-reserved-in-the-memblock-region
+++ a/mm/nobootmem.c
@@ -121,6 +121,9 @@ static unsigned long __init free_low_mem
 
 	memblock_clear_hotplug(0, -1);
 
+	for_each_reserved_mem_region(i, &start, &end)
+		reserve_bootmem_region(start, end);
+
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
diff -puN mm/page_alloc.c~mm-meminit-only-set-page-reserved-in-the-memblock-region mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-only-set-page-reserved-in-the-memblock-region
+++ a/mm/page_alloc.c
@@ -788,7 +788,6 @@ static void __meminit __init_single_page
 	init_page_count(page);
 	page_mapcount_reset(page);
 	page_cpupid_reset_last(page);
-	SetPageReserved(page);
 
 	/*
 	 * Mark the block movable so that blocks are reserved for
@@ -823,6 +822,22 @@ static void __meminit __init_single_pfn(
 	return __init_single_page(pfn_to_page(pfn), pfn, zone, nid);
 }
 
+/*
+ * Initialised pages do not have PageReserved set. This function is
+ * called for each range allocated by the bootmem allocator and
+ * marks the pages PageReserved. The remaining valid pages are later
+ * sent to the buddy page allocator.
+ */
+void reserve_bootmem_region(unsigned long start, unsigned long end)
+{
+	unsigned long start_pfn = PFN_DOWN(start);
+	unsigned long end_pfn = PFN_UP(end);
+
+	for (; start_pfn < end_pfn; start_pfn++)
+		if (pfn_valid(start_pfn))
+			SetPageReserved(pfn_to_page(start_pfn));
+}
+
 static bool free_pages_prepare(struct page *page, unsigned int order)
 {
 	bool compound = PageCompound(page);
_

Patches currently in -mm which might be from nzimmer@sgi.com are

memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-remove-mminit_verify_page_links.patch

