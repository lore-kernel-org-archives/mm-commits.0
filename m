Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0E3C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011130; cv=none; b=X4Bx1ui2RP0R3Pf+JGJnpmrn2UKRVbG3MpNgrZ2Q4Z7YWnkTDqN2ja8oTtpcbPVa0MFw/SXaJxz2kRdQ2tQmU1eq+bBN9P4Et2xNWef3CEiar/+2ix4I4zQJFp+0GcoseQCOACf/0hXcM6xAc3ELl4jJZmQKGGMn1JAyDaQ0IP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011130; c=relaxed/simple;
	bh=V946W2sACUq+taCYe3EMFWvbxDZwAG7lJ/MkpgftOY4=;
	h=Date:To:From:Subject:Message-Id; b=Z4h5OMhbPgxc/Kz0KxO+uYvmT2Mf5G81hB89YUsGsm1PBNuImFo43LjCYa5VUlJDbntHFw0FawWZVAtvVQYsr68jxGtuo9HllNXBxFMRNVDZs6+eDsVgF+R2EeDSPrRZThL6e63C7IdSy7J4fX7doTnjLGX6oTj35Y/Exg2VWAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G5Lioj3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5Lioj3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30656C4CEE4;
	Mon, 12 May 2025 00:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011130;
	bh=V946W2sACUq+taCYe3EMFWvbxDZwAG7lJ/MkpgftOY4=;
	h=Date:To:From:Subject:From;
	b=G5Lioj3+Cu8ctuEgmOGlIKA4A/6iuBe2NatjNkfsJNqkXKq71qs1mZpH8gYgpPIhL
	 ROIlW5PcydrL9bt3tjYFhiZe3Og1nHwZJ3f1dr1jBS3/HLONoAgHkVZI4n8o68+7gn
	 3cixPruYlb8h4zy+ad4KpcBGnGeJgpXfWioFzq+s=
Date: Sun, 11 May 2025 17:52:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,muchun.song@linux.dev,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch removed from -mm tree
Message-Id: <20250512005210.30656C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,hugetlb: allocate frozen pages in alloc_buddy_hugetlb_folio
has been removed from the -mm tree.  Its filename was
     mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: allocate frozen pages in alloc_buddy_hugetlb_folio
Date: Fri, 11 Apr 2025 15:23:59 +0200

alloc_buddy_hugetlb_folio() allocates a rmappable folio, then strips the
rmappable part and freezes it.  We can simplify all that by allocating
frozen pages directly.

Link: https://lkml.kernel.org/r/20250411132359.312708-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1950,7 +1950,6 @@ static struct folio *alloc_buddy_hugetlb
 	int order = huge_page_order(h);
 	struct folio *folio;
 	bool alloc_try_hard = true;
-	bool retry = true;
 
 	/*
 	 * By default we always try hard to allocate the folio with
@@ -1965,22 +1964,8 @@ static struct folio *alloc_buddy_hugetlb
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
-retry:
-	folio = __folio_alloc(gfp_mask, order, nid, nmask);
-	/* Ensure hugetlb folio won't have large_rmappable flag set. */
-	if (folio)
-		folio_clear_large_rmappable(folio);
 
-	if (folio && !folio_ref_freeze(folio, 1)) {
-		folio_put(folio);
-		if (retry) {	/* retry once */
-			retry = false;
-			goto retry;
-		}
-		/* WOW!  twice in a row. */
-		pr_warn("HugeTLB unexpected inflated folio ref count\n");
-		folio = NULL;
-	}
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
_

Patches currently in -mm which might be from osalvador@suse.de are


