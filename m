From: akpm@linux-foundation.org
Subject: + rapidio-modify-mport-id-assignment.patch added to -mm tree
Date: Tue, 01 Mar 2011 16:24:07 -0800
Message-ID: <201103020024.p220O8As008467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab1CBAZa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2011 19:25:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, benh@kernel.crashing.org, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: modify mport ID assignment
has been added to the -mm tree.  Its filename is
     rapidio-modify-mport-id-assignment.patch

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
Subject: rapidio: modify mport ID assignment
From: Alexandre Bounine <alexandre.bounine@idt.com>

Changes mport ID and host destination ID assignment to implement unified
method common to all mport drivers.  Makes "riohdid=" kernel command line
parameter common for all architectures with support for more that one host
destination ID assignment.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   25 -------------------------
 drivers/rapidio/rio.c         |   26 ++++++++++++++++++++++++++
 include/linux/rio.h           |    1 +
 3 files changed, 27 insertions(+), 25 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-modify-mport-id-assignment arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-modify-mport-id-assignment
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -1288,28 +1288,6 @@ err_out:
 	return rc;
 }
 
-static char *cmdline = NULL;
-
-static int fsl_rio_get_hdid(int index)
-{
-	/* XXX Need to parse multiple entries in some format */
-	if (!cmdline)
-		return -1;
-
-	return simple_strtol(cmdline, NULL, 0);
-}
-
-static int fsl_rio_get_cmdline(char *s)
-{
-	if (!s)
-		return 0;
-
-	cmdline = s;
-	return 1;
-}
-
-__setup("riohdid=", fsl_rio_get_cmdline);
-
 static inline void fsl_rio_info(struct device *dev, u32 ccsr)
 {
 	const char *str;
@@ -1439,7 +1417,6 @@ int fsl_rio_setup(struct platform_device
 		rc = -ENOMEM;
 		goto err_port;
 	}
-	port->id = 0;
 	port->index = 0;
 
 	priv = kzalloc(sizeof(struct rio_priv), GFP_KERNEL);
@@ -1470,8 +1447,6 @@ int fsl_rio_setup(struct platform_device
 	priv->dev = &dev->dev;
 
 	port->ops = ops;
-	port->host_deviceid = fsl_rio_get_hdid(port->id);
-
 	port->priv = priv;
 	port->phys_efptr = 0x100;
 	rio_register_mport(port);
diff -puN drivers/rapidio/rio.c~rapidio-modify-mport-id-assignment drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-modify-mport-id-assignment
+++ a/drivers/rapidio/rio.c
@@ -32,6 +32,7 @@
 #include "rio.h"
 
 static LIST_HEAD(rio_mports);
+static unsigned char next_portid;
 
 /**
  * rio_local_get_device_id - Get the base/extended device id for a port
@@ -1164,8 +1165,33 @@ int __devinit rio_init_mports(void)
 
 device_initcall_sync(rio_init_mports);
 
+static int hdids[RIO_MAX_MPORTS + 1];
+
+static int rio_get_hdid(int index)
+{
+	if (!hdids[0] || hdids[0] <= index || index >= RIO_MAX_MPORTS)
+		return -1;
+
+	return hdids[index + 1];
+}
+
+static int rio_hdid_setup(char *str)
+{
+	(void)get_options(str, ARRAY_SIZE(hdids), hdids);
+	return 1;
+}
+
+__setup("riohdid=", rio_hdid_setup);
+
 void rio_register_mport(struct rio_mport *port)
 {
+	if (next_portid >= RIO_MAX_MPORTS) {
+		pr_err("RIO: reached specified max number of mports\n");
+		return;
+	}
+
+	port->id = next_portid++;
+	port->host_deviceid = rio_get_hdid(port->id);
 	list_add_tail(&port->node, &rio_mports);
 }
 
diff -puN include/linux/rio.h~rapidio-modify-mport-id-assignment include/linux/rio.h
--- a/include/linux/rio.h~rapidio-modify-mport-id-assignment
+++ a/include/linux/rio.h
@@ -24,6 +24,7 @@
 #define RIO_NO_HOPCOUNT		-1
 #define RIO_INVALID_DESTID	0xffff
 
+#define RIO_MAX_MPORTS		8
 #define RIO_MAX_MPORT_RESOURCES	16
 #define RIO_MAX_DEV_RESOURCES	16
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-sysfs-attributes-v2.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch
rapidio-add-architecture-specific-callbacks.patch
rapidio-modify-configuration-to-support-pci-srio-controller.patch
rapidio-modify-subsystem-and-driver-initialization-sequence.patch
rapidio-modify-mport-id-assignment.patch
rapidio-remove-mport-resource-reservation-from-common-rio-code.patch

