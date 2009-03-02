From: akpm@linux-foundation.org
Subject: [merged] hpilo-new-pci-device.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:27 -0800
Message-ID: <200903021923.n22JNRjw014415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbZCBTYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:24:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.altobelli@hp.com, mm-commits@vger.kernel.org


The patch titled
     hpilo: new pci device
has been removed from the -mm tree.  Its filename was
     hpilo-new-pci-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpilo: new pci device
From: David Altobelli <david.altobelli@hp.com>

Future iLO devices will have an HP vendor id.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hpilo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/hpilo.c~hpilo-new-pci-device drivers/misc/hpilo.c
--- a/drivers/misc/hpilo.c~hpilo-new-pci-device
+++ a/drivers/misc/hpilo.c
@@ -710,6 +710,7 @@ out:
 
 static struct pci_device_id ilo_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB204) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3307) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ilo_devices);
@@ -758,7 +759,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("0.06");
+MODULE_VERSION("1.0");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
_

Patches currently in -mm which might be from david.altobelli@hp.com are

origin.patch

