From: akpm@linux-foundation.org
Subject: + fix-pca953x-set_type-scheduling-while-atomic-bug.patch added to -mm tree
Date: Mon, 26 Apr 2010 12:26:04 -0700
Message-ID: <201004261926.o3QJQ4VK014688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276Ab0DZT0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 15:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maz@misterjones.org, bgat@billgatliff.com, eric.y.miao@gmail.com


The patch titled
     gpio: fix pca953x set_type 'scheduling while atomic' bug
has been added to the -mm tree.  Its filename is
     fix-pca953x-set_type-scheduling-while-atomic-bug.patch

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
Subject: gpio: fix pca953x set_type 'scheduling while atomic' bug
From: Marc Zyngier <maz@misterjones.org>

Bill Gatliff reported the following bug when using the irq_chip facility
of the pca953x driver on a PPC platform:

BUG: scheduling while atomic: insmod/1530/0x00000002

He traced it back to an i2c transaction in pca953x_irq_set_type(), which
can be called with interrupt disabled (from __setup_irq()).  As the i2c
controller can sleep while sending a message, this qualifies as a bad
idea.

This patch moves the i2c transaction to pca953x_irq_bus_sync_unlock(),
where it is actually safe to send an i2c message.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Reported-by: Bill Gatliff <bgat@billgatliff.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/pca953x.c~fix-pca953x-set_type-scheduling-while-atomic-bug drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~fix-pca953x-set_type-scheduling-while-atomic-bug
+++ a/drivers/gpio/pca953x.c
@@ -252,6 +252,18 @@ static void pca953x_irq_bus_lock(unsigne
 static void pca953x_irq_bus_sync_unlock(unsigned int irq)
 {
 	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	uint16_t new_irqs;
+	uint16_t level;
+
+	/* Look for any newly setup interrupt */
+	new_irqs = chip->irq_trig_fall | chip->irq_trig_raise;
+	new_irqs &= ~chip->reg_direction;
+
+	while(new_irqs) {
+		level = __ffs(new_irqs);
+		pca953x_gpio_direction_input(&chip->gpio_chip, level);
+		new_irqs &= ~(1 << level);
+	}
 
 	mutex_unlock(&chip->irq_lock);
 }
@@ -278,7 +290,7 @@ static int pca953x_irq_set_type(unsigned
 	else
 		chip->irq_trig_raise &= ~mask;
 
-	return pca953x_gpio_direction_input(&chip->gpio_chip, level);
+	return 0;
 }
 
 static struct irq_chip pca953x_irq_chip = {
_

Patches currently in -mm which might be from maz@misterjones.org are

linux-next.patch
fix-pca953x-set_type-scheduling-while-atomic-bug.patch
rtc-ds1302-add-some-abstraction-for-new-platform-support.patch
gpio-add-interrupt-handling-capability-to-max732x.patch
gpio-max732x-fix-input-configuration-for-open-drain-pins.patch

