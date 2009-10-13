From: akpm@linux-foundation.org
Subject: + hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch added to -mm tree
Date: Tue, 13 Oct 2009 12:32:41 -0700
Message-ID: <200910131932.n9DJWfbJ031756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934185AbZJMTe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 15:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, randy.dunlap@oracle.com


The patch titled
     hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix
has been added to the -mm tree.  Its filename is
     hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch

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

linux-next.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
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
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

