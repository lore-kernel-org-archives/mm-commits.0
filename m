From: akpm@linux-foundation.org
Subject: + vmscan-simplify-code.patch added to -mm tree
Date: Mon, 30 Nov 2009 13:54:44 -0800
Message-ID: <200911302154.nAULsifR026473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbZK3Vyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 16:54:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     vmscan: simplify code
has been added to the -mm tree.  Its filename is
     vmscan-simplify-code.patch

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
Subject: vmscan: simplify code
From: Huang Shijie <shijie8@gmail.com>

Simplify the code for shrink_inactive_list().

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-simplify-code mm/vmscan.c
--- a/mm/vmscan.c~vmscan-simplify-code
+++ a/mm/vmscan.c
@@ -1165,10 +1165,8 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
 		__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
 
-		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
-		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
-		reclaim_stat->recent_scanned[1] += count[LRU_INACTIVE_FILE];
-		reclaim_stat->recent_scanned[1] += count[LRU_ACTIVE_FILE];
+		reclaim_stat->recent_scanned[0] += nr_anon;
+		reclaim_stat->recent_scanned[1] += nr_file;
 
 		spin_unlock_irq(&zone->lru_lock);
 
_

Patches currently in -mm which might be from shijie8@gmail.com are

rmap-fix-the-comment-for-try_to_unmap_anon.patch
rmap-simplify-try_to_unmap_file.patch
rmap-move-the-out-to-a-more-proper-place.patch
vmscan-simplify-code.patch

