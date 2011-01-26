From: akpm@linux-foundation.org
Subject: + backlight-apple_bl-depends-on-acpi.patch added to -mm tree
Date: Wed, 26 Jan 2011 13:56:54 -0800
Message-ID: <201101262156.p0QLusgS006938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903Ab1AZV5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 16:57:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mjg@redhat.com, rpurdie@rpsys.net


The patch titled
     backlight: apple_bl depends on ACPI
has been added to the -mm tree.  Its filename is
     backlight-apple_bl-depends-on-acpi.patch

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
Subject: backlight: apple_bl depends on ACPI
From: Randy Dunlap <randy.dunlap@oracle.com>

apple_bl uses ACPI interfaces (data & code), so it should depend on ACPI.

drivers/video/backlight/apple_bl.c:142: warning: 'struct acpi_device' declared inside parameter list
drivers/video/backlight/apple_bl.c:142: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/video/backlight/apple_bl.c:201: warning: 'struct acpi_device' declared inside parameter list
drivers/video/backlight/apple_bl.c:215: error: variable 'apple_bl_driver' has initializer but incomplete type
drivers/video/backlight/apple_bl.c:216: error: unknown field 'name' specified in initializer
drivers/video/backlight/apple_bl.c:216: warning: excess elements in struct initializer
drivers/video/backlight/apple_bl.c:216: warning: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:217: error: unknown field 'ids' specified in initializer
drivers/video/backlight/apple_bl.c:217: warning: excess elements in struct initializer
drivers/video/backlight/apple_bl.c:217: warning: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:218: error: unknown field 'ops' specified in initializer
drivers/video/backlight/apple_bl.c:218: error: extra brace group at end of initializer
drivers/video/backlight/apple_bl.c:218: error: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:221: warning: excess elements in struct initializer
drivers/video/backlight/apple_bl.c:221: warning: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:226: error: implicit declaration of function 'acpi_bus_register_driver'
drivers/video/backlight/apple_bl.c:231: error: implicit declaration of function 'acpi_bus_unregister_driver'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/Kconfig~backlight-apple_bl-depends-on-acpi drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-apple_bl-depends-on-acpi
+++ a/drivers/video/backlight/Kconfig
@@ -238,10 +238,10 @@ config BACKLIGHT_MAX8925
 
 config BACKLIGHT_APPLE
        tristate "Apple Backlight Driver"
-       depends on X86
+       depends on X86 && ACPI
        help
          If you have an Intel-based Apple say Y to enable a driver for its
-	 backlight
+	 backlight.
 
 config BACKLIGHT_TOSA
 	tristate "Sharp SL-6000 Backlight Driver"
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-apple_bl-depends-on-acpi.patch
tty-serial-fix-apbuart-build.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

