From: akpm@linux-foundation.org
Subject: + spi-add-pci-interface-driver-for-designware-spi-core-fix.patch added to -mm tree
Date: Thu, 15 Oct 2009 13:43:22 -0700
Message-ID: <200910152043.n9FKhMlX016222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758578AbZJOUoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 16:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, feng.tang@intel.com


The patch titled
     spi: fix dw_spi_pci build when CONFIG_PM=n
has been added to the -mm tree.  Its filename is
     spi-add-pci-interface-driver-for-designware-spi-core-fix.patch

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
cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
scsi-fix-func-names-in-kernel-doc.patch
pcmcia-fix-controller-printk-format-warnings.patch
ia64-sn-fix-percpu-warnings.patch
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
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

