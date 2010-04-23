From: akpm@linux-foundation.org
Subject: + gpio-max732x-fix-input-configuration-for-open-drain-pins.patch added to -mm tree
Date: Fri, 23 Apr 2010 11:20:02 -0700
Message-ID: <201004231820.o3NIK2Eu004352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644Ab0DWSUl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Apr 2010 14:20:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maz@misterjones.org, eric.y.miao@gmail.com


The patch titled
     gpio: max732x: fix input configuration for open-drain pins
has been added to the -mm tree.  Its filename is
     gpio-max732x-fix-input-configuration-for-open-drain-pins.patch

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

 drivers/gpio/max732x.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/gpio/max732x.c~gpio-max732x-fix-input-configuration-for-open-drain-pins drivers/gpio/max732x.c
--- a/drivers/gpio/max732x.c~gpio-max732x-fix-input-configuration-for-open-drain-pins
+++ a/drivers/gpio/max732x.c
@@ -232,6 +232,13 @@ static int max732x_gpio_direction_input(
 		return -EACCES;
 	}
 
+	/*
+	 * Open-drain pins must be set to high impedance (which is
+	 * equivalent to output-high) to be turned into an input.
+	 */
+	if ((mask & chip->dir_output))
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

