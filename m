From: akpm@linux-foundation.org
Subject: - jiffies_round-jiffies_round_relative-conversion.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:31:20 -0700
Message-ID: <200710292031.l9TKVK5L021842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35639 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbXJ2UeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, arjan@linux.intel.com, linville@tuxdriver.com, yi.zhu@intel.com, mm-commits@vger.kernel.org


The patch titled
     jiffies_round -> jiffies_round_relative conversion - ipw2100/ipw2200
has been removed from the -mm tree.  Its filename was
     jiffies_round-jiffies_round_relative-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jiffies_round -> jiffies_round_relative conversion - ipw2100/ipw2200
From: Anton Blanchard <anton@samba.org>

When rounding a relative timeout we need to use round_jiffies_relative().

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2100.c |    9 +++++----
 drivers/net/wireless/ipw2200.c |    6 +++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/net/wireless/ipw2100.c~jiffies_round-jiffies_round_relative-conversion drivers/net/wireless/ipw2100.c
--- a/drivers/net/wireless/ipw2100.c~jiffies_round-jiffies_round_relative-conversion
+++ a/drivers/net/wireless/ipw2100.c
@@ -1769,7 +1769,7 @@ static int ipw2100_up(struct ipw2100_pri
 		if (priv->stop_rf_kill) {
 			priv->stop_rf_kill = 0;
 			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies(HZ));
+					   round_jiffies_relative(HZ));
 		}
 
 		deferred = 1;
@@ -2086,7 +2086,8 @@ static void isr_indicate_rf_kill(struct 
 	/* Make sure the RF Kill check timer is running */
 	priv->stop_rf_kill = 0;
 	cancel_delayed_work(&priv->rf_kill);
-	queue_delayed_work(priv->workqueue, &priv->rf_kill, round_jiffies(HZ));
+	queue_delayed_work(priv->workqueue, &priv->rf_kill,
+			   round_jiffies_relative(HZ));
 }
 
 static void send_scan_event(void *data)
@@ -4242,7 +4243,7 @@ static int ipw_radio_kill_sw(struct ipw2
 			priv->stop_rf_kill = 0;
 			cancel_delayed_work(&priv->rf_kill);
 			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies(HZ));
+					   round_jiffies_relative(HZ));
 		} else
 			schedule_reset(priv);
 	}
@@ -5981,7 +5982,7 @@ static void ipw2100_rf_kill(struct work_
 		IPW_DEBUG_RF_KILL("RF Kill active, rescheduling GPIO check\n");
 		if (!priv->stop_rf_kill)
 			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies(HZ));
+					   round_jiffies_relative(HZ));
 		goto exit_unlock;
 	}
 
diff -puN drivers/net/wireless/ipw2200.c~jiffies_round-jiffies_round_relative-conversion drivers/net/wireless/ipw2200.c
--- a/drivers/net/wireless/ipw2200.c~jiffies_round-jiffies_round_relative-conversion
+++ a/drivers/net/wireless/ipw2200.c
@@ -1753,7 +1753,7 @@ static int ipw_radio_kill_sw(struct ipw_
 			/* Make sure the RF_KILL check timer is running */
 			cancel_delayed_work(&priv->rf_kill);
 			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies(2 * HZ));
+					   round_jiffies_relative(2 * HZ));
 		} else
 			queue_work(priv->workqueue, &priv->up);
 	}
@@ -4364,7 +4364,7 @@ static void handle_scan_event(struct ipw
 	if (!priv->user_requested_scan) {
 		if (!delayed_work_pending(&priv->scan_event))
 			queue_delayed_work(priv->workqueue, &priv->scan_event,
-					 round_jiffies(msecs_to_jiffies(4000)));
+				round_jiffies_relative(msecs_to_jiffies(4000)));
 	} else {
 		union iwreq_data wrqu;
 
@@ -4728,7 +4728,7 @@ static void ipw_rx_notification(struct i
 				 && priv->status & STATUS_ASSOCIATED)
 				queue_delayed_work(priv->workqueue,
 						   &priv->request_scan,
-						   round_jiffies(HZ));
+						   round_jiffies_relative(HZ));
 
 			/* Send an empty event to user space.
 			 * We don't send the received data on the event because
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
drivers-edac-use-round_jiffies_relative.patch
