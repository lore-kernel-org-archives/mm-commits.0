Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3638C283121
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 20:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764275266; cv=none; b=NjjDRy1bQBSlnXMNQPapTGTVwj+gHx28QCe/IXYeiFtZy+VHF7MeQH2t8TYKrS/9QwTQdXzj8P6erSWBqGMdgg99uB7rYRTSNf/t1Srd942dJ8gWG/ofxm+RjX3LhEQpLuHjTZsWK9NZyHu1WMPNDz3UOf6/EoI+I0I09Lt2OA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764275266; c=relaxed/simple;
	bh=HOvCahblmZNnDPnkzeUySTy49hRF1661uQ3Ws+wAhhs=;
	h=Date:To:From:Subject:Message-Id; b=Y16b7Y/fOkM09PcptKcfltQ3wUssOVKuHZEHJcRLOTGVUqkzXMthmqq5LJAWTKwVAKyW4rcsV49nH9DR4102BISU+YE7a5eSKkuH4pMmxRVakY/jNbRVScq4NgtUINkWFXBtXOiS/J60NMl3gNwW/Ouv4qLXs6M7gyK9AKjdk/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nV5g8TXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nV5g8TXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0067C4CEF8;
	Thu, 27 Nov 2025 20:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764275265;
	bh=HOvCahblmZNnDPnkzeUySTy49hRF1661uQ3Ws+wAhhs=;
	h=Date:To:From:Subject:From;
	b=nV5g8TXOb6Gwi1ZS/v051P1hz4SS+6oZBIcMKDTmDPmkCjhKKH5U80FJW7zeha0jt
	 wfxFaxWkPcZUIJMep+jlnxITdmgjirNMuylrlg57qlLNFq8O0a7x6m1aEhUCVLr4Qx
	 5aast3pEfAbFX3D1+Cz3IkIw0zEedmQfZQ/fZJtI=
Date: Thu, 27 Nov 2025 12:27:45 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-make-min_order_for_split-always-return-an-order.patch added to mm-new branch
Message-Id: <20251127202745.B0067C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: make min_order_for_split() always return an order
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-make-min_order_for_split-always-return-an-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-make-min_order_for_split-always-return-an-order.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: make min_order_for_split() always return an order
Date: Tue, 25 Nov 2025 22:50:07 -0500

min_order_for_split() returns -EBUSY when the folio is truncated and
cannot be split.  In commit 77008e1b2ef7 ("mm/huge_memory: do not change
split_huge_page*() target order silently"), memory_failure() does not
handle it and pass -EBUSY to try_to_split_thp_page() directly. 
try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
new_order is unsigned int in __folio_split() and this large new_order is
rejected as an invalid input.  The code does not cause a bug. 
soft_offline_in_use_page() also uses min_order_for_split() but it always
passes 0 as new_order for split.

Fix it by making min_order_for_split() always return an order.  When the
given folio is truncated, namely folio->mapping == NULL, return 0 and let
a subsequent split function handle the situation and return -EBUSY.

Add kernel-doc to min_order_for_split() to clarify its use.

Link: https://lkml.kernel.org/r/20251126035008.1919461-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 +++---
 mm/huge_memory.c        |   25 +++++++++++++++++++------
 2 files changed, 22 insertions(+), 9 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-make-min_order_for_split-always-return-an-order
+++ a/include/linux/huge_mm.h
@@ -372,7 +372,7 @@ enum split_type {
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
-int min_order_for_split(struct folio *folio);
+unsigned int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type);
@@ -630,10 +630,10 @@ static inline int split_huge_page(struct
 	return -EINVAL;
 }
 
-static inline int min_order_for_split(struct folio *folio)
+static inline unsigned int min_order_for_split(struct folio *folio)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
-	return -EINVAL;
+	return 0;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
--- a/mm/huge_memory.c~mm-huge_memory-make-min_order_for_split-always-return-an-order
+++ a/mm/huge_memory.c
@@ -4221,16 +4221,29 @@ int folio_split(struct folio *folio, uns
 			     SPLIT_TYPE_NON_UNIFORM);
 }
 
-int min_order_for_split(struct folio *folio)
+/**
+ * min_order_for_split() - get the minimum order @folio can be split to
+ * @folio: folio to split
+ *
+ * min_order_for_split() tells the minimum order @folio can be split to.
+ * If a file-backed folio is truncated, 0 will be returned. Any subsequent
+ * split attempt should get -EBUSY from split checking code.
+ *
+ * Return: @folio's minimum order for split
+ */
+unsigned int min_order_for_split(struct folio *folio)
 {
 	if (folio_test_anon(folio))
 		return 0;
 
-	if (!folio->mapping) {
-		if (folio_test_pmd_mappable(folio))
-			count_vm_event(THP_SPLIT_PAGE_FAILED);
-		return -EBUSY;
-	}
+	/*
+	 * If the folio got truncated, we don't know the previous mapping and
+	 * consequently the old min order. But it doesn't matter, as any split
+	 * attempt will immediately fail with -EBUSY as the folio cannot get
+	 * split until freed.
+	 */
+	if (!folio->mapping)
+		return 0;
 
 	return mapping_min_folio_order(folio->mapping);
 }
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch

