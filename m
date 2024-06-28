Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD8147779
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 18:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719599420; cv=none; b=X25H0Pysv1QuarohLviPNanL4K6XG4EwY1IzKkcAGPgNZ4/wwQpnZRUX2h4fbsdJTIyU1KegUe8elOcSHZAAQnNB0eJmg+q+VH9DWnXko+ImIzQd5wlUeyaYqp6IAJP6lL7t6sKuvIi5Ed/tIE6uwIRTS1ic3tIkL6mG8lDu/Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719599420; c=relaxed/simple;
	bh=HmTTdVgblELywrkNpt0izxIo3g8ZFamjvGNdap4NH2U=;
	h=Date:To:From:Subject:Message-Id; b=d0tz0IbRJS50JWmM0nzRGofERNJPvWHB3qloQ4iMHKXi0qOBQP4LilIXhYAisdZEqXbNgPwd+uYc1/6yaY1UZGB2qJhpgBnwQdGmlfaK05fhKowRmG04MD9wkbgiGYzAzxR2eBX5J0IhQG1GD1f+m/dyzjE2fgCG7wFcJ3vdO+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=amiY9/eX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="amiY9/eX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1F6C116B1;
	Fri, 28 Jun 2024 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719599419;
	bh=HmTTdVgblELywrkNpt0izxIo3g8ZFamjvGNdap4NH2U=;
	h=Date:To:From:Subject:From;
	b=amiY9/eXWrDOC8WzpybRS8S0rMeTsfSLpfd98dCQ9V8m5vWn8KiR8+G7GXhkPPwkp
	 O1E/JJbhfpLdqdu4yY2VkfJIGQlhucg0GUag69VdiafSeXj/elfqIjnDskD9bOh3TX
	 cJSbhbWvjhN8mGHmal3pjCT63uKmXlvu7Sq21JmY=
Date: Fri, 28 Jun 2024 11:30:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-split-counters.patch added to mm-unstable branch
Message-Id: <20240628183019.4E1F6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add per-order mTHP split counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-split-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-split-counters.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm: add per-order mTHP split counters
Date: Fri, 28 Jun 2024 21:07:49 +0800

Patch series "mm: introduce per-order mTHP split counters", v2.

Currently, the split counters in THP statistics no longer include
PTE-mapped mTHP.  Therefore, we propose introducing per-order mTHP split
counters to monitor the frequency of mTHP splits.  This will help
developers better analyze and optimize system performance.

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

Link: https://lkml.kernel.org/r/20240628130750.73097-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240628130750.73097-2-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 +++
 mm/huge_memory.c        |   19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

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
@@ -3076,7 +3082,7 @@ int split_huge_page_to_list_to_order(str
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
-	if (new_order >= folio_order(folio))
+	if (new_order >= order)
 		return -EINVAL;
 
 	if (folio_test_anon(folio)) {
@@ -3253,8 +3259,9 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (is_thp)
+	if (order >= HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
+	count_mthp_stat(order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
 }
 
@@ -3278,13 +3285,14 @@ void deferred_split_folio(struct folio *
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup *memcg = folio_memcg(folio);
 #endif
+	int order = folio_order(folio);
 	unsigned long flags;
 
 	/*
 	 * Order 1 folios have no space for a deferred list, but we also
 	 * won't waste much memory by not adding them to the deferred list.
 	 */
-	if (folio_order(folio) <= 1)
+	if (order <= 1)
 		return;
 
 	/*
@@ -3305,8 +3313,9 @@ void deferred_split_folio(struct folio *
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(&folio->_deferred_list)) {
-		if (folio_test_pmd_mappable(folio))
+		if (order >= HPAGE_PMD_ORDER)
 			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
+		count_mthp_stat(order, MTHP_STAT_SPLIT_DEFERRED);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-add-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters.patch

