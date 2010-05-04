From: akpm@linux-foundation.org
Subject: + ipmi-change-addr_source-to-an-enum-rather-than-strings.patch added to -mm tree
Date: Tue, 04 May 2010 15:54:07 -0700
Message-ID: <201005042254.o44Ms7Br023792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756654Ab0EDWyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 18:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, cminyard@mvista.com


The patch titled
     ipmi: change addr_source to an enum rather than strings
has been added to the -mm tree.  Its filename is
     ipmi-change-addr_source-to-an-enum-rather-than-strings.patch

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
Subject: ipmi: change addr_source to an enum rather than strings
From: Matthew Garrett <mjg@redhat.com>

Switch from a char* to an enum to identify the address source of SIs,
making it easier to handle them appropriately during registration.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   44 ++++++++++++++++-------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-change-addr_source-to-an-enum-rather-than-strings drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-change-addr_source-to-an-enum-rather-than-strings
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -107,6 +107,14 @@ enum si_type {
 };
 static char *si_to_str[] = { "kcs", "smic", "bt" };
 
+enum ipmi_addr_src {
+	SI_INVALID = 0, SI_HOTMOD, SI_HARDCODED, SI_SPMI, SI_ACPI, SI_SMBIOS,
+	SI_PCI,	SI_DEVICETREE, SI_DEFAULT
+};
+static char *ipmi_addr_src_to_str[] = { NULL, "hotmod", "hardcoded", "SPMI",
+					"ACPI", "SMBIOS", "PCI",
+					"device-tree", "default" };
+
 #define DEVICE_NAME "ipmi_si"
 
 static struct platform_driver ipmi_driver = {
@@ -188,7 +196,7 @@ struct smi_info {
 	int (*irq_setup)(struct smi_info *info);
 	void (*irq_cleanup)(struct smi_info *info);
 	unsigned int io_size;
-	char *addr_source; /* ACPI, PCI, SMBIOS, hardcode, default. */
+	enum ipmi_addr_src addr_source; /* ACPI, PCI, SMBIOS, hardcode, etc. */
 	void (*addr_source_cleanup)(struct smi_info *info);
 	void *addr_source_data;
 
@@ -1755,7 +1763,7 @@ static int hotmod_handler(const char *va
 				goto out;
 			}
 
-			info->addr_source = "hotmod";
+			info->addr_source = SI_HOTMOD;
 			info->si_type = si_type;
 			info->io.addr_data = addr;
 			info->io.addr_type = addr_space;
@@ -1813,7 +1821,7 @@ static __devinit void hardcode_find_bmc(
 		if (!info)
 			return;
 
-		info->addr_source = "hardcoded";
+		info->addr_source = SI_HARDCODED;
 
 		if (!si_type[i] || strcmp(si_type[i], "kcs") == 0) {
 			info->si_type = SI_KCS;
@@ -2004,7 +2012,7 @@ static __devinit int try_init_spmi(struc
 		return -ENOMEM;
 	}
 
-	info->addr_source = "SPMI";
+	info->addr_source = SI_SPMI;
 
 	/* Figure out the interface type. */
 	switch (spmi->InterfaceType) {
@@ -2105,7 +2113,7 @@ static int __devinit ipmi_pnp_probe(stru
 	if (!info)
 		return -ENOMEM;
 
-	info->addr_source = "ACPI";
+	info->addr_source = SI_ACPI;
 
 	handle = acpi_dev->handle;
 
@@ -2269,7 +2277,7 @@ static __devinit void try_init_dmi(struc
 		return;
 	}
 
-	info->addr_source = "SMBIOS";
+	info->addr_source = SI_SMBIOS;
 
 	switch (ipmi_data->type) {
 	case 0x01: /* KCS */
@@ -2368,7 +2376,7 @@ static int __devinit ipmi_pci_probe(stru
 	if (!info)
 		return -ENOMEM;
 
-	info->addr_source = "PCI";
+	info->addr_source = SI_PCI;
 
 	switch (class_type) {
 	case PCI_ERMC_CLASSCODE_TYPE_SMIC:
@@ -2508,7 +2516,7 @@ static int __devinit ipmi_of_probe(struc
 	}
 
 	info->si_type		= (enum si_type) match->data;
-	info->addr_source	= "device-tree";
+	info->addr_source	= SI_DEVICETREE;
 	info->irq_setup		= std_irq_setup;
 
 	if (resource.flags & IORESOURCE_IO) {
@@ -2948,7 +2956,7 @@ static __devinit void default_find_bmc(v
 		if (!info)
 			return;
 
-		info->addr_source = NULL;
+		info->addr_source = SI_DEFAULT;
 
 		info->si_type = ipmi_defaults[i].type;
 		info->io_setup = port_setup;
@@ -2991,16 +2999,14 @@ static int try_smi_init(struct smi_info 
 	int rv;
 	int i;
 
-	if (new_smi->addr_source) {
-		printk(KERN_INFO "ipmi_si: Trying %s-specified %s state"
-		       " machine at %s address 0x%lx, slave address 0x%x,"
-		       " irq %d\n",
-		       new_smi->addr_source,
-		       si_to_str[new_smi->si_type],
-		       addr_space_to_str[new_smi->io.addr_type],
-		       new_smi->io.addr_data,
-		       new_smi->slave_addr, new_smi->irq);
-	}
+	printk(KERN_INFO "ipmi_si: Trying %s-specified %s state"
+	       " machine at %s address 0x%lx, slave address 0x%x,"
+	       " irq %d\n",
+	       ipmi_addr_src_to_str[new_smi->addr_source],
+	       si_to_str[new_smi->si_type],
+	       addr_space_to_str[new_smi->io.addr_type],
+	       new_smi->io.addr_data,
+	       new_smi->slave_addr, new_smi->irq);
 
 	mutex_lock(&smi_infos_lock);
 	if (!is_new_interface(new_smi)) {
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
mbp_nvidia_bl-add-support-for-older-macbookpro-and-macbook-61.patch
ipmi-change-addr_source-to-an-enum-rather-than-strings.patch
ipmi-split-device-discovery-and-registration.patch
ipmi-only-register-one-si-per-bmc.patch
ipmi-change-device-discovery-order.patch
ipmi-reduce-polling-when-interrupts-are-available.patch
ipmi-reduce-polling.patch
ipmi-attempt-to-register-multiple-sis-of-the-same-type.patch

