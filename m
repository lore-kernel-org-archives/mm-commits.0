From: akpm@linux-foundation.org
Subject: + acpi-make-bay-depend-on-dock.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:34:10 -0800
Message-ID: <200702272034.l1RKYD9W027553@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50704 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbXB0Ufe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:35:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, lenb@kernel.org


The patch titled
     ACPI: make bay depend on dock
has been added to the -mm tree.  Its filename is
     acpi-make-bay-depend-on-dock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: make bay depend on dock
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since the bay driver depends on the dock driver for proper notification,
make this driver depend on the dock driver.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/Kconfig~acpi-make-bay-depend-on-dock drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-make-bay-depend-on-dock
+++ a/drivers/acpi/Kconfig
@@ -143,6 +143,7 @@ config ACPI_FAN
 config ACPI_DOCK
 	tristate "Dock"
 	depends on EXPERIMENTAL
+	depends on ACPI_DOCK
 	help
 	  This driver adds support for ACPI controlled docking stations
 
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

acpi-make-bay-depend-on-dock.patch
