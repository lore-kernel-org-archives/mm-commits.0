From: akpm@linux-foundation.org
Subject: + pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch added to -mm tree
Date: Mon, 22 Mar 2010 22:50:16 -0400
Message-ID: <201003230551.o2N5p8lh016734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab0CWFvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 01:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, David.Woodhouse@intel.com, arnd@arndb.de, benh@kernel.crashing.org, ddaney@caviumnetworks.com, deller@gmx.de, heiko.carstens@de.ibm.com, jbarnes@virtuousgeek.org, jesper.nilsson@axis.com, lethal@linux-sh.org, matt@console-pimps.org, schwidefsky@de.ibm.com


The patch titled
     pci/dmar: tone down warnings about invalid BIOS DMAR tables
has been added to the -mm tree.  Its filename is
     pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci/dmar: tone down warnings about invalid BIOS DMAR tables
From: Ben Hutchings <ben@decadent.org.uk>

We now know how to deal with these tables so that they are harmless.  Use
the TAINT_FIRMWARE_WORKAROUND flag and don't say the BIOS is 'broken' as
this makes users think of hardware damage.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Helge Deller <deller@gmx.de>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/pci/dmar.c~pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables
+++ a/drivers/pci/dmar.c
@@ -615,12 +615,13 @@ int __init dmar_table_init(void)
 
 static void warn_invalid_dmar(u64 addr, const char *message)
 {
-	WARN_ONCE(1, "Your BIOS is broken; DMAR reported at address %llx%s!\n"
-		  "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-		  addr, message,
-		  dmi_get_system_info(DMI_BIOS_VENDOR),
-		  dmi_get_system_info(DMI_BIOS_VERSION),
-		  dmi_get_system_info(DMI_PRODUCT_VERSION));
+	WARN_TAINT_ONCE(1, TAINT_FIRMWARE_WORKAROUND,
+			"BIOS bug: DMAR reported at address %llx%s!\n"
+			"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+			addr, message,
+			dmi_get_system_info(DMI_BIOS_VENDOR),
+			dmi_get_system_info(DMI_BIOS_VERSION),
+			dmi_get_system_info(DMI_PRODUCT_VERSION));
 }
 
 int __init check_zero_address(void)
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
panic-add-taint-flag-taint_firmware_workaround-i.patch
pci-dmar-combine-the-bios-dmar-table-warning-messages.patch
pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch

