From: akpm@linux-foundation.org
Subject: [folded] spi-add-pci-interface-driver-for-designware-spi-core-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 14:17:44 -0800
Message-ID: <200912142217.nBEMHi7k027664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932617AbZLNWRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 17:17:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, feng.tang@intel.com, mm-commits@vger.kernel.org


The patch titled
     spi: fix dw_spi_pci build when CONFIG_PM=n
has been removed from the -mm tree.  Its filename was
     spi-add-pci-interface-driver-for-designware-spi-core-fix.patch

This patch was dropped because it was folded into spi-add-pci-interface-driver-for-designware-spi-core.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: fix dw_spi_pci build when CONFIG_PM=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix names of the suspend and resume macros so that build succeeds
when CONFIG_PM=n:

drivers/spi/dw_spi_pci.c:150: error: 'spi_suspend' undeclared here (not in a function)
drivers/spi/dw_spi_pci.c:151: error: 'spi_resume' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/spi/dw_spi_pci.c~spi-add-pci-interface-driver-for-designware-spi-core-fix drivers/spi/dw_spi_pci.c
--- a/drivers/spi/dw_spi_pci.c~spi-add-pci-interface-driver-for-designware-spi-core-fix
+++ a/drivers/spi/dw_spi_pci.c
@@ -132,8 +132,8 @@ static int spi_resume(struct pci_dev *pd
 	return dw_spi_resume_host(&dwpci->dws);
 }
 #else
-#define mrst_spi_suspend	NULL
-#define mrst_spi_resume		NULL
+#define spi_suspend	NULL
+#define spi_resume	NULL
 #endif
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
hugetlb-offload-per-node-attribute-registrations-fix.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
parser-remove-unnecessary-strlen.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
readahead-add-blk_run_backing_dev.patch
spi-add-pci-interface-driver-for-designware-spi-core.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
docs-large-update-to-ioctl-numbertxt.patch
doc-submitchecklist-add-ioctls-remove-osdl-reference.patch
proc-remove-docbook-and-example.patch
seq_file-use-proc_create-in-documentation.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

