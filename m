From: akpm@linux-foundation.org
Subject: + mm-memcg-only-evict-file-pages-when-we-have-plenty.patch added to -mm tree
Date: Wed, 19 Dec 2012 16:11:10 -0800
Message-ID: <20121220001111.67AB5100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:47771 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LTALM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 19:11:12 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so305623ggn.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 16:11:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com


The patch titled
     Subject: mm: memcg: only evict file pages when we have plenty
has been added to the -mm tree.  Its filename is
     mm-memcg-only-evict-file-pages-when-we-have-plenty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: only evict file pages when we have plenty

e986850 ("mm, vmscan: only evict file pages when we have plenty") makes a
point of not going for anonymous memory while there is still enough
inactive cache around.

The check was added only for global reclaim, but it is just as useful to
reduce swapping in memory cgroup reclaim:

200M-memcg-defconfig-j2

                                 vanilla                   patched
Real time              454.06 (  +0.00%)         453.71 (  -0.08%)
User time              668.57 (  +0.00%)         668.73 (  +0.02%)
System time            128.92 (  +0.00%)         129.53 (  +0.46%)
Swap in               1246.80 (  +0.00%)         814.40 ( -34.65%)
Swap out              1198.90 (  +0.00%)         827.00 ( -30.99%)
Pages allocated   16431288.10 (  +0.00%)    16434035.30 (  +0.02%)
Major faults           681.50 (  +0.00%)         593.70 ( -12.86%)
THP faults             237.20 (  +0.00%)         242.40 (  +2.18%)
THP collapse           241.20 (  +0.00%)         248.50 (  +3.01%)
THP splits             157.30 (  +0.00%)         161.40 (  +2.59%)

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>
Cc: Simon Jeons <simon.jeons@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-memcg-only-evict-file-pages-when-we-have-plenty mm/vmscan.c
--- a/mm/vmscan.c~mm-memcg-only-evict-file-pages-when-we-have-plenty
+++ a/mm/vmscan.c
@@ -1700,19 +1700,21 @@ static void get_scan_count(struct lruvec
 			fraction[1] = 0;
 			denominator = 1;
 			goto out;
-		} else if (!inactive_file_is_low_global(zone)) {
-			/*
-			 * There is enough inactive page cache, do not
-			 * reclaim anything from the working set right now.
-			 */
-			fraction[0] = 0;
-			fraction[1] = 1;
-			denominator = 1;
-			goto out;
 		}
 	}
 
 	/*
+	 * There is enough inactive page cache, do not reclaim
+	 * anything from the anonymous working set right now.
+	 */
+	if (!inactive_file_is_low(lruvec)) {
+		fraction[0] = 0;
+		fraction[1] = 1;
+		denominator = 1;
+		goto out;
+	}
+
+	/*
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-fix-calculation-of-dirtyable-memory.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

