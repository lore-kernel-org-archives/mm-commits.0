From: akpm@linux-foundation.org
Subject: - memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch removed from -mm tree
Date: Sun, 06 Apr 2008 19:35:08 -0700
Message-ID: <200804070235.m372Z8Ck018341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762AbYDGCfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Apr 2008 22:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, clameter@sgi.com, pbadari@us.ibm.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: allocate usemap on the section with pgdat
has been removed from the -mm tree.  Its filename was
     memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: allocate usemap on the section with pgdat
From: Yasunori Goto <y-goto@jp.fujitsu.com>

Usemaps are allocated on the section which has pgdat by this.

Because usemap size is very small, many usemaps for sections are allocated on
only one page.  The page will be quite hard to be removed until removing all
other sections.  This dependency is not desirable for memory removing.

Pgdat has similar feature.  If sections has pgdat area, it must be the last
section for removing on the node.

This is to collect the cause pages of its dependency on one section.  If other
sections doesn't have any dependency, this section will be able to be removed
finally.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN mm/sparse.c~memory-hotplug-allocate-usemap-on-the-section-with-pgdat mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-allocate-usemap-on-the-section-with-pgdat
+++ a/mm/sparse.c
@@ -237,13 +237,23 @@ static unsigned long *__kmalloc_section_
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
+static unsigned long *__init sparse_early_usemap_alloc(int pnum)
 {
-	unsigned long *usemap;
+	unsigned long *usemap, section_nr;
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
+	struct pglist_data *pgdat = NODE_DATA(nid);
+
+	/*
+	 * This is allocated on same section of pgdat.
+	 * It will not be freed until other sections hot-removing on the node.
+	 * Pgdat has same feature. This collects all usemap on the same
+	 * section.
+	 */
+
+	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
+	usemap = alloc_bootmem_section(usemap_size(), section_nr);
 
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
 	if (usemap)
 		return usemap;
 
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

hotplug-memory-remove-generic-__remove_pages-support.patch
powerpc-hotplug-memory-notifications-for-ppc.patch
powerpc-update-lmb-for-hotplug-memory-add-remove.patch
powerpc-provide-walk_memory_resource-for-ppc.patch
block-fix-memory-hotplug-and-bouncing-in-block-layer.patch
mm-make-mem_map-allocation-continuous-v2.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch
memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch
memory-hotplug-free-memmaps-allocated-by-bootmem.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch

