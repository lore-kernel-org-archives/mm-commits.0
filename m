From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-function-__putback_isolated_page.patch added to
 -mm tree
Date: Tue, 11 Feb 2020 16:19:46 -0800
Message-ID: <20200212001946.YZyKF4q-V%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgBLATs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 19:19:48 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com, dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com, lcapitulino@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, nitesh@redhat.com, osalvador@suse.de, pagupta@redhat.com, pbonzini@redhat.com, riel@surriel.com, vbabka@suse.cz, wei.w.wang@intel.com, willy@infradead.org, yang.zhang.wz@gmail.com


The patch titled
     Subject: mm: add function __putback_isolated_page
has been added to the -mm tree.  Its filename is
     mm-add-function-__putback_isolated_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-function-__putback_isolated_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-function-__putback_isolated_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: mm: add function __putback_isolated_page

There are cases where we would benefit from avoiding having to go through
the allocation and free cycle to return an isolated page.

Examples for this might include page poisoning in which we isolate a page
and then put it back in the free list without ever having actually
allocated it.

This will enable us to also avoid notifiers for the future free page
reporting which will need to avoid retriggering page reporting when
returning pages that have been reported on.

Link: http://lkml.kernel.org/r/20200211224624.29318.89287.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Yang Zhang <yang.zhang.wz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    2 ++
 mm/page_alloc.c     |   19 +++++++++++++++++++
 mm/page_isolation.c |    6 ++----
 3 files changed, 23 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-add-function-__putback_isolated_page
+++ a/mm/internal.h
@@ -157,6 +157,8 @@ static inline struct page *pageblock_pfn
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
+extern void __putback_isolated_page(struct page *page, unsigned int order,
+				    int mt);
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order);
--- a/mm/page_alloc.c~mm-add-function-__putback_isolated_page
+++ a/mm/page_alloc.c
@@ -3219,6 +3219,25 @@ int __isolate_free_page(struct page *pag
 	return 1UL << order;
 }
 
+/**
+ * __putback_isolated_page - Return a now-isolated page back where we got it
+ * @page: Page that was isolated
+ * @order: Order of the isolated page
+ *
+ * This function is meant to return a page pulled from the free lists via
+ * __isolate_free_page back to the free lists they were pulled from.
+ */
+void __putback_isolated_page(struct page *page, unsigned int order, int mt)
+{
+	struct zone *zone = page_zone(page);
+
+	/* zone lock should be held when this function is called */
+	lockdep_assert_held(&zone->lock);
+
+	/* Return isolated page to tail of freelist. */
+	__free_one_page(page, page_to_pfn(page), zone, order, mt);
+}
+
 /*
  * Update NUMA hit/miss statistics
  *
--- a/mm/page_isolation.c~mm-add-function-__putback_isolated_page
+++ a/mm/page_isolation.c
@@ -117,13 +117,11 @@ static void unset_migratetype_isolate(st
 		__mod_zone_freepage_state(zone, nr_pages, migratetype);
 	}
 	set_pageblock_migratetype(page, migratetype);
+	if (isolated_page)
+		__putback_isolated_page(page, order, migratetype);
 	zone->nr_isolate_pageblock--;
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
-	if (isolated_page) {
-		post_alloc_hook(page, order, __GFP_MOVABLE);
-		__free_pages(page, order);
-	}
 }
 
 static inline struct page *
_

Patches currently in -mm which might be from alexander.h.duyck@linux.intel.com are

mm-adjust-shuffle-code-to-allow-for-future-coalescing.patch
mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators.patch
mm-add-function-__putback_isolated_page.patch
mm-introduce-reported-pages.patch
virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting.patch
virtio-balloon-add-support-for-providing-free-page-reports-to-host.patch
mm-page_reporting-rotate-reported-pages-to-the-tail-of-the-list.patch
mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass.patch
mm-page_reporting-add-free-page-reporting-documentation.patch
