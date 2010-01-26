From: akpm@linux-foundation.org
Subject: + rtc-fm3130-add-missing-braces.patch added to -mm tree
Date: Tue, 26 Jan 2010 14:25:57 -0800
Message-ID: <201001262225.o0QMPvnK024511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262Ab0AZW0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 17:26:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geomatsi@gmail.com, a.zummo@towertech.it, slapin@ossfans.org


The patch titled
     rtc-fm3130: add missing braces
has been added to the -mm tree.  Its filename is
     rtc-fm3130-add-missing-braces.patch

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

rtc-fm3130-add-missing-braces.patch

