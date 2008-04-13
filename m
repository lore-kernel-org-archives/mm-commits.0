From: akpm@linux-foundation.org
Subject: - pci-hotplug-fix-leaks-in-ibm-hot-plug-controller-driver-ibmphp_init_devno.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:40:15 -0700
Message-ID: <200804130240.m3D2eFfI032485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421AbYDMCkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, gregkh@suse.de, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     pci-hotplug: fix leaks in IBM Hot Plug Controller Driver - ibmphp_init_devno()
has been removed from the -mm tree.  Its filename was
     pci-hotplug-fix-leaks-in-ibm-hot-plug-controller-driver-ibmphp_init_devno.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-hotplug: fix leaks in IBM Hot Plug Controller Driver - ibmphp_init_devno()
From: Jesper Juhl <jesper.juhl@gmail.com>

In drivers/pci/hotplug/ibmphp_core.c::ibmphp_init_devno() we allocate space
dynamically for a PCI irq routing table by calling
pcibios_get_irq_routing_table(), but we never free the allocated space.

This patch frees the allocated space at the function exit points.

Spotted by the Coverity checker. Compile tested only.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/pci/hotplug/ibmphp_core.c~pci-hotplug-fix-leaks-in-ibm-hot-plug-controller-driver-ibmphp_init_devno drivers/pci/hotplug/ibmphp_core.c
--- a/drivers/pci/hotplug/ibmphp_core.c~pci-hotplug-fix-leaks-in-ibm-hot-plug-controller-driver-ibmphp_init_devno
+++ a/drivers/pci/hotplug/ibmphp_core.c
@@ -148,8 +148,10 @@ int ibmphp_init_devno(struct slot **cur_
 	len = (rtable->size - sizeof(struct irq_routing_table)) /
 			sizeof(struct irq_info);
 
-	if (!len)
+	if (!len) {
+		kfree(rtable);
 		return -1;
+	}
 	for (loop = 0; loop < len; loop++) {
 		if ((*cur_slot)->number == rtable->slots[loop].slot) {
 		if ((*cur_slot)->bus == rtable->slots[loop].bus) {
@@ -187,11 +189,13 @@ int ibmphp_init_devno(struct slot **cur_
 				debug("rtable->slots[loop].irq[3].link = %x\n",
 					rtable->slots[loop].irq[3].link);
 				debug("end of init_devno\n");
+				kfree(rtable);
 				return 0;
 			}
 		}
 	}
 
+	kfree(rtable);
 	return -1;
 }
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-x86.patch

