From: akpm@linux-foundation.org
Subject: [merged] rpmsg-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:06 -0800
Message-ID: <20130228201506.9B01231C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:37536 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab3B1UPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:07 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so261427qah.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ohad@wizery.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rpmsg: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     rpmsg-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: rpmsg: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rpmsg/virtio_rpmsg_bus.c |   30 +++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff -puN drivers/rpmsg/virtio_rpmsg_bus.c~rpmsg-convert-to-idr_alloc drivers/rpmsg/virtio_rpmsg_bus.c
--- a/drivers/rpmsg/virtio_rpmsg_bus.c~rpmsg-convert-to-idr_alloc
+++ a/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -213,13 +213,10 @@ static struct rpmsg_endpoint *__rpmsg_cr
 		struct rpmsg_channel *rpdev, rpmsg_rx_cb_t cb,
 		void *priv, u32 addr)
 {
-	int err, tmpaddr, request;
+	int id_min, id_max, id;
 	struct rpmsg_endpoint *ept;
 	struct device *dev = rpdev ? &rpdev->dev : &vrp->vdev->dev;
 
-	if (!idr_pre_get(&vrp->endpoints, GFP_KERNEL))
-		return NULL;
-
 	ept = kzalloc(sizeof(*ept), GFP_KERNEL);
 	if (!ept) {
 		dev_err(dev, "failed to kzalloc a new ept\n");
@@ -234,31 +231,28 @@ static struct rpmsg_endpoint *__rpmsg_cr
 	ept->priv = priv;
 
 	/* do we need to allocate a local address ? */
-	request = addr == RPMSG_ADDR_ANY ? RPMSG_RESERVED_ADDRESSES : addr;
+	if (addr == RPMSG_ADDR_ANY) {
+		id_min = RPMSG_RESERVED_ADDRESSES;
+		id_max = 0;
+	} else {
+		id_min = addr;
+		id_max = addr + 1;
+	}
 
 	mutex_lock(&vrp->endpoints_lock);
 
 	/* bind the endpoint to an rpmsg address (and allocate one if needed) */
-	err = idr_get_new_above(&vrp->endpoints, ept, request, &tmpaddr);
-	if (err) {
-		dev_err(dev, "idr_get_new_above failed: %d\n", err);
+	id = idr_alloc(&vrp->endpoints, ept, id_min, id_max, GFP_KERNEL);
+	if (id < 0) {
+		dev_err(dev, "idr_alloc failed: %d\n", id);
 		goto free_ept;
 	}
-
-	/* make sure the user's address request is fulfilled, if relevant */
-	if (addr != RPMSG_ADDR_ANY && tmpaddr != addr) {
-		dev_err(dev, "address 0x%x already in use\n", addr);
-		goto rem_idr;
-	}
-
-	ept->addr = tmpaddr;
+	ept->addr = id;
 
 	mutex_unlock(&vrp->endpoints_lock);
 
 	return ept;
 
-rem_idr:
-	idr_remove(&vrp->endpoints, request);
 free_ept:
 	mutex_unlock(&vrp->endpoints_lock);
 	kref_put(&ept->refcount, __ept_release);
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

