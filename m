From: akpm@linux-foundation.org
Subject: [merged] mmc-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:45 -0800
Message-ID: <20130228201445.9D99931C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:64467 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3B1UOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:46 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so244942ghb.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cjb@laptop.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mmc: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     mmc-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mmc: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/host.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/core/host.c~mmc-convert-to-idr_alloc drivers/mmc/core/host.c
--- a/drivers/mmc/core/host.c~mmc-convert-to-idr_alloc
+++ a/drivers/mmc/core/host.c
@@ -429,19 +429,20 @@ struct mmc_host *mmc_alloc_host(int extr
 	int err;
 	struct mmc_host *host;
 
-	if (!idr_pre_get(&mmc_host_idr, GFP_KERNEL))
-		return NULL;
-
 	host = kzalloc(sizeof(struct mmc_host) + extra, GFP_KERNEL);
 	if (!host)
 		return NULL;
 
 	/* scanning will be enabled when we're ready */
 	host->rescan_disable = 1;
+	idr_preload(GFP_KERNEL);
 	spin_lock(&mmc_host_lock);
-	err = idr_get_new(&mmc_host_idr, host, &host->index);
+	err = idr_alloc(&mmc_host_idr, host, 0, 0, GFP_NOWAIT);
+	if (err >= 0)
+		host->index = err;
 	spin_unlock(&mmc_host_lock);
-	if (err)
+	idr_preload_end();
+	if (err < 0)
 		goto free;
 
 	dev_set_name(&host->class_dev, "mmc%d", host->index);
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

