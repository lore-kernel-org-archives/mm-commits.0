From: akpm@linux-foundation.org
Subject: + ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch added to -mm tree
Date: Fri, 19 Mar 2010 14:23:50 -0700
Message-ID: <201003192123.o2JLNonK013150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324Ab0CSVX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 17:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: myron.stowe@hp.com, bjorn.helgaas@hp.com, lenb@kernel.org, minyard@acm.org, yakui.zhao@intel.com


The patch titled
     ipmi: raise precedence of PNP based discovery mechanisms (ACPI, PCI)
has been added to the -mm tree.  Its filename is
     ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch

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

 drivers/char/ipmi/ipmi_si_intf.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -3260,13 +3260,6 @@ static __devinit int init_ipmi_si(void)
 
 	hardcode_find_bmc();
 
-#ifdef CONFIG_DMI
-	dmi_find_bmc();
-#endif
-
-#ifdef CONFIG_ACPI
-	spmi_find_bmc();
-#endif
 #ifdef CONFIG_ACPI
 	pnp_register_driver(&ipmi_pnp_driver);
 #endif
@@ -3283,6 +3276,14 @@ static __devinit int init_ipmi_si(void)
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
 
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
ipmi-update-driver-to-use-dev_printk-and-its-constructs.patch

