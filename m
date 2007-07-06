From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-acpi.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:51:46 -0700
Message-ID: <200707060051.l660pk76028317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760955AbXGFAwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:52:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: ACPI
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-acpi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: ACPI
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/acpi/Kconfig~use-menuconfig-objects-acpi drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~use-menuconfig-objects-acpi
+++ a/drivers/acpi/Kconfig
@@ -2,16 +2,12 @@
 # ACPI Configuration
 #
 
-menu "ACPI (Advanced Configuration and Power Interface) Support"
+menuconfig ACPI
+	bool "ACPI Support (Advanced Configuration and Power Interface) Support"
 	depends on !X86_NUMAQ
 	depends on !X86_VISWS
 	depends on !IA64_HP_SIM
 	depends on IA64 || X86
-	depends on PM
-
-config ACPI
-	bool "ACPI Support"
-	depends on IA64 || X86
 	depends on PCI
 	depends on PM
 	select PNP
@@ -49,7 +45,6 @@ if ACPI
 config ACPI_SLEEP
 	bool "Sleep States"
 	depends on X86 && (!SMP || SUSPEND_SMP)
-	depends on PM
 	default y
 	---help---
 	  This option adds support for ACPI suspend states. 
@@ -82,7 +77,6 @@ config ACPI_SLEEP_PROC_SLEEP
 
 config ACPI_PROCFS
 	bool "Procfs interface (deprecated)"
-	depends on ACPI
 	default y
 	---help---
 	  The Procfs interface for ACPI is made optional for backward compatibility.
@@ -338,7 +332,6 @@ config ACPI_CONTAINER
 
 config ACPI_HOTPLUG_MEMORY
 	tristate "Memory Hotplug"
-	depends on ACPI
 	depends on MEMORY_HOTPLUG
 	default n
 	help
@@ -367,5 +360,3 @@ config ACPI_SBS
 	  to today's ACPI "Control Method" battery.
 
 endif	# ACPI
-
-endmenu
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-acpi.patch
git-hid.patch
git-infiniband.patch
git-kvm.patch
git-netdev-all.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
kernel-utf-8-handling.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_i4l.patch
use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch
