From: akpm@linux-foundation.org
Subject: - pci_module_init-convertion-in-tmscsimc.patch removed from -mm tree
Date: Sun, 06 May 2007 23:52:02 -0700
Message-ID: <200705070652.l476q2mw020598@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077AbXEGGwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtinwdheim.de, alan@redhat.com, henne@nachtwindheim.de, mm-commits@vger.kernel.org


The patch titled
     pci_module_init() convertion in tmscsim.c
has been removed from the -mm tree.  Its filename was
     pci_module_init-convertion-in-tmscsimc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci_module_init() convertion in tmscsim.c
From: Henrik Kretzschmar <henne@nachtinwdheim.de>

pci_module_init() convertion in tmscsim.c

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/tmscsim.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/tmscsim.c~pci_module_init-convertion-in-tmscsimc drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c~pci_module_init-convertion-in-tmscsimc
+++ a/drivers/scsi/tmscsim.c
@@ -177,6 +177,8 @@
  *	2.1d  04/05/27	GL	Moved setting of scan_devices to	*
  *				slave_alloc/_configure/_destroy, as	*
  *				suggested by CH.			*
+ *	2.1e  06/09/04	HENKR	change pci_module_init() to		*
+ *				pci_register_driver()			*
  ***********************************************************************/
 
 /* DEBUG options */
@@ -244,7 +246,7 @@
 
 
 #define DC390_BANNER "Tekram DC390/AM53C974"
-#define DC390_VERSION "2.1d 2004-05-27"
+#define DC390_VERSION "2.1e 2006-09-04"
 
 #define PCI_DEVICE_ID_AMD53C974 	PCI_DEVICE_ID_AMD_SCSI
 
@@ -2680,7 +2682,7 @@ static int __init dc390_module_init(void
 		printk (KERN_INFO "DC390: Using safe settings.\n");
 	}
 
-	return pci_module_init(&dc390_driver);
+	return pci_register_driver(&dc390_driver);
 }
 
 static void __exit dc390_module_exit(void)
_

Patches currently in -mm which might be from henne@nachtinwdheim.de are
