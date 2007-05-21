From: akpm@linux-foundation.org
Subject: + sch_htb-fix-event-cache-time-calculation.patch added to -mm tree
Date: Mon, 21 May 2007 15:02:50 -0700
Message-ID: <200705212202.l4LM2o4L021090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756823AbXEUWEc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 18:04:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaber@trash.net, kernel@prachanda.info


The patch titled
     sch_htb: fix event cache time calculation
has been added to the -mm tree.  Its filename is
     sch_htb-fix-event-cache-time-calculation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
networking-fix-sending-netlink-message-when-replace-route.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
sch_htb-fix-event-cache-time-calculation.patch
