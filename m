From: akpm@linux-foundation.org
Subject: [nacked] drm-vmwgfx-use-ida_simple_get-for-id-allocation.patch removed from -mm tree
Date: Fri, 02 Sep 2011 17:10:45 -0700
Message-ID: <201109030010.p830AjKM018605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011Ab1ICALJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 20:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jic23@cam.ac.uk, James.Bottomley@HansenPartnership.com, airlied@linux.ie, guenter.roeck@ericsson.com, rusty@rustcorp.com.au, thellstrom@vmware.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drm/vmwgfx: use ida_simple_get() for id allocation
has been removed from the -mm tree.  Its filename was
     drm-vmwgfx-use-ida_simple_get-for-id-allocation.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/vmwgfx: use ida_simple_get() for id allocation
From: Jonathan Cameron <jic23@cam.ac.uk>

Some messing with error codes to return 0 on out id's and match
current situation.  Is this necessary? Looks a touch 'interesting'.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c |   34 +++-------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff -puN drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c~drm-vmwgfx-use-ida_simple_get-for-id-allocation drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c~drm-vmwgfx-use-ida_simple_get-for-id-allocation
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
@@ -37,7 +37,6 @@
 #include <linux/kernel.h>
 
 struct vmwgfx_gmrid_man {
-	spinlock_t lock;
 	struct ida gmr_ida;
 	uint32_t max_gmr_ids;
 };
@@ -49,34 +48,20 @@ static int vmw_gmrid_man_get_node(struct
 {
 	struct vmwgfx_gmrid_man *gman =
 		(struct vmwgfx_gmrid_man *)man->priv;
-	int ret;
 	int id;
 
 	mem->mm_node = NULL;
 
-	do {
-		if (unlikely(ida_pre_get(&gman->gmr_ida, GFP_KERNEL) == 0))
-			return -ENOMEM;
-
-		spin_lock(&gman->lock);
-		ret = ida_get_new(&gman->gmr_ida, &id);
-
-		if (unlikely(ret == 0 && id >= gman->max_gmr_ids)) {
-			ida_remove(&gman->gmr_ida, id);
-			spin_unlock(&gman->lock);
+	id = ida_simple_get(&gman->gmr_ida, 0, gman->max_gmr_ids, GFP_KERNEL);
+	if (id < 0) {
+		if (id == -ENOSPC)
 			return 0;
-		}
-
-		spin_unlock(&gman->lock);
-
-	} while (ret == -EAGAIN);
-
-	if (likely(ret == 0)) {
-		mem->mm_node = gman;
-		mem->start = id;
+		return id;
 	}
+	mem->mm_node = gman;
+	mem->start = id;
 
-	return ret;
+	return 0;
 }
 
 static void vmw_gmrid_man_put_node(struct ttm_mem_type_manager *man,
@@ -86,9 +71,7 @@ static void vmw_gmrid_man_put_node(struc
 		(struct vmwgfx_gmrid_man *)man->priv;
 
 	if (mem->mm_node) {
-		spin_lock(&gman->lock);
-		ida_remove(&gman->gmr_ida, mem->start);
-		spin_unlock(&gman->lock);
+		ida_simple_remove(&gman->gmr_ida, mem->start);
 		mem->mm_node = NULL;
 	}
 }
@@ -102,7 +85,6 @@ static int vmw_gmrid_man_init(struct ttm
 	if (unlikely(gman == NULL))
 		return -ENOMEM;
 
-	spin_lock_init(&gman->lock);
 	ida_init(&gman->gmr_ida);
 	gman->max_gmr_ids = p_size;
 	man->priv = (void *) gman;
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

linux-next.patch
hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch
drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch
drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch

