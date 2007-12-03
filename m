From: akpm@linux-foundation.org
Subject: + apanel-use-generic-keycode-routines.patch added to -mm tree
Date: Mon, 03 Dec 2007 14:56:41 -0800
Message-ID: <200712032256.lB3MufWe021822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52072 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbXLCW4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 17:56:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, dtor@mail.ru, jkosina@suse.cz


The patch titled
     apanel: use generic keycode routines
has been added to the -mm tree.  Its filename is
     apanel-use-generic-keycode-routines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: apanel: use generic keycode routines
From: Stephen Hemminger <shemminger@linux-foundation.org>

Don't need driver specific keymap routines, generic keycode routines will work
fine.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/apanel.c |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff -puN drivers/input/misc/apanel.c~apanel-use-generic-keycode-routines drivers/input/misc/apanel.c
--- a/drivers/input/misc/apanel.c~apanel-use-generic-keycode-routines
+++ a/drivers/input/misc/apanel.c
@@ -120,33 +120,6 @@ static void apanel_poll(struct input_pol
 			report_key(idev, ap->keymap[i]);
 }
 
-static int apanel_getkeycode(struct input_dev *idev, int scancode, int *keycode)
-{
-	struct apanel *ap = idev->private;
-
-	if (scancode < 0 || scancode >= MAX_PANEL_KEYS)
-		return -EINVAL;
-
-	*keycode = ap->keymap[scancode];
-	return 0;
-}
-
-static int apanel_setkeycode(struct input_dev *idev, int scancode, int keycode)
-{
-	struct apanel *ap = idev->private;
-
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
-
-	if (scancode < 0 || scancode >= MAX_PANEL_KEYS)
-		return -EINVAL;
-
-	clear_bit(ap->keymap[scancode], idev->keybit);
-	ap->keymap[scancode] = keycode;
-	set_bit(keycode, idev->keybit);
-	return 0;
-}
-
 /* Track state changes of LED */
 static void led_update(struct work_struct *work)
 {
@@ -274,11 +247,11 @@ static int apanel_probe(struct i2c_adapt
 	idev->phys = "apanel/input0";
 	idev->id.bustype = BUS_HOST;
 	idev->dev.parent = &ap->client.dev;
-	idev->getkeycode = apanel_getkeycode;
-	idev->setkeycode = apanel_setkeycode;
 
 	set_bit(EV_KEY, idev->evbit);
 
+	idev->keycode = ap->keymap;
+	idev->keycodesize = sizeof(ap->keymap[0]);
 	idev->keycodemax = (device_chip[APANEL_DEV_CDBTN] != CHIP_NONE) ? 12 : 4;
 
 	for (i = 0; i < idev->keycodemax; i++)
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

git-input.patch
fujitsu-application-panel-driver.patch
apanel-free-input-device-on-close.patch
apanel-change-name-of-led.patch
apanel-detach-on-shutdown.patch
apanel-use-generic-keycode-routines.patch
git-net.patch
git-netdev-all.patch
git-wireless.patch
