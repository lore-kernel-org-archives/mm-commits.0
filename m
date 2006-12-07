From: akpm@osdl.org
Subject: - spi-check-platform_device_register_simple-error.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:34 -0800
Message-ID: <200612072307.kB7N7YVd030370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52809 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163941AbWLGXHn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: check platform_device_register_simple() error
has been removed from the -mm tree.  Its filename was
     spi-check-platform_device_register_simple-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: check platform_device_register_simple() error
From: Akinobu Mita <akinobu.mita@gmail.com>

Check the return value of platform_device_register_simple().

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/spi_butterfly.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/spi/spi_butterfly.c~spi-check-platform_device_register_simple-error drivers/spi/spi_butterfly.c
--- a/drivers/spi/spi_butterfly.c~spi-check-platform_device_register_simple-error
+++ a/drivers/spi/spi_butterfly.c
@@ -251,6 +251,8 @@ static void butterfly_attach(struct parp
 	 * setting up a platform device like this is an ugly kluge...
 	 */
 	pdev = platform_device_register_simple("butterfly", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return;
 
 	master = spi_alloc_master(&pdev->dev, sizeof *pp);
 	if (!master) {
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

