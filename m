From: akpm@linux-foundation.org
Subject: - hp-wmi-update-to-match-current-rfkill-semantics.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:42 -0700
Message-ID: <200809031611.m83GBg00023791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYICQMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, hidave.darkstar@gmail.com, hmh@hmh.eng.br, ivdoorn@gmail.com, marcel@holtmann.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     hp-wmi: update to match current rfkill semantics
has been removed from the -mm tree.  Its filename was
     hp-wmi-update-to-match-current-rfkill-semantics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp-wmi: update to match current rfkill semantics
From: Matthew Garrett <mjg59@srcf.ucam.org>

hp-wmi currently changes the RFKill state by altering the struct members
rather than using the dedicated interface, meaning that update events
won't be pushed to userspace.  This patch fixes that, along with fixing
the declared type of the WWAN kill switch.  It also ensures that rfkill
interfaces are only registered for hardware that exists.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hp-wmi.c |   81 ++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff -puN drivers/misc/hp-wmi.c~hp-wmi-update-to-match-current-rfkill-semantics drivers/misc/hp-wmi.c
--- a/drivers/misc/hp-wmi.c~hp-wmi-update-to-match-current-rfkill-semantics
+++ a/drivers/misc/hp-wmi.c
@@ -177,9 +177,9 @@ static int hp_wmi_wifi_state(void)
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	if (wireless & 0x100)
-		return 1;
+		return RFKILL_STATE_UNBLOCKED;
 	else
-		return 0;
+		return RFKILL_STATE_SOFT_BLOCKED;
 }
 
 static int hp_wmi_bluetooth_state(void)
@@ -187,9 +187,9 @@ static int hp_wmi_bluetooth_state(void)
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	if (wireless & 0x10000)
-		return 1;
+		return RFKILL_STATE_UNBLOCKED;
 	else
-		return 0;
+		return RFKILL_STATE_SOFT_BLOCKED;
 }
 
 static int hp_wmi_wwan_state(void)
@@ -197,9 +197,9 @@ static int hp_wmi_wwan_state(void)
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	if (wireless & 0x1000000)
-		return 1;
+		return RFKILL_STATE_UNBLOCKED;
 	else
-		return 0;
+		return RFKILL_STATE_SOFT_BLOCKED;
 }
 
 static ssize_t show_display(struct device *dev, struct device_attribute *attr,
@@ -338,12 +338,14 @@ void hp_wmi_notify(u32 value, void *cont
 			}
 		} else if (eventcode == 0x5) {
 			if (wifi_rfkill)
-				wifi_rfkill->state = hp_wmi_wifi_state();
+				rfkill_force_state(wifi_rfkill,
+						   hp_wmi_wifi_state());
 			if (bluetooth_rfkill)
-				bluetooth_rfkill->state =
-				    hp_wmi_bluetooth_state();
+				rfkill_force_state(bluetooth_rfkill,
+						   hp_wmi_bluetooth_state());
 			if (wwan_rfkill)
-				wwan_rfkill->state = hp_wmi_wwan_state();
+				rfkill_force_state(wwan_rfkill,
+						   hp_wmi_wwan_state());
 		} else
 			printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
 			       eventcode);
@@ -398,6 +400,7 @@ static void cleanup_sysfs(struct platfor
 static int __init hp_wmi_bios_setup(struct platform_device *device)
 {
 	int err;
+	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	err = device_create_file(&device->dev, &dev_attr_display);
 	if (err)
@@ -412,28 +415,33 @@ static int __init hp_wmi_bios_setup(stru
 	if (err)
 		goto add_sysfs_error;
 
-	wifi_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WLAN);
-	wifi_rfkill->name = "hp-wifi";
-	wifi_rfkill->state = hp_wmi_wifi_state();
-	wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
-	wifi_rfkill->user_claim_unsupported = 1;
-
-	bluetooth_rfkill = rfkill_allocate(&device->dev,
-					   RFKILL_TYPE_BLUETOOTH);
-	bluetooth_rfkill->name = "hp-bluetooth";
-	bluetooth_rfkill->state = hp_wmi_bluetooth_state();
-	bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
-	bluetooth_rfkill->user_claim_unsupported = 1;
-
-	wwan_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WIMAX);
-	wwan_rfkill->name = "hp-wwan";
-	wwan_rfkill->state = hp_wmi_wwan_state();
-	wwan_rfkill->toggle_radio = hp_wmi_wwan_set;
-	wwan_rfkill->user_claim_unsupported = 1;
-
-	rfkill_register(wifi_rfkill);
-	rfkill_register(bluetooth_rfkill);
-	rfkill_register(wwan_rfkill);
+	if (wireless & 0x1) {
+		wifi_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WLAN);
+		wifi_rfkill->name = "hp-wifi";
+		wifi_rfkill->state = hp_wmi_wifi_state();
+		wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
+		wifi_rfkill->user_claim_unsupported = 1;
+		rfkill_register(wifi_rfkill);
+	}
+
+	if (wireless & 0x2) {
+		bluetooth_rfkill = rfkill_allocate(&device->dev,
+						   RFKILL_TYPE_BLUETOOTH);
+		bluetooth_rfkill->name = "hp-bluetooth";
+		bluetooth_rfkill->state = hp_wmi_bluetooth_state();
+		bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
+		bluetooth_rfkill->user_claim_unsupported = 1;
+		rfkill_register(bluetooth_rfkill);
+	}
+
+	if (wireless & 0x4) {
+		wwan_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WWAN);
+		wwan_rfkill->name = "hp-wwan";
+		wwan_rfkill->state = hp_wmi_wwan_state();
+		wwan_rfkill->toggle_radio = hp_wmi_wwan_set;
+		wwan_rfkill->user_claim_unsupported = 1;
+		rfkill_register(wwan_rfkill);
+	}
 
 	return 0;
 add_sysfs_error:
@@ -445,9 +453,12 @@ static int __exit hp_wmi_bios_remove(str
 {
 	cleanup_sysfs(device);
 
-	rfkill_unregister(wifi_rfkill);
-	rfkill_unregister(bluetooth_rfkill);
-	rfkill_unregister(wwan_rfkill);
+	if (wifi_rfkill)
+		rfkill_unregister(wifi_rfkill);
+	if (bluetooth_rfkill)
+		rfkill_unregister(bluetooth_rfkill);
+	if (wwan_rfkill)
+		rfkill_unregister(wwan_rfkill);
 
 	return 0;
 }
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

origin.patch
linux-next.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
eeepc-laptop-use-standard-interfaces.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch

