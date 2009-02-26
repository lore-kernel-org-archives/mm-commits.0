From: akpm@linux-foundation.org
Subject: [merged] driver-core-remove-polling-for-driver_probe_donev5.patch removed from -mm tree
Date: Thu, 26 Feb 2009 11:30:24 -0800
Message-ID: <200902261930.n1QJUOu1014416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbZBZTak (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 14:30:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom.leiming@gmail.com, arjan@linux.intel.com, cornelia.huck@de.ibm.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     driver core: remove polling for driver_probe_done(v5)
has been removed from the -mm tree.  Its filename was
     driver-core-remove-polling-for-driver_probe_donev5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver core: remove polling for driver_probe_done(v5)
From: Ming Lei <tom.leiming@gmail.com>

Remove the 100ms polling for driver_probe_done in wait_for_device_probe(),
and uses wait_event() instead.  Removing polling in fs initialization may
lead to a faster boot.

This patch also changes the return type of wait_for_device_done() from int
to void.

This patch is against Arjan's patch in linux-next tree.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dd.c      |    8 ++------
 include/linux/device.h |    2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/base/dd.c~driver-core-remove-polling-for-driver_probe_donev5 drivers/base/dd.c
--- a/drivers/base/dd.c~driver-core-remove-polling-for-driver_probe_donev5
+++ a/drivers/base/dd.c
@@ -172,16 +172,12 @@ int driver_probe_done(void)
 /**
  * wait_for_device_probe
  * Wait for device probing to be completed.
- *
- * Note: this function polls at 100 msec intervals.
  */
-int wait_for_device_probe(void)
+void wait_for_device_probe(void)
 {
 	/* wait for the known devices to complete their probing */
-	while (driver_probe_done() != 0)
-		msleep(100);
+	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
 	async_synchronize_full();
-	return 0;
 }
 
 /**
diff -puN include/linux/device.h~driver-core-remove-polling-for-driver_probe_donev5 include/linux/device.h
--- a/include/linux/device.h~driver-core-remove-polling-for-driver_probe_donev5
+++ a/include/linux/device.h
@@ -148,7 +148,7 @@ extern void put_driver(struct device_dri
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
-extern int wait_for_device_probe(void);
+extern void wait_for_device_probe(void);
 
 
 /* sysfs interface for exporting driver attributes */
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

linux-next.patch

