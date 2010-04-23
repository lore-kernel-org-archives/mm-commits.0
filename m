From: akpm@linux-foundation.org
Subject: [to-be-updated] gpio-max732x-fix-input-configuration-for-open-drain-pins.patch removed from -mm tree
Date: Fri, 23 Apr 2010 11:19:04 -0700
Message-ID: <201004231819.o3NIJ5np004328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab0DWSTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Apr 2010 14:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maz@misterjones.org, eric.y.miao@gmail.com, mm-commits@vger.kernel.org


The patch titled
     gpio: max732x: fix input configuration for open-drain pins
has been removed from the -mm tree.  Its filename was
     gpio-max732x-fix-input-configuration-for-open-drain-pins.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: max732x: fix input configuration for open-drain pins
From: Marc Zyngier <maz@misterjones.org>

Fix a bug I noticed while hacking on the max732x driver for interrupt
support.  According to the datasheets, open-drain pins have to be
configured as output-high (which in that case is actually high impedance)
to be used as input.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max732x.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/max732x.c~gpio-max732x-fix-input-configuration-for-open-drain-pins drivers/gpio/max732x.c
--- a/drivers/gpio/max732x.c~gpio-max732x-fix-input-configuration-for-open-drain-pins
+++ a/drivers/gpio/max732x.c
@@ -223,15 +223,25 @@ static int max732x_gpio_direction_input(
 {
 	struct max732x_chip *chip;
 	unsigned int mask = 1u << off;
+	unsigned int is_input;
 
 	chip = container_of(gc, struct max732x_chip, gpio_chip);
 
-	if ((mask & chip->dir_input) == 0) {
+	is_input = mask & chip->dir_input;
+
+	if (!is_input) {
 		dev_dbg(&chip->client->dev, "%s port %d is output only\n",
 			chip->client->name, off);
 		return -EACCES;
 	}
 
+	/*
+	 * Open-drain pins must be set to high impedance (which is
+	 * equivalent to output-high) to be turned into an input.
+	 */
+	if ((is_input & chip->dir_output))
+		max732x_gpio_set_value(gc, off, 1);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from maz@misterjones.org are

linux-next.patch
rtc-ds1302-add-some-abstraction-for-new-platform-support.patch
gpio-add-interrupt-handling-capability-to-max732x.patch
gpio-max732x-fix-input-configuration-for-open-drain-pins.patch

