From: akpm@linux-foundation.org
Subject: + fix-kconfig-dependency-problems-wrt-boolean-menuconfigs.patch added to -mm tree
Date: Mon, 25 Jun 2007 14:49:06 -0700
Message-ID: <200706252149.l5PLn647011615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60278 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbXFYVtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 17:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xyzzy@speakeasy.org, akpm@linux-foundation.org, chas@cmf.nrl.navy.mil, davem@davemloft.net, jeff@garzik.org, linux@dominikbrodowski.net, mchehab@infradead.org


The patch titled
     Fix Kconfig dependency problems wrt boolean menuconfigs
has been added to the -mm tree.  Its filename is
     fix-kconfig-dependency-problems-wrt-boolean-menuconfigs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix Kconfig dependency problems wrt boolean menuconfigs
From: Trent Piepho <xyzzy@speakeasy.org>

If one has a dependency chain (tristate)FOO depends on (bool)BAR depends on
(tristate)BAZ, build problems will result.  If BAZ=m, then BAR can be set
y, which allows FOO=y.  It's possible to have FOO=y && BAZ=m, which
wouldn't be allowed if FOO depended directly on BAZ.  In effect, the bool
promotes the tristate from m to y.

This ends up causing a problem with several menuconfigs that look like:

menuconfig BAR
	bool
	depends on BAZ [tristate]
if BAR
config FOO
	tristate
endif

The solution used here is to add the dependencies of BAR to the if
statement, so that items in the if block will gain a direct
non-bool-promoted dependency on BAZ.  This is how it would work if a menu
was used instead of an if block.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/Kconfig         |    2 +-
 drivers/media/dvb/Kconfig   |    2 +-
 drivers/media/radio/Kconfig |    2 +-
 drivers/media/video/Kconfig |    6 +++---
 drivers/net/pcmcia/Kconfig  |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/atm/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs drivers/atm/Kconfig
--- a/drivers/atm/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs
+++ a/drivers/atm/Kconfig
@@ -7,7 +7,7 @@ menuconfig ATM_DRIVERS
 	depends on NETDEVICES && ATM
 	default y
 
-if ATM_DRIVERS
+if ATM_DRIVERS && NETDEVICES && ATM
 
 config ATM_DUMMY
 	tristate "Dummy ATM driver"
diff -puN drivers/media/dvb/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs drivers/media/dvb/Kconfig
--- a/drivers/media/dvb/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs
+++ a/drivers/media/dvb/Kconfig
@@ -11,7 +11,7 @@ menuconfig DVB_CAPTURE_DRIVERS
 	---help---
 	  Say Y to select Digital TV adapters
 
-if DVB_CAPTURE_DRIVERS
+if DVB_CAPTURE_DRIVERS && DVB_CORE
 
 comment "Supported SAA7146 based PCI Adapters"
 	depends on DVB_CORE && PCI && I2C
diff -puN drivers/media/radio/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs drivers/media/radio/Kconfig
--- a/drivers/media/radio/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs
+++ a/drivers/media/radio/Kconfig
@@ -9,7 +9,7 @@ menuconfig RADIO_ADAPTERS
 	---help---
 	  Say Y here to enable selecting AM/FM radio adapters.
 
-if RADIO_ADAPTERS
+if RADIO_ADAPTERS && VIDEO_DEV
 
 config RADIO_CADET
 	tristate "ADS Cadet AM/FM Tuner"
diff -puN drivers/media/video/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs
+++ a/drivers/media/video/Kconfig
@@ -11,7 +11,7 @@ menuconfig VIDEO_CAPTURE_DRIVERS
 	  webcams, analog TV, and hybrid analog/digital TV.
 	  Some of those devices also supports FM radio.
 
-if VIDEO_CAPTURE_DRIVERS
+if VIDEO_CAPTURE_DRIVERS && VIDEO_DEV
 
 config VIDEO_ADV_DEBUG
 	bool "Enable advanced debug functionality"
@@ -347,7 +347,7 @@ endmenu # encoder / decoder chips
 
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
-	depends on VIDEO_V4L2 && !SPARC32 && !SPARC64 && PCI && VIDEO_DEV
+	depends on VIDEO_V4L2 && !SPARC32 && !SPARC64 && PCI
 	select VIDEO_BUF
 	default n
 	---help---
@@ -691,7 +691,7 @@ menuconfig V4L_USB_DRIVERS
 	depends on USB
 	default y
 
-if V4L_USB_DRIVERS
+if V4L_USB_DRIVERS && USB
 
 source "drivers/media/video/pvrusb2/Kconfig"
 
diff -puN drivers/net/pcmcia/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs drivers/net/pcmcia/Kconfig
--- a/drivers/net/pcmcia/Kconfig~fix-kconfig-dependency-problems-wrt-boolean-menuconfigs
+++ a/drivers/net/pcmcia/Kconfig
@@ -19,7 +19,7 @@ menuconfig NET_PCMCIA
 
 	  If unsure, say N.
 
-if NET_PCMCIA
+if NET_PCMCIA && PCMCIA
 
 config PCMCIA_3C589
 	tristate "3Com 3c589 PCMCIA support"
_

Patches currently in -mm which might be from xyzzy@speakeasy.org are

fix-kconfig-dependency-problems-wrt-boolean-menuconfigs.patch
git-dvb.patch
