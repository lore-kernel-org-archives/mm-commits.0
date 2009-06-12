From: akpm@linux-foundation.org
Subject: [merged] ads7846-pin-change-interrupt-support.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:14 -0700
Message-ID: <200906121822.n5CIMEk0030960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182AbZFLS0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:26:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mroth@nessie.de, dtor@mail.ru, imre.deak@nokia.com, mm-commits@vger.kernel.org


The patch titled
     ads7846: pin change interrupt support
has been removed from the -mm tree.  Its filename was
     ads7846-pin-change-interrupt-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1150,9 +1150,15 @@ static int __devinit ads7846_probe(struc
 
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

linux-next.patch

