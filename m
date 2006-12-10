From: akpm@osdl.org
Subject: + fix-more-workqueue-build-breakage-tps65010.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:30:24 -0800
Message-ID: <200612101930.kBAJUOZm000903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53407 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762457AbWLJTbS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:31:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, dhowells@redhat.com, khali@linux-fr.org, rmk@arm.linux.org.uk


The patch titled
     fix more workqueue build breakage (tps65010)
has been added to the -mm tree.  Its filename is
     fix-more-workqueue-build-breakage-tps65010.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix more workqueue build breakage (tps65010)
From: David Brownell <david-b@pacbell.net>

More fixes to build breakage from the work_struct changes ...  this updates
the tps65010 driver.  Plus, fix some dependencies related to the way it's
used on the OMAP OSK: force static linking there, since the resulting
kernel can't link.

NOTE that until the i2c core gets fixed to work without SMBUS_QUICK,
kernels needing this driver must still use "tps65010.force=0,0x48" on the
command line.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/mach-omap1/Kconfig  |    1 +
 drivers/i2c/chips/tps65010.c |   21 ++++++++++++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -puN arch/arm/mach-omap1/Kconfig~fix-more-workqueue-build-breakage-tps65010 arch/arm/mach-omap1/Kconfig
--- a/arch/arm/mach-omap1/Kconfig~fix-more-workqueue-build-breakage-tps65010
+++ a/arch/arm/mach-omap1/Kconfig
@@ -43,6 +43,7 @@ config MACH_OMAP_H3
 config MACH_OMAP_OSK
 	bool "TI OSK Support"
 	depends on ARCH_OMAP1 && ARCH_OMAP16XX
+	select TPS65010
     	help
 	  TI OMAP 5912 OSK (OMAP Starter Kit) board support. Say Y here
           if you have such a board.
diff -puN drivers/i2c/chips/tps65010.c~fix-more-workqueue-build-breakage-tps65010 drivers/i2c/chips/tps65010.c
--- a/drivers/i2c/chips/tps65010.c~fix-more-workqueue-build-breakage-tps65010
+++ a/drivers/i2c/chips/tps65010.c
@@ -82,7 +82,7 @@ struct tps65010 {
 	struct i2c_client	client;
 	struct mutex		lock;
 	int			irq;
-	struct work_struct	work;
+	struct delayed_work	work;
 	struct dentry		*file;
 	unsigned		charging:1;
 	unsigned		por:1;
@@ -328,7 +328,7 @@ static void tps65010_interrupt(struct tp
 {
 	u8 tmp = 0, mask, poll;
 
-	/* IRQs won't trigger irqs for certain events, but we can get
+	/* IRQs won't trigger for certain events, but we can get
 	 * others by polling (normally, with external power applied).
 	 */
 	poll = 0;
@@ -411,10 +411,11 @@ static void tps65010_interrupt(struct tp
 }
 
 /* handle IRQs and polling using keventd for now */
-static void tps65010_work(void *_tps)
+static void tps65010_work(struct work_struct *work)
 {
-	struct tps65010		*tps = _tps;
+	struct tps65010		*tps;
 
+	tps = container_of(work, struct tps65010, work.work);
 	mutex_lock(&tps->lock);
 
 	tps65010_interrupt(tps);
@@ -452,7 +453,7 @@ static irqreturn_t tps65010_irq(int irq,
 
 	disable_irq_nosync(irq);
 	set_bit(FLAG_IRQ_ENABLE, &tps->flags);
-	(void) schedule_work(&tps->work);
+	(void) schedule_work(&tps->work.work);
 	return IRQ_HANDLED;
 }
 
@@ -465,13 +466,15 @@ static int __exit tps65010_detach_client
 	struct tps65010		*tps;
 
 	tps = container_of(client, struct tps65010, client);
+	free_irq(tps->irq, tps);
 #ifdef	CONFIG_ARM
 	if (machine_is_omap_h2())
 		omap_free_gpio(58);
 	if (machine_is_omap_osk())
 		omap_free_gpio(OMAP_MPUIO(1));
 #endif
-	free_irq(tps->irq, tps);
+	cancel_delayed_work(&tps->work);
+	flush_scheduled_work();
 	debugfs_remove(tps->file);
 	if (i2c_detach_client(client) == 0)
 		kfree(tps);
@@ -505,7 +508,7 @@ tps65010_probe(struct i2c_adapter *bus, 
 		return 0;
 
 	mutex_init(&tps->lock);
-	INIT_WORK(&tps->work, tps65010_work, tps);
+	INIT_DELAYED_WORK(&tps->work, tps65010_work);
 	tps->irq = -1;
 	tps->client.addr = address;
 	tps->client.adapter = bus;
@@ -620,7 +623,7 @@ tps65010_probe(struct i2c_adapter *bus, 
 	(void) i2c_smbus_write_byte_data(&tps->client, TPS_MASK3, 0x0f
 		| i2c_smbus_read_byte_data(&tps->client, TPS_MASK3));
 
-	tps65010_work(tps);
+	tps65010_work(&tps->work.work);
 
 	tps->file = debugfs_create_file(DRIVER_NAME, S_IRUGO, NULL,
 				tps, DEBUG_FOPS);
@@ -672,7 +675,7 @@ int tps65010_set_vbus_draw(unsigned mA)
 			&& test_and_set_bit(
 				FLAG_VBUS_CHANGED, &the_tps->flags)) {
 		/* gadget drivers call this in_irq() */
-		(void) schedule_work(&the_tps->work);
+		(void) schedule_work(&the_tps->work.work);
 	}
 	local_irq_restore(flags);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtcs-dont-use-i2c_adapterdev.patch
fix-more-workqueue-build-breakage-tps65010.patch
watchdog-omap_wdt-build-fix.patch

