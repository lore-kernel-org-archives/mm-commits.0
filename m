Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07878C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjJYXry (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjJYXrv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:47:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B31189
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D544BC433CD;
        Wed, 25 Oct 2023 23:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277668;
        bh=O5h7hze0PeIbq7AnxrRtq2jcUnrz/s2y4WxKmbcXsag=;
        h=Date:To:From:Subject:From;
        b=GHD/WdjGqqj+XwD6DswxaHOrbDUp0XbqyTVVk4/KUDk608NFhFaNAPs7M5q5UWpHE
         R37Xw2QQk5F/a7p+QaH6DWDfYU+SmWMyEJs2s1dfXbsAJf0R2jlq8BxzE8X7OcCOvP
         RckinHqvIlnTaIU4F3OTLhDtYUbWqYk6JCjAb+uY=
Date:   Wed, 25 Oct 2023 16:47:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        usama.arif@bytedance.com, songmuchun@bytedance.com,
        senozhatsky@chromium.org, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        konradybcio@kernel.org, jthoughton@google.com,
        joao.m.martins@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, anshuman.khandual@arm.com, 21cnbao@gmail.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch removed from -mm tree
Message-Id: <20231025234748.D544BC433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: batch TLB flushes when restoring vmemmap
has been removed from the -mm tree.  Its filename was
     hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: batch TLB flushes when restoring vmemmap
Date: Wed, 18 Oct 2023 19:31:10 -0700

Update the internal hugetlb restore vmemmap code path such that TLB
flushing can be batched.  Use the existing mechanism of passing the
VMEMMAP_REMAP_NO_TLB_FLUSH flag to indicate flushing should not be
performed for individual pages.  The routine
hugetlb_vmemmap_restore_folios is the only user of this new mechanism, and
it will perform a global flush after all vmemmap is restored.

Link: https://lkml.kernel.org/r/20231019023113.345257-9-mike.kravetz@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Houghton <jthoughton@google.com>
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

 mm/hugetlb_vmemmap.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/mm/hugetlb_vmemmap.c~hugetlb-batch-tlb-flushes-when-restoring-vmemmap
+++ a/mm/hugetlb_vmemmap.c
@@ -461,18 +461,19 @@ out:
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
  * @reuse:	reuse address.
+ * @flags:	modifications to vmemmap_remap_walk flags
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long reuse)
+			       unsigned long reuse, unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
 		.reuse_addr	= reuse,
 		.vmemmap_pages	= &vmemmap_pages,
-		.flags		= 0,
+		.flags		= flags,
 	};
 
 	/* See the comment in the vmemmap_remap_free(). */
@@ -494,17 +495,7 @@ EXPORT_SYMBOL(hugetlb_optimize_vmemmap_k
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
 
-/**
- * hugetlb_vmemmap_restore - restore previously optimized (by
- *			     hugetlb_vmemmap_optimize()) vmemmap pages which
- *			     will be reallocated and remapped.
- * @h:		struct hstate.
- * @head:	the head page whose vmemmap pages will be restored.
- *
- * Return: %0 if @head's vmemmap pages have been reallocated and remapped,
- * negative error code otherwise.
- */
-int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head)
+static int __hugetlb_vmemmap_restore(const struct hstate *h, struct page *head, unsigned long flags)
 {
 	int ret;
 	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
@@ -525,7 +516,7 @@ int hugetlb_vmemmap_restore(const struct
 	 * When a HugeTLB page is freed to the buddy allocator, previously
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse);
+	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse, flags);
 	if (!ret) {
 		ClearHPageVmemmapOptimized(head);
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
@@ -535,6 +526,21 @@ int hugetlb_vmemmap_restore(const struct
 }
 
 /**
+ * hugetlb_vmemmap_restore - restore previously optimized (by
+ *				hugetlb_vmemmap_optimize()) vmemmap pages which
+ *				will be reallocated and remapped.
+ * @h:		struct hstate.
+ * @head:	the head page whose vmemmap pages will be restored.
+ *
+ * Return: %0 if @head's vmemmap pages have been reallocated and remapped,
+ * negative error code otherwise.
+ */
+int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head)
+{
+	return __hugetlb_vmemmap_restore(h, head, 0);
+}
+
+/**
  * hugetlb_vmemmap_restore_folios - restore vmemmap for every folio on the list.
  * @h:			hstate.
  * @folio_list:		list of folios.
@@ -557,7 +563,8 @@ long hugetlb_vmemmap_restore_folios(cons
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
-			ret = hugetlb_vmemmap_restore(h, &folio->page);
+			ret = __hugetlb_vmemmap_restore(h, &folio->page,
+						VMEMMAP_REMAP_NO_TLB_FLUSH);
 			if (ret)
 				break;
 			restored++;
@@ -567,6 +574,8 @@ long hugetlb_vmemmap_restore_folios(cons
 		list_move(&folio->lru, non_hvo_folios);
 	}
 
+	if (restored)
+		flush_tlb_all();
 	if (!ret)
 		ret = restored;
 	return ret;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


