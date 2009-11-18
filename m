From: akpm@linux-foundation.org
Subject: + acpi-get_bios_limit-static-inline-when-cpu_freq=n.patch added to -mm tree
Date: Wed, 18 Nov 2009 14:00:47 -0800
Message-ID: <200911182200.nAIM0lRF023894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbZKRWBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Nov 2009 17:01:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, lenb@kernel.org


The patch titled
     acpi: get_bios_limit static inline when CPU_FREQ=n
has been added to the -mm tree.  Its filename is
     acpi-get_bios_limit-static-inline-when-cpu_freq=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: get_bios_limit static inline when CPU_FREQ=n
From: Randy Dunlap <randy.dunlap@oracle.com>

For CONFIG_CPU_FREQ=n, make acpi_processor_get_bios_limit() static inline
so that multiple source files that use this header file do not create
multiple definitions of the function.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/acpi/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/acpi/processor.h~acpi-get_bios_limit-static-inline-when-cpu_freq=n include/acpi/processor.h
--- a/include/acpi/processor.h~acpi-get_bios_limit-static-inline-when-cpu_freq=n
+++ a/include/acpi/processor.h
@@ -318,7 +318,7 @@ static inline int acpi_processor_ppc_has
 	}
 	return 0;
 }
-int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
+static inline int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
 {
 	return -ENODEV;
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
hso-fix-debug-routines.patch
hso-fix-soft-lockup.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
acpi-get_bios_limit-static-inline-when-cpu_freq=n.patch
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
partitions-use-sector-size-for-efi-gpt-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

