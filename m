From: akpm@linux-foundation.org
Subject: + leds-leds-regulatorc-fix-handling-of-already-enabled-regulators.patch added to -mm tree
Date: Wed, 30 Mar 2011 13:58:37 -0700
Message-ID: <201103302058.p2UKwbhk008943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252Ab1C3U7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 16:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ospite@studenti.unina.it, broonie@opensource.wolfsonmicro.com, drwyrm@gmail.com, lrg@slimlogic.co.uk, rpurdie@rpsys.net


The patch titled
     leds/leds-regulator.c: fix handling of already enabled regulators
has been added to the -mm tree.  Its filename is
     leds-leds-regulatorc-fix-handling-of-already-enabled-regulators.patch

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

leds-leds-regulatorc-fix-handling-of-already-enabled-regulators.patch

