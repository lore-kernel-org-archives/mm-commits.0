From: akpm@linux-foundation.org
Subject: + mm-page_owner-make-init_pages_in_zone-faster.patch added to -mm tree
Date: Fri, 21 Jul 2017 13:07:25 -0700
Message-ID: <59725efd.ytgnmESTYJXiG4Ro%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54932 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdGUUH0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 16:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, vinmenon@codeaurora.org, yang.shi@linaro.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: make init_pages_in_zone() faster
has been added to the -mm tree.  Its filename is
     mm-page_owner-make-init_pages_in_zone-faster.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-make-init_pages_in_zone-faster.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-make-init_pages_in_zone-faster.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: make init_pages_in_zone() faster

In init_pages_in_zone() we currently use the generic set_page_owner()
function to initialize page_owner info for early allocated pages.  This
means we needlessly do lookup_page_ext() twice for each page, and more
importantly save_stack(), which has to unwind the stack and find the
corresponding stack depot handle.  Because the stack is always the same
for the initialization, unwind it once in init_pages_in_zone() and reuse
the handle.  Also avoid the repeated lookup_page_ext().

This can significantly reduce boot times with page_owner=on on large
machines, especially for kernels built without frame pointer, where the
stack unwinding is noticeably slower.

Link: http://lkml.kernel.org/r/20170720134029.25268-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN mm/page_owner.c~mm-page_owner-make-init_pages_in_zone-faster mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-make-init_pages_in_zone-faster
+++ a/mm/page_owner.c
@@ -183,6 +183,20 @@ noinline void __set_page_owner(struct pa
 	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 }
 
+static void __set_page_owner_init(struct page_ext *page_ext,
+					depot_stack_handle_t handle)
+{
+	struct page_owner *page_owner;
+
+	page_owner = get_page_owner(page_ext);
+	page_owner->handle = handle;
+	page_owner->order = 0;
+	page_owner->gfp_mask = 0;
+	page_owner->last_migrate_reason = -1;
+
+	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
+}
+
 void __set_page_owner_migrate_reason(struct page *page, int reason)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
@@ -520,10 +534,13 @@ static void init_pages_in_zone(pg_data_t
 	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
 	unsigned long end_pfn = pfn + zone->spanned_pages;
 	unsigned long count = 0;
+	depot_stack_handle_t init_handle;
 
 	/* Scan block by block. First and last block may be incomplete */
 	pfn = zone->zone_start_pfn;
 
+	init_handle = save_stack(0);
+
 	/*
 	 * Walk the zone in pageblock_nr_pages steps. If a page block spans
 	 * a zone boundary, it will be double counted between zones. This does
@@ -570,7 +587,7 @@ static void init_pages_in_zone(pg_data_t
 				continue;
 
 			/* Found early allocated page */
-			set_page_owner(page, 0, 0);
+			__set_page_owner_init(page_ext, init_handle);
 			count++;
 		}
 	}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_owner-make-init_pages_in_zone-faster.patch
mm-page_ext-periodically-reschedule-during-page_ext_init.patch
mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone.patch
mm-page_ext-move-page_ext_init-after-page_alloc_init_late.patch

