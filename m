From: akpm@linux-foundation.org
Subject: [withdrawn] gpio-show-irq-settings-even-if-gpio-direction-is-output.patch removed from -mm tree
Date: Thu, 26 Nov 2009 09:04:00 -0800
Message-ID: <200911261704.nAQH403a014961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760858AbZKZRFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Nov 2009 12:05:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, david-b@pacbell.net, hskinnemoen@atmel.com, janakiram.sistla@gmail.com, raffaele.recalcati@bticino.it, mm-commits@vger.kernel.org


The patch titled
     gpio: show IRQ settings even if GPIO direction is "output"
has been removed from the -mm tree.  Its filename was
     gpio-show-irq-settings-even-if-gpio-direction-is-output.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: show IRQ settings even if GPIO direction is "output"
From: Rodolfo Giometti <giometti@linux.it>

Some architectures (as PXA 27x for example) may define GPIO IRQ lines as
outputs since internal circuitry supports such configuration.

This patch simply detects if a GPIO is a IRQ line or not just looking for
IRQ line number, "desc" and "desc->action" fields.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: <raffaele.recalcati@bticino.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Janakiram Sistla <janakiram.sistla@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |   82 +++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpio-show-irq-settings-even-if-gpio-direction-is-output drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-show-irq-settings-even-if-gpio-direction-is-output
+++ a/drivers/gpio/gpiolib.c
@@ -1518,6 +1518,8 @@ static void gpiolib_dbg_show(struct seq_
 	unsigned		gpio = chip->base;
 	struct gpio_desc	*gdesc = &gpio_desc[gpio];
 	int			is_out;
+	int			irq;
+	struct irq_desc		*desc;
 
 	for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {
 		if (!test_bit(FLAG_REQUESTED, &gdesc->flags))
@@ -1531,48 +1533,46 @@ static void gpiolib_dbg_show(struct seq_
 				? (chip->get(chip, i) ? "hi" : "lo")
 				: "?  ");
 
-		if (!is_out) {
-			int		irq = gpio_to_irq(gpio);
-			struct irq_desc	*desc = irq_to_desc(irq);
-
-			/* This races with request_irq(), set_irq_type(),
-			 * and set_irq_wake() ... but those are "rare".
-			 *
-			 * More significantly, trigger type flags aren't
-			 * currently maintained by genirq.
-			 */
-			if (irq >= 0 && desc->action) {
-				char *trigger;
-
-				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
-				case IRQ_TYPE_NONE:
-					trigger = "(default)";
-					break;
-				case IRQ_TYPE_EDGE_FALLING:
-					trigger = "edge-falling";
-					break;
-				case IRQ_TYPE_EDGE_RISING:
-					trigger = "edge-rising";
-					break;
-				case IRQ_TYPE_EDGE_BOTH:
-					trigger = "edge-both";
-					break;
-				case IRQ_TYPE_LEVEL_HIGH:
-					trigger = "level-high";
-					break;
-				case IRQ_TYPE_LEVEL_LOW:
-					trigger = "level-low";
-					break;
-				default:
-					trigger = "?trigger?";
-					break;
-				}
-
-				seq_printf(s, " irq-%d %s%s",
-					irq, trigger,
-					(desc->status & IRQ_WAKEUP)
-						? " wakeup" : "");
+		irq = gpio_to_irq(gpio);
+		desc = irq_to_desc(irq);
+
+		/* This races with request_irq(), set_irq_type(),
+		 * and set_irq_wake() ... but those are "rare".
+		 *
+		 * More significantly, trigger type flags aren't
+		 * currently maintained by genirq.
+		 */
+		if (irq >= 0 && desc && desc->action) {
+			char *trigger;
+
+			switch (desc->status & IRQ_TYPE_SENSE_MASK) {
+			case IRQ_TYPE_NONE:
+				trigger = "(default)";
+				break;
+			case IRQ_TYPE_EDGE_FALLING:
+				trigger = "edge-falling";
+				break;
+			case IRQ_TYPE_EDGE_RISING:
+				trigger = "edge-rising";
+				break;
+			case IRQ_TYPE_EDGE_BOTH:
+				trigger = "edge-both";
+				break;
+			case IRQ_TYPE_LEVEL_HIGH:
+				trigger = "level-high";
+				break;
+			case IRQ_TYPE_LEVEL_LOW:
+				trigger = "level-low";
+				break;
+			default:
+				trigger = "?trigger?";
+				break;
 			}
+
+			seq_printf(s, " irq-%d %s%s",
+				irq, trigger,
+				(desc->status & IRQ_WAKEUP)
+					? " wakeup" : "");
 		}
 
 		seq_printf(s, "\n");
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
gpio-show-irq-settings-even-if-gpio-direction-is-output.patch

