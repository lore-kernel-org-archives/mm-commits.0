Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B797ACD37B4
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 23:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbjIOX2P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 19:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237487AbjIOX1q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 19:27:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599B01FDE
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 16:27:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A47C433C8;
        Fri, 15 Sep 2023 23:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694820461;
        bh=PF+sa5Q5Db9jGEyG9Lb8kvGfrqNL0jBQK2ShBUt5Hwc=;
        h=Date:To:From:Subject:From;
        b=IBQWtREiWGZyiIcILDmRWFnQzDFPA1iIJWyZX1jWZFhgT2SUCGAJS126GeogVkvg7
         htOjONOpCKjn6ctU+dZ0urWxeEYz5uSfUlOjdy+WkgdKifEvVgwbcizOUyO9HCecld
         FXi/Q+wGSIasPBkVXHLjrrTEIc5Ac2FqJtaKSmjM=
Date:   Fri, 15 Sep 2023 16:27:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        rientjes@google.com, osalvador@suse.de, naoya.horiguchi@linux.dev,
        mike.kravetz@oracle.com, mhocko@suse.com, linmiaohe@huawei.com,
        jthoughton@google.com, duanxiongchun@bytedance.com,
        david@redhat.com, anshuman.khandual@arm.com,
        joao.m.martins@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-batch-tlb-flushes-when-freeing-vmemmap.patch added to mm-unstable branch
Message-Id: <20230915232740.E8A47C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: batch TLB flushes when freeing vmemmap
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-batch-tlb-flushes-when-freeing-vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-batch-tlb-flushes-when-freeing-vmemmap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: hugetlb: batch TLB flushes when freeing vmemmap
Date: Fri, 15 Sep 2023 15:15:44 -0700

Now that a list of pages is deduplicated at once, the TLB flush can be
batched for all vmemmap pages that got remapped.

Expand the flags field value to pass whether to skip the TLB flush on
remap of the PTE.

The TLB flush is global as we don't have guarantees from caller that the
set of folios is contiguous, or to add complexity in composing a list of
kVAs to flush.

Modified by Mike Kravetz to perform TLB flush on single folio if an
error is encountered.

Link: https://lkml.kernel.org/r/20230915221548.552084-12-mike.kravetz@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   44 ++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

--- a/mm/hugetlb_vmemmap.c~hugetlb-batch-tlb-flushes-when-freeing-vmemmap
+++ a/mm/hugetlb_vmemmap.c
@@ -37,6 +37,7 @@ struct vmemmap_remap_walk {
 	unsigned long		reuse_addr;
 	struct list_head	*vmemmap_pages;
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
+#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
 	unsigned long		flags;
 };
 
@@ -211,7 +212,7 @@ static int vmemmap_remap_range(unsigned
 			return ret;
 	} while (pgd++, addr = next, addr != end);
 
-	if (walk->remap_pte)
+	if (walk->remap_pte && !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
 		flush_tlb_kernel_range(start, end);
 
 	return 0;
@@ -355,19 +356,21 @@ static int vmemmap_remap_split(unsigned
  * @reuse:	reuse address.
  * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
  *		responsibility to free pages.
+ * @flags:	modifications to vmemmap_remap_walk flags
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
 			      unsigned long reuse,
-			      struct list_head *vmemmap_pages)
+			      struct list_head *vmemmap_pages,
+			      unsigned long flags)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
 		.reuse_addr	= reuse,
 		.vmemmap_pages	= vmemmap_pages,
-		.flags		= 0,
+		.flags		= flags,
 	};
 	int nid = page_to_nid((struct page *)reuse);
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
@@ -628,7 +631,8 @@ static bool vmemmap_should_optimize(cons
 
 static int __hugetlb_vmemmap_optimize(const struct hstate *h,
 					struct page *head,
-					struct list_head *vmemmap_pages)
+					struct list_head *vmemmap_pages,
+					unsigned long flags)
 {
 	int ret = 0;
 	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
@@ -639,6 +643,18 @@ static int __hugetlb_vmemmap_optimize(co
 		return ret;
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
+	/*
+	 * Very Subtle
+	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
+	 * immediately after remapping.  As a result, subsequent accesses
+	 * and modifications to struct pages associated with the hugetlb
+	 * page could be to the OLD struct pages.  Set the vmemmap optimized
+	 * flag here so that it is copied to the new head page.  This keeps
+	 * the old and new struct pages in sync.
+	 * If there is an error during optimization, we will immediately FLUSH
+	 * the TLB and clear the flag below.
+	 */
+	SetHPageVmemmapOptimized(head);
 
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 	vmemmap_reuse	= vmemmap_start;
@@ -650,11 +666,12 @@ static int __hugetlb_vmemmap_optimize(co
 	 * mapping the range to vmemmap_pages list so that they can be freed by
 	 * the caller.
 	 */
-	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse, vmemmap_pages);
-	if (ret)
+	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse,
+							vmemmap_pages, flags);
+	if (ret) {
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
-	else
-		SetHPageVmemmapOptimized(head);
+		ClearHPageVmemmapOptimized(head);
+	}
 
 	return ret;
 }
@@ -673,7 +690,7 @@ void hugetlb_vmemmap_optimize(const stru
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize(h, head, &vmemmap_pages);
+	__hugetlb_vmemmap_optimize(h, head, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -708,19 +725,24 @@ void hugetlb_vmemmap_optimize_folios(str
 
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret = __hugetlb_vmemmap_optimize(h, &folio->page,
-								&vmemmap_pages);
+						&vmemmap_pages,
+						VMEMMAP_REMAP_NO_TLB_FLUSH);
 
 		/*
 		 * Pages may have been accumulated, thus free what we have
 		 * and try again.
 		 */
 		if (ret == -ENOMEM) {
+			flush_tlb_all();
 			free_vmemmap_page_list(&vmemmap_pages);
 			INIT_LIST_HEAD(&vmemmap_pages);
-			__hugetlb_vmemmap_optimize(h, &folio->page, &vmemmap_pages);
+			__hugetlb_vmemmap_optimize(h, &folio->page,
+						&vmemmap_pages,
+						VMEMMAP_REMAP_NO_TLB_FLUSH);
 		}
 	}
 
+	flush_tlb_all();
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

hugetlb-batch-pmd-split-for-bulk-vmemmap-dedup.patch
hugetlb-batch-tlb-flushes-when-freeing-vmemmap.patch

