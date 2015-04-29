From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-meminit-remove-mminit_verify_page_links.patch
 removed from -mm tree
Date: Wed, 29 Apr 2015 13:37:05 -0700
Message-ID: <554140f1.Y0cJrt4y1gzgl/9h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbD2UhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 16:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, holt@sgi.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: remove mminit_verify_page_links
has been removed from the -mm tree.  Its filename was
     mm-meminit-remove-mminit_verify_page_links.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: meminit: remove mminit_verify_page_links

mminit_verify_page_links() is an extremely paranoid check that was
introduced when memory initialisation was being heavily reworked. 
Profiles indicated that up to 10% of parallel memory initialisation was
spent on checking this for every page.  The cost could be reduced but in
practice this check only found problems very early during the
initialisation rewrite and has found nothing since.  This patch removes an
expensive unnecessary check.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    8 --------
 mm/mm_init.c    |    8 --------
 mm/page_alloc.c |    1 -
 3 files changed, 17 deletions(-)

diff -puN mm/internal.h~mm-meminit-remove-mminit_verify_page_links mm/internal.h
--- a/mm/internal.h~mm-meminit-remove-mminit_verify_page_links
+++ a/mm/internal.h
@@ -362,10 +362,7 @@ do { \
 } while (0)
 
 extern void mminit_verify_pageflags_layout(void);
-extern void mminit_verify_page_links(struct page *page,
-		enum zone_type zone, unsigned long nid, unsigned long pfn);
 extern void mminit_verify_zonelist(void);
-
 #else
 
 static inline void mminit_dprintk(enum mminit_level level,
@@ -377,11 +374,6 @@ static inline void mminit_verify_pagefla
 {
 }
 
-static inline void mminit_verify_page_links(struct page *page,
-		enum zone_type zone, unsigned long nid, unsigned long pfn)
-{
-}
-
 static inline void mminit_verify_zonelist(void)
 {
 }
diff -puN mm/mm_init.c~mm-meminit-remove-mminit_verify_page_links mm/mm_init.c
--- a/mm/mm_init.c~mm-meminit-remove-mminit_verify_page_links
+++ a/mm/mm_init.c
@@ -131,14 +131,6 @@ void __init mminit_verify_pageflags_layo
 	BUG_ON(or_mask != add_mask);
 }
 
-void __meminit mminit_verify_page_links(struct page *page, enum zone_type zone,
-			unsigned long nid, unsigned long pfn)
-{
-	BUG_ON(page_to_nid(page) != nid);
-	BUG_ON(page_zonenum(page) != zone);
-	BUG_ON(page_to_pfn(page) != pfn);
-}
-
 static __init int set_mminit_loglevel(char *str)
 {
 	get_option(&str, &mminit_loglevel);
diff -puN mm/page_alloc.c~mm-meminit-remove-mminit_verify_page_links mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-remove-mminit_verify_page_links
+++ a/mm/page_alloc.c
@@ -853,7 +853,6 @@ static void __meminit __init_single_page
 				unsigned long zone, int nid)
 {
 	set_page_links(page, zone, nid, pfn);
-	mminit_verify_page_links(page, zone, nid, pfn);
 	init_page_count(page);
 	page_mapcount_reset(page);
 	page_cpupid_reset_last(page);
_

Patches currently in -mm which might be from mgorman@suse.de are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
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

