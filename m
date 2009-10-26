From: akpm@linux-foundation.org
Subject: [merged] ia64-sn-fix-percpu-warnings.patch removed from -mm tree
Date: Mon, 26 Oct 2009 15:23:33 -0700
Message-ID: <200910262223.n9QMNX4X011099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058AbZJZWYe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Oct 2009 18:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jes@sgi.com, tj@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64/sn: fix percpu warnings
has been removed from the -mm tree.  Its filename was
     ia64-sn-fix-percpu-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64/sn: fix percpu warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix percpu types warning in ia64/sn:

arch/ia64/sn/kernel/setup.c:74: error: conflicting types for '__pcpu_scope___sn_cnodeid_to_nasid'
arch/ia64/include/asm/sn/arch.h:74: error: previous declaration of '__pcpu_scope___sn_cnodeid_to_nasid' was here

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jes Sorensen <jes@sgi.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/ia64/include/asm/sn/arch.h~ia64-sn-fix-percpu-warnings arch/ia64/include/asm/sn/arch.h
--- a/arch/ia64/include/asm/sn/arch.h~ia64-sn-fix-percpu-warnings
+++ a/arch/ia64/include/asm/sn/arch.h
@@ -71,7 +71,7 @@ DECLARE_PER_CPU(struct sn_hub_info_s, __
  * Compact node ID to nasid mappings kept in the per-cpu data areas of each
  * cpu.
  */
-DECLARE_PER_CPU(short, __sn_cnodeid_to_nasid[MAX_COMPACT_NODES]);
+DECLARE_PER_CPU(short [MAX_COMPACT_NODES], __sn_cnodeid_to_nasid);
 #define sn_cnodeid_to_nasid	(&__get_cpu_var(__sn_cnodeid_to_nasid[0]))
 
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
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
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

