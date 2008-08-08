From: akpm@linux-foundation.org
Subject: + usb-hso-driver-fix-kconfig.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:19:52 -0700
Message-ID: <200808082119.m78LJqhg029075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281AbYHHVUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, greg@kroah.com, jeff@garzik.org


The patch titled
     usb HSO driver: fix Kconfig
has been added to the -mm tree.  Its filename is
     usb-hso-driver-fix-kconfig.patch

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
Subject: usb HSO driver: fix Kconfig
From: David Brownell <dbrownell@users.sourceforge.net>

Move the Kconfig for the new "Option" driver so it's not in the middle of
the usbnet-based drivers, so the dependency displays in the Kconfig user
interfaces don't get trashed.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/Kconfig |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/net/usb/Kconfig~usb-hso-driver-fix-kconfig drivers/net/usb/Kconfig
--- a/drivers/net/usb/Kconfig~usb-hso-driver-fix-kconfig
+++ a/drivers/net/usb/Kconfig
@@ -154,17 +154,6 @@ config USB_NET_AX8817X
 	  This driver creates an interface named "ethX", where X depends on
 	  what other networking devices you have in use.
 
-config USB_HSO
-	tristate "Option USB High Speed Mobile Devices"
-	depends on USB && RFKILL
-	default n
-	help
-	  Choose this option if you have an Option HSDPA/HSUPA card.
-	  These cards support downlink speeds of 7.2Mbps or greater.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hso.
-
 config USB_NET_CDCETHER
 	tristate "CDC Ethernet support (smart devices such as cable modems)"
 	depends on USB_USBNET
@@ -337,5 +326,15 @@ config USB_NET_ZAURUS
 	  really need this non-conformant variant of CDC Ethernet (or in
 	  some cases CDC MDLM) protocol, not "g_ether".
 
+config USB_HSO
+	tristate "Option USB High Speed Mobile Devices"
+	depends on USB && RFKILL
+	default n
+	help
+	  Choose this option if you have an Option HSDPA/HSUPA card.
+	  These cards support downlink speeds of 7.2Mbps or greater.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hso.
 
 endmenu
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

revert-rtc-cdev-lock_kernel-pushdown.patch
linux-next.patch
usb-hso-driver-fix-kconfig.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

