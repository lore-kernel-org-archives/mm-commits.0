From: akpm@linux-foundation.org
Subject: [merged] cs5535-gpio-apply-cs5536-errata-workaround-for-gpios.patch removed from -mm tree
Date: Tue, 07 Dec 2010 11:46:41 -0800
Message-ID: <201012071948.oB7JmG1g004598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195Ab0LGTs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 14:48:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cs5535-gpio: apply CS5536 errata workaround for GPIOs
has been removed from the -mm tree.  Its filename was
     cs5535-gpio-apply-cs5536-errata-workaround-for-gpios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs5535-gpio: apply CS5536 errata workaround for GPIOs
From: Andres Salomon <dilinger@queued.net>

The AMD Geode CS5536 Companion Device Silicon Revision B1 Specification
Update mentions the follow as issue #36:

"Atomic write transactions to the atomic GPIO High Bank Feature Bit registers
should only affect the bits selected [...]"
"after Suspend, an atomic write transaction [...] will clear all non-selected
bits of the accessed register."

In other words, writing to the high bank for a single GPIO bit will clear
every other GPIO bit (but only sometimes after a suspend).  The workaround
described is obvious and simple; do a read-modify-write.  This patch does
that, and documents why we're doing it.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/cs5535-gpio.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/cs5535-gpio.c~cs5535-gpio-apply-cs5536-errata-workaround-for-gpios drivers/gpio/cs5535-gpio.c
--- a/drivers/gpio/cs5535-gpio.c~cs5535-gpio-apply-cs5536-errata-workaround-for-gpios
+++ a/drivers/gpio/cs5535-gpio.c
@@ -56,6 +56,18 @@ static struct cs5535_gpio_chip {
  * registers, see include/linux/cs5535.h.
  */
 
+static void errata_outl(u32 val, unsigned long addr)
+{
+	/*
+	 * According to the CS5536 errata (#36), after suspend
+	 * a write to the high bank GPIO register will clear all
+	 * non-selected bits; the recommended workaround is a
+	 * read-modify-write operation.
+	 */
+	val |= inl(addr);
+	outl(val, addr);
+}
+
 static void __cs5535_gpio_set(struct cs5535_gpio_chip *chip, unsigned offset,
 		unsigned int reg)
 {
@@ -64,7 +76,7 @@ static void __cs5535_gpio_set(struct cs5
 		outl(1 << offset, chip->base + reg);
 	else
 		/* high bank register */
-		outl(1 << (offset - 16), chip->base + 0x80 + reg);
+		errata_outl(1 << (offset - 16), chip->base + 0x80 + reg);
 }
 
 void cs5535_gpio_set(unsigned offset, unsigned int reg)
@@ -86,7 +98,7 @@ static void __cs5535_gpio_clear(struct c
 		outl(1 << (offset + 16), chip->base + reg);
 	else
 		/* high bank register */
-		outl(1 << offset, chip->base + 0x80 + reg);
+		errata_outl(1 << offset, chip->base + 0x80 + reg);
 }
 
 void cs5535_gpio_clear(unsigned offset, unsigned int reg)
_

Patches currently in -mm which might be from dilinger@queued.net are

linux-next.patch
drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality.patch
drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api.patch

