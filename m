From: akpm@linux-foundation.org
Subject: - input-fix-aux-port-detection-with-some-i8042-chips.patch removed from -mm tree
Date: Tue, 08 May 2007 19:42:56 -0700
Message-ID: <200705090242.l492gub3008397@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969300AbXEICnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sroland@tungstengraphics.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: fix aux port detection with some i8042 chips
has been removed from the -mm tree.  Its filename was
     input-fix-aux-port-detection-with-some-i8042-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: input: fix aux port detection with some i8042 chips
From: Roland Scheidegger <sroland@tungstengraphics.com>

The i8042 driver fails detection of the AUX port with some chips, because
they apparently do not change the I8042_CTR_AUXDIS bit immediately.  This
is known to affect at least HP500 / HP510 notebooks, consequently the
built-in touchpad will not work.  The patch will simply reread the value
until it gets the expected value or a retry limit is hit, without touching
other workaround code in the same area.

Signed-off-by: Roland Scheidegger <sroland@tungstengraphics.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff -puN drivers/input/serio/i8042.c~input-fix-aux-port-detection-with-some-i8042-chips drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c~input-fix-aux-port-detection-with-some-i8042-chips
+++ a/drivers/input/serio/i8042.c
@@ -537,6 +537,7 @@ static int __devinit i8042_check_aux(voi
 	int retval = -1;
 	int irq_registered = 0;
 	int aux_loop_broken = 0;
+	int i = 0;
 	unsigned long flags;
 	unsigned char param;
 
@@ -582,14 +583,27 @@ static int __devinit i8042_check_aux(voi
 
 	if (i8042_command(&param, I8042_CMD_AUX_DISABLE))
 		return -1;
-	if (i8042_command(&param, I8042_CMD_CTL_RCTR) || (~param & I8042_CTR_AUXDIS)) {
+	/* some chips need some time to set the I8042_CTR_AUXDIS bit */
+	for (i = 0; i < 100; i++) {
+		if (!i8042_command(&param, I8042_CMD_CTL_RCTR) && (param & I8042_CTR_AUXDIS))
+			break;
+		udelay(50);
+	}
+	if (i == 100) {
 		printk(KERN_WARNING "Failed to disable AUX port, but continuing anyway... Is this a SiS?\n");
 		printk(KERN_WARNING "If AUX port is really absent please use the 'i8042.noaux' option.\n");
 	}
 
 	if (i8042_command(&param, I8042_CMD_AUX_ENABLE))
 		return -1;
-	if (i8042_command(&param, I8042_CMD_CTL_RCTR) || (param & I8042_CTR_AUXDIS))
+	for (i = 0; i < 100; i++) {
+		if (i8042_command(&param, I8042_CMD_CTL_RCTR))
+			return -1;
+		if (~param & I8042_CTR_AUXDIS)
+			break;
+		udelay(50);
+	}
+	if (i == 100)
 		return -1;
 
 /*
_

Patches currently in -mm which might be from sroland@tungstengraphics.com are

origin.patch
