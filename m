From: akpm@linux-foundation.org
Subject: + rapidio-use-component-tag-for-unified-switch-identification.patch added to -mm tree
Date: Fri, 10 Dec 2010 15:24:29 -0800
Message-ID: <201012102324.oBANOT0F009036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395Ab0LJXZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Dec 2010 18:25:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: use Component Tag for unified switch identification
has been added to the -mm tree.  Its filename is
     rapidio-use-component-tag-for-unified-switch-identification.patch

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
Subject: rapidio: use Component Tag for unified switch identification
From: Alexandre Bounine <alexandre.bounine@idt.com>

Change the way how switchid value is set.  Local counter variable does not
provide unified way to identify switch devices in a system with multiple
processors.  Using local counter leads to the situation when the same RIO
switch has different switch ID for each processor.  Replacing local
counter with unique portion of the Component Tag provides unified
reference to the switch by every processor in the system.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-use-component-tag-for-unified-switch-identification drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-use-component-tag-for-unified-switch-identification
+++ a/drivers/rapidio/rio-scan.c
@@ -46,7 +46,6 @@ static void rio_init_em(struct rio_dev *
 DEFINE_SPINLOCK(rio_global_list_lock);
 
 static int next_destid = 0;
-static int next_switchid = 0;
 static int next_net = 0;
 static int next_comptag = 1;
 
@@ -438,6 +437,10 @@ static struct rio_dev __devinit *rio_set
 		rio_mport_write_config_32(port, destid, hopcount,
 					  RIO_COMPONENT_TAG_CSR, next_comptag);
 		rdev->comp_tag = next_comptag++;
+	}  else {
+		rio_mport_read_config_32(port, destid, hopcount,
+					 RIO_COMPONENT_TAG_CSR,
+					 &rdev->comp_tag);
 	}
 
 	if (rio_device_has_destid(port, rdev->src_ops, rdev->dst_ops)) {
@@ -461,7 +464,7 @@ static struct rio_dev __devinit *rio_set
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
 		rswitch = rdev->rswitch;
-		rswitch->switchid = next_switchid;
+		rswitch->switchid = rdev->comp_tag & RIO_CTAG_UDEVID;
 		rswitch->port_ok = 0;
 		rswitch->route_table = kzalloc(sizeof(u8)*
 					RIO_MAX_ROUTE_ENTRIES(port->sys_size),
@@ -816,7 +819,6 @@ static int __devinit rio_enum_peer(struc
 		return -1;
 
 	if (rio_is_switch(rdev)) {
-		next_switchid++;
 		sw_inport = RIO_GET_PORT_NUM(rdev->swpinfo);
 		rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport, 0);
@@ -964,8 +966,6 @@ rio_disc_peer(struct rio_net *net, struc
 		return -1;
 
 	if (rio_is_switch(rdev)) {
-		next_switchid++;
