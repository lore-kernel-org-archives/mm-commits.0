From: akpm@linux-foundation.org
Subject: [merged] rapidio-modify-subsystem-and-driver-initialization-sequence.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:11 -0700
Message-ID: <201103250726.p2P7Q5D9026109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab1CYH0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, benh@kernel.crashing.org, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com, mm-commi


The patch titled
     rapidio: modify subsystem and driver initialization sequence
has been removed from the -mm tree.  Its filename was
     rapidio-modify-subsystem-and-driver-initialization-sequence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: modify subsystem and driver initialization sequence
From: Alexandre Bounine <alexandre.bounine@idt.com>

Subsystem initialization sequence modified to support presence of multiple
RapidIO controllers in the system.  The new sequence is compatible with
initialization of PCI devices.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   10 +---------
 drivers/net/rionet.c          |    2 +-
 drivers/rapidio/rio.c         |    6 ++++--
 include/linux/rio.h           |    1 -
 4 files changed, 6 insertions(+), 13 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-modify-subsystem-and-driver-initialization-sequence arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-modify-subsystem-and-driver-initialization-sequence
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -1574,18 +1574,10 @@ err_ops:
  */
 static int __devinit fsl_of_rio_rpn_probe(struct platform_device *dev)
 {
-	int rc;
 	printk(KERN_INFO "Setting up RapidIO peer-to-peer network %s\n",
 			dev->dev.of_node->full_name);
 
-	rc = fsl_rio_setup(dev);
-	if (rc)
-		goto out;
-
-	/* Enumerate all registered ports */
-	rc = rio_init_mports();
-out:
-	return rc;
+	return fsl_rio_setup(dev);
 };
 
 static const struct of_device_id fsl_of_rio_rpn_ids[] = {
diff -puN drivers/net/rionet.c~rapidio-modify-subsystem-and-driver-initialization-sequence drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-modify-subsystem-and-driver-initialization-sequence
+++ a/drivers/net/rionet.c
@@ -571,5 +571,5 @@ static void __exit rionet_exit(void)
 	rio_unregister_driver(&rionet_driver);
 }
 
-module_init(rionet_init);
+late_initcall(rionet_init);
 module_exit(rionet_exit);
diff -puN drivers/rapidio/rio.c~rapidio-modify-subsystem-and-driver-initialization-sequence drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-modify-subsystem-and-driver-initialization-sequence
+++ a/drivers/rapidio/rio.c
@@ -1134,8 +1134,6 @@ static int __devinit rio_init(void)
 	return 0;
 }
 
-device_initcall(rio_init);
-
 int __devinit rio_init_mports(void)
 {
 	int rc = 0;
@@ -1158,10 +1156,14 @@ int __devinit rio_init_mports(void)
 			rio_disc_mport(port);
 	}
 
+	rio_init();
+
       out:
 	return rc;
 }
 
+device_initcall_sync(rio_init_mports);
+
 void rio_register_mport(struct rio_mport *port)
 {
 	list_add_tail(&port->node, &rio_mports);
diff -puN include/linux/rio.h~rapidio-modify-subsystem-and-driver-initialization-sequence include/linux/rio.h
--- a/include/linux/rio.h~rapidio-modify-subsystem-and-driver-initialization-sequence
+++ a/include/linux/rio.h
@@ -395,7 +395,6 @@ union rio_pw_msg {
 };
 
 /* Architecture and hardware-specific functions */
-extern int rio_init_mports(void);
 extern void rio_register_mport(struct rio_mport *);
 extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_inb_mbox(struct rio_mport *, int);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

