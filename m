From: akpm@linux-foundation.org
Subject: - gen_estimator-fix-locking-and-timer-related-bugs.patch removed from -mm tree
Date: Fri, 13 Jul 2007 14:46:28 -0700
Message-ID: <200707132146.l6DLkS1K022358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757106AbXGMVqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 17:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaber@trash.net, jarkao2@o2.pl, ranko@spidernet.net, mm-commits@vger.kernel.org


The patch titled
     gen_estimator: fix locking and timer related bugs
has been removed from the -mm tree.  Its filename was
     gen_estimator-fix-locking-and-timer-related-bugs.patch

This patch was dropped because I've lost track of what's happening here

------------------------------------------------------
Subject: gen_estimator: fix locking and timer related bugs
From: Patrick McHardy <kaber@trash.net>

As noticed by Jarek Poplawski <jarkao2@o2.pl>, the timer removal in
gen_kill_estimator races with the timer function rearming the timer.

Additionally there are a few more related problems that seem to be
relicts from the timer when the estimator was qdisc specific and
could rely on the rtnl or dev->qdisc_lock:

- the check whether the list is empty and a timer needs to be started
  when adding a new estimator doesn't take the lock, so it races
  against concurrent additions, which can result in the timer beeing
  added twice or getting reinitialized after being added.

- the new estimator's next pointer is also set without holding the
  lock, again racing against concurrent additions with possible
  list corruption as a result.

- the timer deletion when killing an estimator is also not under
  the lock and races against timer arming when adding a new estimator.

Fix by holding the lock around the entire list addition and initial
timer arming. Removal is not done explicitly anymore, instead the
timer function only rearms the timer when there are still estimators
present.

Addreses http://bugzilla.kernel.org/show_bug.cgi?id=8668

Signed-off-by: Patrick McHardy <kaber@trash.net>
Cc: Ranko Zivojnovic <ranko@spidernet.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/gen_estimator.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff -puN net/core/gen_estimator.c~gen_estimator-fix-locking-and-timer-related-bugs net/core/gen_estimator.c
--- a/net/core/gen_estimator.c~gen_estimator-fix-locking-and-timer-related-bugs
+++ a/net/core/gen_estimator.c
@@ -127,8 +127,8 @@ static void est_timer(unsigned long arg)
 		e->rate_est->pps = (e->avpps+0x1FF)>>10;
 		spin_unlock(e->stats_lock);
 	}
-
-	mod_timer(&elist[idx].timer, jiffies + ((HZ<<idx)/4));
+	if (elist[idx].list != NULL)
+		mod_timer(&elist[idx].timer, jiffies + ((HZ<<idx)/4));
 	read_unlock(&est_lock);
 }
 
@@ -152,6 +152,7 @@ int gen_new_estimator(struct gnet_stats_
 {
 	struct gen_estimator *est;
 	struct gnet_estimator *parm = RTA_DATA(opt);
+	int idx;
 
 	if (RTA_PAYLOAD(opt) < sizeof(*parm))
 		return -EINVAL;
@@ -163,7 +164,7 @@ int gen_new_estimator(struct gnet_stats_
 	if (est == NULL)
 		return -ENOBUFS;
 
-	est->interval = parm->interval + 2;
+	est->interval = idx = parm->interval + 2;
 	est->bstats = bstats;
 	est->rate_est = rate_est;
 	est->stats_lock = stats_lock;
@@ -173,16 +174,14 @@ int gen_new_estimator(struct gnet_stats_
 	est->last_packets = bstats->packets;
 	est->avpps = rate_est->pps<<10;
 
-	est->next = elist[est->interval].list;
-	if (est->next == NULL) {
-		init_timer(&elist[est->interval].timer);
-		elist[est->interval].timer.data = est->interval;
-		elist[est->interval].timer.expires = jiffies + ((HZ<<est->interval)/4);
-		elist[est->interval].timer.function = est_timer;
-		add_timer(&elist[est->interval].timer);
-	}
 	write_lock_bh(&est_lock);
-	elist[est->interval].list = est;
+	if (!elist[idx].timer.function)
+		setup_timer(&elist[idx].timer, est_timer, est->interval);
+	if (elist[est->interval].list == NULL)
+		mod_timer(&elist[idx].timer, jiffies + ((HZ<<idx)/4));
+
+	est->next = elist[idx].list;
+	elist[idx].list = est;
 	write_unlock_bh(&est_lock);
 	return 0;
 }
@@ -202,7 +201,6 @@ void gen_kill_estimator(struct gnet_stat
 	struct gen_estimator *est, **pest;
 
 	for (idx=0; idx <= EST_MAX_INTERVAL; idx++) {
-		int killed = 0;
 		pest = &elist[idx].list;
 		while ((est=*pest) != NULL) {
 			if (est->rate_est != rate_est || est->bstats != bstats) {
@@ -215,10 +213,7 @@ void gen_kill_estimator(struct gnet_stat
 			write_unlock_bh(&est_lock);
 
 			kfree(est);
-			killed++;
 		}
-		if (killed && elist[idx].list == NULL)
-			del_timer(&elist[idx].timer);
 	}
 }
 
_

Patches currently in -mm which might be from kaber@trash.net are

origin.patch
gen_estimator-fix-locking-and-timer-related-bugs.patch
