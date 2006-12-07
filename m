From: akpm@osdl.org
Subject: - ipmi-fix-pci-warning.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:47 -0800
Message-ID: <200612072317.kB7NHlpi030963@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53892 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163888AbWLGXRt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     IPMI: fix pci warning
has been removed from the -mm tree.  Its filename was
     ipmi-fix-pci-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: fix pci warning
From: Corey Minyard <minyard@acm.org>

Change pci_module_init() to the new interface, and check the return code to
avoid warnings and give the user useful information if this fails.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-pci-warning drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-pci-warning
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2774,7 +2774,12 @@ static __devinit int init_ipmi_si(void)
 #endif
 
 #ifdef CONFIG_PCI
-	pci_module_init(&ipmi_pci_driver);
+	rv = pci_register_driver(&ipmi_pci_driver);
+	if (rv){
+		printk(KERN_ERR
+		       "init_ipmi_si: Unable to register PCI driver: %d\n",
+		       rv);
+	}
 #endif
 
 	if (si_trydefaults) {
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch

