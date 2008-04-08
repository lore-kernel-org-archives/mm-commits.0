From: akpm@linux-foundation.org
Subject: + memory-hotplugallocate-usemap-on-the-section-with-pgdat.patch added to -mm tree
Date: Tue, 08 Apr 2008 01:02:41 -0700
Message-ID: <200804080802.m3882f94015414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbYDHID3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 04:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, pbadari@us.ibm.com, yhlu.kernel@gmail.com


The patch titled
     memory hotplug)allocat: usemap on the section with pgdat
has been added to the -mm tree.  Its filename is
     memory-hotplugallocate-usemap-on-the-section-with-pgdat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug)allocat: usemap on the section with pgdat
From: Yasunori Goto <y-goto@jp.fujitsu.com>

Usemaps are allocated on the section which has pgdat by this.

Because usemap size is very small, many other sections usemaps are allocated
on only one page.  If a section has usemap, it can't be removed until removing
other sections.  This dependency is not desirable for memory removing.

Pgdat has similar feature.  When a section has pgdat area, it must be the last
section for removing on the node.  So, if section A has pgdat and section B
has usemap for section A, Both sections can't be removed due to dependency
each other.

To solve this issue, this patch collects usemap on same section with pgdat. 
If other sections doesn't have any dependency, this section will be able to be
removed finally.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/sparse.c~memory-hotplugallocate-usemap-on-the-section-with-pgdat mm/sparse.c
--- a/mm/sparse.c~memory-hotplugallocate-usemap-on-the-section-with-pgdat
+++ a/mm/sparse.c
@@ -239,11 +239,22 @@ static unsigned long *__kmalloc_section_
 
 static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 {
-	unsigned long *usemap;
+	unsigned long *usemap, section_nr;
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
+	struct pglist_data *pgdat = NODE_DATA(nid);
 
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	/*
+	 * Usemap's page can't be freed until freeing other sections
+	 * which use it. And, Pgdat has same feature.
+	 * If section A has pgdat and section B has usemap for other
+	 * sections (includes section A), both sections can't be removed,
+	 * because there is the dependency each other.
+	 * To solve above issue, this collects all usemap on the same section
+	 * which has pgdat.
+	 */
+	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
+	usemap = alloc_bootmem_section(usemap_size(), section_nr);
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
memory-hotplug-register-section-node-id-to-free.patch
memory-hotplug-align-memmap-to-page-size.patch
memory-hotplug-make-alloc_bootmem_section.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat.patch
memory-hotplug-free-memmaps-allocated-by-bootmem.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch

