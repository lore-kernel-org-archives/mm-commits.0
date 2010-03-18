From: akpm@linux-foundation.org
Subject: + led-driver-for-the-soekris-net5501-board-fix-2.patch added to -mm tree
Date: Thu, 18 Mar 2010 16:15:57 -0700
Message-ID: <201003182315.o2INFvF2021368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab0CRXQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 19:16:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, a.zummo@towertech.it, gurligebis@gentoo.org, rpurdie@rpsys.net


The patch titled
     leds: fix net5501 kconfig
has been added to the -mm tree.  Its filename is
     led-driver-for-the-soekris-net5501-board-fix-2.patch

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
Subject: leds: fix net5501 kconfig
From: Randy Dunlap <randy.dunlap@oracle.com>

LEDS_NET5501 selects LEDS_TRIGGER_DEFAULT_ON even when the symbol
LEDS_TRIGGERS is not enabled.  This causes build errors, so make
LEDS_NET5501 depend on LEDS_TRIGGERS to prevent the build errors.

drivers/leds/ledtrig-default-on.c:25: error: variable 'defon_led_trigger' has initializer but incomplete type
drivers/leds/ledtrig-default-on.c:26: error: unknown field 'name' specified in initializer
drivers/leds/ledtrig-default-on.c:26: warning: excess elements in struct initializer
drivers/leds/ledtrig-default-on.c:26: warning: (near initialization for 'defon_led_trigger')
drivers/leds/ledtrig-default-on.c:27: error: unknown field 'activate' specified in initializer
drivers/leds/ledtrig-default-on.c:27: warning: excess elements in struct initializer
drivers/leds/ledtrig-default-on.c:27: warning: (near initialization for 'defon_led_trigger')
drivers/leds/ledtrig-default-on.c:32: error: implicit declaration of function 'led_trigger_register'
drivers/leds/ledtrig-default-on.c:37: error: implicit declaration of function 'led_trigger_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/leds/Kconfig~led-driver-for-the-soekris-net5501-board-fix-2 drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~led-driver-for-the-soekris-net5501-board-fix-2
+++ a/drivers/leds/Kconfig
@@ -69,7 +69,8 @@ config LEDS_NET48XX
 
 config LEDS_NET5501
 	tristate "LED Support for Soekris net5501 series Error LED"
-	depends on LEDS_CLASS && LEDS_GPIO_PLATFORM && GPIO_CS5535
+	depends on LEDS_CLASS && LEDS_TRIGGERS
+	depends on LEDS_GPIO_PLATFORM && GPIO_CS5535
 	select LEDS_TRIGGER_DEFAULT_ON
 	default n
 	help
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
scripts-kernel-doc-handle-struct-member-__aligned.patch
linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

