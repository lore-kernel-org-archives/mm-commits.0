From: akpm@linux-foundation.org
Subject: + ipmi-change-device-node-ordering-to-reflect-probe-order.patch added to -mm tree
Date: Wed, 13 Feb 2008 15:28:20 -0800
Message-ID: <200802132328.m1DNSLhi019553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758422AbYBMX3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 18:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cah@us.ibm.com, cminyard@mvista.com


The patch titled
     ipmi: change device node ordering to reflect probe order
has been added to the -mm tree.  Its filename is
     ipmi-change-device-node-ordering-to-reflect-probe-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: change device node ordering to reflect probe order
From: Carol Hebert <cah@us.ibm.com>

Currently, on systems with multiple BMC interfaces, the ipmi device names are
being created in reverse order relative to how they are discovered on the
system (e.g.  on an IBM x3950 multinode server with N nodes, the device name
for the BMC in the first node is /dev/ipmiN-1 and the device name for the BMC
in the last node is /dev/ipmi0, etc.).  The problem is caused by the list
handling routines chosen in dmi_scan.c.  Using list_add() causes the multiple
ipmi devices to be added to the device list using a stack-paradigm and so the
ipmi driver subsequently pulls them off during initialization in LIFO order. 
This patch changes the dmi_save_ipmi_device() list handling paradigm to a
queue, thereby allowing the ipmi driver to build the ipmi device names in the
order in which they are found on the system.

Signed-off-by: Carol Hebert <cah@us.ibm.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/dmi_scan.c~ipmi-change-device-node-ordering-to-reflect-probe-order drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~ipmi-change-device-node-ordering-to-reflect-probe-order
+++ a/drivers/firmware/dmi_scan.c
@@ -272,7 +272,7 @@ static void __init dmi_save_ipmi_device(
 	dev->name = "IPMI controller";
 	dev->device_data = data;
 
-	list_add(&dev->list, &dmi_devices);
+	list_add_tail(&dev->list, &dmi_devices);
 }
 
 static void __init dmi_save_extended_devices(const struct dmi_header *dm)
_

Patches currently in -mm which might be from cah@us.ibm.com are

ipmi-change-device-node-ordering-to-reflect-probe-order.patch
