From: akpm@linux-foundation.org
Subject: - acpi-use-select-power_supply-for-ac-battery-and-sbs.patch removed from -mm tree
Date: Mon, 29 Oct 2007 14:32:28 -0700
Message-ID: <200710292132.l9TLWS41024342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755872AbXJ2Vcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: astarikovskiy@suse.de, elendil@planet.nl, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: use select POWER_SUPPLY for AC, BATTERY and SBS
has been removed from the -mm tree.  Its filename was
     acpi-use-select-power_supply-for-ac-battery-and-sbs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: use select POWER_SUPPLY for AC, BATTERY and SBS
From: Alexey Starikovskiy <astarikovskiy@suse.de>

POWER_SUPPLY is needed for AC, battery, and SBS sysfs support.  Use
'select' instead of 'depends on', as it is will not be selected by anything
else, leading to confusion.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Tested-by: Frans Pop <elendil@planet.nl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/Kconfig~acpi-use-select-power_supply-for-ac-battery-and-sbs drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-use-select-power_supply-for-ac-battery-and-sbs
+++ a/drivers/acpi/Kconfig
@@ -88,7 +88,8 @@ config ACPI_PROC_EVENT
 
 config ACPI_AC
 	tristate "AC Adapter"
-	depends on X86 && POWER_SUPPLY
+	depends on X86
+	select POWER_SUPPLY
 	default y
 	help
 	  This driver adds support for the AC Adapter object, which indicates
@@ -97,7 +98,8 @@ config ACPI_AC
 
 config ACPI_BATTERY
 	tristate "Battery"
-	depends on X86 && POWER_SUPPLY
+	depends on X86
+	select POWER_SUPPLY
 	default y
 	help
 	  This driver adds support for battery information through
@@ -352,7 +354,7 @@ config ACPI_HOTPLUG_MEMORY
 config ACPI_SBS
 	tristate "Smart Battery System"
 	depends on X86
-	depends on POWER_SUPPLY
+	select POWER_SUPPLY
 	depends on ACPI_PROC_EVENT
 	help
 	  This driver adds support for the Smart Battery System, another
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

git-acpi.patch
make-smart-battery-system-depend-on-acpi_sbs.patch
acpi-use-select-power_supply-for-ac-battery-and-sbs.patch
