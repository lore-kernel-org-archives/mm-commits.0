From: akpm@linux-foundation.org
Subject: [merged] da9030_battery-fix-race-between-event-handler-and-monitor.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:23 -0700
Message-ID: <200906091812.n59ICNMv018659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967AbZFISNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, cbou@mail.ru, mm-commits@vger.kernel.org


The patch titled
     da9030_battery: fix race between event handler and monitor
has been removed from the -mm tree.  Its filename was
     da9030_battery-fix-race-between-event-handler-and-monitor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: da9030_battery: fix race between event handler and monitor
From: Mike Rapoport <mike@compulab.co.il>

There are cases when charging monitor and the event handler try to change
the charger state simultaneously.  For instance, a charger is connected to
the system, there's the detection event and the event handler tries to
enable charging.  It is possible that the periodic charging monitor runs
at the same time and it still thinks there's no external charger.  So it
tries to disable the charging.  As the result, even if the conditions
necessary to charge the battery hold, there will be no actual charging.

The patch changes the event handler so that instead of enabling/disabling
the charger immediately it would rather make the monitor run.  The monitor
code then decides what should be the charger state.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/da9030_battery.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN drivers/power/da9030_battery.c~da9030_battery-fix-race-between-event-handler-and-monitor drivers/power/da9030_battery.c
--- a/drivers/power/da9030_battery.c~da9030_battery-fix-race-between-event-handler-and-monitor
+++ a/drivers/power/da9030_battery.c
@@ -22,8 +22,6 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
-#define DA9030_STATUS_CHDET	(1 << 3)
-
 #define DA9030_FAULT_LOG		0x0a
 #define DA9030_FAULT_LOG_OVER_TEMP	(1 << 7)
 #define DA9030_FAULT_LOG_VBAT_OVER	(1 << 4)
@@ -244,6 +242,8 @@ static void da9030_set_charge(struct da9
 	}
 
 	da903x_write(charger->master, DA9030_CHARGE_CONTROL, val);
+
+	power_supply_changed(&charger->psy);
 }
 
 static void da9030_charger_check_state(struct da9030_charger *charger)
@@ -258,6 +258,12 @@ static void da9030_charger_check_state(s
 			da9030_set_charge(charger, 1);
 		}
 	} else {
+		/* Charger has been pulled out */
+		if (!charger->chdet) {
+			da9030_set_charge(charger, 0);
+			return;
+		}
+
 		if (charger->adc.vbat_res >=
 		    charger->thresholds.vbat_charge_stop) {
 			da9030_set_charge(charger, 0);
@@ -395,13 +401,11 @@ static int da9030_battery_event(struct n
 {
 	struct da9030_charger *charger =
 		container_of(nb, struct da9030_charger, nb);
-	int status;
 
 	switch (event) {
 	case DA9030_EVENT_CHDET:
-		status = da903x_query_status(charger->master,
-					     DA9030_STATUS_CHDET);
-		da9030_set_charge(charger, status);
+		cancel_delayed_work_sync(&charger->work);
+		schedule_work(&charger->work.work);
 		break;
 	case DA9030_EVENT_VBATMON:
 		da9030_battery_vbat_event(charger);
@@ -565,7 +569,8 @@ static int da9030_battery_remove(struct 
 	da903x_unregister_notifier(charger->master, &charger->nb,
 				   DA9030_EVENT_CHDET | DA9030_EVENT_VBATMON |
 				   DA9030_EVENT_CHIOVER | DA9030_EVENT_TBAT);
-	cancel_delayed_work(&charger->work);
+	cancel_delayed_work_sync(&charger->work);
+	da9030_set_charge(charger, 0);
 	power_supply_unregister(&charger->psy);
 
 	kfree(charger);
_

Patches currently in -mm which might be from mike@compulab.co.il are

linux-next.patch

