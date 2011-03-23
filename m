From: akpm@linux-foundation.org
Subject: [merged] backlight-apple_bl-depends-on-acpi.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:25 -0700
Message-ID: <201103232037.p2NKb1YM028192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933340Ab1CWUhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mjg@redhat.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: apple_bl depends on ACPI
has been removed from the -mm tree.  Its filename was
     backlight-apple_bl-depends-on-acpi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/Kconfig~backlight-apple_bl-depends-on-acpi drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-apple_bl-depends-on-acpi
+++ a/drivers/video/backlight/Kconfig
@@ -246,10 +246,10 @@ config BACKLIGHT_MAX8925
 
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
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

