From: akpm@linux-foundation.org
Subject: + mm-bug-fix-free-page-check-in-zone_watermark_ok.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:02:09 -0700
Message-ID: <20120712210210.A1C9A5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:38991 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab2GLVCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:02:13 -0400
Received: by lbbgp10 with SMTP id gp10so165276lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:02:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, aaditya.kumar@ap.sony.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz


The patch titled
     Subject: mm: fix free page check in zone_watermark_ok()
has been added to the -mm tree.  Its filename is
     mm-bug-fix-free-page-check-in-zone_watermark_ok.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix free page check in zone_watermark_ok()

In __zone_watermark_ok(), free and min are signed long type while
z->lowmem_reserve[classzone_idx] is unsigned long type.  So comparision of
them could be wrong due to type conversion to unsigned although free_pages
is minus value.

It could return true instead of false in case of order-0 check so that
kswapd could sleep forever.  It means livelock because direct reclaimer
loops forever until kswapd set zone->all_unreclaimable.

Aaditya reported this problem when he test my hotplug patch.

Reported-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Tested-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-bug-fix-free-page-check-in-zone_watermark_ok mm/page_alloc.c
--- a/mm/page_alloc.c~mm-bug-fix-free-page-check-in-zone_watermark_ok
+++ a/mm/page_alloc.c
@@ -1594,6 +1594,7 @@ static bool __zone_watermark_ok(struct z
 {
 	/* free_pages my go negative - that's OK */
 	long min = mark;
+	long lowmem_reserve = z->lowmem_reserve[classzone_idx];
 	int o;
 
 	free_pages -= (1 << order) - 1;
@@ -1602,7 +1603,7 @@ static bool __zone_watermark_ok(struct z
 	if (alloc_flags & ALLOC_HARDER)
 		min -= min / 4;
 
-	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
+	if (free_pages <= min + lowmem_reserve)
 		return false;
 	for (o = 0; o < order; o++) {
 		/* At the next order, this order's pages become unavailable */
_
Subject: Subject: mm: fix free page check in zone_watermark_ok()

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
linux-next.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-cleanup-on-compaction_deferred.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
vmscan-remove-obsolete-shrink_control-comment.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch

