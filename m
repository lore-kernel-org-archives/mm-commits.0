From: akpm@linux-foundation.org
Subject: [merged] agp-correct-missing-cleanup-on-error-in-agp_add_bridge.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:30 -0800
Message-ID: <200911201930.nAKJUUBk010824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754918AbZKTTcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:32:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjwinchester@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     agp: correct missing cleanup on error in agp_add_bridge
has been removed from the -mm tree.  Its filename was
     agp-correct-missing-cleanup-on-error-in-agp_add_bridge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: agp: correct missing cleanup on error in agp_add_bridge
From: Kevin Winchester <kjwinchester@gmail.com>

While investigating a kmemleak detected leak, I encountered the
agp_add_bridge function.  It appears to be responsible for freeing
the agp_bridge_data in the case of a failure, but it is only doing
so for some errors.

Fix it to always free the bridge data if a failure condition is
encountered.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/backend.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/char/agp/backend.c~agp-correct-missing-cleanup-on-error-in-agp_add_bridge drivers/char/agp/backend.c
--- a/drivers/char/agp/backend.c~agp-correct-missing-cleanup-on-error-in-agp_add_bridge
+++ a/drivers/char/agp/backend.c
@@ -285,18 +285,22 @@ int agp_add_bridge(struct agp_bridge_dat
 {
 	int error;
 
-	if (agp_off)
-		return -ENODEV;
+	if (agp_off) {
+		error = -ENODEV;
+		goto err_put_bridge;
+	}
 
 	if (!bridge->dev) {
 		printk (KERN_DEBUG PFX "Erk, registering with no pci_dev!\n");
-		return -EINVAL;
+		error = -EINVAL;
+		goto err_put_bridge;
 	}
 
 	/* Grab reference on the chipset driver. */
 	if (!try_module_get(bridge->driver->owner)) {
 		dev_info(&bridge->dev->dev, "can't lock chipset driver\n");
-		return -EINVAL;
+		error = -EINVAL;
+		goto err_put_bridge;
 	}
 
 	error = agp_backend_initialize(bridge);
@@ -326,6 +330,7 @@ frontend_err:
 	agp_backend_cleanup(bridge);
 err_out:
 	module_put(bridge->driver->owner);
+err_put_bridge:
 	agp_put_bridge(bridge);
 	return error;
 }
_

Patches currently in -mm which might be from kjwinchester@gmail.com are

linux-next.patch

