From: akpm@linux-foundation.org
Subject: - mca-add-integrated-device-bus-matching.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:53 -0700
Message-ID: <200705092149.l49LnrTY002739@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbXEIVt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: James.Bottomley@SteelEye.com, mm-commits@vger.kernel.org


The patch titled
     mca: add integrated device bus matching
has been removed from the -mm tree.  Its filename was
     mca-add-integrated-device-bus-matching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mca: add integrated device bus matching
From: James Bottomley <James.Bottomley@SteelEye.com>

The MCA bus has a few "integrated" functions, which are effectively virtual
slots on the bus.  The problem is that these special functions don't have
dedicated pos IDs, so we have to manufacture ids for them outside the pos
space ...  and these ids can't be matched by the standard matching function,
so add a special registration that requests a list of pos ids or a particular
integrated function.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mca/mca-bus.c    |    9 ++++++++-
 drivers/mca/mca-driver.c |   13 +++++++++++++
 include/linux/mca.h      |    2 ++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff -puN drivers/mca/mca-bus.c~mca-add-integrated-device-bus-matching drivers/mca/mca-bus.c
--- a/drivers/mca/mca-bus.c~mca-add-integrated-device-bus-matching
+++ a/drivers/mca/mca-bus.c
@@ -59,7 +59,14 @@ static int mca_bus_match (struct device 
 			return 1;
 		}
 	}
-
+	/* If the integrated id is present, treat it as though it were an
+	 * additional id in the id_table (it can't be because by definition,
+	 * integrated id's overflow a short */
+	if (mca_drv->integrated_id && mca_dev->pos_id ==
+	    mca_drv->integrated_id) {
+		mca_dev->index = i;
+		return 1;
+	}
 	return 0;
 }
 
diff -puN drivers/mca/mca-driver.c~mca-add-integrated-device-bus-matching drivers/mca/mca-driver.c
--- a/drivers/mca/mca-driver.c~mca-add-integrated-device-bus-matching
+++ a/drivers/mca/mca-driver.c
@@ -36,12 +36,25 @@ int mca_register_driver(struct mca_drive
 		mca_drv->driver.bus = &mca_bus_type;
 		if ((r = driver_register(&mca_drv->driver)) < 0)
 			return r;
+		mca_drv->integrated_id = 0;
 	}
 
 	return 0;
 }
 EXPORT_SYMBOL(mca_register_driver);
 
+int mca_register_driver_integrated(struct mca_driver *mca_driver,
+				   int integrated_id)
+{
+	int r = mca_register_driver(mca_driver);
+
+	if (!r)
+		mca_driver->integrated_id = integrated_id;
+
+	return r;
+}
+EXPORT_SYMBOL(mca_register_driver_integrated);
+
 void mca_unregister_driver(struct mca_driver *mca_drv)
 {
 	if (MCA_bus)
diff -puN include/linux/mca.h~mca-add-integrated-device-bus-matching include/linux/mca.h
--- a/include/linux/mca.h~mca-add-integrated-device-bus-matching
+++ a/include/linux/mca.h
@@ -94,6 +94,7 @@ struct mca_bus {
 struct mca_driver {
 	const short		*id_table;
 	void			*driver_data;
+	int			integrated_id;
 	struct device_driver	driver;
 };
 #define to_mca_driver(mdriver) container_of(mdriver, struct mca_driver, driver)
@@ -125,6 +126,7 @@ extern enum MCA_AdapterStatus mca_device
 extern struct bus_type mca_bus_type;
 
 extern int mca_register_driver(struct mca_driver *drv);
+extern int mca_register_driver_integrated(struct mca_driver *, int);
 extern void mca_unregister_driver(struct mca_driver *drv);
 
 /* WARNING: only called by the boot time device setup */
_

Patches currently in -mm which might be from James.Bottomley@SteelEye.com are

origin.patch
fix--confusion-in-fusion-driver.patch
upper-32-bits.patch
