From: akpm@linux-foundation.org
Subject: - ipmi-change-device-node-ordering-to-reflect-probe-order.patch removed from -mm tree
Date: Mon, 07 Apr 2008 13:01:51 -0700
Message-ID: <200804072001.m37K1p2m022777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbYDGUFn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 16:05:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cah@us.ibm.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: change device node ordering to reflect probe order
has been removed from the -mm tree.  Its filename was
     ipmi-change-device-node-ordering-to-reflect-probe-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: change device node ordering to reflect probe order
From: Carol Hebert <cah@us.ibm.com>

In 2.6.14 a patch was merged which switching the order of the ipmi device
naming from in-order-of-discovery over to reverse-order-of-discovery.

So on systems with multiple BMC interfaces, the ipmi device names are being
created in reverse order relative to how they are discovered on the system
(e.g.  on an IBM x3950 multinode server with N nodes, the device name for the
BMC in the first node is /dev/ipmiN-1 and the device name for the BMC in the
last node is /dev/ipmi0, etc.).

The problem is caused by the list handling routines chosen in dmi_scan.c. 
Using list_add() causes the multiple ipmi devices to be added to the device
list using a stack-paradigm and so the ipmi driver subsequently pulls them off
during initialization in LIFO order.  This patch changes the
dmi_save_ipmi_device() list handling paradigm to a queue, thereby allowing the
ipmi driver to build the ipmi device names in the order in which they are
found on the system.

Signed-off-by: Carol Hebert <cah@us.ibm.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/dmi_scan.c~ipmi-change-device-node-ordering-to-reflect-probe-order drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~ipmi-change-device-node-ordering-to-reflect-probe-order
+++ a/drivers/firmware/dmi_scan.c
@@ -266,7 +266,7 @@ static void __init dmi_save_ipmi_device(
 	dev->name = "IPMI controller";
 	dev->device_data = data;
 
-	list_add(&dev->list, &dmi_devices);
+	list_add_tail(&dev->list, &dmi_devices);
 }
 
 static void __init dmi_save_extended_devices(const struct dmi_header *dm)
_

Patches currently in -mm which might be from cah@us.ibm.com are

origin.patch

