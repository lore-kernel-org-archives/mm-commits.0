From: akpm@linux-foundation.org
Subject: [merged] alpha-gpio-generic_gpio-default-must-be-n.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:36:06 -0700
Message-ID: <201109151936.p8FJa6FQ001582@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:10445 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934591Ab1IOTgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, broonie@opensource.wolfsonmicro.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, mcree@orcon.net.nz, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha, gpio: GENERIC_GPIO default must be n
has been removed from the -mm tree.  Its filename was
     alpha-gpio-generic_gpio-default-must-be-n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

