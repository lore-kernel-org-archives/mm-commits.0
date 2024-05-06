Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163D6208A8
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957033; cv=none; b=o8dOsMImDZVVLJScWSP4WvEoxhRl/6zsZbQ6/1c1Z59DIMtteh724EdlV7/Qw1VjIygL3S5ivnRFamXTv8RbHUrZDapd0a0Qepx8sA3t7Wdm4bXmm9MjeNhUPML5hZJSbwXnsGfI2UqBDMJgPjxjNydBcPcN9FhoLW9cq0AHqu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957033; c=relaxed/simple;
	bh=QL0o22G3MF7z8lNEeKYoZ+tV0hkNZrRsxj95jwcJ0A8=;
	h=Date:To:From:Subject:Message-Id; b=HGLU1+YEie0Y9NRejaAToWsuvm+RXvpoAAHeX10l0uWA+Wx+bflxSaImbq7qLhQtlgZi9MWPsy8+UFqOxu2p8MHFfja+bNvjwcrg098B9oTH9Aa70ufmTwBOfgzRATgL+LKdIpElebKwNXG1S0Gt9bm7cZRi3qrTL9f8DhuMMcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cs32HE8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cs32HE8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03D7C116B1;
	Mon,  6 May 2024 00:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957033;
	bh=QL0o22G3MF7z8lNEeKYoZ+tV0hkNZrRsxj95jwcJ0A8=;
	h=Date:To:From:Subject:From;
	b=Cs32HE8XJzSOnah9pkZZ006/PJ2Bkq7JKxzhildqJQETZNFyytAuGzdBEVhkm9i76
	 vhJnqKN7KjsdEULQ6Re03b3uQx9x1EaMtATnw9fmapja/onGALwnkhNVDERj994Pfc
	 wcsrMU89qBVV1iNscq5BCrQFaf39KBzaSVbFeaxk=
Date: Sun, 05 May 2024 17:57:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch removed from -mm tree
Message-Id: <20240506005712.E03D7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: replace set_page_stable_node by folio_set_stable_node
has been removed from the -mm tree.  Its filename was
     mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: replace set_page_stable_node by folio_set_stable_node
Date: Thu, 11 Apr 2024 14:17:11 +0800

Only single page could be reached where we set stable node after write
protect, so use folio converted func to replace page's.  And remove the
unused func set_page_stable_node().

Link: https://lkml.kernel.org/r/20240411061713.1847574-11-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/ksm.c~mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node
+++ a/mm/ksm.c
@@ -1094,17 +1094,11 @@ static inline struct ksm_stable_node *pa
 	return folio_stable_node(page_folio(page));
 }
 
-static inline void set_page_stable_node(struct page *page,
-					struct ksm_stable_node *stable_node)
-{
-	VM_BUG_ON_PAGE(PageAnon(page) && PageAnonExclusive(page), page);
-	page->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
-}
-
 static inline void folio_set_stable_node(struct folio *folio,
 					 struct ksm_stable_node *stable_node)
 {
-	set_page_stable_node(&folio->page, stable_node);
+	VM_WARN_ON_FOLIO(folio_test_anon(folio) && PageAnonExclusive(&folio->page), folio);
+	folio->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
 }
 
 #ifdef CONFIG_SYSFS
@@ -1519,7 +1513,7 @@ static int try_to_merge_one_page(struct
 			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
 			 * stable_tree_insert() will update stable_node.
 			 */
-			set_page_stable_node(page, NULL);
+			folio_set_stable_node(page_folio(page), NULL);
 			mark_page_accessed(page);
 			/*
 			 * Page reclaim just frees a clean page with no dirty
_

Patches currently in -mm which might be from alexs@kernel.org are


