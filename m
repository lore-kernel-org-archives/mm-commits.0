From: akpm@linux-foundation.org
Subject: + rapidio-add-device-object-linking-into-discovery.patch added to -mm tree
Date: Fri, 10 Dec 2010 15:24:27 -0800
Message-ID: <201012102324.oBANORTn009033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353Ab0LJXY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Dec 2010 18:24:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add device object linking into discovery
has been added to the -mm tree.  Its filename is
     rapidio-add-device-object-linking-into-discovery.patch

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
Subject: rapidio: add device object linking into discovery
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add setting links between rio_dev objects into the discovery process. 
This needed to report device connections on agent (non-host) processors
that perform RIO discovery.  Originally, these links have been introduced
for enumerating host only to support error management.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-add-device-object-linking-into-discovery drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-add-device-object-linking-into-discovery
+++ a/drivers/rapidio/rio-scan.c
@@ -947,7 +947,7 @@ static int rio_enum_complete(struct rio_
  */
 static int __devinit
 rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
-	      u8 hopcount)
+	      u8 hopcount, struct rio_dev *prev, int prev_port)
 {
 	u8 port_num, route_port;
 	struct rio_dev *rdev;
@@ -957,6 +957,9 @@ rio_disc_peer(struct rio_net *net, struc
 	if ((rdev = rio_setup_device(net, port, destid, hopcount, 0))) {
 		/* Add device to the global and bus/net specific list. */
 		list_add_tail(&rdev->net_list, &net->devices);
+		rdev->prev = prev;
+		if (prev && rio_is_switch(prev))
+			prev->rswitch->nextdev[prev_port] = rdev;
 	} else
 		return -1;
 
@@ -998,8 +1001,8 @@ rio_disc_peer(struct rio_net *net, struc
 				if (ndestid == RIO_ANY_DESTID(port->sys_size))
 					continue;
 				rio_unlock_device(port, destid, hopcount);
-				if (rio_disc_peer
-				    (net, port, ndestid, hopcount + 1) < 0)
+				if (rio_disc_peer(net, port, ndestid,
+					hopcount + 1, rdev, port_num) < 0)
 					return -1;
 			}
 		}
@@ -1291,7 +1294,7 @@ int __devinit rio_disc_mport(struct rio_
 						   mport->host_deviceid);
 
 		if (rio_disc_peer(net, mport, RIO_ANY_DESTID(mport->sys_size),
-					0) < 0) {
+					0, NULL, 0) < 0) {
 			printk(KERN_INFO
 			       "RIO: master port %d device has failed discovery\n",
 			       mport->id);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-use-common-destid-storage-for-endpoints-and-switches.patch
rapidio-integrate-rio_switch-into-rio_dev.patch
rapidio-add-definitions-of-component-tag-fields.patch
rapidio-add-device-object-linking-into-discovery.patch
rapidio-use-component-tag-for-unified-switch-identification.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-idt-srio-switches.patch

