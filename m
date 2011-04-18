From: akpm@linux-foundation.org
Subject: [merged] leds-leds-regulatorc-fix-handling-of-already-enabled-regulators.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:32 -0700
Message-ID: <201104181758.p3IHwhEu016061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756238Ab1DRSES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:04:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ospite@studenti.unina.it, broonie@opensource.wolfsonmicro.com, drwyrm@gmail.com, lrg@slimlogic.co.uk, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds/leds-regulator.c: fix handling of already enabled regulators
has been removed from the -mm tree.  Its filename was
     leds-leds-regulatorc-fix-handling-of-already-enabled-regulators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds/leds-regulator.c: fix handling of already enabled regulators
From: Antonio Ospite <ospite@studenti.unina.it>

Make the driver aware of the initial status of the regulator.

The leds-regulator driver was ignoring the initial status of the
regulator; this resulted in rdev->use_count being incremented to 2 after
calling regulator_led_set_value() in the .probe method when a regulator
was already enabled at insmod time, which made it impossible to ever
disable the regulator.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-regulator.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/leds/leds-regulator.c~leds-leds-regulatorc-fix-handling-of-already-enabled-regulators drivers/leds/leds-regulator.c
--- a/drivers/leds/leds-regulator.c~leds-leds-regulatorc-fix-handling-of-already-enabled-regulators
+++ a/drivers/leds/leds-regulator.c
@@ -178,6 +178,10 @@ static int __devinit regulator_led_probe
 	led->cdev.flags |= LED_CORE_SUSPENDRESUME;
 	led->vcc = vcc;
 
+	/* to handle correctly an already enabled regulator */
+	if (regulator_is_enabled(led->vcc))
+		led->enabled = 1;
+
 	mutex_init(&led->mutex);
 	INIT_WORK(&led->work, led_work);
 
_

Patches currently in -mm which might be from ospite@studenti.unina.it are

origin.patch
linux-next.patch

