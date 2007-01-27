From: akpm@osdl.org
Subject: - spi-alternative-fix-for-spi_busnum_to_master.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:36 -0800
Message-ID: <200701270131.l0R1Vasg031846@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35415 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbXA0Bbo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI: alternative fix for spi_busnum_to_master
has been removed from the -mm tree.  Its filename was
     spi-alternative-fix-for-spi_busnum_to_master.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI: alternative fix for spi_busnum_to_master
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

If a SPI master device exists, udev (udevtrigger) causes kernel crash, due
to wrong kobj pointer in kobject_uevent_env().  This problem was not in
2.6.19.

The backtrace (on MIPS) was:
[<8024db6c>] kobject_uevent_env+0x54c/0x5e8
[<802a8264>] store_uevent+0x1c/0x3c  (in drivers/class.c)
[<801cb14c>] subsys_attr_store+0x2c/0x50
[<801cb80c>] flush_write_buffer+0x38/0x5c
[<801cb900>] sysfs_write_file+0xd0/0x190
[<80181444>] vfs_write+0xc4/0x1a0
[<80181cdc>] sys_write+0x54/0xa0
[<8010dae4>] stack_done+0x20/0x3c

flush_write_buffer() passes kobject of spi_master_class.subsys to
subsys_addr_store(), then subsys_addr_store() passes a pointer to a struct
subsystem to store_uevent() which expects a pointer to a struct
class_device.  The problem seems subsys_attr_store() called instead of
class_device_attr_store().

This mismatch was caused by commit
3bd0f6943520e459659d10f3282285e43d3990f1, which overrides kset of master
class.  This made spi_master_class.subsys.kset.ktype NULL so
subsys_sysfs_ops is used instead of class_dev_sysfs_ops.

The commit was to fix spi_busnum_to_master().  Here is a patch fixes
this function in other way, just searching children list of
class_device.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/spi.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN drivers/spi/spi.c~spi-alternative-fix-for-spi_busnum_to_master drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-alternative-fix-for-spi_busnum_to_master
+++ a/drivers/spi/spi.c
@@ -366,7 +366,6 @@ spi_alloc_master(struct device *dev, uns
 
 	class_device_initialize(&master->cdev);
 	master->cdev.class = &spi_master_class;
-	kobj_set_kset_s(&master->cdev, spi_master_class.subsys);
 	master->cdev.dev = get_device(dev);
 	spi_master_set_devdata(master, &master[1]);
 
@@ -466,14 +465,20 @@ EXPORT_SYMBOL_GPL(spi_unregister_master)
  */
 struct spi_master *spi_busnum_to_master(u16 bus_num)
 {
-	char			name[9];
-	struct kobject		*bus;
-
-	snprintf(name, sizeof name, "spi%u", bus_num);
-	bus = kset_find_obj(&spi_master_class.subsys.kset, name);
-	if (bus)
-		return container_of(bus, struct spi_master, cdev.kobj);
-	return NULL;
+	struct class_device	*cdev;
+	struct spi_master	*master = NULL;
+	struct spi_master	*m;
+
+	down(&spi_master_class.sem);
+	list_for_each_entry(cdev, &spi_master_class.children, node) {
+		m = container_of(cdev, struct spi_master, cdev);
+		if (m->bus_num == bus_num) {
+			master = spi_master_get(m);
+			break;
+		}
+	}
+	up(&spi_master_class.sem);
+	return master;
 }
 EXPORT_SYMBOL_GPL(spi_busnum_to_master);
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-mips.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
serial-serial_txx9-driver-update.patch
