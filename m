From: akpm@linux-foundation.org
Subject: [merged] mm-add-alloc_page_vma_node.patch removed from -mm tree
Date: Mon, 07 Mar 2011 13:31:18 -0800
Message-ID: <201103072132.p27LW1AJ028084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756199Ab1CGVdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 16:33:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: add alloc_page_vma_node()
has been removed from the -mm tree.  Its filename was
     mm-add-alloc_page_vma_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add alloc_page_vma_node()
From: Andi Kleen <ak@linux.intel.com>

Add a alloc_page_vma_node that allows passing the "local" node in.  Used
in a followon patch.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/gfp.h~mm-add-alloc_page_vma_node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-alloc_page_vma_node
+++ a/include/linux/gfp.h
@@ -343,6 +343,8 @@ extern struct page *alloc_pages_vma(gfp_
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
 	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id())
+#define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
+	alloc_pages_vma(gfp_mask, 0, vma, addr, node)
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
mm-add-__gfp_other_node-flag.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

