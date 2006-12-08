From: akpm@osdl.org
Subject: - isdn-fix-missing-unregister_capi_driver.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:44 -0800
Message-ID: <200612082010.kB8KAiNA002841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58938 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946531AbWLHUKy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, kai.germaschewski@gmx.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: fix missing unregister_capi_driver
has been removed from the -mm tree.  Its filename was
     isdn-fix-missing-unregister_capi_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isdn: fix missing unregister_capi_driver
From: Akinobu Mita <akinobu.mita@gmail.com>

unregister_capi_driver() needs to be called in module cleanup.
(It fixes data corruption by reloading t1isa driver)

Cc: Kai Germaschewski <kai.germaschewski@gmx.de>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hardware/avm/t1isa.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/isdn/hardware/avm/t1isa.c~isdn-fix-missing-unregister_capi_driver drivers/isdn/hardware/avm/t1isa.c
--- a/drivers/isdn/hardware/avm/t1isa.c~isdn-fix-missing-unregister_capi_driver
+++ a/drivers/isdn/hardware/avm/t1isa.c
@@ -584,6 +584,7 @@ static void __exit t1isa_exit(void)
 {
 	int i;
 
+	unregister_capi_driver(&capi_driver_t1isa);
 	for (i = 0; i < MAX_CARDS; i++) {
 		if (!io[i])
 			break;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
isdn-fix-missing-unregister_capi_driver.patch
fault-injection-documentation-and-scripts.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-capability-for-kmalloc.patch
fault-injection-capability-for-alloc_pages.patch
fault-injection-capability-for-disk-io.patch
fault-injection-process-filtering-for-fault-injection-capabilities.patch
fault-injection-stacktrace-filtering.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
acpi-fix-single-linked-list-manipulation.patch
acpi-processor-prevent-loading-module-on-failures.patch
git-alsa.patch
audit-fix-kstrdup-error-check.patch
drm-fix-return-value-check.patch
ata-fix-platform_device_register_simple-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
gss_spkm3-fix-error-handling-in-module-init.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch

