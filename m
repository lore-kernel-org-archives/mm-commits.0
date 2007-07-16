From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-ipmi.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:19 -0700
Message-ID: <200707162052.l6GKqJJA001536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759509AbXGPVdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:33:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - IPMI
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-ipmi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - IPMI
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/Kconfig |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/char/ipmi/Kconfig~use-menuconfig-objects-ii-ipmi drivers/char/ipmi/Kconfig
--- a/drivers/char/ipmi/Kconfig~use-menuconfig-objects-ii-ipmi
+++ a/drivers/char/ipmi/Kconfig
@@ -2,11 +2,9 @@
 # IPMI device configuration
 #
 
-menu "IPMI"
-	depends on HAS_IOMEM
-
-config IPMI_HANDLER
+menuconfig IPMI_HANDLER
        tristate 'IPMI top-level message handler'
+       depends on HAS_IOMEM
        help
          This enables the central IPMI message handler, required for IPMI
 	 to work.
@@ -18,9 +16,10 @@ config IPMI_HANDLER
 
 	 If unsure, say N.
 
+if IPMI_HANDLER
+
 config IPMI_PANIC_EVENT
        bool 'Generate a panic event to all BMCs on a panic'
-       depends on IPMI_HANDLER
        help
          When a panic occurs, this will cause the IPMI message handler to
 	 generate an IPMI event describing the panic to each interface
@@ -40,14 +39,12 @@ config IPMI_PANIC_STRING
 
 config IPMI_DEVICE_INTERFACE
        tristate 'Device interface for IPMI'
-       depends on IPMI_HANDLER
        help
          This provides an IOCTL interface to the IPMI message handler so
 	 userland processes may use IPMI.  It supports poll() and select().
 
 config IPMI_SI
        tristate 'IPMI System Interface handler'
-       depends on IPMI_HANDLER
        help
          Provides a driver for System Interfaces (KCS, SMIC, BT).
 	 Currently, only KCS and SMIC are supported.  If
@@ -55,15 +52,13 @@ config IPMI_SI
 
 config IPMI_WATCHDOG
        tristate 'IPMI Watchdog Timer'
-       depends on IPMI_HANDLER
        help
          This enables the IPMI watchdog timer.
 
 config IPMI_POWEROFF
        tristate 'IPMI Poweroff'
-       depends on IPMI_HANDLER
        help
          This enables a function to power off the system with IPMI if
 	 the IPMI management controller is capable of this.
 
-endmenu
+endif # IPMI_HANDLER
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch
