From: akpm@linux-foundation.org
Subject: + mm-slab-allocate-memory-section-nodemask-for-large-systems.patch added to -mm tree
Date: Fri, 20 Nov 2009 14:15:17 -0800
Message-ID: <200911202215.nAKMFHiS019405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbZKTWPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 17:15:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, achiang@hp.com, garyhade@us.ibm.com, gregkh@suse.de, pbadari@us.ibm.com


The patch titled
     mm: slab-allocate memory section nodemask for large systems
has been added to the -mm tree.  Its filename is
     mm-slab-allocate-memory-section-nodemask-for-large-systems.patch

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
Subject: mm: slab-allocate memory section nodemask for large systems
From: David Rientjes <rientjes@google.com>

Nodemasks should not be allocated on the stack for large systems (when it
is larger than 256 bytes) since there is a threat of overflow.

This patch causes the unregister_mem_sect_under_nodes() nodemask to be
allocated on the stack for smaller systems and be allocated by slab for
larger systems.

GFP_KERNEL is used since remove_memory_block() can block.

Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/base/node.c~mm-slab-allocate-memory-section-nodemask-for-large-systems drivers/base/node.c
--- a/drivers/base/node.c~mm-slab-allocate-memory-section-nodemask-for-large-systems
+++ a/drivers/base/node.c
@@ -363,12 +363,16 @@ int register_mem_sect_under_node(struct 
 /* unregister memory section under all nodes that it spans */
 int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
 {
-	nodemask_t unlinked_nodes;
+	NODEMASK_ALLOC(nodemask_t, unlinked_nodes, GFP_KERNEL);
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
 
-	if (!mem_blk)
+	if (!mem_blk) {
+		NODEMASK_FREE(unlinked_nodes);
 		return -EFAULT;
-	nodes_clear(unlinked_nodes);
+	}
+	if (!unlinked_nodes)
+		return -ENOMEM;
+	nodes_clear(*unlinked_nodes);
 	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
@@ -379,13 +383,14 @@ int unregister_mem_sect_under_nodes(stru
 			continue;
 		if (!node_online(nid))
 			continue;
-		if (node_test_and_set(nid, unlinked_nodes))
+		if (node_test_and_set(nid, *unlinked_nodes))
 			continue;
 		sysfs_remove_link(&node_devices[nid].sysdev.kobj,
 			 kobject_name(&mem_blk->sysdev.kobj));
 		sysfs_remove_link(&mem_blk->sysdev.kobj,
 			 kobject_name(&node_devices[nid].sysdev.kobj));
 	}
+	NODEMASK_FREE(unlinked_nodes);
 	return 0;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
acpi-remove-nid_inval.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
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
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
mm-slab-allocate-memory-section-nodemask-for-large-systems.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

