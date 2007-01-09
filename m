From: akpm@osdl.org
Subject: + acpi-make-bay-depend-on-dock.patch added to -mm tree
Date: Mon, 08 Jan 2007 16:21:26 -0800
Message-ID: <200701090021.l090LQ0d023803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57026 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbXAIAV2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 19:21:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


The patch titled
     ACPI: Make bay depend on dock
has been added to the -mm tree.  Its filename is
     acpi-make-bay-depend-on-dock.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: Make bay depend on dock
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since the bay driver depends on the dock driver for proper notification, make
this driver depend on the dock driver.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/acpi/Kconfig~acpi-make-bay-depend-on-dock drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-make-bay-depend-on-dock
+++ a/drivers/acpi/Kconfig
@@ -133,6 +133,7 @@ config ACPI_DOCK
 config ACPI_BAY
 	tristate "Removable Drive Bay"
 	depends on EXPERIMENTAL
+	depends on ACPI_DOCK
 	help
 	  This driver adds support for ACPI controlled removable drive
 	  bays such as the IBM ultrabay or the Dell Module Bay.
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
acpi-bay-remove-acpi-driver-struct.patch
acpi-make-bay-depend-on-dock.patch
git-libata-all.patch
