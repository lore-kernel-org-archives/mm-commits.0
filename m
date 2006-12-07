From: akpm@osdl.org
Subject: - paride-return-proper-error-code.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:08 -0800
Message-ID: <200612072303.kB7N38IP029938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51852 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163594AbWLGXDP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, tim@cyberelk.net, mm-commits@vger.kernel.org


The patch titled
     paride: return proper error code
has been removed from the -mm tree.  Its filename was
     paride-return-proper-error-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paride: return proper error code
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch makes module init return proper value instead of -1 (-EPERM).

Cc: Tim Waugh <tim@cyberelk.net>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/paride/pcd.c |    8 ++++----
 drivers/block/paride/pf.c  |    8 ++++----
 drivers/block/paride/pg.c  |    4 ++--
 drivers/block/paride/pt.c  |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/block/paride/pcd.c~paride-return-proper-error-code drivers/block/paride/pcd.c
--- a/drivers/block/paride/pcd.c~paride-return-proper-error-code
+++ a/drivers/block/paride/pcd.c
@@ -912,12 +912,12 @@ static int __init pcd_init(void)
 	int unit;
 
 	if (disable)
-		return -1;
+		return -EINVAL;
 
 	pcd_init_units();
 
 	if (pcd_detect())
-		return -1;
+		return -ENODEV;
 
 	/* get the atapi capabilities page */
 	pcd_probe_capabilities();
@@ -925,7 +925,7 @@ static int __init pcd_init(void)
 	if (register_blkdev(major, name)) {
 		for (unit = 0, cd = pcd; unit < PCD_UNITS; unit++, cd++)
 			put_disk(cd->disk);
-		return -1;
+		return -EBUSY;
 	}
 
 	pcd_queue = blk_init_queue(do_pcd_request, &pcd_lock);
@@ -933,7 +933,7 @@ static int __init pcd_init(void)
 		unregister_blkdev(major, name);
 		for (unit = 0, cd = pcd; unit < PCD_UNITS; unit++, cd++)
 			put_disk(cd->disk);
-		return -1;
+		return -ENOMEM;
 	}
 
 	for (unit = 0, cd = pcd; unit < PCD_UNITS; unit++, cd++) {
diff -puN drivers/block/paride/pf.c~paride-return-proper-error-code drivers/block/paride/pf.c
--- a/drivers/block/paride/pf.c~paride-return-proper-error-code
+++ a/drivers/block/paride/pf.c
@@ -933,25 +933,25 @@ static int __init pf_init(void)
 	int unit;
 
 	if (disable)
-		return -1;
+		return -EINVAL;
 
 	pf_init_units();
 
 	if (pf_detect())
-		return -1;
+		return -ENODEV;
 	pf_busy = 0;
 
 	if (register_blkdev(major, name)) {
 		for (pf = units, unit = 0; unit < PF_UNITS; pf++, unit++)
 			put_disk(pf->disk);
-		return -1;
+		return -EBUSY;
 	}
 	pf_queue = blk_init_queue(do_pf_request, &pf_spin_lock);
 	if (!pf_queue) {
 		unregister_blkdev(major, name);
 		for (pf = units, unit = 0; unit < PF_UNITS; pf++, unit++)
 			put_disk(pf->disk);
-		return -1;
+		return -ENOMEM;
 	}
 
 	blk_queue_max_phys_segments(pf_queue, cluster);
diff -puN drivers/block/paride/pg.c~paride-return-proper-error-code drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c~paride-return-proper-error-code
+++ a/drivers/block/paride/pg.c
@@ -646,14 +646,14 @@ static int __init pg_init(void)
 	int err;
 
 	if (disable){
-		err = -1;
+		err = -EINVAL;
 		goto out;
 	}
 
 	pg_init_units();
 
 	if (pg_detect()) {
-		err = -1;
+		err = -ENODEV;
 		goto out;
 	}
 
diff -puN drivers/block/paride/pt.c~paride-return-proper-error-code drivers/block/paride/pt.c
--- a/drivers/block/paride/pt.c~paride-return-proper-error-code
+++ a/drivers/block/paride/pt.c
@@ -946,12 +946,12 @@ static int __init pt_init(void)
 	int err;
 
 	if (disable) {
-		err = -1;
+		err = -EINVAL;
 		goto out;
 	}
 
 	if (pt_detect()) {
-		err = -1;
+		err = -ENODEV;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
acpi-fix-single-linked-list-manipulation.patch
acpi-processor-prevent-loading-module-on-failures.patch
git-alsa.patch
audit-fix-kstrdup-error-check.patch
drm-fix-return-value-check.patch
git-input.patch
ata-fix-platform_device_register_simple-error-check.patch
git-mtd.patch
gss_spkm3-fix-error-handling-in-module-init.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
bit-revese-library.patch
crc32-replace-bitreverse-by-bitrev32.patch
video-use-bitrev8.patch
net-use-bitrev8.patch
net-use-bitrev8-tidy.patch
isdn-hisax-use-bitrev8.patch
atm-ambassador-use-bitrev8.patch
isdn-gigaset-use-bitrev8.patch
isdn-fix-missing-unregister_capi_driver.patch
fault-injection-documentation-and-scripts.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-capability-for-kmalloc.patch
fault-injection-capability-for-kmalloc-failslab-remove-__gfp_highmem-filtering.patch
fault-injection-capability-for-alloc_pages.patch
fault-injection-capability-for-disk-io.patch
fault-injection-process-filtering-for-fault-injection-capabilities.patch
fault-injection-stacktrace-filtering.patch
fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-Kconfig-cleanup-config_fault_injection-help-text.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch

