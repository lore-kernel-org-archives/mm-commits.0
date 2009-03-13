From: akpm@linux-foundation.org
Subject: + vmscan-pgmoved-should-be-cleared-after-updating-recent_rotated.patch added to -mm tree
Date: Fri, 13 Mar 2009 12:46:27 -0700
Message-ID: <200903131946.n2DJkRQ8018716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbZCMTuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 15:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan: pgmoved should be cleared after updating recent_rotated
has been added to the -mm tree.  Its filename is
     vmscan-pgmoved-should-be-cleared-after-updating-recent_rotated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: pgmoved should be cleared after updating recent_rotated
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

pgmoved should be cleared after updating recent_rotated.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-pgmoved-should-be-cleared-after-updating-recent_rotated mm/vmscan.c
--- a/mm/vmscan.c~vmscan-pgmoved-should-be-cleared-after-updating-recent_rotated
+++ a/mm/vmscan.c
@@ -1262,7 +1262,6 @@ static void shrink_active_list(unsigned 
 	 * Move the pages to the [file or anon] inactive list.
 	 */
 	pagevec_init(&pvec, 1);
-	pgmoved = 0;
 	lru = LRU_BASE + file * LRU_FILE;
 
 	spin_lock_irq(&zone->lru_lock);
@@ -1274,6 +1273,7 @@ static void shrink_active_list(unsigned 
 	 */
 	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
+	pgmoved = 0;
 	while (!list_empty(&l_inactive)) {
 		page = lru_to_page(&l_inactive);
 		prefetchw_prev_lru_page(page, &l_inactive, flags);
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

vmscan-pgmoved-should-be-cleared-after-updating-recent_rotated.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch

