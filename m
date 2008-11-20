From: akpm@linux-foundation.org
Subject: + leds-fix-cobalt-raq-led-dependency.patch added to -mm tree
Date: Thu, 20 Nov 2008 13:40:48 -0800
Message-ID: <200811202140.mAKLemnt005102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755317AbYKTVlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 16:41:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, rpurdie@rpsys.net


The patch titled
     leds: fix Cobalt Raq LED dependency
has been added to the -mm tree.  Its filename is
     leds-fix-cobalt-raq-led-dependency.patch

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
Subject: leds: fix Cobalt Raq LED dependency
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Cobalt Raq LEDs require LEDS_CLASS=y.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/Kconfig~leds-fix-cobalt-raq-led-dependency drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-fix-cobalt-raq-led-dependency
+++ a/drivers/leds/Kconfig
@@ -83,7 +83,7 @@ config LEDS_COBALT_QUBE
 
 config LEDS_COBALT_RAQ
 	bool "LED Support for the Cobalt Raq series"
-	depends on LEDS_CLASS && MIPS_COBALT
+	depends on LEDS_CLASS=y && MIPS_COBALT
 	select LEDS_TRIGGERS
 	help
 	  This option enables support for the Cobalt Raq series LEDs.
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

leds-fix-cobalt-raq-led-dependency.patch

