From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-acpi.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:47:15 -0700
Message-ID: <200704122247.l3CMlF0G018679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXDLWso (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, lenb@kernel.org


The patch titled
     Use menuconfig objects: ACPI
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-acpi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 11 deletions(-)

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
@@ -330,7 +324,6 @@ config ACPI_CONTAINER
 
 config ACPI_HOTPLUG_MEMORY
 	tristate "Memory Hotplug"
-	depends on ACPI
 	depends on MEMORY_HOTPLUG
 	default n
 	help
@@ -359,5 +352,3 @@ config ACPI_SBS
 	  to today's ACPI "Control Method" battery.
 
 endif	# ACPI
-
-endmenu
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-kbuild.patch
remove-artificial-software-max_loop-limit.patch
fix-kevents-childs-priority-greediness.patch
vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
vt-add-color-support-to-the-underline-and-italic-attributes.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-mtd.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pcihotplug.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
