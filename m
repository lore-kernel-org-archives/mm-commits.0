From: akpm@linux-foundation.org
Subject: + mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch added
 to -mm tree
Date: Fri, 01 May 2015 13:44:01 -0700
Message-ID: <5543e591.XhIZbP958EVAt9CQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbbEAUoC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2015 16:44:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: pass PFN to __free_pages_bootmem -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: pass PFN to __free_pages_bootmem -fix

Stephen Rothwell reported the following

	Today's linux-next build (sparc defconfig) failed like this:

	mm/bootmem.c: In function 'free_all_bootmem_core':
	mm/bootmem.c:237:32: error: 'cur' undeclared (first use in this function)
	   __free_pages_bootmem(page++, cur++, 0);
                                ^
	Caused by commit "mm: page_alloc: pass PFN to __free_pages_bootmem".

He also merged a fix. The only difference in this version is one line is
moved so the final diff context is clearer. This is a fix to the mmotm
patch mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/bootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix mm/bootmem.c
--- a/mm/bootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix
+++ a/mm/bootmem.c
@@ -172,7 +172,7 @@ void __init free_bootmem_late(unsigned l
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	struct page *page;
-	unsigned long *map, start, end, pages, count = 0;
+	unsigned long *map, start, end, pages, cur, count = 0;
 
 	if (!bdata->node_bootmem_map)
 		return 0;
@@ -214,7 +214,7 @@ static unsigned long __init free_all_boo
 			count += BITS_PER_LONG;
 			start += BITS_PER_LONG;
 		} else {
-			unsigned long cur = start;
+			cur = start;
 
 			start = ALIGN(start + 1, BITS_PER_LONG);
 			while (vec && cur != start) {
@@ -229,6 +229,7 @@ static unsigned long __init free_all_boo
 		}
 	}
 
+	cur = bdata->node_min_pfn;
 	page = virt_to_page(bdata->node_bootmem_map);
 	pages = bdata->node_low_pfn - bdata->node_min_pfn;
 	pages = bootmem_bootmap_pages(pages);
_

Patches currently in -mm which might be from mgorman@suse.de are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-remove-mminit_verify_page_links.patch
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
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

