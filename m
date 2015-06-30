From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch removed from -mm tree
Date: Tue, 30 Jun 2015 14:49:04 -0700
Message-ID: <55930ed0.ZTcjRdK0oMwWIYKY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbbF3VtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: Reduce number of times pageblocks are set during struct page init -fix
has been removed from the -mm tree.  Its filename was
     mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch

This patch was dropped because it was folded into mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch

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
@@ -4591,8 +4591,8 @@ void __meminit memmap_init_zone(unsigned
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

origin.patch
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
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch

