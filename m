From: akpm@linux-foundation.org
Subject: + leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch added to -mm tree
Date: Fri, 26 Mar 2010 16:10:10 -0700
Message-ID: <201003262310.o2QNAAlc026494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754463Ab0CZXLN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 19:11:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dmitry.torokhov@gmail.com, pavel@ucw.cz, rpurdie@rpsys.net, samuel.thibault@ens-lyon.org


The patch titled
     leds-input: depends on INPUT
has been added to the -mm tree.  Its filename is
     leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch

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
Subject: leds-input: depends on INPUT
From: Randy Dunlap <randy.dunlap@oracle.com>

leds-input uses input_*() functions so it should depend on INPUT.

leds-input.c:(.text+0x6e0513): undefined reference to `input_unregister_handle'
leds-input.c:(.text+0x6e06eb): undefined reference to `input_inject_event'
leds-input.c:(.text+0x6e0700): undefined reference to `input_inject_event'
leds-input.c:(.text+0x6e0906): undefined reference to `input_register_handle'
leds-input.c:(.text+0x6e0bdc): undefined reference to `input_unregister_handler'
leds-input.c:(.init.text+0x285c8): undefined reference to `input_register_handler'
leds-input.c:(.exit.text+0x7b04): undefined reference to `input_unregister_handler'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/Kconfig~leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input
+++ a/drivers/leds/Kconfig
@@ -25,7 +25,7 @@ config LEDS_88PM860X
 
 config LEDS_INPUT
 	tristate "LED Support using input keyboards"
-	depends on LEDS_CLASS
+	depends on LEDS_CLASS && INPUT
 	select LEDS_TRIGGERS
 	help
 	  This option enables support for the LEDs on keyboard managed
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

