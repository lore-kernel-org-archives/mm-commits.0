From: akpm@linux-foundation.org
Subject: + memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch added to
 -mm tree
Date: Thu, 31 Jul 2014 15:25:09 -0700
Message-ID: <53dac245.nIYxb02XLbbdbO43%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:65157 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaGaWZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jul 2014 18:25:10 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so627151pab.3
        for <mm-commits@vger.kernel.org>; Thu, 31 Jul 2014 15:25:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, vmscan: Fix forced scan of anonymous pages
has been added to the -mm tree.  Its filename is
     memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: memcg, vmscan: Fix forced scan of anonymous pages

When memory cgoups are enabled, the code that decides to force to scan
anonymous pages in get_scan_count() compares global values (free,
high_watermark) to a value that is restricted to a memory cgroup (file). 
It make the code over-eager to force anon scan.

For instance, it will force anon scan when scanning a memcg that is mainly
populated by anonymous page, even when there is plenty of file pages to
get rid of in others memcgs, even when swappiness == 0.  It breaks user's
expectation about swappiness and hurts performance.

This patch makes sure that forced anon scan only happens when there not
enough file pages for the all zone, not just in one random memcg.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~memcg-vmscan-fix-forced-scan-of-anonymous-pages mm/vmscan.c
--- a/mm/vmscan.c~memcg-vmscan-fix-forced-scan-of-anonymous-pages
+++ a/mm/vmscan.c
@@ -1950,8 +1950,11 @@ static void get_scan_count(struct lruvec
 	 */
 	if (global_reclaim(sc)) {
 		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
+		unsigned long zonefile =
+			zone_page_state(zone, NR_LRU_BASE + LRU_ACTIVE_FILE) +
+			zone_page_state(zone, NR_LRU_BASE + LRU_INACTIVE_FILE);
 
-		if (unlikely(file + free <= high_wmark_pages(zone))) {
+		if (unlikely(zonefile + free <= high_wmark_pages(zone))) {
 			scan_balance = SCAN_ANON;
 			goto out;
 		}
_

Patches currently in -mm which might be from jmarchan@redhat.com are

mm-make-copy_pte_range-static-again.patch
mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
zram-use-size_t-instead-of-u16.patch
zram-remove-global-tb_lock-with-fine-grain-lock.patch

