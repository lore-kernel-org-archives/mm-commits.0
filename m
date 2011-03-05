From: akpm@linux-foundation.org
Subject: + mm-preserve-original-node-for-transparent-huge-page-copies.patch added to -mm tree
Date: Fri, 04 Mar 2011 16:01:44 -0800
Message-ID: <201103050001.p2501id7011650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760072Ab1CEABz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 19:01:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: preserve original node for transparent huge page copies
has been added to the -mm tree.  Its filename is
     mm-preserve-original-node-for-transparent-huge-page-copies.patch

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
Subject: mm: preserve original node for transparent huge page copies
From: Andi Kleen <ak@linux.intel.com>

This makes a difference for LOCAL policy, where the node cannot be
determined from the policy itself, but has to be gotten from the original
page.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-preserve-original-node-for-transparent-huge-page-copies mm/huge_memory.c
--- a/mm/huge_memory.c~mm-preserve-original-node-for-transparent-huge-page-copies
+++ a/mm/huge_memory.c
@@ -799,8 +799,8 @@ static int do_huge_pmd_wp_page_fallback(
 	}
 
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		pages[i] = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
-					  vma, address);
+		pages[i] = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE,
+					       vma, address, page_to_nid(page));
 		if (unlikely(!pages[i] ||
 			     mem_cgroup_newpage_charge(pages[i], mm,
 						       GFP_KERNEL))) {
_

Patches currently in -mm which might be from ak@linux.intel.com are

mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy.patch
mm-add-alloc_page_vma_node.patch
mm-preserve-original-node-for-transparent-huge-page-copies.patch
mm-use-correct-numa-policy-node-for-transparent-hugepages.patch
linux-next.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

