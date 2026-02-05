Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A94728726D
	for <mm-commits@vger.kernel.org>; Thu,  5 Feb 2026 03:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770263950; cv=none; b=a6fAoEZVBN4A+riRONlMGALrFxLWeyYeIO9kdQm/H3UGdqXMJgT7BqUdtgb9xujKaCELLhlZ8khJ7ITwYLV7xBnxknG29md9JQj3wQKdHhv0IHSL+ApfwRhOlVS8mMeoosldT6GaBDQ9me78ukszyq8X6uvCklUSGl4nMxesulY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770263950; c=relaxed/simple;
	bh=ZVS4pJY1wfgymDV3s0F+rwayt2edWZwa8+SrbeEJzR0=;
	h=Date:To:From:Subject:Message-Id; b=hUF/Nf6Mk9Lp3Fc9OgBPP4j36s49rFjlT98YGrDlSh9IZL+Jqg1aL3jnZw3mh5KpAFhS4rAv4vs4N4b3yn4Yxt2KRaoaNGfHRBLESAvZTKeT4FTk00FDIQLwYrPhnutSlPCFA4QOrp3/eL1QbQexT9MMG6JgQguiZl1XFJNv2iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jpFsMADm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jpFsMADm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC2CC4CEF7;
	Thu,  5 Feb 2026 03:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770263949;
	bh=ZVS4pJY1wfgymDV3s0F+rwayt2edWZwa8+SrbeEJzR0=;
	h=Date:To:From:Subject:From;
	b=jpFsMADmiUX9LzBZNTTRiMi4NQo84P6e8qV3lHCRXch2zJGhY9Si3XSvgnNp+8SyC
	 LREkCq9dP9MqQAq0A8Oa1P83JIlY5ZlAxY4gffH77798BDvULDXyD5QGqUuV8/TlFj
	 kUZfhDslxKkZ0cMQhV8phCvIc9QipoUbcEbA+seE=
Date: Wed, 04 Feb 2026 19:59:09 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shicenci@gmail.com,rppt@kernel.org,richard.weiyang@gmail.com,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,harry.yoo@oracle.com,david@kernel.org,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory_failure-reject-unsupported-non-folio-compound-page.patch removed from -mm tree
Message-Id: <20260205035909.CCC2CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_failure: reject unsupported non-folio compound page
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-reject-unsupported-non-folio-compound-page.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/memory_failure: reject unsupported non-folio compound page
Date: Wed, 4 Feb 2026 19:56:03 -0500

When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear in
a userspace mapping via either vm_insert_*() functions or
vm_operatios_struct->fault().  They are not folios, thus should not be
considered for folio operations like split.  Change memory_failure() and
soft_offline_page() to reject these non-folio compound pages as
EOPNOTSUPP.

Add PageNonFolioCompound() helper function.  This function is functionally
equivalent to folio_test_large() && !folio_test_large_rmappable(), but it
is supposed to be used on struct page.  So open code it instead.

Link: https://lkml.kernel.org/r/20260205005603.274383-1-ziy@nvidia.com
Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: 是参差 <shicenci@gmail.com>
Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   16 ++++++++++++++++
 mm/memory-failure.c        |    9 ++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

--- a/include/linux/page-flags.h~mm-memory_failure-reject-unsupported-non-folio-compound-page
+++ a/include/linux/page-flags.h
@@ -1102,6 +1102,22 @@ static inline bool folio_contain_hwpoiso
 
 bool is_free_buddy_page(const struct page *page);
 
+static inline bool PageNonFolioCompound(const struct page *page)
+{
+	if (PageCompound(page)) {
+		const struct page *head = compound_head(page);
+
+		/*
+		 * Without CONFIG_TRANSPARENT_HUGEPAGE, PG_large_rmappable
+		 * should not be set/used.
+		 */
+		return !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
+		       !test_bit(PG_large_rmappable, &head[1].flags.f);
+	}
+
+	return false;
+}
+
 #ifdef CONFIG_MIGRATION
 /*
  * This page is migratable through movable_ops (for selected typed pages
--- a/mm/memory-failure.c~mm-memory_failure-reject-unsupported-non-folio-compound-page
+++ a/mm/memory-failure.c
@@ -2440,9 +2440,12 @@ try_again:
 
 	folio = page_folio(p);
 
-	/* filter pages that are protected from hwpoison test by users */
+	/*
+	 * filter pages that are protected from hwpoison test by users or
+	 * unsupported non folio compound ones
+	 */
 	folio_lock(folio);
-	if (hwpoison_filter(p)) {
+	if (hwpoison_filter(p) || PageNonFolioCompound(p)) {
 		ClearPageHWPoison(p);
 		folio_unlock(folio);
 		folio_put(folio);
@@ -2945,7 +2948,7 @@ retry:
 	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
 	put_online_mems();
 
-	if (hwpoison_filter(page)) {
+	if (hwpoison_filter(page) || PageNonFolioCompound(page)) {
 		if (ret > 0)
 			put_page(page);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


