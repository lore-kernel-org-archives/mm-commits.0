From: akpm@linux-foundation.org
Subject: [merged] rtc-fm3130-add-missing-braces.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:54:40 -0800
Message-ID: <201002031754.o13HsePw008908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932761Ab0BCRzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:55:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geomatsi@gmail.com, a.zummo@towertech.it, slapin@ossfans.org, mm-commits@vger.kernel.org


The patch titled
     rtc-fm3130: add missing braces
has been removed from the -mm tree.  Its filename was
     rtc-fm3130-add-missing-braces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-fm3130: add missing braces
From: Sergey Matyukevich <geomatsi@gmail.com>

Add missing braces for multiline 'if' statements in fm3130_probe.

Signed-off-by: Sergey Matyukevich <geomatsi@gmail.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sergey Lapin <slapin@ossfans.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-fm3130.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-fm3130.c~rtc-fm3130-add-missing-braces drivers/rtc/rtc-fm3130.c
--- a/drivers/rtc/rtc-fm3130.c~rtc-fm3130-add-missing-braces
+++ a/drivers/rtc/rtc-fm3130.c
@@ -376,20 +376,22 @@ static int __devinit fm3130_probe(struct
 	}
 
 	/* Disabling calibration mode */
-	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_CAL)
+	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_CAL) {
 		i2c_smbus_write_byte_data(client, FM3130_RTC_CONTROL,
 			fm3130->regs[FM3130_RTC_CONTROL] &
 				~(FM3130_RTC_CONTROL_BIT_CAL));
 		dev_warn(&client->dev, "Disabling calibration mode!\n");
+	}
 
 	/* Disabling read and write modes */
 	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_WRITE ||
-	    fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_READ)
+	    fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_READ) {
 		i2c_smbus_write_byte_data(client, FM3130_RTC_CONTROL,
 			fm3130->regs[FM3130_RTC_CONTROL] &
 				~(FM3130_RTC_CONTROL_BIT_READ |
 					FM3130_RTC_CONTROL_BIT_WRITE));
 		dev_warn(&client->dev, "Disabling READ or WRITE mode!\n");
+	}
 
 	/* oscillator off?  turn it on, so clock can tick. */
 	if (fm3130->regs[FM3130_CAL_CONTROL] & FM3130_CAL_CONTROL_BIT_nOSCEN)
_

Patches currently in -mm which might be from geomatsi@gmail.com are

origin.patch

