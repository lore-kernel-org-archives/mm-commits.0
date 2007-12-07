From: akpm@linux-foundation.org
Subject: + hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter.patch added to -mm tree
Date: Fri, 07 Dec 2007 13:37:40 -0800
Message-ID: <200712072137.lB7Lbeoh004888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757448AbXLGVh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 16:37:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, jkosina@suse.cz


The patch titled
     hid: the `bit' in hidinput_mapping_quirks() is an out parameter
has been added to the -mm tree.  Its filename is
     hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hid: the `bit' in hidinput_mapping_quirks() is an out parameter
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Fix a panic, by changing
	hidinput_mapping_quirks(,, unsigned long *bit,)
to
	hidinput_mapping_quirks(,, unsigned long **bit,)

The `bit' in this function is an out parameter.

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-input-quirks.c |   36 +++++++++++++++----------------
 drivers/hid/hid-input.c        |    2 -
 include/linux/hid.h            |    2 -
 3 files changed, 20 insertions(+), 20 deletions(-)

diff -puN drivers/hid/hid-input-quirks.c~hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter drivers/hid/hid-input-quirks.c
--- a/drivers/hid/hid-input-quirks.c~hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter
+++ a/drivers/hid/hid-input-quirks.c
@@ -16,16 +16,16 @@
 #include <linux/input.h>
 #include <linux/hid.h>
 
-#define map_abs(c)      do { usage->code = c; usage->type = EV_ABS; bit = input->absbit; *max = ABS_MAX; } while (0)
-#define map_rel(c)      do { usage->code = c; usage->type = EV_REL; bit = input->relbit; *max = REL_MAX; } while (0)
-#define map_key(c)      do { usage->code = c; usage->type = EV_KEY; bit = input->keybit; *max = KEY_MAX; } while (0)
-#define map_led(c)      do { usage->code = c; usage->type = EV_LED; bit = input->ledbit; *max = LED_MAX; } while (0)
+#define map_abs(c)      do { usage->code = c; usage->type = EV_ABS; *bit = input->absbit; *max = ABS_MAX; } while (0)
+#define map_rel(c)      do { usage->code = c; usage->type = EV_REL; *bit = input->relbit; *max = REL_MAX; } while (0)
+#define map_key(c)      do { usage->code = c; usage->type = EV_KEY; *bit = input->keybit; *max = KEY_MAX; } while (0)
+#define map_led(c)      do { usage->code = c; usage->type = EV_LED; *bit = input->ledbit; *max = LED_MAX; } while (0)
 
-#define map_abs_clear(c)        do { map_abs(c); clear_bit(c, bit); } while (0)
-#define map_key_clear(c)        do { map_key(c); clear_bit(c, bit); } while (0)
+#define map_abs_clear(c)        do { map_abs(c); clear_bit(c, *bit); } while (0)
+#define map_key_clear(c)        do { map_key(c); clear_bit(c, *bit); } while (0)
 
 static int quirk_belkin_wkbd(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -41,7 +41,7 @@ static int quirk_belkin_wkbd(struct hid_
 }
 
 static int quirk_cherry_cymotion(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -57,7 +57,7 @@ static int quirk_cherry_cymotion(struct 
 }
 
 static int quirk_logitech_ultrax_remote(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
 		return 0;
@@ -90,7 +90,7 @@ static int quirk_logitech_ultrax_remote(
 }
 
 static int quirk_chicony_tactical_pad(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
 		return 0;
@@ -115,7 +115,7 @@ static int quirk_chicony_tactical_pad(st
 }
 
 static int quirk_microsoft_ergonomy_kb(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
 		return 0;
@@ -138,7 +138,7 @@ static int quirk_microsoft_ergonomy_kb(s
 }
 
 static int quirk_microsoft_presenter_8k(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
 		return 0;
@@ -156,7 +156,7 @@ static int quirk_microsoft_presenter_8k(
 }
 
 static int quirk_petalynx_remote(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if (((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR) &&
 			((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER))
@@ -184,7 +184,7 @@ static int quirk_petalynx_remote(struct 
 }
 
 static int quirk_logitech_wireless(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -236,7 +236,7 @@ static int quirk_logitech_wireless(struc
 }
 
 static int quirk_cherry_genius_29e(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -254,7 +254,7 @@ static int quirk_cherry_genius_29e(struc
 }
 
 static int quirk_btc_8193(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long *bit, int *max)
+			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -307,7 +307,7 @@ static int quirk_btc_8193(struct hid_usa
 static const struct hid_input_blacklist {
 	__u16 idVendor;
 	__u16 idProduct;
-	int (*quirk)(struct hid_usage *, struct input_dev *, unsigned long *, int *);
+	int (*quirk)(struct hid_usage *, struct input_dev *, unsigned long **, int *);
 } hid_input_blacklist[] = {
 	{ VENDOR_ID_BELKIN, DEVICE_ID_BELKIN_WIRELESS_KEYBOARD, quirk_belkin_wkbd },
 
@@ -335,7 +335,7 @@ static const struct hid_input_blacklist 
 
 int hidinput_mapping_quirks(struct hid_usage *usage, 
 				   struct input_dev *input, 
-				   unsigned long *bit, int *max)
+				   unsigned long **bit, int *max)
 {
 	struct hid_device *device = input_get_drvdata(input);
 	int i = 0;
diff -puN drivers/hid/hid-input.c~hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter drivers/hid/hid-input.c
--- a/drivers/hid/hid-input.c~hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter
+++ a/drivers/hid/hid-input.c
@@ -382,7 +382,7 @@ static void hidinput_configure_usage(str
 	}
 
 	/* handle input mappings for quirky devices */
-	ret = hidinput_mapping_quirks(usage, input, bit, &max);
+	ret = hidinput_mapping_quirks(usage, input, &bit, &max);
 	if (ret)
 		goto mapped;
 
diff -puN include/linux/hid.h~hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter include/linux/hid.h
--- a/include/linux/hid.h~hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter
+++ a/include/linux/hid.h
@@ -526,7 +526,7 @@ extern void hidinput_disconnect(struct h
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *, int type, u8 *, int, int);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
-int hidinput_mapping_quirks(struct hid_usage *, struct input_dev *, unsigned long *, int *);
+int hidinput_mapping_quirks(struct hid_usage *, struct input_dev *, unsigned long **, int *);
 void hidinput_event_quirks(struct hid_device *, struct hid_field *, struct hid_usage *, __s32);
 int hidinput_apple_event(struct hid_device *, struct input_dev *, struct hid_usage *, __s32);
 void hid_input_field(struct hid_device *hid, struct hid_field *field, __u8 *data, int interrupt);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
