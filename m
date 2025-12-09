Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4536D306486
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308385; cv=none; b=PuvY3ERX/6yxXP38M6sWV6Fqtk4Dlj+RoQ7XALx1CckMn75jDQI6mdHN+5bjXQQmJ6vBO4zFFr7qtKueJFyd/OmRZb/U7hpJsT5CukmOXvZIoXdB+l5inwLl2iKQY54OpSKScOz8XmydWVLqlScegDmbWhVVCC2/l/0RlrwMM84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308385; c=relaxed/simple;
	bh=cz+NtOl0y42PilHF8ZfZ6UJBgVExpK6az4+juP6Kogo=;
	h=Date:To:From:Subject:Message-Id; b=P0eyDSRYmm5+Lok9IjBcjjhHuUn4N/ROFPC7bL7qMWPh7Kq9BtSV5ETj0VpXhRZcacdfvgUtKD6OLSlD0d2AhZaUfXSnSpMnS+szErJP93m5vxrY09pZwm7mjsxq3oHNOSc1k43sZMX1cmK290VE0SSGYoVkzWOuUUrNFT1S5Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zzl50jVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zzl50jVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20E6C4CEF5;
	Tue,  9 Dec 2025 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308384;
	bh=cz+NtOl0y42PilHF8ZfZ6UJBgVExpK6az4+juP6Kogo=;
	h=Date:To:From:Subject:From;
	b=zzl50jVUCZhZDnnj8xOqVV6z7rXm9wzk/edg6zusJZp50xEQ2TdWwRSRuLJsyYehm
	 8CJis0OL6FUB09STp4yhy+CQp5eVSkg0ySH39GHHigBVuAC/RsXbvNkVNIN/old/nW
	 NaCsinKMwS/acQ1gdUmBgeKq/dF1tdMSplEoQFTc=
Date: Tue, 09 Dec 2025 11:26:24 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-make-min_order_for_split-always-return-an-order.patch removed from -mm tree
Message-Id: <20251209192624.C20E6C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: make min_order_for_split() always return an order
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-make-min_order_for_split-always-return-an-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: make min_order_for_split() always return an order
Date: Wed, 26 Nov 2025 16:06:17 -0500

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

Link: https://lkml.kernel.org/r/20251126210618.1971206-4-ziy@nvidia.com
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
@@ -4219,16 +4219,29 @@ int folio_split(struct folio *folio, uns
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


