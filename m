From: akpm@linux-foundation.org
Subject: - wm9713-support-five-wire-panels.patch removed from -mm tree
Date: Fri, 30 May 2008 15:39:17 -0700
Message-ID: <200805302239.m4UMdHqd014898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbYE3Wk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:40:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     wm9713: support five wire panels
has been removed from the -mm tree.  Its filename was
     wm9713-support-five-wire-panels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wm9713: support five wire panels
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm9713.c |   22 ++++++++++++++++++++++
 include/linux/wm97xx.h             |    1 +
 2 files changed, 23 insertions(+)

diff -puN drivers/input/touchscreen/wm9713.c~wm9713-support-five-wire-panels drivers/input/touchscreen/wm9713.c
--- a/drivers/input/touchscreen/wm9713.c~wm9713-support-five-wire-panels
+++ a/drivers/input/touchscreen/wm9713.c
@@ -85,6 +85,15 @@ module_param(delay, int, 0);
 MODULE_PARM_DESC(delay, "Set adc sample delay.");
 
 /*
+ * Set five_wire = 1 to use a 5 wire touchscreen.
+ *
+ * NOTE: Five wire mode does not allow for readback of pressure.
+ */
+static int five_wire;
+module_param(five_wire, int, 0);
+MODULE_PARM_DESC(five_wire, "Set to '1' to use 5-wire touchscreen.");
+
+/*
  * Set adc mask function.
  *
  * Sources of glitch noise, such as signals driving an LCD display, may feed
@@ -162,6 +171,19 @@ static void wm9713_phy_init(struct wm97x
 			 64000 / rpu);
 	}
 
+	/* Five wire panel? */
+	if (five_wire) {
+		dig3 |= WM9713_45W;
+		dev_info(wm->dev, "setting 5-wire touchscreen mode.");
+
+		if (pil) {
+			dev_warn(wm->dev,
+				 "Pressure measurement not supported in 5 "
+				 "wire mode, disabling\n");
+			pil = 0;
+		}
+	}
+
 	/* touchpanel pressure */
 	if (pil == 2) {
 		dig3 |= WM9712_PIL;
diff -puN include/linux/wm97xx.h~wm9713-support-five-wire-panels include/linux/wm97xx.h
--- a/include/linux/wm97xx.h~wm9713-support-five-wire-panels
+++ a/include/linux/wm97xx.h
@@ -100,6 +100,7 @@
 #define WM9713_ADCSEL_Y		0x0004	/* Y measurement */
 #define WM9713_ADCSEL_PRES	0x0008	/* Pressure measurement */
 #define WM9713_COO		0x0001	/* enable coordinate mode */
+#define WM9713_45W		0x1000  /* set for 5 wire panel */
 #define WM9713_PDEN		0x0800	/* measure only when pen down */
 #define WM9713_ADCSEL_MASK	0x00fe	/* ADC selection mask */
 #define WM9713_WAIT		0x0200	/* coordinate wait */
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
git-regulator.patch

