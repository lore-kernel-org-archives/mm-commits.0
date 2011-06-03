From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-asic3-make-leds_asic3-depend-on-leds_class.patch added to -mm tree
Date: Fri, 03 Jun 2011 15:17:36 -0700
Message-ID: <201106032217.p53MHaD2010736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756525Ab1FCWSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 18:18:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, lost.distance@yahoo.com, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-asic3: make LEDS_ASIC3 depend on LEDS_CLASS
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-asic3-make-leds_asic3-depend-on-leds_class.patch

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
Subject: drivers/leds/leds-asic3: make LEDS_ASIC3 depend on LEDS_CLASS
From: Axel Lin <axel.lin@gmail.com>

We call led_classdev_unregister/led_classdev_register in
asic3_led_remove/asic3_led_probe, thus make LEDS_ASIC3 depend on
LEDS_CLASS.

This patch fixes below build error if LEDS_CLASS is not configured.

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `asic3_led_remove':
clkdev.c:(.devexit.text+0x1860): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `asic3_led_probe':
clkdev.c:(.devinit.text+0xcee8): undefined reference to `led_classdev_register'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Paul Parsons <lost.distance@yahoo.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/Kconfig~drivers-leds-leds-asic3-make-leds_asic3-depend-on-leds_class drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~drivers-leds-leds-asic3-make-leds_asic3-depend-on-leds_class
+++ a/drivers/leds/Kconfig
@@ -388,6 +388,7 @@ config LEDS_NETXBIG
 
 config LEDS_ASIC3
 	bool "LED support for the HTC ASIC3"
+	depends on LEDS_CLASS
 	depends on MFD_ASIC3
 	default y
 	help
_

Patches currently in -mm which might be from axel.lin@gmail.com are

drivers-misc-spear13xx_pcie_gadgetc-fix-a-memory-leak-in-spear_pcie_gadget_probe-error-path.patch
drivers-leds-leds-asic3-make-leds_asic3-depend-on-leds_class.patch
linux-next.patch

