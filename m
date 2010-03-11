From: akpm@linux-foundation.org
Subject: [nacked] ipmi-add-proper-offset-for-hp-pci-interfaces.patch removed from -mm tree
Date: Thu, 11 Mar 2010 15:06:58 -0800
Message-ID: <201003112306.o2BN6wNE016439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab0CKXHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Mar 2010 18:07:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: add proper offset for HP PCI interfaces
has been removed from the -mm tree.  Its filename was
     ipmi-add-proper-offset-for-hp-pci-interfaces.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: add proper offset for HP PCI interfaces
From: Corey Minyard <cminyard@mvista.com>

On a PCI update, the offset for HP PCI interfaces to the IPMI controller
was left off.  Add the offset back in.  The "dead code" dealing with
first_reg_offset was removed in 2.6.32, so that is re-added.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-proper-offset-for-hp-pci-interfaces drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-proper-offset-for-hp-pci-interfaces
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2363,6 +2363,7 @@ static int __devinit ipmi_pci_probe(stru
 	int rv;
 	int class_type = pdev->class & PCI_ERMC_CLASSCODE_TYPE_MASK;
 	struct smi_info *info;
+	int first_reg_offset = 0;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -2401,6 +2402,9 @@ static int __devinit ipmi_pci_probe(stru
 	info->addr_source_cleanup = ipmi_pci_cleanup;
 	info->addr_source_data = pdev;
 
+	if (pdev->subsystem_vendor == PCI_HP_VENDOR_ID)
+		first_reg_offset = 1;
+
 	if (pci_resource_flags(pdev, 0) & IORESOURCE_IO) {
 		info->io_setup = port_setup;
 		info->io.addr_type = IPMI_IO_ADDR_SPACE;
@@ -2408,7 +2412,7 @@ static int __devinit ipmi_pci_probe(stru
 		info->io_setup = mem_setup;
 		info->io.addr_type = IPMI_MEM_ADDR_SPACE;
 	}
-	info->io.addr_data = pci_resource_start(pdev, 0);
+	info->io.addr_data = pci_resource_start(pdev, 0) + first_reg_offset;
 
 	info->io.regspacing = DEFAULT_REGSPACING;
 	info->io.regsize = DEFAULT_REGSPACING;
_

Patches currently in -mm which might be from cminyard@mvista.com are

ipmi-add-parameter-to-limit-cpu-usage-in-kipmid.patch
ipmi-add-proper-offset-for-hp-pci-interfaces.patch

