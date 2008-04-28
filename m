From: akpm@linux-foundation.org
Subject: - memory-hotplug-align-memmap-to-page-size.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:56 -0700
Message-ID: <200804282153.m3SLruuI017941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936068AbYD1VyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, pbadari@us.ibm.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: align memmap to page size
has been removed from the -mm tree.  Its filename was
     memory-hotplug-align-memmap-to-page-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: align memmap to page size
From: Yasunori Goto <y-goto@jp.fujitsu.com>

To free memmap easier, this patch aligns it to page size.  Bootmem allocater
may mix some objects in one pages.  It's not good for freeing memmap of memory
hot-remove.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/sparse.c~memory-hotplug-align-memmap-to-page-size mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-align-memmap-to-page-size
+++ a/mm/sparse.c
@@ -273,8 +273,8 @@ struct page __init *sparse_mem_map_popul
 	if (map)
 		return map;
 
-	map = alloc_bootmem_node(NODE_DATA(nid),
-			sizeof(struct page) * PAGES_PER_SECTION);
+	map = alloc_bootmem_pages_node(NODE_DATA(nid),
+		       PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION));
 	return map;
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch
powerpc-hotplug-memory-notifications-for-ppc.patch
powerpc-update-lmb-for-hotplug-memory-add-remove.patch
powerpc-provide-walk_memory_resource-for-ppc.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch

