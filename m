From: akpm@osdl.org
Subject: - make-8250_pnp-serial-driver-work-after.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:04 -0800
Message-ID: <200612072315.kB7NF4oN030706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54204 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163865AbWLGXU6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:20:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, ambx1@neo.rr.com, bjorn.helgaas@hp.com, pavel@ucw.cz, rjw@sisk.pl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     make 8250_pnp serial driver work after suspend to ram
has been removed from the -mm tree.  Its filename was
     make-8250_pnp-serial-driver-work-after.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make 8250_pnp serial driver work after suspend to ram
From: Mike Galbraith <efault@gmx.de>

Add suspend/resume methods to drivers/serial/8250_pnp.c.  Tested on a
P4/HT 16550A box, ttyS0 login survives across suspend to ram.

[akpm@osdl.org: cleanups]
Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/8250_pnp.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250_pnp.c~make-8250_pnp-serial-driver-work-after drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~make-8250_pnp-serial-driver-work-after
+++ a/drivers/serial/8250_pnp.c
@@ -464,11 +464,38 @@ static void __devexit serial_pnp_remove(
 		serial8250_unregister_port(line - 1);
 }
 
+#ifdef CONFIG_PM
+static int serial_pnp_suspend(struct pnp_dev *dev, pm_message_t state)
+{
+	long line = (long)pnp_get_drvdata(dev);
+
+	if (!line)
+		return -ENODEV;
+	serial8250_suspend_port(line - 1);
+	return 0;
+}
+
+static int serial_pnp_resume(struct pnp_dev *dev)
+{
+	long line = (long)pnp_get_drvdata(dev);
+
+	if (!line)
+		return -ENODEV;
+	serial8250_resume_port(line - 1);
+	return 0;
+}
+#else
+#define serial_pnp_suspend NULL
+#define serial_pnp_resume NULL
+#endif /* CONFIG_PM */
+
 static struct pnp_driver serial_pnp_driver = {
 	.name		= "serial",
-	.id_table	= pnp_dev_table,
 	.probe		= serial_pnp_probe,
 	.remove		= __devexit_p(serial_pnp_remove),
+	.suspend	= serial_pnp_suspend,
+	.resume		= serial_pnp_resume,
+	.id_table	= pnp_dev_table,
 };
 
 static int __init serial8250_pnp_init(void)
_

Patches currently in -mm which might be from efault@gmx.de are

origin.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-improve-migration-accuracy-fix.patch
readahead-call-scheme.patch

