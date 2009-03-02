From: akpm@linux-foundation.org
Subject: [to-be-updated] mfd-twl4030-add-twl4030-pwrbutton-as-our-child.patch removed from -mm tree
Date: Mon, 02 Mar 2009 12:30:15 -0800
Message-ID: <200903022030.n22KUGwc019380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbZCBUkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 15:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: felipe.balbi@nokia.com, dbrownell@users.sourceforge.net, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: twl4030: add twl4030-pwrbutton as our child
has been removed from the -mm tree.  Its filename was
     mfd-twl4030-add-twl4030-pwrbutton-as-our-child.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: twl4030: add twl4030-pwrbutton as our child
From: Felipe Balbi <felipe.balbi@nokia.com>

Make the twl4030-pwrbutton.c driver probe with current child creation api
for twl4030.

Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/twl4030-core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/mfd/twl4030-core.c~mfd-twl4030-add-twl4030-pwrbutton-as-our-child drivers/mfd/twl4030-core.c
--- a/drivers/mfd/twl4030-core.c~mfd-twl4030-add-twl4030-pwrbutton-as-our-child
+++ a/drivers/mfd/twl4030-core.c
@@ -101,6 +101,12 @@
 #define twl_has_usb()	false
 #endif
 
+#if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
+	|| defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
+#define twl_has_pwrbutton()	true
+#else
+#define twl_has_pwrbutton()	false
+#endif
 
 /* Triton Core internal information (BEGIN) */
 
@@ -526,6 +532,13 @@ add_children(struct twl4030_platform_dat
 		usb_transceiver = child;
 	}
 
+	if (twl_has_pwrbutton()) {
+		child = add_child(1, "twl4030_pwrbutton",
+				NULL, 0, true, pdata->irq_base + 8 + 0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	if (twl_has_regulator()) {
 		/*
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
_

Patches currently in -mm which might be from felipe.balbi@nokia.com are

origin.patch
linux-next.patch
input-keyboard-introduce-lm8323-driver.patch
input-keyboard-introduce-lm8323-driver-checkpatch-fixes.patch
mfd-twl4030-add-twl4030-pwrbutton-as-our-child.patch

