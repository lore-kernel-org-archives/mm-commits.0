From: akpm@linux-foundation.org
Subject: - ipmi-add-ppc-openfirmware-unregister.patch removed from -mm tree
Date: Sat, 12 May 2007 22:14:48 -0700
Message-ID: <200705130514.l4D5ElBV022729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbXEMFO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:14:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krafft@de.ibm.com, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     IPMI: Add PPC openfirmware unregister
has been removed from the -mm tree.  Its filename was
     ipmi-add-ppc-openfirmware-unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: Add PPC openfirmware unregister
From: Christian Krafft <krafft@de.ibm.com>

When trying to load the ipmi_si module on a powerpc with no BMC (baseboard
management controller) the driver failes to load correctly, but doesn't
unregister itself from of_platform.  So, on a second modprobe the kernel
crashes.  This patch adds the missing unregister call.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-ppc-openfirmware-unregister drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-ppc-openfirmware-unregister
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2974,6 +2974,10 @@ static __devinit int init_ipmi_si(void)
 #ifdef CONFIG_PCI
 		pci_unregister_driver(&ipmi_pci_driver);
 #endif
+
+#ifdef CONFIG_PPC_OF
+		of_unregister_platform_driver(&ipmi_of_platform_driver);
+#endif
 		driver_unregister(&ipmi_driver);
 		printk("ipmi_si: Unable to find any System Interface(s)\n");
 		return -ENODEV;
_

Patches currently in -mm which might be from krafft@de.ibm.com are
