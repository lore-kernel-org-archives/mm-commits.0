From: akpm@linux-foundation.org
Subject: - legacy-pc-parports-support-parport-dev.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:52 -0700
Message-ID: <200705090247.l492lqsb009027@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934774AbXEICsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, dbrownell@users.sourceforge.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     legacy PC parports support parport->dev
has been removed from the -mm tree.  Its filename was
     legacy-pc-parports-support-parport-dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: legacy PC parports support parport->dev
From: Jean Delvare <khali@linux-fr.org>

Give legacy parallel ports a platform device in the device tree.

This is a quick and dirty implementation; it doesn't actually convert the
legacy parport code to the device driver model (by splitting out probing from
device creation).  But at least parallel port device drivers will finally have
a device to work with.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |   39 +++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff -puN drivers/parport/parport_pc.c~legacy-pc-parports-support-parport-dev drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~legacy-pc-parports-support-parport-dev
+++ a/drivers/parport/parport_pc.c
@@ -53,6 +53,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/pnp.h>
+#include <linux/platform_device.h>
 #include <linux/sysctl.h>
 
 #include <asm/io.h>
@@ -2156,6 +2157,17 @@ struct parport *parport_pc_probe_port (u
 	struct resource *base_res;
 	struct resource	*ECR_res = NULL;
 	struct resource	*EPP_res = NULL;
+	struct platform_device *pdev = NULL;
+
+	if (!dev) {
+		/* We need a physical device to attach to, but none was
+		 * provided. Create our own. */
+		pdev = platform_device_register_simple("parport_pc",
+						       base, NULL, 0);
+		if (IS_ERR(pdev))
+			return NULL;
+		dev = &pdev->dev;
+	}
 
 	ops = kmalloc(sizeof (struct parport_operations), GFP_KERNEL);
 	if (!ops)
@@ -2359,6 +2371,8 @@ out3:
 out2:
 	kfree (ops);
 out1:
+	if (pdev)
+		platform_device_unregister(pdev);
 	return NULL;
 }
 
@@ -3106,6 +3120,21 @@ static struct pnp_driver parport_pc_pnp_
 };
 
 
+static int __devinit parport_pc_platform_probe(struct platform_device *pdev)
+{
+	/* Always succeed, the actual probing is done in
+	 * parport_pc_probe_port(). */
+	return 0;
+}
+
+static struct platform_driver parport_pc_platform_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "parport_pc",
+	},
+	.probe		= parport_pc_platform_probe,
+};
+
 /* This is called by parport_pc_find_nonpci_ports (in asm/parport.h) */
 static int __devinit __attribute__((unused))
 parport_pc_find_isa_ports (int autoirq, int autodma)
@@ -3381,9 +3410,15 @@ __setup("parport_init_mode=",parport_ini
 
 static int __init parport_pc_init(void)
 {
+	int err;
+
 	if (parse_parport_params())
 		return -EINVAL;
 
+	err = platform_driver_register(&parport_pc_platform_driver);
+	if (err)
+		return err;
+
 	if (io[0]) {
 		int i;
 		/* Only probe the ports we were given. */
@@ -3408,6 +3443,7 @@ static void __exit parport_pc_exit(void)
 		pci_unregister_driver (&parport_pc_pci_driver);
 	if (pnp_registered_parport)
 		pnp_unregister_driver (&parport_pc_pnp_driver);
+	platform_driver_unregister(&parport_pc_platform_driver);
 
 	spin_lock(&ports_lock);
 	while (!list_empty(&ports_list)) {
@@ -3416,6 +3452,9 @@ static void __exit parport_pc_exit(void)
 		priv = list_entry(ports_list.next,
 				  struct parport_pc_private, list);
 		port = priv->port;
+		if (port->dev && port->dev->bus == &platform_bus_type)
+			platform_device_unregister(
+				to_platform_device(port->dev));
 		spin_unlock(&ports_lock);
 		parport_pc_unregister_port(port);
 		spin_lock(&ports_lock);
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
applesmc-use-the-address-as-platform-device-id.patch
applesmc-use-standard-sysfs-names-for-labels.patch
git-alsa.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
x86-msr-add-support-for-safe-variants.patch
