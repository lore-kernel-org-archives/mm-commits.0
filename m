From: akpm@linux-foundation.org
Subject: [merged] mm-slab-allocate-memory-section-nodemask-for-large-systems.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:13 -0800
Message-ID: <200912152154.nBFLsDO8015341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761366AbZLOWQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, achiang@hp.com, garyhade@us.ibm.com, gregkh@suse.de, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: slab-allocate memory section nodemask for large systems
has been removed from the -mm tree.  Its filename was
     mm-slab-allocate-memory-section-nodemask-for-large-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
acpi-remove-nid_inval.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

