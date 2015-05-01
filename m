From: akpm@linux-foundation.org
Subject: +
 mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch added to -mm tree
Date: Fri, 01 May 2015 13:45:05 -0700
Message-ID: <5543e5d1.q3v7dMsfhhaDdFge%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbEAUpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2015 16:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: Reduce number of times pageblocks are set during struct page init -fix
has been added to the -mm tree.  Its filename is
     mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch

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
Subject: mm: meminit: Reduce number of times pageblocks are set during struct page init -fix

The patch "mm: meminit: Reduce number of times pageblocks are
set during struct page init" is setting a pageblock before
the page is initialised. This is a fix for the mmotm patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix
+++ a/mm/page_alloc.c
@@ -4541,8 +4541,8 @@ void __meminit memmap_init_zone(unsigned
 		if (!(pfn & (pageblock_nr_pages - 1))) {
 			struct page *page = pfn_to_page(pfn);
 
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 			__init_single_page(page, pfn, zone, nid);
+			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 		} else {
 			__init_single_pfn(pfn, zone, nid);
 		}
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
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch
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

