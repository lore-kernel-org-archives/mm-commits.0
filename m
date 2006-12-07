From: akpm@osdl.org
Subject: - spi-set-kset-of-master-class-dev-explicitly.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:25 -0800
Message-ID: <200612072302.kB7N2P6V029850@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51694 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163610AbWLGXCc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi: set kset of master class dev explicitly
has been removed from the -mm tree.  Its filename was
     spi-set-kset-of-master-class-dev-explicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: set kset of master class dev explicitly
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

<quote Imre Deak from Thu, 12 Jan 2006 21:18:54 +0200>
In order for spi_busnum_to_master to work spi master devices must be linked
into the spi_master_class.subsys.kset list.  At the moment the default
class_obj_subsys.kset is used and we can't enumerate the master devices.
</quote>

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/spi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/spi/spi.c~spi-set-kset-of-master-class-dev-explicitly drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-set-kset-of-master-class-dev-explicitly
+++ a/drivers/spi/spi.c
@@ -366,6 +366,7 @@ spi_alloc_master(struct device *dev, uns
 
 	class_device_initialize(&master->cdev);
 	master->cdev.class = &spi_master_class;
+	kobj_set_kset_s(&master->cdev, spi_master_class.subsys);
 	master->cdev.dev = get_device(dev);
 	spi_master_set_devdata(master, &master[1]);
 
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

origin.patch

