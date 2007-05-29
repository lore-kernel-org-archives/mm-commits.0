From: akpm@linux-foundation.org
Subject: - sch_htb-fix-event-cache-time-calculation.patch removed from -mm tree
Date: Tue, 29 May 2007 11:56:29 -0700
Message-ID: <200705291856.l4TIuSdl008650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765147AbXE2S46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaber@trash.net, kernel@prachanda.info, mm-commits@vger.kernel.org


The patch titled
     sch_htb: fix event cache time calculation
has been removed from the -mm tree.  Its filename was
     sch_htb-fix-event-cache-time-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sch_htb: fix event cache time calculation
From: Patrick McHardy <kaber@trash.net>

The event cache time must be an absolute value, when no event exists it is
incorrectly set to 1s instead of 1s in the future.

Should fix excessive load reported by Anant Nitya <kernel@prachanda.info>.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/sch_htb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN net/sched/sch_htb.c~sch_htb-fix-event-cache-time-calculation net/sched/sch_htb.c
--- a/net/sched/sch_htb.c~sch_htb-fix-event-cache-time-calculation
+++ a/net/sched/sch_htb.c
@@ -976,8 +976,9 @@ static struct sk_buff *htb_dequeue(struc
 
 		if (q->now >= q->near_ev_cache[level]) {
 			event = htb_do_events(q, level);
-			q->near_ev_cache[level] = event ? event :
-							  PSCHED_TICKS_PER_SEC;
+			if (!event)
+				event = q->now + PSCHED_TICKS_PER_SEC;
+			q->near_ev_cache[level] = event;
 		} else
 			event = q->near_ev_cache[level];
 
_

Patches currently in -mm which might be from kaber@trash.net are

make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
