From: akpm@linux-foundation.org
Subject: + mm-fix-incorrect-nr_free_pages-accounting-appears-like-memory-leak.patch added to -mm tree
Date: Wed, 21 Nov 2012 12:24:00 -0800
Message-ID: <20121121202400.BE123820612@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:47182 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab2KUUYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Nov 2012 15:24:01 -0500
Received: by mail-ye0-f202.google.com with SMTP id m11so210619yen.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Nov 2012 12:24:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, mgorman@suse.de, sukijaki@gmail.com


The patch titled
     Subject: mm: fix incorrect NR_FREE_PAGES accounting (appears like memory leak)
has been added to the -mm tree.  Its filename is
     mm-fix-incorrect-nr_free_pages-accounting-appears-like-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: mm: fix incorrect NR_FREE_PAGES accounting (appears like memory leak)

There have been some 3.7-rc reports of vm issues, including some
kswapd bugs and, more importantly, some memory "leaks":

	http://www.spinics.net/lists/linux-mm/msg46187.html
	https://bugzilla.kernel.org/show_bug.cgi?id=50181

The post-3.6 commit 1fb3f8ca ("mm: compaction: capture a suitable
high-order page immediately when it is made available") took
split_free_page() and reused it for the compaction code.  It does
something curious with capture_free_page() (previously known as
split_free_page()):

int capture_free_page(struct page *page, int alloc_order,
...
        __mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));

-       /* Split into individual pages */
-       set_page_refcounted(page);
-       split_page(page, order);
+       if (alloc_order != order)
+               expand(zone, page, alloc_order, order,
+                       &zone->free_area[order], migratetype);

Note that expand() puts the pages _back_ in the allocator, but it does not
bump NR_FREE_PAGES.  We "return" 'alloc_order' worth of pages, but we
accounted for removing 'order' in the __mod_zone_page_state() call.  For
the old split_page()-style use (order==alloc_order) the bug will not
trigger.  But, when called from the compaction code where we occasionally
get a larger page out of the buddy allocator than we need, we will run in
to this.

This patch simply changes the NR_FREE_PAGES manipulation to the correct
'alloc_order' instead of 'order'.

I've been able to repeatedly trigger this in my testing environment.  The
amount "leaked" very closely tracks the imbalance I see in buddy pages vs.
 NR_FREE_PAGES.  I have confirmed that this patch fixes the imbalance

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reported-by: Milos Jakovljevic <sukijaki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-fix-incorrect-nr_free_pages-accounting-appears-like-memory-leak mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-incorrect-nr_free_pages-accounting-appears-like-memory-leak
+++ a/mm/page_alloc.c
@@ -1405,7 +1405,7 @@ int capture_free_page(struct page *page,
 
 	mt = get_pageblock_migratetype(page);
 	if (unlikely(mt != MIGRATE_ISOLATE))
-		__mod_zone_freepage_state(zone, -(1UL << order), mt);
+		__mod_zone_freepage_state(zone, -(1UL << alloc_order), mt);
 
 	if (alloc_order != order)
 		expand(zone, page, alloc_order, order,
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

mm-fix-incorrect-nr_free_pages-accounting-appears-like-memory-leak.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
drop_caches-add-some-documentation-and-info-messsge.patch

