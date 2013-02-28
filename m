From: akpm@linux-foundation.org
Subject: [merged] misc-c2port-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:39 -0800
Message-ID: <20130228201439.A5F1A5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:62726 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3B1UOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:40 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so261367qah.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, arnd@arndb.de, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     Subject: misc/c2port: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     misc-c2port-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: misc/c2port: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/core.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN drivers/misc/c2port/core.c~misc-c2port-convert-to-idr_alloc drivers/misc/c2port/core.c
--- a/drivers/misc/c2port/core.c~misc-c2port-convert-to-idr_alloc
+++ a/drivers/misc/c2port/core.c
@@ -885,7 +885,7 @@ struct c2port_device *c2port_device_regi
 					struct c2port_ops *ops, void *devdata)
 {
 	struct c2port_device *c2dev;
-	int id, ret;
+	int ret;
 
 	if (unlikely(!ops) || unlikely(!ops->access) || \
 		unlikely(!ops->c2d_dir) || unlikely(!ops->c2ck_set) || \
@@ -897,22 +897,18 @@ struct c2port_device *c2port_device_regi
 	if (unlikely(!c2dev))
 		return ERR_PTR(-ENOMEM);
 
-	ret = idr_pre_get(&c2port_idr, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
-		goto error_idr_get_new;
-	}
-
+	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&c2port_idr_lock);
-	ret = idr_get_new(&c2port_idr, c2dev, &id);
+	ret = idr_alloc(&c2port_idr, c2dev, 0, 0, GFP_NOWAIT);
 	spin_unlock_irq(&c2port_idr_lock);
+	idr_preload_end();
 
 	if (ret < 0)
-		goto error_idr_get_new;
-	c2dev->id = id;
+		goto error_idr_alloc;
+	c2dev->id = ret;
 
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
-					"c2port%d", id);
+				   "c2port%d", c2dev->id);
 	if (unlikely(IS_ERR(c2dev->dev))) {
 		ret = PTR_ERR(c2dev->dev);
 		goto error_device_create;
@@ -946,10 +942,10 @@ error_device_create_bin_file:
 
 error_device_create:
 	spin_lock_irq(&c2port_idr_lock);
-	idr_remove(&c2port_idr, id);
+	idr_remove(&c2port_idr, c2dev->id);
 	spin_unlock_irq(&c2port_idr_lock);
 
-error_idr_get_new:
+error_idr_alloc:
 	kfree(c2dev);
 
 	return ERR_PTR(ret);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

