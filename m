From: akpm@linux-foundation.org
Subject: + mm-add-alloc_page_vma_node.patch added to -mm tree
Date: Fri, 04 Mar 2011 16:01:42 -0800
Message-ID: <201103050001.p2501gmO011644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760072Ab1CEABx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 19:01:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: add alloc_page_vma_node()
has been added to the -mm tree.  Its filename is
     mm-add-alloc_page_vma_node.patch

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

