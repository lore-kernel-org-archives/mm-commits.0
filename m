Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F44B5246
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="joIswZOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C22C433C8;
	Mon, 11 Dec 2023 00:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256137;
	bh=INicT0BBe72cfEUu+khtSWciZYb9Btc8PPNnkD0Ic9s=;
	h=Date:To:From:Subject:From;
	b=joIswZOX2a70pJBQ7jCZ2tbOUUAwJ7bLitvNoYntXy+eLuegmBEuN9bAsmSkt2Nod
	 HhxkcLFMFT0zK00OqrcyRMzR3phMfR2rXCuzkBTfeFYYzYA1x3BQq2KpyXPjL4sC3F
	 Wyddng2TaiB/tdQQJj8hC7AuViZTyuqV4X0DO91A=
Date: Sun, 10 Dec 2023 16:55:36 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,mike.kravetz@oracle.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-convert-page-to-folio.patch removed from -mm tree
Message-Id: <20231211005537.49C22C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: convert page to folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-convert-page-to-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: convert page to folio
Date: Mon, 27 Nov 2023 16:46:45 +0800

There are still some places where it does not be converted to folio, this
patch convert all of them to folio.  And this patch also does some trival
cleanup to fix the code style problems.

Link: https://lkml.kernel.org/r/20231127084645.27017-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   51 ++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-convert-page-to-folio
+++ a/mm/hugetlb_vmemmap.c
@@ -280,7 +280,7 @@ static void vmemmap_restore_pte(pte_t *p
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_split(unsigned long start, unsigned long end,
-				unsigned long reuse)
+			       unsigned long reuse)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
@@ -447,14 +447,14 @@ EXPORT_SYMBOL(hugetlb_optimize_vmemmap_k
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
 
-static int __hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio, unsigned long flags)
+static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
+					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	struct page *head = &folio->page;
-	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
+	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
-	VM_WARN_ON_ONCE(!PageHuge(head));
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
@@ -517,7 +517,7 @@ long hugetlb_vmemmap_restore_folios(cons
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
 			ret = __hugetlb_vmemmap_restore_folio(h, folio,
-						VMEMMAP_REMAP_NO_TLB_FLUSH);
+							      VMEMMAP_REMAP_NO_TLB_FLUSH);
 			if (ret)
 				break;
 			restored++;
@@ -535,9 +535,9 @@ long hugetlb_vmemmap_restore_folios(cons
 }
 
 /* Return true iff a HugeTLB whose vmemmap should and can be optimized. */
-static bool vmemmap_should_optimize(const struct hstate *h, const struct page *head)
+static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *folio)
 {
-	if (HPageVmemmapOptimized((struct page *)head))
+	if (folio_test_hugetlb_vmemmap_optimized(folio))
 		return false;
 
 	if (!READ_ONCE(vmemmap_optimize_enabled))
@@ -550,17 +550,16 @@ static bool vmemmap_should_optimize(cons
 }
 
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
-					struct folio *folio,
-					struct list_head *vmemmap_pages,
-					unsigned long flags)
+					    struct folio *folio,
+					    struct list_head *vmemmap_pages,
+					    unsigned long flags)
 {
 	int ret = 0;
-	struct page *head = &folio->page;
-	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
+	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
-	VM_WARN_ON_ONCE(!PageHuge(head));
-	if (!vmemmap_should_optimize(h, head))
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
+	if (!vmemmap_should_optimize_folio(h, folio))
 		return ret;
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
@@ -588,7 +587,7 @@ static int __hugetlb_vmemmap_optimize_fo
 	 * the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse,
-							vmemmap_pages, flags);
+				 vmemmap_pages, flags);
 	if (ret) {
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
 		folio_clear_hugetlb_vmemmap_optimized(folio);
@@ -615,12 +614,12 @@ void hugetlb_vmemmap_optimize_folio(cons
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-static int hugetlb_vmemmap_split(const struct hstate *h, struct page *head)
+static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
 {
-	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
+	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
-	if (!vmemmap_should_optimize(h, head))
+	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
@@ -640,7 +639,7 @@ void hugetlb_vmemmap_optimize_folios(str
 	LIST_HEAD(vmemmap_pages);
 
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret = hugetlb_vmemmap_split(h, &folio->page);
+		int ret = hugetlb_vmemmap_split_folio(h, folio);
 
 		/*
 		 * Spliting the PMD requires allocating a page, thus lets fail
@@ -655,9 +654,10 @@ void hugetlb_vmemmap_optimize_folios(str
 	flush_tlb_all();
 
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret = __hugetlb_vmemmap_optimize_folio(h, folio,
-						&vmemmap_pages,
-						VMEMMAP_REMAP_NO_TLB_FLUSH);
+		int ret;
+
+		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages,
+						       VMEMMAP_REMAP_NO_TLB_FLUSH);
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
@@ -671,9 +671,8 @@ void hugetlb_vmemmap_optimize_folios(str
 			flush_tlb_all();
 			free_vmemmap_page_list(&vmemmap_pages);
 			INIT_LIST_HEAD(&vmemmap_pages);
-			__hugetlb_vmemmap_optimize_folio(h, folio,
-						&vmemmap_pages,
-						VMEMMAP_REMAP_NO_TLB_FLUSH);
+			__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages,
+							 VMEMMAP_REMAP_NO_TLB_FLUSH);
 		}
 	}
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch
mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch

