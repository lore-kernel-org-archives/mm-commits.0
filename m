From: akpm@linux-foundation.org
Subject: [folded] cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch removed from -mm tree
Date: Tue, 17 Nov 2009 14:26:05 -0800
Message-ID: <200911172226.nAHMQ5h3019710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756389AbZKQW1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Nov 2009 17:27:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, cascardo@holoscopio.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cmpc_acpi: depends on ACPI
has been removed from the -mm tree.  Its filename was
     cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch

This patch was dropped because it was folded into cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cmpc_acpi: depends on ACPI
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix about 100 build errors/warnings when ACPI is not enabled.  E.g.:

drivers/platform/x86/cmpc_acpi.c:50: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:55: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:56: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:72: warning: 'struct acpi_device' declared inside parameter list
drivers/platform/x86/cmpc_acpi.c:77: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:79: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/platform/x86/Kconfig~cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi
+++ a/drivers/platform/x86/Kconfig
@@ -438,7 +438,7 @@ config ACPI_TOSHIBA
 
 config ACPI_CMPC
 	tristate "CMPC Laptop Extras"
-	depends on X86
+	depends on X86 && ACPI
 	select INPUT
 	select BACKLIGHT_CLASS_DEVICE
 	default n
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
x86-cpufreq-dont-use-acpi_processor_get_bios_limit-when-not-available.patch
scsi-fix-func-names-in-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
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
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
docs-large-update-to-ioctl-numbertxt.patch
doc-submitchecklist-add-ioctls-remove-osdl-reference.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

