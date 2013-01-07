From: akpm@linux-foundation.org
Subject: + ipmi-add-options-to-disable-openfirmware-and-pci-scanning.patch added to -mm tree
Date: Mon, 07 Jan 2013 15:44:18 -0800
Message-ID: <20130107234419.97B532004C5@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:52613 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3AGXoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 18:44:22 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so1273321wgb.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 15:44:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com


The patch titled
     Subject: ipmi: add options to disable openfirmware and PCI scanning
has been added to the -mm tree.  Its filename is
     ipmi-add-options-to-disable-openfirmware-and-pci-scanning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Corey Minyard <cminyard@mvista.com>
Subject: ipmi: add options to disable openfirmware and PCI scanning

Add try...  parameters to disable pci and platform (openfirmware) device
scanning for IPMI.  Also add docs for all the try...  parameters.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/IPMI.txt           |   18 +++++++++----
 drivers/char/ipmi/ipmi_si_intf.c |   38 +++++++++++++++++++++--------
 2 files changed, 40 insertions(+), 16 deletions(-)

diff -puN Documentation/IPMI.txt~ipmi-add-options-to-disable-openfirmware-and-pci-scanning Documentation/IPMI.txt
--- a/Documentation/IPMI.txt~ipmi-add-options-to-disable-openfirmware-and-pci-scanning
+++ a/Documentation/IPMI.txt
@@ -348,34 +348,40 @@ You can change this at module load time 
 
   modprobe ipmi_si.o type=<type1>,<type2>....
        ports=<port1>,<port2>... addrs=<addr1>,<addr2>...
-       irqs=<irq1>,<irq2>... trydefaults=[0|1]
+       irqs=<irq1>,<irq2>...
        regspacings=<sp1>,<sp2>,... regsizes=<size1>,<size2>,...
        regshifts=<shift1>,<shift2>,...
        slave_addrs=<addr1>,<addr2>,...
        force_kipmid=<enable1>,<enable2>,...
        kipmid_max_busy_us=<ustime1>,<ustime2>,...
        unload_when_empty=[0|1]
+       trydefaults=[0|1] trydmi=[0|1] tryacpi=[0|1]
+       tryplatform=[0|1] trypci=[0|1]
 
-Each of these except si_trydefaults is a list, the first item for the
+Each of these except try... items is a list, the first item for the
 first interface, second item for the second interface, etc.
 
 The si_type may be either "kcs", "smic", or "bt".  If you leave it blank, it
 defaults to "kcs".
 
-If you specify si_addrs as non-zero for an interface, the driver will
+If you specify addrs as non-zero for an interface, the driver will
 use the memory address given as the address of the device.  This
 overrides si_ports.
 
-If you specify si_ports as non-zero for an interface, the driver will
+If you specify ports as non-zero for an interface, the driver will
 use the I/O port given as the device address.
 
-If you specify si_irqs as non-zero for an interface, the driver will
+If you specify irqs as non-zero for an interface, the driver will
 attempt to use the given interrupt for the device.
 
-si_trydefaults sets whether the standard IPMI interface at 0xca2 and
+trydefaults sets whether the standard IPMI interface at 0xca2 and
 any interfaces specified by ACPE are tried.  By default, the driver
 tries it, set this value to zero to turn this off.
 
+The other try... items disable discovery by their corresponding
+names.  These are all enabled by default, set them to zero to disable
+them.  The tryplatform disables openfirmware.
+
 The next three parameters have to do with register layout.  The
 registers used by the interfaces may not appear at successive
 locations and they may not be in 8-bit registers.  These parameters
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-options-to-disable-openfirmware-and-pci-scanning drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-options-to-disable-openfirmware-and-pci-scanning
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -1214,6 +1214,10 @@ static bool          si_tryacpi = 1;
 #ifdef CONFIG_DMI
 static bool          si_trydmi = 1;
 #endif
+static bool          si_tryplatform = 1;
+#ifdef CONFIG_PCI
+static bool          si_trypci = 1;
+#endif
 static bool          si_trydefaults = 1;
 static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
@@ -1254,6 +1258,15 @@ module_param_named(trydmi, si_trydmi, bo
 MODULE_PARM_DESC(trydmi, "Setting this to zero will disable the"
 		 " default scan of the interfaces identified via DMI");
 #endif
+module_param_named(tryplatform, si_tryplatform, bool, 0);
+MODULE_PARM_DESC(tryacpi, "Setting this to zero will disable the"
+		 " default scan of the interfaces identified via platform"
+		 " interfaces like openfirmware");
+#ifdef CONFIG_PCI
+module_param_named(trypci, si_trypci, bool, 0);
+MODULE_PARM_DESC(tryacpi, "Setting this to zero will disable the"
+		 " default scan of the interfaces identified via pci");
+#endif
 module_param_named(trydefaults, si_trydefaults, bool, 0);
 MODULE_PARM_DESC(trydefaults, "Setting this to 'false' will disable the"
 		 " default scan of the KCS and SMIC interface at the standard"
@@ -3387,13 +3400,15 @@ static int init_ipmi_si(void)
 		return 0;
 	initialized = 1;
 
-	rv = platform_driver_register(&ipmi_driver);
-	if (rv) {
-		printk(KERN_ERR PFX "Unable to register driver: %d\n", rv);
-		return rv;
+	if (si_tryplatform) {
+		rv = platform_driver_register(&ipmi_driver);
+		if (rv) {
+			printk(KERN_ERR PFX "Unable to register "
+			       "driver: %d\n", rv);
+			return rv;
+		}
 	}
 
-
 	/* Parse out the si_type string into its components. */
 	str = si_type_str;
 	if (*str != '\0') {
@@ -3416,11 +3431,14 @@ static int init_ipmi_si(void)
 		return 0;
 
 #ifdef CONFIG_PCI
-	rv = pci_register_driver(&ipmi_pci_driver);
-	if (rv)
-		printk(KERN_ERR PFX "Unable to register PCI driver: %d\n", rv);
-	else
-		pci_registered = 1;
+	if (si_trypci) {
+		rv = pci_register_driver(&ipmi_pci_driver);
+		if (rv)
+			printk(KERN_ERR PFX "Unable to register "
+			       "PCI driver: %d\n", rv);
+		else
+			pci_registered = 1;
+	}
 #endif
 
 #ifdef CONFIG_ACPI
_

Patches currently in -mm which might be from cminyard@mvista.com are

ipmi-remove-superfluous-kernel-userspace-explanation.patch
ipmi-add-new-kernel-options-to-prevent-automatic-ipmi-init.patch
ipmi-add-options-to-disable-openfirmware-and-pci-scanning.patch

