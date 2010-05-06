From: akpm@linux-foundation.org
Subject: [nacked] ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch removed from -mm tree
Date: Thu, 06 May 2010 11:59:36 -0400
Message-ID: <201005061901.o46J16w7008116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570Ab0EFTBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:01:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: myron.stowe@hp.com, bjorn.helgaas@hp.com, lenb@kernel.org, minyard@acm.org, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: raise precedence of PNP based discovery mechanisms (ACPI, PCI)
has been removed from the -mm tree.  Its filename was
     ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: raise precedence of PNP based discovery mechanisms (ACPI, PCI)
From: Myron Stowe <myron.stowe@hp.com>

This raises the precedence of PNP discovery mechanisms, ACPI and PCI,
above SMBIOS and SPMI as indicated by Appendix C1 of the IPMI
specification.

Reference: IPMI - Intelligent Platform Management Interface Specification
           v2.0, Document Revision 1.0, 05.05.2005 Markup

  Appendix C1 - Locating IPMI System Interfaces via SMBIOS Tables
      "Note that the settings that this structure reports may be over-
      ridden by `Plug-and-Play' reassignment by the OS.  Therefore, this
      structure should be used only when the interface cannot be
      discovered via `Plug-and-Play' discovery mechanisms incorporated
      in interfaces such as PCI and ACPI."

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -3334,14 +3334,6 @@ static __devinit int init_ipmi_si(void)
 	pnp_register_driver(&ipmi_pnp_driver);
 #endif
 
-#ifdef CONFIG_DMI
-	dmi_find_bmc();
-#endif
-
-#ifdef CONFIG_ACPI
-	spmi_find_bmc();
-#endif
-
 #ifdef CONFIG_PPC_OF
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
@@ -3383,6 +3375,14 @@ static __devinit int init_ipmi_si(void)
 	if (type)
 		return 0;
 
+#ifdef CONFIG_DMI
+	dmi_find_bmc();
+#endif
+
+#ifdef CONFIG_ACPI
+	spmi_find_bmc();
+#endif
+
 	if (si_trydefaults) {
 		mutex_lock(&smi_infos_lock);
 		if (list_empty(&smi_infos)) {
_

Patches currently in -mm which might be from myron.stowe@hp.com are

ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch
ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device.patch

