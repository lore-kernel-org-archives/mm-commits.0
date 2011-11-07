From: akpm@linux-foundation.org
Subject: [merged] drivers-w1-w1_intc-multiple-masters-used-same-init_name.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:43 -0800
Message-ID: <201111072029.pA7KThrC013653@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5931 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1KGU3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: faber@faberman.de, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/w1_int.c: multiple masters used same init_name
has been removed from the -mm tree.  Its filename was
     drivers-w1-w1_intc-multiple-masters-used-same-init_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Florian Faber <faber@faberman.de>
Subject: drivers/w1/w1_int.c: multiple masters used same init_name

When using multiple masters, w1_int.c would use the .init_name from w1.c
for all entities, which will fail when creating a corresponding sysfs
entry.  This patch uses the unique name previously generated.

[    0.716000] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x48/0x64()
[    0.716000] sysfs: cannot create duplicate filename '/devices/w1 bus
master'
[    0.716000] Modules linked in:
[    0.716000] Call trace:
[    0.716000]  [<9001a604>] warn_slowpath_common+0x34/0x44
[    0.716000]  [<9001a64c>] warn_slowpath_fmt+0x14/0x18
[    0.720000]  [<90078020>] sysfs_add_one+0x48/0x64
[    0.720000]  [<900784ec>] create_dir+0x40/0x68
[    0.720000]  [<9007857a>] sysfs_create_dir+0x66/0x78
[    0.720000]  [<900c1a8a>] kobject_add_internal+0x6e/0x104
[    0.720000]  [<900c1bc0>] kobject_add_varg+0x20/0x2c
[    0.720000]  [<900c1c1c>] kobject_add+0x30/0x3c
[    0.720000]  [<900dbd66>] device_add+0x6a/0x378
[    0.720000]  [<900dbb4a>] device_initialize+0x12/0x48
[    0.720000]  [<900dc080>] device_register+0xc/0x10
[    0.720000]  [<900f99be>] w1_add_master_device+0x162/0x274
[    0.720000]  [<90008e7a>] w1_gpio_probe+0x66/0xb4
[    0.720000]  [<9000030c>] kernel_init+0x0/0xe8
[    0.720000]  [<900dde54>] platform_drv_probe+0xc/0xe
[    0.720000]  [<9000030c>] kernel_init+0x0/0xe8
[    0.720000]  [<900dd4f8>] driver_probe_device+0x6c/0xdc
[    0.720000]  [<900dd5fc>] __driver_attach+0x34/0x48
[    0.720000]  [<900dcce8>] bus_for_each_dev+0x2c/0x48
[    0.720000]  [<900dd5c8>] __driver_attach+0x0/0x48
[    0.720000]  [<900dd38c>] driver_attach+0x10/0x14
[    0.720000]  [<900dd16a>] bus_add_driver+0x6a/0x18c
[    0.720000]  [<900dd768>] driver_register+0x60/0xb8
[    0.720000]  [<90011594>] __initcall_w1_therm_init6+0x0/0x4
[    0.720000]  [<90008e00>] w1_gpio_init+0x0/0x14
[    0.720000]  [<9000030c>] kernel_init+0x0/0xe8
[    0.720000]  [<900ddf48>] platform_driver_register+0x30/0x38
[    0.720000]  [<90011594>] __initcall_w1_therm_init6+0x0/0x4
[    0.720000]  [<90008e00>] w1_gpio_init+0x0/0x14
[    0.720000]  [<9000030c>] kernel_init+0x0/0xe8
[    0.720000]  [<900ddf5e>] platform_driver_probe+0xe/0x3c
[    0.720000]  [<90008e0c>] w1_gpio_init+0xc/0x14
[    0.720000]  [<90011594>] __initcall_w1_therm_init6+0x0/0x4
[    0.720000]  [<90008e00>] w1_gpio_init+0x0/0x14
[    0.720000]  [<900126d4>] do_one_initcall+0x34/0x130
[    0.720000]  [<90000372>] kernel_init+0x66/0xe8
[    0.720000]  [<90011594>] __initcall_w1_therm_init6+0x0/0x4
[    0.720000]  [<9001ca3e>] do_exit+0x0/0x3a6
[    0.720000]  [<9000030c>] kernel_init+0x0/0xe8
[    0.720000]  [<9001ca3e>] do_exit+0x0/0x3a6
[    0.720000]
[    0.720000] ---[ end trace 5a9233884fead918 ]---
[    0.720000] kobject_add_internal failed for w1 bus master with
-EEXIST, don't try to register things with the same name in the same
directory.

Signed-off-by: Florian Faber <faber@faberman.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_int.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/w1/w1_int.c~drivers-w1-w1_intc-multiple-masters-used-same-init_name drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~drivers-w1-w1_intc-multiple-masters-used-same-init_name
+++ a/drivers/w1/w1_int.c
@@ -78,6 +78,7 @@ static struct w1_master * w1_alloc_dev(u
 	memcpy(&dev->dev, device, sizeof(struct device));
 	dev_set_name(&dev->dev, "w1_bus_master%u", dev->id);
 	snprintf(dev->name, sizeof(dev->name), "w1_bus_master%u", dev->id);
+	dev->dev.init_name = dev->name;
 
 	dev->driver = driver;
 
_

Patches currently in -mm which might be from faber@faberman.de are

origin.patch

