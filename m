From: akpm@linux-foundation.org
Subject: [merged] dca-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:27 -0800
Message-ID: <20130228201327.B39955A4242@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:44252 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3B1UN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:29 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244814vch.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, maciej.sosnowski@intel.com, paul.gortmaker@windriver.com, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dca: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     dca-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dca: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dca/dca-sysfs.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN drivers/dca/dca-sysfs.c~dca-convert-to-idr_alloc drivers/dca/dca-sysfs.c
--- a/drivers/dca/dca-sysfs.c~dca-convert-to-idr_alloc
+++ a/drivers/dca/dca-sysfs.c
@@ -53,22 +53,19 @@ void dca_sysfs_remove_req(struct dca_pro
 int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev)
 {
 	struct device *cd;
-	int err = 0;
+	int ret;
 
-idr_try_again:
-	if (!idr_pre_get(&dca_idr, GFP_KERNEL))
-		return -ENOMEM;
+	idr_preload(GFP_KERNEL);
 	spin_lock(&dca_idr_lock);
-	err = idr_get_new(&dca_idr, dca, &dca->id);
+
+	ret = idr_alloc(&dca_idr, dca, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		dca->id = ret;
+
 	spin_unlock(&dca_idr_lock);
-	switch (err) {
-	case 0:
-		break;
-	case -EAGAIN:
-		goto idr_try_again;
-	default:
-		return err;
-	}
+	idr_preload_end();
+	if (ret < 0)
+		return ret;
 
 	cd = device_create(dca_class, dev, MKDEV(0, 0), NULL, "dca%d", dca->id);
 	if (IS_ERR(cd)) {
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

