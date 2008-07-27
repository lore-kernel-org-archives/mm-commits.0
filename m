From: akpm@linux-foundation.org
Subject: + arm-fix-have_clk-merge-goof.patch added to -mm tree
Date: Sat, 26 Jul 2008 23:57:01 -0700
Message-ID: <200807270657.m6R6v1g4007497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbYG0G5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 02:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


The patch titled
     arm: fix HAVE_CLK merge goof
has been added to the -mm tree.  Its filename is
     arm-fix-have_clk-merge-goof.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: fix HAVE_CLK merge goof
From: David Brownell <dbrownell@users.sourceforge.net>

This fixes a merge goof whereby ARCH_EP93XX got the "select HAVE_CLK" line
which belongs instead with ARCH_AT91.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/Kconfig~arm-fix-have_clk-merge-goof arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-fix-have_clk-merge-goof
+++ a/arch/arm/Kconfig
@@ -234,6 +234,7 @@ config ARCH_VERSATILE
 config ARCH_AT91
 	bool "Atmel AT91"
 	select GENERIC_GPIO
+	select HAVE_CLK
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
@@ -267,7 +268,6 @@ config ARCH_EP93XX
 	select ARM_VIC
 	select GENERIC_GPIO
 	select HAVE_CLK
-	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
arm-fix-have_clk-merge-goof.patch
linux-next.patch

