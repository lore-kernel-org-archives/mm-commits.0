From: akpm@linux-foundation.org
Subject: [merged] mfd-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:36 -0800
Message-ID: <20130228201436.9A8CC5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:48991 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3B1UOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:37 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so261358qah.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mfd: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     mfd-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mfd: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/rtsx_pcr.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/mfd/rtsx_pcr.c~mfd-convert-to-idr_alloc drivers/mfd/rtsx_pcr.c
--- a/drivers/mfd/rtsx_pcr.c~mfd-convert-to-idr_alloc
+++ a/drivers/mfd/rtsx_pcr.c
@@ -1091,15 +1091,14 @@ static int rtsx_pci_probe(struct pci_dev
 	}
 	handle->pcr = pcr;
 
-	if (!idr_pre_get(&rtsx_pci_idr, GFP_KERNEL)) {
-		ret = -ENOMEM;
-		goto free_handle;
-	}
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&rtsx_pci_lock);
-	ret = idr_get_new(&rtsx_pci_idr, pcr, &pcr->id);
+	ret = idr_alloc(&rtsx_pci_idr, pcr, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		pcr->id = ret;
 	spin_unlock(&rtsx_pci_lock);
-	if (ret)
+	idr_preload_end();
+	if (ret < 0)
 		goto free_handle;
 
 	pcr->pci = pcidev;
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

