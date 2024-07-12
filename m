Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50FF1CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824857; cv=none; b=I8TofA8RbtJOz3F0CPrKhjCb90KMZzAofwlTqazMW1G9CVy0WeSbjLSUbmX6AHCTa7T77BPTWCZC4TMWgcjm18D4mLf306tX2SFn+f4C45n2qLi5yKP1rE8OS8Bo7LiJWPXKy9N7w0digNBXxLDY6t8wFlZyIiZP+2zy45ZA9zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824857; c=relaxed/simple;
	bh=yXetg8phh5eKLsMmTVLGNire5FZqLCZ9A1+/jO9ikB8=;
	h=Date:To:From:Subject:Message-Id; b=m+pbtrLObtOjj0d0AAmSVxHeirN2BuoNfTS/GMaiLFyPiGPIZJ9+4jVGHPwPWXxQxzJKW+k5qmFFevu+KL8y9OQCdFqdgKLuIf7VTcFOyfwJ+GZnfs4wnMZ8t9x8hY6CRnWaBwwEB8SQke/uzMfyvC4oNNaVb0fj65ClEJHliq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aP3NpLxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aP3NpLxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C63C32782;
	Fri, 12 Jul 2024 22:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824856;
	bh=yXetg8phh5eKLsMmTVLGNire5FZqLCZ9A1+/jO9ikB8=;
	h=Date:To:From:Subject:From;
	b=aP3NpLxPyE3MXmcFujYWZnx0WVdsJL8CI3Sn1TFFAszdFllI2uT+/ThcMAlkjVSQe
	 3QTm5vw0rp2CUhqVX9FzxN+x82oe72NakMYxrLjpoEBOHOevZxSzddQ3u3izPRJsuI
	 8zGRYySsLZ2YFobIOPWknNN6jOz/5Zs/EAJCEi5o=
Date: Fri, 12 Jul 2024 15:54:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-per-order-mthp-split-counters.patch removed from -mm tree
Message-Id: <20240712225416.B7C63C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add per-order mTHP split counters
has been removed from the -mm tree.  Its filename was
     mm-add-per-order-mthp-split-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm: add per-order mTHP split counters
Date: Fri, 28 Jun 2024 21:07:49 +0800

Patch series "mm: introduce per-order mTHP split counters", v3.

At present, the split counters in THP statistics no longer include
PTE-mapped mTHP.  Therefore, we want to introduce per-order mTHP split
counters to monitor the frequency of mTHP splits.  This will assist
developers in better analyzing and optimizing system performance.

/sys/kernel/mm/transparent_hugepage/hugepages-<size>/stats
        split
        split_failed
        split_deferred


This patch (of 2):

Currently, the split counters in THP statistics no longer include
PTE-mapped mTHP.  Therefore, we propose introducing per-order mTHP split
counters to monitor the frequency of mTHP splits.  This will help
developers better analyze and optimize system performance.

/sys/kernel/mm/transparent_hugepage/hugepages-<size>/stats
        split
        split_failed
        split_deferred

[ioworker0@gmail.com: make things more readable, per Barry and Baolin]
  Link: https://lkml.kernel.org/r/20240704012905.42971-2-ioworker0@gmail.com
[ioworker0@gmail.com: use == for `order' test, per David]
  Link: https://lkml.kernel.org/r/20240705113119.82210-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240704012905.42971-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240704012905.42971-2-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240628130750.73097-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240628130750.73097-2-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 +++
 mm/huge_memory.c        |   12 ++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-split-counters
+++ a/include/linux/huge_mm.h
@@ -284,6 +284,9 @@ enum mthp_stat_item {
 	MTHP_STAT_FILE_ALLOC,
 	MTHP_STAT_FILE_FALLBACK,
 	MTHP_STAT_FILE_FALLBACK_CHARGE,
+	MTHP_STAT_SPLIT,
+	MTHP_STAT_SPLIT_FAILED,
+	MTHP_STAT_SPLIT_DEFERRED,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-add-per-order-mthp-split-counters
+++ a/mm/huge_memory.c
@@ -559,6 +559,9 @@ DEFINE_MTHP_STAT_ATTR(swpout_fallback, M
 DEFINE_MTHP_STAT_ATTR(file_alloc, MTHP_STAT_FILE_ALLOC);
 DEFINE_MTHP_STAT_ATTR(file_fallback, MTHP_STAT_FILE_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(file_fallback_charge, MTHP_STAT_FILE_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(split, MTHP_STAT_SPLIT);
+DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
+DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 
 static struct attribute *stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -569,6 +572,9 @@ static struct attribute *stats_attrs[] =
 	&file_alloc_attr.attr,
 	&file_fallback_attr.attr,
 	&file_fallback_charge_attr.attr,
+	&split_attr.attr,
+	&split_failed_attr.attr,
+	&split_deferred_attr.attr,
 	NULL,
 };
 
@@ -3068,7 +3074,7 @@ int split_huge_page_to_list_to_order(str
 	XA_STATE_ORDER(xas, &folio->mapping->i_pages, folio->index, new_order);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
-	bool is_thp = folio_test_pmd_mappable(folio);
+	int order = folio_order(folio);
 	int extra_pins, ret;
 	pgoff_t end;
 	bool is_hzp;
@@ -3253,8 +3259,9 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (is_thp)
+	if (order == HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
+	count_mthp_stat(order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
 }
 
@@ -3307,6 +3314,7 @@ void deferred_split_folio(struct folio *
 	if (list_empty(&folio->_deferred_list)) {
 		if (folio_test_pmd_mappable(folio))
 			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
+		count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
_

Patches currently in -mm which might be from ioworker0@gmail.com are


