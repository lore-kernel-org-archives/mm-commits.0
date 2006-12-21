From: akpm@osdl.org
Subject: - acpi-processor-prevent-loading-module-on-failures.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:11 -0800
Message-ID: <200612210036.kBL0aBeO011171@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53221 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161091AbWLUAgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:36:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi/processor: prevent loading module on failures
has been removed from the -mm tree.  Its filename was
     acpi-processor-prevent-loading-module-on-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi/processor: prevent loading module on failures
From: Akinobu Mita <akinobu.mita@gmail.com>

Make loading processor.ko fail when an error happens.

Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/processor_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/processor_core.c~acpi-processor-prevent-loading-module-on-failures drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-processor-prevent-loading-module-on-failures
+++ a/drivers/acpi/processor_core.c
@@ -901,13 +901,13 @@ static int __init acpi_processor_init(vo
 
 	acpi_processor_dir = proc_mkdir(ACPI_PROCESSOR_CLASS, acpi_root_dir);
 	if (!acpi_processor_dir)
-		return 0;
+		return -ENOMEM;
 	acpi_processor_dir->owner = THIS_MODULE;
 
 	result = acpi_bus_register_driver(&acpi_processor_driver);
 	if (result < 0) {
 		remove_proc_entry(ACPI_PROCESSOR_CLASS, acpi_root_dir);
-		return 0;
+		return result;
 	}
 
 	acpi_processor_install_hotplug_notify();
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
audit-fix-kstrdup-error-check.patch
gss_spkm3-fix-error-handling-in-module-init.patch
git-acpi.patch
git-alsa.patch
git-drm.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

