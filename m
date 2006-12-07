From: akpm@osdl.org
Subject: - futex-init-error-check.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:29 -0800
Message-ID: <200612072307.kB7N7THn030366@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52805 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163941AbWLGXHl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     futex: init error check
has been removed from the -mm tree.  Its filename was
     futex-init-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: futex: init error check
From: Akinobu Mita <akinobu.mita@gmail.com>

Check register_filesystem() and kern_mount() return values.

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/futex.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/futex.c~futex-init-error-check kernel/futex.c
--- a/kernel/futex.c~futex-init-error-check
+++ a/kernel/futex.c
@@ -1857,10 +1857,16 @@ static struct file_system_type futex_fs_
 
 static int __init init(void)
 {
-	unsigned int i;
+	int i = register_filesystem(&futex_fs_type);
+
+	if (i)
+		return i;
 
-	register_filesystem(&futex_fs_type);
 	futex_mnt = kern_mount(&futex_fs_type);
+	if (IS_ERR(futex_mnt)) {
+		unregister_filesystem(&futex_fs_type);
+		return PTR_ERR(futex_mnt);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
 		INIT_LIST_HEAD(&futex_queues[i].chain);
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

