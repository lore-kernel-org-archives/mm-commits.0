From: akpm@linux-foundation.org
Subject: [to-be-updated] thp-fix-interleaving-for-transparent-hugepages.patch removed from -mm tree
Date: Wed, 23 Feb 2011 16:39:57 -0800
Message-ID: <201102240039.p1O0dvi1001719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab1BXAkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, aarcange@redhat.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     thp: fix interleaving for transparent hugepages
has been removed from the -mm tree.  Its filename was
     thp-fix-interleaving-for-transparent-hugepages.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: fix interleaving for transparent hugepages
From: Andi Kleen <ak@linux.intel.com>

The THP code didn't pass the correct interleaving shift to the memory
policy code. Fix this here by adjusting for the order.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~thp-fix-interleaving-for-transparent-hugepages mm/mempolicy.c
--- a/mm/mempolicy.c~thp-fix-interleaving-for-transparent-hugepages
+++ a/mm/mempolicy.c
@@ -1830,7 +1830,7 @@ alloc_pages_vma(gfp_t gfp, int order, st
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
 
-		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
+		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT << order);
 		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
 		put_mems_allowed();
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
fix-interleaving-for-transparent-hugepages-v2.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
llist-lib-add-lock-less-null-terminated-single-list.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

