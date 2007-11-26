From: akpm@linux-foundation.org
Subject: - power-use-kasprintf.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:50:07 -0800
Message-ID: <200711262150.lAQLo7Mu024828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347AbXKZV6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, cbou@mail.ru, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     power: use kasprintf
has been removed from the -mm tree.  Its filename was
     power-use-kasprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: power: use kasprintf
From: Akinobu Mita <akinobu.mita@gmail.com>

Use kasprintf instead of kmalloc()-strcpy()-strcat().

Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/power_supply_leds.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff -puN drivers/power/power_supply_leds.c~power-use-kasprintf drivers/power/power_supply_leds.c
--- a/drivers/power/power_supply_leds.c~power-use-kasprintf
+++ a/drivers/power/power_supply_leds.c
@@ -10,6 +10,7 @@
  *  You may use this code as per GPL version 2
  */
 
+#include <linux/kernel.h>
 #include <linux/power_supply.h>
 
 #include "power_supply.h"
@@ -48,28 +49,20 @@ static int power_supply_create_bat_trigg
 {
 	int rc = 0;
 
-	psy->charging_full_trig_name = kmalloc(strlen(psy->name) +
-				  sizeof("-charging-or-full"), GFP_KERNEL);
+	psy->charging_full_trig_name = kasprintf(GFP_KERNEL,
+					"%s-charging-or-full", psy->name);
 	if (!psy->charging_full_trig_name)
 		goto charging_full_failed;
 
-	psy->charging_trig_name = kmalloc(strlen(psy->name) +
-					  sizeof("-charging"), GFP_KERNEL);
+	psy->charging_trig_name = kasprintf(GFP_KERNEL,
+					"%s-charging", psy->name);
 	if (!psy->charging_trig_name)
 		goto charging_failed;
 
-	psy->full_trig_name = kmalloc(strlen(psy->name) +
-				      sizeof("-full"), GFP_KERNEL);
+	psy->full_trig_name = kasprintf(GFP_KERNEL, "%s-full", psy->name);
 	if (!psy->full_trig_name)
 		goto full_failed;
 
-	strcpy(psy->charging_full_trig_name, psy->name);
-	strcat(psy->charging_full_trig_name, "-charging-or-full");
-	strcpy(psy->charging_trig_name, psy->name);
-	strcat(psy->charging_trig_name, "-charging");
-	strcpy(psy->full_trig_name, psy->name);
-	strcat(psy->full_trig_name, "-full");
-
 	led_trigger_register_simple(psy->charging_full_trig_name,
 				    &psy->charging_full_trig);
 	led_trigger_register_simple(psy->charging_trig_name,
@@ -120,14 +113,10 @@ static int power_supply_create_gen_trigg
 {
 	int rc = 0;
 
-	psy->online_trig_name = kmalloc(strlen(psy->name) + sizeof("-online"),
-					GFP_KERNEL);
+	psy->online_trig_name = kasprintf(GFP_KERNEL, "%s-online", psy->name);
 	if (!psy->online_trig_name)
 		goto online_failed;
 
-	strcpy(psy->online_trig_name, psy->name);
-	strcat(psy->online_trig_name, "-online");
-
 	led_trigger_register_simple(psy->online_trig_name, &psy->online_trig);
 
 	goto success;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-battery.patch
fs-use-hlist_unhashed.patch
partitions-use-kasprintf.patch
fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch
