From: akpm@linux-foundation.org
Subject: [merged] mtd-maps-gpio-addr-flash-fix-up-the-generic_gpio=n-build.patch removed from -mm tree
Date: Fri, 25 Sep 2009 12:53:48 -0700
Message-ID: <200909251953.n8PJrmBp003677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbZIYTyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 15:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, cooloney@kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     mtd/maps: gpio-addr-flash: Fix up the GENERIC_GPIO=n build.
has been removed from the -mm tree.  Its filename was
     mtd-maps-gpio-addr-flash-fix-up-the-generic_gpio=n-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/maps: gpio-addr-flash: Fix up the GENERIC_GPIO=n build.
From: Paul Mundt <lethal@linux-sh.org>

linux/gpio.h takes care of wrapping in to asm/gpio.h or defining a stubbed out
interface. gpio-addr-flush unfortunately references asm/gpio.h directly and as
a result blows up when CONFIG_GENERIC_GPIO is disabled.

  CC      drivers/mtd/maps/gpio-addr-flash.o
In file included from /home/pmundt/devel/git/sh-2.6/arch/sh/include/asm/gpio.h:24,
                 from drivers/mtd/maps/gpio-addr-flash.c:27:
include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
include/asm-generic/gpio.h:170: error: implicit declaration of function 'gpio_get_value'
include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
include/asm-generic/gpio.h:176: error: implicit declaration of function 'gpio_set_value'
In file included from drivers/mtd/maps/gpio-addr-flash.c:27:
/home/pmundt/devel/git/sh-2.6/arch/sh/include/asm/gpio.h: At top level:
/home/pmundt/devel/git/sh-2.6/arch/sh/include/asm/gpio.h:131: error: field 'chip' has incomplete type
drivers/mtd/maps/gpio-addr-flash.c: In function 'gpio_flash_probe':
drivers/mtd/maps/gpio-addr-flash.c:232: error: implicit declaration of function 'gpio_request'
drivers/mtd/maps/gpio-addr-flash.c:236: error: implicit declaration of function 'gpio_free'
drivers/mtd/maps/gpio-addr-flash.c:240: error: implicit declaration of function 'gpio_direction_output'
make[3]: *** [drivers/mtd/maps/gpio-addr-flash.o] Error 1
make[2]: *** [drivers/mtd/maps] Error 2
make[1]: *** [drivers/mtd] Error 2
make: *** [drivers] Error 2

I've opted to just switch to the linux/ version instead of adding a
depends on, as the driver still builds and does the error handling
properly.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/gpio-addr-flash.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mtd/maps/gpio-addr-flash.c~mtd-maps-gpio-addr-flash-fix-up-the-generic_gpio=n-build drivers/mtd/maps/gpio-addr-flash.c
--- a/drivers/mtd/maps/gpio-addr-flash.c~mtd-maps-gpio-addr-flash-fix-up-the-generic_gpio=n-build
+++ a/drivers/mtd/maps/gpio-addr-flash.c
@@ -22,8 +22,7 @@
 #include <linux/mtd/physmap.h>
 #include <linux/platform_device.h>
 #include <linux/types.h>
