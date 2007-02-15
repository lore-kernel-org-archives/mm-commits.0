From: akpm@linux-foundation.org
Subject: - acpi-use-null-for-ptrs.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:58 -0800
Message-ID: <200702150850.l1F8owx3025266@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40382 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965568AbXBOIwP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: use NULL for ptrs
has been removed from the -mm tree.  Its filename was
     acpi-use-null-for-ptrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: use NULL for ptrs
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warnings in ACPI:
drivers/acpi/osl.c:208:10: warning: Using plain integer as NULL pointer
drivers/acpi/tables/tbxface.c:411:49: warning: Using plain integer as NULL pointer
drivers/acpi/processor_core.c:1008:10: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c            |    2 +-
 drivers/acpi/processor_core.c |    2 +-
 drivers/acpi/tables/tbxface.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/osl.c~acpi-use-null-for-ptrs drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~acpi-use-null-for-ptrs
+++ a/drivers/acpi/osl.c
@@ -202,7 +202,7 @@ void __iomem *acpi_os_map_memory(acpi_ph
 {
 	if (phys > ULONG_MAX) {
 		printk(KERN_ERR PREFIX "Cannot map memory that high\n");
-		return 0;
+		return NULL;
 	}
 	if (acpi_gbl_permanent_mmap)
 		/*
diff -puN drivers/acpi/processor_core.c~acpi-use-null-for-ptrs drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-use-null-for-ptrs
+++ a/drivers/acpi/processor_core.c
@@ -1006,7 +1006,7 @@ static int __init acpi_processor_init(vo
 #ifdef CONFIG_SMP
 	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
 				(struct acpi_table_header **)&madt)))
-		madt = 0;
+		madt = NULL;
 #endif
 
 	acpi_processor_dir = proc_mkdir(ACPI_PROCESSOR_CLASS, acpi_root_dir);
diff -puN drivers/acpi/tables/tbxface.c~acpi-use-null-for-ptrs drivers/acpi/tables/tbxface.c
--- a/drivers/acpi/tables/tbxface.c~acpi-use-null-for-ptrs
+++ a/drivers/acpi/tables/tbxface.c
@@ -408,7 +408,7 @@ acpi_get_table(char *signature,
 		}
 
 		if (!acpi_gbl_permanent_mmap) {
-			acpi_gbl_root_table_list.tables[i].pointer = 0;
+			acpi_gbl_root_table_list.tables[i].pointer = NULL;
 		}
 
 		return (status);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
build-errors-uevent-with-config_sysfs=n.patch
git-acpi.patch
git-drm.patch
sata-use-null-for-ptrs.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
ueagle-atmc-needs-schedh.patch
kernel-doc-include-struct-short-description-in-title.patch
tty-use-null-for-ptrs.patch
cdrom-use-unsigned-bitfields.patch
irq-kernel-doc-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
