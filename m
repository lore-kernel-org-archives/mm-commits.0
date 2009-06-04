From: akpm@linux-foundation.org
Subject: + hp-wmi-add-support-for-reporting-tablet-state.patch added to -mm tree
Date: Thu, 04 Jun 2009 14:07:18 -0700
Message-ID: <200906042107.n54L7I2a004365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824AbZFDVIh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 17:08:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, lenb@kernel.org


The patch titled
     hp-wmi: add support for reporting tablet state
has been added to the -mm tree.  Its filename is
     hp-wmi-add-support-for-reporting-tablet-state.patch

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
Subject: hp-wmi: add support for reporting tablet state
From: Matthew Garrett <mjg@redhat.com>

HP tablets send a WMI event when a tablet state change occurs, but use the
same method as is used for reporting docking and undocking.  The same
query is used to obtain the state of the hardware.  Bit 0 indicates the
docking state, while bit 2 indicates the tablet state.  This patch breaks
these out and sends separate input events for tablet and dock state
changes.  An additional sysfs file is added to report the tablet state.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |   87 ++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 32 deletions(-)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-add-support-for-reporting-tablet-state drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-add-support-for-reporting-tablet-state
+++ a/drivers/platform/x86/hp-wmi.c
@@ -47,7 +47,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE9
 #define HPWMI_DISPLAY_QUERY 0x1
 #define HPWMI_HDDTEMP_QUERY 0x2
 #define HPWMI_ALS_QUERY 0x3
-#define HPWMI_DOCK_QUERY 0x4
+#define HPWMI_HARDWARE_QUERY 0x4
 #define HPWMI_WIRELESS_QUERY 0x5
 #define HPWMI_HOTKEY_QUERY 0xc
 
@@ -75,10 +75,9 @@ struct key_entry {
 	u16 keycode;
 };
 
-enum { KE_KEY, KE_SW, KE_END };
+enum { KE_KEY, KE_END };
 
 static struct key_entry hp_wmi_keymap[] = {
-	{KE_SW, 0x01, SW_DOCK},
 	{KE_KEY, 0x02, KEY_BRIGHTNESSUP},
 	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
 	{KE_KEY, 0x20e6, KEY_PROG1},
@@ -151,7 +150,22 @@ static int hp_wmi_als_state(void)
 
 static int hp_wmi_dock_state(void)
 {
-	return hp_wmi_perform_query(HPWMI_DOCK_QUERY, 0, 0);
+	int ret = hp_wmi_perform_query(HPWMI_HARDWARE_QUERY, 0, 0);
+
+	if (ret < 0)
+		return ret;
+
+	return ret & 0x1;
+}
+
+static int hp_wmi_tablet_state(void)
+{
+	int ret = hp_wmi_perform_query(HPWMI_HARDWARE_QUERY, 0, 0);
+
+	if (ret < 0)
+		return ret;
+
+	return (ret & 0x4) ? 1 : 0;
 }
 
 static int hp_wmi_set_block(void *data, bool blocked)
@@ -232,6 +246,15 @@ static ssize_t show_dock(struct device *
 	return sprintf(buf, "%d\n", value);
 }
 
+static ssize_t show_tablet(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	int value = hp_wmi_tablet_state();
+	if (value < 0)
+		return -EINVAL;
+	return sprintf(buf, "%d\n", value);
+}
+
 static ssize_t set_als(struct device *dev, struct device_attribute *attr,
 		       const char *buf, size_t count)
 {
@@ -244,6 +267,7 @@ static DEVICE_ATTR(display, S_IRUGO, sho
 static DEVICE_ATTR(hddtemp, S_IRUGO, show_hddtemp, NULL);
 static DEVICE_ATTR(als, S_IRUGO | S_IWUSR, show_als, set_als);
 static DEVICE_ATTR(dock, S_IRUGO, show_dock, NULL);
+static DEVICE_ATTR(tablet, S_IRUGO, show_tablet, NULL);
 
 static struct key_entry *hp_wmi_get_entry_by_scancode(int code)
 {
@@ -326,13 +350,13 @@ static void hp_wmi_notify(u32 value, voi
 						 key->keycode, 0);
 				input_sync(hp_wmi_input_dev);
 				break;
-			case KE_SW:
-				input_report_switch(hp_wmi_input_dev,
-						    key->keycode,
-						    hp_wmi_dock_state());
-				input_sync(hp_wmi_input_dev);
-				break;
 			}
+		} else if (eventcode == 0x1) {
+			input_report_switch(hp_wmi_input_dev, SW_DOCK,
+					    hp_wmi_dock_state());
+			input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
+					    hp_wmi_tablet_state());
+			input_sync(hp_wmi_input_dev);
 		} else if (eventcode == 0x5) {
 			if (wifi_rfkill)
 				rfkill_set_sw_state(wifi_rfkill,
@@ -369,18 +393,19 @@ static int __init hp_wmi_input_setup(voi
 			set_bit(EV_KEY, hp_wmi_input_dev->evbit);
 			set_bit(key->keycode, hp_wmi_input_dev->keybit);
 			break;
-		case KE_SW:
-			set_bit(EV_SW, hp_wmi_input_dev->evbit);
-			set_bit(key->keycode, hp_wmi_input_dev->swbit);
-
-			/* Set initial dock state */
-			input_report_switch(hp_wmi_input_dev, key->keycode,
-					    hp_wmi_dock_state());
-			input_sync(hp_wmi_input_dev);
-			break;
 		}
 	}
 
+	set_bit(EV_SW, hp_wmi_input_dev->evbit);
+	set_bit(SW_DOCK, hp_wmi_input_dev->swbit);
+	set_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit);
+
+	/* Set initial hardware state */
+	input_report_switch(hp_wmi_input_dev, SW_DOCK, hp_wmi_dock_state());
+	input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
+			    hp_wmi_tablet_state());
+	input_sync(hp_wmi_input_dev);
+
 	err = input_register_device(hp_wmi_input_dev);
 
 	if (err) {
@@ -397,6 +422,7 @@ static void cleanup_sysfs(struct platfor
 	device_remove_file(&device->dev, &dev_attr_hddtemp);
 	device_remove_file(&device->dev, &dev_attr_als);
 	device_remove_file(&device->dev, &dev_attr_dock);
+	device_remove_file(&device->dev, &dev_attr_tablet);
 }
 
 static int __init hp_wmi_bios_setup(struct platform_device *device)
@@ -416,6 +442,9 @@ static int __init hp_wmi_bios_setup(stru
 	err = device_create_file(&device->dev, &dev_attr_dock);
 	if (err)
 		goto add_sysfs_error;
+	err = device_create_file(&device->dev, &dev_attr_tablet);
+	if (err)
+		goto add_sysfs_error;
 
 	if (wireless & 0x1) {
 		wifi_rfkill = rfkill_alloc("hp-wifi", &device->dev,
@@ -489,23 +518,17 @@ static int __exit hp_wmi_bios_remove(str
 
 static int hp_wmi_resume_handler(struct platform_device *device)
 {
-	struct key_entry *key;
-
 	/*
-	 * Docking state may have changed while suspended, so trigger
-	 * an input event for the current state. As this is a switch,
+	 * Hardware state may have changed while suspended, so trigger
+	 * input events for the current state. As this is a switch,
 	 * the input layer will only actually pass it on if the state
 	 * changed.
 	 */
-	for (key = hp_wmi_keymap; key->type != KE_END; key++) {
-		switch (key->type) {
-		case KE_SW:
-			input_report_switch(hp_wmi_input_dev, key->keycode,
-					    hp_wmi_dock_state());
-			input_sync(hp_wmi_input_dev);
-			break;
-		}
-	}
+
+	input_report_switch(hp_wmi_input_dev, SW_DOCK, hp_wmi_dock_state());
+	input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
+			    hp_wmi_tablet_state());
+	input_sync(hp_wmi_input_dev);
 
 	return 0;
 }
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
dell-wmi-mask-off-upper-bytes-of-event-response.patch
dell-wmi-add-additional-keyboard-events.patch
dell-wmi-dont-generate-errors-on-empty-messages.patch
hp-wmi-add-support-for-reporting-tablet-state.patch

