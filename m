Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697DE134420
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055005; cv=none; b=Kw8lufLOQsre30oaVCYJNRYJ+/+el0C3DuD7uyhiLyPQBr0o4+lVcp7ePpKMYiLX8o0KvU40Z4ROVPgw2z2wIPPChUXs1IjFOCCIt8xXWF/edmlgl0zr5XvU/otJD1TYwYmw9AJE/zw67zQi2U/vd66VpnwV3uXWWjPZbHfjLeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055005; c=relaxed/simple;
	bh=d660/M9OckDvIDVWy8mKdbELECNFgHhpW7GtExQRuMU=;
	h=Date:To:From:Subject:Message-Id; b=ShKLJYhLUpqCyxanT+IcTR8kdNylVdV6ddSzbFy0G/04fLTGmTcndEu7X03KSEDYADPGL4qxxPvi6Hb4f5ZYCHJv3YlB4SwO9ix1WjzNYArXbL3zGHNTO7VVchcRZ752DnP121EdGBVq+C93iCK1SX/7ppRs6YcEReG+8vx7NwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oHllytrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oHllytrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35646C433C7;
	Thu, 21 Mar 2024 21:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711055005;
	bh=d660/M9OckDvIDVWy8mKdbELECNFgHhpW7GtExQRuMU=;
	h=Date:To:From:Subject:From;
	b=oHllytrFWwKgkUT8xnKz3AuRntmB2hKKMdg2K76AFhrt+/yx8au84/7QETftIm2a5
	 5S6Ky2Y3Mjqa00qj2vaX+D/PAUzwIRuj37n/iWySa9X2XzKuGIhWup4JaHcr4kXNDU
	 SvTsV+E1nmSsnjCIz+rSiRqO6QVcdFNuHZ9qfFb8=
Date: Thu, 21 Mar 2024 14:03:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-folio_prep_large_rmappable.patch added to mm-unstable branch
Message-Id: <20240321210325.35646C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove folio_prep_large_rmappable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-folio_prep_large_rmappable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-folio_prep_large_rmappable.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove folio_prep_large_rmappable()
Date: Thu, 21 Mar 2024 14:24:41 +0000

Now that prep_compound_page() initialises folio->_deferred_list,
folio_prep_large_rmappable()'s only purpose is to set the large_rmappable
flag, so inline it into the two callers.  Take the opportunity to convert
the large_rmappable definition from PAGEFLAG to FOLIO_FLAG and remove the
existance of PageTestLargeRmappable and friends.

Link: https://lkml.kernel.org/r/20240321142448.1645400-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |    3 ---
 include/linux/page-flags.h |    4 ++--
 mm/huge_memory.c           |    9 +--------
 mm/internal.h              |    3 ++-
 4 files changed, 5 insertions(+), 14 deletions(-)

--- a/include/linux/huge_mm.h~mm-remove-folio_prep_large_rmappable
+++ a/include/linux/huge_mm.h
@@ -263,7 +263,6 @@ unsigned long thp_vma_allowable_orders(s
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 
-void folio_prep_large_rmappable(struct folio *folio);
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
@@ -411,8 +410,6 @@ static inline unsigned long thp_vma_allo
 	return 0;
 }
 
-static inline void folio_prep_large_rmappable(struct folio *folio) {}
-
 #define transparent_hugepage_flags 0UL
 
 #define thp_get_unmapped_area	NULL
--- a/include/linux/page-flags.h~mm-remove-folio_prep_large_rmappable
+++ a/include/linux/page-flags.h
@@ -869,9 +869,9 @@ static inline void ClearPageCompound(str
 	BUG_ON(!PageHead(page));
 	ClearPageHead(page);
 }
-PAGEFLAG(LargeRmappable, large_rmappable, PF_SECOND)
+FOLIO_FLAG(large_rmappable, FOLIO_SECOND_PAGE)
 #else
-TESTPAGEFLAG_FALSE(LargeRmappable, large_rmappable)
+FOLIO_FLAG_FALSE(large_rmappable)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
--- a/mm/huge_memory.c~mm-remove-folio_prep_large_rmappable
+++ a/mm/huge_memory.c
@@ -767,13 +767,6 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 	return pmd;
 }
 
-void folio_prep_large_rmappable(struct folio *folio)
-{
-	if (!folio || !folio_test_large(folio))
-		return;
-	folio_set_large_rmappable(folio);
-}
-
 static inline bool is_transparent_hugepage(struct folio *folio)
 {
 	if (!folio_test_large(folio))
@@ -2840,7 +2833,7 @@ static void __split_huge_page_tail(struc
 	clear_compound_head(page_tail);
 	if (new_order) {
 		prep_compound_page(page_tail, new_order);
-		folio_prep_large_rmappable(new_folio);
+		folio_set_large_rmappable(new_folio);
 	}
 
 	/* Finally unfreeze refcount. Additional reference from page cache. */
--- a/mm/internal.h~mm-remove-folio_prep_large_rmappable
+++ a/mm/internal.h
@@ -513,7 +513,8 @@ static inline struct folio *page_rmappab
 {
 	struct folio *folio = (struct folio *)page;
 
-	folio_prep_large_rmappable(folio);
+	if (folio && folio_test_large(folio))
+		folio_set_large_rmappable(folio);
 	return folio;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

