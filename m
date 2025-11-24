Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC55733509F
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025802; cv=none; b=l8ugCz/l33JEE35/XfP3DX6xC4HC8uW9YmdOrN0Zeg/BzhEr5f7fVzSp/eCleQRk/Tdsp3P4u3Koj/z+FVy7X6hcGkbp5w5gcWm+fbZVwwrOA1Vju9791hi3hVIReZ25szsRwj8p+gNTlr55IWaYTeP8NMtE8R0gS+LxXaZOUYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025802; c=relaxed/simple;
	bh=vF33abEQ/AOeuprNOSO3lq5jfaxsukGnwlF6bmg4jtA=;
	h=Date:To:From:Subject:Message-Id; b=JXSXJamBr9x71+g2xZR7CyLSRX1uGSTN80o8o0yU/Sk2LVZid1Vq7e8jsHVwoilbAkP2glNkB7zKCwplqI6JsF2T9ADK21tLb3QK61IGeMrnpx4c8stG5+HYZzv8QP3TNrL+/JqfU5wkZMKQjH8uVMiOJetK0QKT72TknMERhbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gXiSnGpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gXiSnGpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87B3C4CEF1;
	Mon, 24 Nov 2025 23:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025801;
	bh=vF33abEQ/AOeuprNOSO3lq5jfaxsukGnwlF6bmg4jtA=;
	h=Date:To:From:Subject:From;
	b=gXiSnGpeqigBNB8gBHuVRM0nGVox0JCbCxquoSvr+jgM7OhZZAP7sQEan7VnTXzmU
	 jhy6JGEMlI8H+Nlm9m2ZcwIRbQ+buNLV9c1IciN0hgzuwT+W8twdw4U17mBT6PRX3+
	 79AWfHYmSPg0syiBu4471hicMLMfS5TsLOLMDokY=
Date: Mon, 24 Nov 2025 15:10:01 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch removed from -mm tree
Message-Id: <20251124231001.B87B3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: only get folio_order() once during __folio_split()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: only get folio_order() once during __folio_split()
Date: Fri, 10 Oct 2025 14:11:42 +0000

Before splitting folio, its order keeps the same.

It is only necessary to get folio_order() once.

Also rename order to old_order to represent the original folio order.

Link: https://lkml.kernel.org/r/20251010141142.1349-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-only-get-folio_order-once-during-__folio_split
+++ a/mm/huge_memory.c
@@ -3682,7 +3682,7 @@ static int __folio_split(struct folio *f
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
-	int order = folio_order(folio);
+	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	int remap_flags = 0;
@@ -3706,7 +3706,7 @@ static int __folio_split(struct folio *f
 	if (!is_anon && !folio->mapping)
 		return -EBUSY;
 
-	if (new_order >= folio_order(folio))
+	if (new_order >= old_order)
 		return -EINVAL;
 
 	if (uniform_split && !uniform_split_supported(folio, new_order, true))
@@ -3764,7 +3764,7 @@ static int __folio_split(struct folio *f
 
 		if (uniform_split) {
 			xas_set_order(&xas, folio->index, new_order);
-			xas_split_alloc(&xas, folio, folio_order(folio), gfp);
+			xas_split_alloc(&xas, folio, old_order, gfp);
 			if (xas_error(&xas)) {
 				ret = xas_error(&xas);
 				goto out;
@@ -3820,13 +3820,13 @@ static int __folio_split(struct folio *f
 		struct lruvec *lruvec;
 		int expected_refs;
 
-		if (folio_order(folio) > 1 &&
+		if (old_order > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(folio_order(folio),
-					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+				mod_mthp_stat(old_order,
+					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
 			/*
 			 * Reinitialize page_deferred_list after removing the
@@ -3954,7 +3954,7 @@ fail:
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
 
-	remap_page(folio, 1 << order, remap_flags);
+	remap_page(folio, 1 << old_order, remap_flags);
 
 	/*
 	 * Unlock all after-split folios except the one containing
@@ -3985,9 +3985,9 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (order == HPAGE_PMD_ORDER)
+	if (old_order == HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
-	count_mthp_stat(order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
+	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


