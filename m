From: akpm@linux-foundation.org
Subject: [wrecked] matrix_keypad-allow-platform-to-disable-key-autorepeat.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:47:18 -0400
Message-ID: <201004071848.o37ImirY001177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab0DGSss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, dmitry.torokhov@gmail.com, hsweeten@visionengravers.com, mm-commits@vger.kernel.org


The patch titled
     drivers/input/keyboard/matrix_keypad.c: allow platform to disable key autorepeat
has been removed from the -mm tree.  Its filename was
     matrix_keypad-allow-platform-to-disable-key-autorepeat.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/input/keyboard/matrix_keypad.c: allow platform to disable key autorepeat
From: H Hartley Sweeten <hartleys@visionengravers.com>

In an embedded system the matrix_keypad driver might be used to interface
with an external control panel and not an actual keyboard.  On the control
panel some of the keys could be used to turn on/off various functions.  If
key autorepeat is enabled this causes the function to quickly toggle
between the on and off states and makes operation difficult.

Add an option in the platform-specific data to disable the key autorepeat.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/matrix_keypad.c |    4 +++-
 include/linux/input/matrix_keypad.h    |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/input/keyboard/matrix_keypad.c~matrix_keypad-allow-platform-to-disable-key-autorepeat drivers/input/keyboard/matrix_keypad.c
--- a/drivers/input/keyboard/matrix_keypad.c~matrix_keypad-allow-platform-to-disable-key-autorepeat
+++ a/drivers/input/keyboard/matrix_keypad.c
@@ -374,7 +374,9 @@ static int __devinit matrix_keypad_probe
 	input_dev->name		= pdev->name;
 	input_dev->id.bustype	= BUS_HOST;
 	input_dev->dev.parent	= &pdev->dev;
-	input_dev->evbit[0]	= BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	input_dev->evbit[0]	= BIT_MASK(EV_KEY);
+	if (!pdata->no_autorep)
+		input_dev->evbit[0] |= BIT_MASK(EV_REP);
 	input_dev->open		= matrix_keypad_start;
 	input_dev->close	= matrix_keypad_stop;
 
diff -puN include/linux/input/matrix_keypad.h~matrix_keypad-allow-platform-to-disable-key-autorepeat include/linux/input/matrix_keypad.h
--- a/include/linux/input/matrix_keypad.h~matrix_keypad-allow-platform-to-disable-key-autorepeat
+++ a/include/linux/input/matrix_keypad.h
@@ -44,6 +44,7 @@ struct matrix_keymap_data {
  * @active_low: gpio polarity
  * @wakeup: controls whether the device should be set up as wakeup
  *	source
+ * @no_autorep: disable key autorepeat
  *
  * This structure represents platform-specific data that use used by
  * matrix_keypad driver to perform proper initialization.
@@ -64,6 +65,7 @@ struct matrix_keypad_platform_data {
 
 	bool		active_low;
 	bool		wakeup;
+	bool		no_autorep;
 };
 
 /**
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
matrix_keypad-allow-platform-to-disable-key-autorepeat.patch
scsi-sdc-quiet-all-sparse-noise.patch
fs-writebackc-bitfields-should-be-unsigned.patch

