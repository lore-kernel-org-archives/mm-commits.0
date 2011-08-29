From: akpm@linux-foundation.org
Subject: + alpha-gpio-generic_gpio-default-must-be-n.patch added to -mm tree
Date: Mon, 29 Aug 2011 15:35:12 -0700
Message-ID: <201108292235.p7TMZCx4003725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838Ab1H2Wg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 18:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, broonie@opensource.wolfsonmicro.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, mcree@orcon.net.nz, rth@twiddle.net


The patch titled
     alpha, gpio: GENERIC_GPIO default must be n
has been added to the -mm tree.  Its filename is
     alpha-gpio-generic_gpio-default-must-be-n.patch

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
Subject: alpha, gpio: GENERIC_GPIO default must be n
From: Ben Hutchings <ben@decadent.org.uk>

Since GPIOLIB is optional on alpha, GENERIC_GPIO must not be selected by
default.  If GPIOLIB is enabled, it will select GENERIC_GPIO.

See <http://bugs.debian.org/638696> for an example of what 'def_bool y'
breaks.

Reported-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Cree <mcree@orcon.net.nz>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/Kconfig~alpha-gpio-generic_gpio-default-must-be-n arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-gpio-generic_gpio-default-must-be-n
+++ a/arch/alpha/Kconfig
@@ -51,7 +51,7 @@ config GENERIC_CMOS_UPDATE
         def_bool y
 
 config GENERIC_GPIO
-	def_bool y
+	bool
 
 config ZONE_DMA
 	bool
_

Patches currently in -mm which might be from ben@decadent.org.uk are

alpha-gpio-generic_gpio-default-must-be-n.patch
linux-next.patch

