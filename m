From: akpm@linux-foundation.org
Subject: + ads7846-pin-change-interrupt-support.patch added to -mm tree
Date: Mon, 26 Jan 2009 15:05:06 -0800
Message-ID: <200901262305.n0QN56Cp030285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbZAZXFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 18:05:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mroth@nessie.de, dtor@mail.ru, imre.deak@nokia.com


The patch titled
     ads7846: pin change interrupt support
has been added to the -mm tree.  Its filename is
     ads7846-pin-change-interrupt-support.patch

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
Subject: ads7846: pin change interrupt support
From: Michael Roth <mroth@nessie.de>

Some SoC supports only pin change interrupts on GPIO pins used as irq
lines.

The ads7846 core is not affected from the additional irqs on the rising
edge because the code accounts touch bounce anyway by kicking in a timer
and disabling the irq after the first request and reenabling the irq after
a timeout when there is no longer pen down detected.

Signed-off-by: Michael Roth <mroth@nessie.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Imre Deak <imre.deak@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/input/touchscreen/ads7846.c~ads7846-pin-change-interrupt-support drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~ads7846-pin-change-interrupt-support
+++ a/drivers/input/touchscreen/ads7846.c
@@ -1133,9 +1133,15 @@ static int __devinit ads7846_probe(struc
 
 	if (request_irq(spi->irq, ads7846_irq, IRQF_TRIGGER_FALLING,
 			spi->dev.driver->name, ts)) {
-		dev_dbg(&spi->dev, "irq %d busy?\n", spi->irq);
-		err = -EBUSY;
-		goto err_free_gpio;
+		dev_info(&spi->dev,
+			"trying pin change workaround on irq %d\n", spi->irq);
+		if (request_irq(spi->irq, ads7846_irq,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				spi->dev.driver->name, ts)) {
+			dev_dbg(&spi->dev, "irq %d busy?\n", spi->irq);
+			err = -EBUSY;
+			goto err_free_gpio;
+		}
 	}
 
 	err = ads784x_hwmon_register(spi, ts);
_

Patches currently in -mm which might be from mroth@nessie.de are

ads7846-pin-change-interrupt-support.patch

