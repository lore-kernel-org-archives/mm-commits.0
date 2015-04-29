From: akpm@linux-foundation.org
Subject: +
 mm-meminit-move-page-initialization-into-a-separate-function.patch added to -mm tree
Date: Wed, 29 Apr 2015 14:19:27 -0700
Message-ID: <55414adf.7fbjakWVnDEHxpI1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbD2VT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 17:19:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, daniel@numascale.com, dave.hansen@intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, nzimmer@sgi.com, penberg@kernel.org, robinmholt@gmail.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: move page initialization into a separate function
has been added to the -mm tree.  Its filename is
     mm-meminit-move-page-initialization-into-a-separate-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-move-page-initialization-into-a-separate-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-move-page-initialization-into-a-separate-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: mm: meminit: move page initialization into a separate function

Currently, memmap_init_zone() has all the smarts for initializing a single
page.  A subset of this is required for parallel page initialisation and
so this patch breaks up the monolithic function in preparation.

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

 mm/page_alloc.c |   79 ++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-move-page-initialization-into-a-separate-function mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-move-page-initialization-into-a-separate-function
+++ a/mm/page_alloc.c
@@ -778,6 +778,51 @@ static int free_tail_pages_check(struct
 	return 0;
 }
 
+static void __meminit __init_single_page(struct page *page, unsigned long pfn,
+				unsigned long zone, int nid)
+{
+	struct zone *z = &NODE_DATA(nid)->node_zones[zone];
+
+	set_page_links(page, zone, nid, pfn);
+	mminit_verify_page_links(page, zone, nid, pfn);
+	init_page_count(page);
+	page_mapcount_reset(page);
+	page_cpupid_reset_last(page);
+	SetPageReserved(page);
+
+	/*
+	 * Mark the block movable so that blocks are reserved for
+	 * movable at startup. This will force kernel allocations
+	 * to reserve their blocks rather than leaking throughout
+	 * the address space during boot when many long-lived
+	 * kernel allocations are made. Later some blocks near
+	 * the start are marked MIGRATE_RESERVE by
+	 * setup_zone_migrate_reserve()
+	 *
+	 * bitmap is created for zone's valid pfn range. but memmap
+	 * can be created for invalid pages (for alignment)
+	 * check here not to call set_pageblock_migratetype() against
+	 * pfn out of zone.
+	 */
+	if ((z->zone_start_pfn <= pfn)
+	    && (pfn < zone_end_pfn(z))
+	    && !(pfn & (pageblock_nr_pages - 1)))
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+
+	INIT_LIST_HEAD(&page->lru);
+#ifdef WANT_PAGE_VIRTUAL
+	/* The shift won't overflow because ZONE_NORMAL is below 4G. */
+	if (!is_highmem_idx(zone))
+		set_page_address(page, __va(pfn << PAGE_SHIFT));
+#endif
+}
+
+static void __meminit __init_single_pfn(unsigned long pfn, unsigned long zone,
+					int nid)
+{
+	return __init_single_page(pfn_to_page(pfn), pfn, zone, nid);
+}
+
 static bool free_pages_prepare(struct page *page, unsigned int order)
 {
 	bool compound = PageCompound(page);
@@ -4167,7 +4212,6 @@ static void setup_zone_migrate_reserve(s
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		unsigned long start_pfn, enum memmap_context context)
 {
-	struct page *page;
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
 	struct zone *z;
@@ -4188,38 +4232,7 @@ void __meminit memmap_init_zone(unsigned
 			if (!early_pfn_in_nid(pfn, nid))
 				continue;
 		}
-		page = pfn_to_page(pfn);
-		set_page_links(page, zone, nid, pfn);
-		mminit_verify_page_links(page, zone, nid, pfn);
-		init_page_count(page);
-		page_mapcount_reset(page);
-		page_cpupid_reset_last(page);
-		SetPageReserved(page);
-		/*
-		 * Mark the block movable so that blocks are reserved for
-		 * movable at startup. This will force kernel allocations
-		 * to reserve their blocks rather than leaking throughout
-		 * the address space during boot when many long-lived
-		 * kernel allocations are made. Later some blocks near
-		 * the start are marked MIGRATE_RESERVE by
-		 * setup_zone_migrate_reserve()
-		 *
-		 * bitmap is created for zone's valid pfn range. but memmap
-		 * can be created for invalid pages (for alignment)
-		 * check here not to call set_pageblock_migratetype() against
-		 * pfn out of zone.
-		 */
-		if ((z->zone_start_pfn <= pfn)
-		    && (pfn < zone_end_pfn(z))
-		    && !(pfn & (pageblock_nr_pages - 1)))
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
