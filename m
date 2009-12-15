From: akpm@linux-foundation.org
Subject: [folded] hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 16:57:17 -0800
Message-ID: <200912150057.nBF0vHYC018504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758067AbZLOA6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 19:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel


The patch titled
     hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch

This patch was dropped because it was folded into hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix
From: David Rientjes <rientjes@google.com>

On Thu, 8 Oct 2009, Lee Schermerhorn wrote:

> @@ -1144,14 +1156,15 @@ static void __init report_hugepages(void
>  }
>
>  #ifdef CONFIG_HIGHMEM
> -static void try_to_free_low(struct hstate *h, unsigned long count)
> +static void try_to_free_low(struct hstate *h, unsigned long count,
> +						nodemask_t *nodes_allowed)
>  {
>  	int i;
>
>  	if (h->order >= MAX_ORDER)
>  		return;
>
> -	for (i = 0; i < MAX_NUMNODES; ++i) {
> +	for_each_node_mask(node, nodes_allowed_) {
>  		struct page *page, *next;
>  		struct list_head *freel = &h->hugepage_freelists[i];
>  		list_for_each_entry_safe(page, next, freel, lru) {

That's not looking good for i386, Andrew please fold the following into
this patch when it's merged into -mm:

[rientjes@google.com: fix HIGHMEM compile error]

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/hugetlb.c~hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix
+++ a/mm/hugetlb.c
@@ -1164,7 +1164,7 @@ static void try_to_free_low(struct hstat
 	if (h->order >= MAX_ORDER)
 		return;
 
-	for_each_node_mask(node, nodes_allowed_) {
+	for_each_node_mask(i, *nodes_allowed) {
 		struct page *page, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
 		list_for_each_entry_safe(page, next, freel, lru) {
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
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
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
mm-hugetlb-add-hugepage-support-to-pagemap-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch

