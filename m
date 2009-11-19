From: akpm@linux-foundation.org
Subject: [obsolete] x86-cpufreq-dont-use-acpi_processor_get_bios_limit-when-not-available.patch removed from -mm tree
Date: Thu, 19 Nov 2009 13:21:49 -0800
Message-ID: <200911192121.nAJLLncv023591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754770AbZKSVWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 16:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, davej@codemonkey.org.uk, davej@redhat.com, hpa@zytor.com, mingo@redhat.com, sfr@canb.auug.org.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86/cpufreq: don't use acpi_processor_get_bios_limit when not available
has been removed from the -mm tree.  Its filename was
     x86-cpufreq-dont-use-acpi_processor_get_bios_limit-when-not-available.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86/cpufreq: don't use acpi_processor_get_bios_limit when not available
From: Randy Dunlap <randy.dunlap@oracle.com>

Only reference this function when the kconfig makes it available.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k7.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k7.c~x86-cpufreq-dont-use-acpi_processor_get_bios_limit-when-not-available arch/x86/kernel/cpu/cpufreq/powernow-k7.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c~x86-cpufreq-dont-use-acpi_processor_get_bios_limit-when-not-available
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -717,7 +717,9 @@ static struct cpufreq_driver powernow_dr
 	.verify		= powernow_verify,
 	.target		= powernow_target,
 	.get		= powernow_get,
+#ifdef CONFIG_X86_POWERNOW_K7_ACPI
 	.bios_limit	= acpi_processor_get_bios_limit,
+#endif
 	.init		= powernow_cpu_init,
 	.exit		= powernow_cpu_exit,
 	.name		= "powernow-k7",
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
hso-fix-debug-routines.patch
hso-fix-soft-lockup.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
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

