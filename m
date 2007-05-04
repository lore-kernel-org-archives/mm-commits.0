From: akpm@linux-foundation.org
Subject: + input-fix-aux-port-detection-with-some-i8042-chips.patch added to -mm tree
Date: Fri, 04 May 2007 12:22:24 -0700
Message-ID: <200705041922.l44JMO09011824@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423019AbXEDTWv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 15:22:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sroland@tungstengraphics.com, dtor@mail.ru


The patch titled
     input: fix aux port detection with some i8042 chips
has been added to the -mm tree.  Its filename is
     input-fix-aux-port-detection-with-some-i8042-chips.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

input-fix-aux-port-detection-with-some-i8042-chips.patch
input-fix-aux-port-detection-with-some-i8042-chips-fix.patch
