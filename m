From: akpm@linux-foundation.org
Subject: [merged] acpi-do-not-select-acpi_dock-from-ata_acpi.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:11 -0800
Message-ID: <200912292132.nBTLWBon008614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbZL2VdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crmafra@aei.mpg.de, lenb@kernel.org, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: do not select ACPI_DOCK from ATA_ACPI
has been removed from the -mm tree.  Its filename was
     acpi-do-not-select-acpi_dock-from-ata_acpi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: do not select ACPI_DOCK from ATA_ACPI
From: "Carlos R. Mafra" <crmafra@aei.mpg.de>

In March 2008 commit 0ac4a3c2fbbcadc3e96e4dc47d4ae802d66e6f67 ("ACPI: fix
ATA_ACPI build") made CONFIG_ACPI_DOCK be selected by CONFIG_ATA_ACPI because
of a build error when CONFIG_ATA_ACPI=y and CONFIG_ACPI_DOCK=m.

However, in September 2008 commit 898b054f3eec5921320ae8614b5bdd7b07ea5b43
("dock: make dock driver not a module") removed the possibility of having
CONFIG_ACPI_DOCK=m and therefore there is no need for selecting it when
CONFIG_ATA_ACPI=y.

This makes the kernel ~5 Kb smaller for people who don't have a dock by
allowing them to not have ACPI_DOCK compiled-in because of ATA_ACPI=y.

Signed-off-by: Carlos R. Mafra <crmafra@aei.mpg.de>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/ata/Kconfig~acpi-do-not-select-acpi_dock-from-ata_acpi drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~acpi-do-not-select-acpi_dock-from-ata_acpi
+++ a/drivers/ata/Kconfig
@@ -40,7 +40,6 @@ config ATA_VERBOSE_ERROR
 config ATA_ACPI
 	bool "ATA ACPI Support"
 	depends on ACPI && PCI
-	select ACPI_DOCK
 	default y
 	help
 	  This option adds support for ATA-related ACPI objects.
_

Patches currently in -mm which might be from crmafra@aei.mpg.de are


