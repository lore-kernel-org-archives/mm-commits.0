Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FD3C25B70
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjJYXrx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjJYXrv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:47:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A9D185
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB841C433C8;
        Wed, 25 Oct 2023 23:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277665;
        bh=DkZ1l/uuoDNH9Z1DFs3d03EVE0onciHhlnqIsgkI9p4=;
        h=Date:To:From:Subject:From;
        b=q7tlh6mpE8J440FzybXjRtq1QIGbK971z7UidOftBJ1v04y/cVMLQFFPYRInBOV9u
         +UdpKcmOYXs4+dQzUQWAYIpCs1uAX7IteF8uIlSqcvdcV4HYOPuk4IpNIkAvM0v7NB
         nS3+uqjR1dgajVAR1QOtUhqEUYXAUpYnX8caxChU=
Date:   Wed, 25 Oct 2023 16:47:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        usama.arif@bytedance.com, songmuchun@bytedance.com,
        senozhatsky@chromium.org, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        konradybcio@kernel.org, jthoughton@google.com,
        joao.m.martins@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, anshuman.khandual@arm.com, 21cnbao@gmail.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-batch-freeing-of-vmemmap-pages.patch removed from -mm tree
Message-Id: <20231025234745.CB841C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: batch freeing of vmemmap pages
has been removed from the -mm tree.  Its filename was
     hugetlb-batch-freeing-of-vmemmap-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: batch freeing of vmemmap pages
Date: Wed, 18 Oct 2023 19:31:07 -0700

Now that batching of hugetlb vmemmap optimization processing is possible,
batch the freeing of vmemmap pages.  When freeing vmemmap pages for a
hugetlb page, we add them to a list that is freed after the entire batch
has been processed.

This enhances the ability to return contiguous ranges of memory to the low
level allocators.

Link: https://lkml.kernel.org/r/20231019023113.345257-6-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   82 ++++++++++++++++++++++++++++-------------
 1 file changed, 56 insertions(+), 26 deletions(-)

--- a/mm/hugetlb_vmemmap.c~hugetlb-batch-freeing-of-vmemmap-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -251,7 +251,7 @@ static void vmemmap_remap_pte(pte_t *pte
 	}
 
 	entry = mk_pte(walk->reuse_page, pgprot);
-	list_add_tail(&page->lru, walk->vmemmap_pages);
+	list_add(&page->lru, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, entry);
 }
 
@@ -306,18 +306,20 @@ static void vmemmap_restore_pte(pte_t *p
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
  * @reuse:	reuse address.
+ * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
+ *		responsibility to free pages.
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      unsigned long reuse)
+			      unsigned long reuse,
+			      struct list_head *vmemmap_pages)
 {
 	int ret;
-	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
 		.reuse_addr	= reuse,
-		.vmemmap_pages	= &vmemmap_pages,
+		.vmemmap_pages	= vmemmap_pages,
 	};
 	int nid = page_to_nid((struct page *)reuse);
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
@@ -334,7 +336,7 @@ static int vmemmap_remap_free(unsigned l
 	if (walk.reuse_page) {
 		copy_page(page_to_virt(walk.reuse_page),
 			  (void *)walk.reuse_addr);
-		list_add(&walk.reuse_page->lru, &vmemmap_pages);
+		list_add(&walk.reuse_page->lru, vmemmap_pages);
 	}
 
 	/*
@@ -365,15 +367,13 @@ static int vmemmap_remap_free(unsigned l
 		walk = (struct vmemmap_remap_walk) {
 			.remap_pte	= vmemmap_restore_pte,
 			.reuse_addr	= reuse,
-			.vmemmap_pages	= &vmemmap_pages,
+			.vmemmap_pages	= vmemmap_pages,
 		};
 
 		vmemmap_remap_range(reuse, end, &walk);
 	}
 	mmap_read_unlock(&init_mm);
 
-	free_vmemmap_page_list(&vmemmap_pages);
-
 	return ret;
 }
 
@@ -389,7 +389,7 @@ static int alloc_vmemmap_page_list(unsig
 		page = alloc_pages_node(nid, gfp_mask, 0);
 		if (!page)
 			goto out;
-		list_add_tail(&page->lru, list);
+		list_add(&page->lru, list);
 	}
 
 	return 0;
@@ -577,24 +577,17 @@ static bool vmemmap_should_optimize(cons
 	return true;
 }
 
-/**
- * hugetlb_vmemmap_optimize - optimize @head page's vmemmap pages.
- * @h:		struct hstate.
- * @head:	the head page whose vmemmap pages will be optimized.
- *
- * This function only tries to optimize @head's vmemmap pages and does not
- * guarantee that the optimization will succeed after it returns. The caller
- * can use HPageVmemmapOptimized(@head) to detect if @head's vmemmap pages
- * have been optimized.
- */
-void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head)
+static int __hugetlb_vmemmap_optimize(const struct hstate *h,
+					struct page *head,
+					struct list_head *vmemmap_pages)
 {
+	int ret = 0;
 	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
 	VM_WARN_ON_ONCE(!PageHuge(head));
 	if (!vmemmap_should_optimize(h, head))
-		return;
+		return ret;
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
@@ -604,21 +597,58 @@ void hugetlb_vmemmap_optimize(const stru
 
 	/*
 	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end)
-	 * to the page which @vmemmap_reuse is mapped to, then free the pages
-	 * which the range [@vmemmap_start, @vmemmap_end] is mapped to.
+	 * to the page which @vmemmap_reuse is mapped to.  Add pages previously
+	 * mapping the range to vmemmap_pages list so that they can be freed by
+	 * the caller.
 	 */
-	if (vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse))
+	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse, vmemmap_pages);
+	if (ret)
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
 	else
 		SetHPageVmemmapOptimized(head);
+
+	return ret;
+}
+
+/**
+ * hugetlb_vmemmap_optimize - optimize @head page's vmemmap pages.
+ * @h:		struct hstate.
+ * @head:	the head page whose vmemmap pages will be optimized.
+ *
+ * This function only tries to optimize @head's vmemmap pages and does not
+ * guarantee that the optimization will succeed after it returns. The caller
+ * can use HPageVmemmapOptimized(@head) to detect if @head's vmemmap pages
+ * have been optimized.
+ */
+void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head)
+{
+	LIST_HEAD(vmemmap_pages);
+
+	__hugetlb_vmemmap_optimize(h, head, &vmemmap_pages);
+	free_vmemmap_page_list(&vmemmap_pages);
 }
 
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
 {
 	struct folio *folio;
+	LIST_HEAD(vmemmap_pages);
+
+	list_for_each_entry(folio, folio_list, lru) {
+		int ret = __hugetlb_vmemmap_optimize(h, &folio->page,
+								&vmemmap_pages);
+
+		/*
+		 * Pages to be freed may have been accumulated.  If we
+		 * encounter an ENOMEM,  free what we have and try again.
+		 */
+		if (ret == -ENOMEM && !list_empty(&vmemmap_pages)) {
+			free_vmemmap_page_list(&vmemmap_pages);
+			INIT_LIST_HEAD(&vmemmap_pages);
+			__hugetlb_vmemmap_optimize(h, &folio->page, &vmemmap_pages);
+		}
+	}
 
-	list_for_each_entry(folio, folio_list, lru)
-		hugetlb_vmemmap_optimize(h, &folio->page);
+	free_vmemmap_page_list(&vmemmap_pages);
 }
 
 static struct ctl_table hugetlb_vmemmap_sysctls[] = {
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


