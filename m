From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-edac.patch added to -mm tree
Date: Wed, 09 May 2007 23:17:45 -0700
Message-ID: <200705100617.l4A6Hj1k013842@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152AbXEJGRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 02:17:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de


The patch titled
     Use menuconfig objects II - EDAC
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-edac.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects II - EDAC
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/edac/Kconfig~use-menuconfig-objects-ii-edac drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~use-menuconfig-objects-ii-edac
+++ a/drivers/edac/Kconfig
@@ -6,10 +6,8 @@
 # $Id: Kconfig,v 1.4.2.7 2005/07/08 22:05:38 dsp_llnl Exp $
 #
 
-menu 'EDAC - error detection and reporting (RAS) (EXPERIMENTAL)'
-
-config EDAC
-	tristate "EDAC core system error reporting (EXPERIMENTAL)"
+menuconfig EDAC
+	tristate "EDAC - error detection and reporting (EXPERIMENTAL)"
 	depends on X86 && EXPERIMENTAL
 	help
 	  EDAC is designed to report errors in the core system.
@@ -29,13 +27,12 @@ config EDAC
 	  There is also a mailing list for the EDAC project, which can
 	  be found via the sourceforge page.
 
+if EDAC
 
 comment "Reporting subsystems"
-	depends on EDAC
 
 config EDAC_DEBUG
 	bool "Debugging"
-	depends on EDAC
 	help
 	  This turns on debugging information for the entire EDAC
 	  sub-system. You can insert module with "debug_level=x", current
@@ -44,7 +41,6 @@ config EDAC_DEBUG
 
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
-	depends on EDAC
 	default y
 	help
 	  Some systems are able to detect and correct errors in main
@@ -99,15 +95,13 @@ config EDAC_R82600
 
 choice
 	prompt "Error detecting method"
-	depends on EDAC
 	default EDAC_POLL
 
 config EDAC_POLL
 	bool "Poll for errors"
-	depends on EDAC
 	help
 	  Poll the chipset periodically to detect errors.
 
 endchoice
 
-endmenu
+endif # EDAC
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-ii-sound.patch
git-dvb.patch
use-menuconfig-objects-ii-ieee1394.patch
use-menuconfig-objects-ii-infiniband.patch
use-menuconfig-objects-ii-kvm-virt.patch
use-menuconfig-objects-ii-led.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-ii-netdev-atm.patch
use-menuconfig-objects-ii-netdev-pcmcia.patch
use-menuconfig-objects-ii-netdev-wan.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-fusion.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-usb.patch
git-watchdog.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-rtc.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
use-menuconfig-objects-ii-isdn.patch
use-menuconfig-objects-ii-md.patch
