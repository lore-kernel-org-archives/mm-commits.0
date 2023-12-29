Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB7A13AD9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gNvcvO9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7967CC433C8;
	Fri, 29 Dec 2023 20:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880086;
	bh=Qf27yo1wBmK2SdoRRU58dgqm9q/hEBpC2EXozItKYbM=;
	h=Date:To:From:Subject:From;
	b=gNvcvO9WbQ+hxxf+buGbgMCaRGMwCouxZ/EDscWwrbuNuwICptvBbviuL/jZymn7H
	 jH79j1nAHKqjTYse7W1YOgynayaBqRB3p2lKAdZHWgNRj1CWfqMdpyelXDp1a+Z8RM
	 QAQKiQdnqyLsj/OTFUZ0Y0uANLbp0Kkymw1m/x20=
Date: Fri, 29 Dec 2023 12:01:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-introduce-and-use-hugetlb_add_file_rmap.patch removed from -mm tree
Message-Id: <20231229200126.7967CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: introduce and use hugetlb_add_file_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-introduce-and-use-hugetlb_add_file_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: introduce and use hugetlb_add_file_rmap()
Date: Wed, 20 Dec 2023 23:44:27 +0100

hugetlb rmap handling differs quite a lot from "ordinary" rmap code.  For
example, hugetlb currently only supports entire mappings, and treats any
mapping as mapped using a single "logical PTE".  Let's move it out of the
way so we can overhaul our "ordinary" rmap.  implementation/interface.

Right now we're using page_dup_file_rmap() in some cases where "ordinary"
rmap code would have used page_add_file_rmap().  So let's introduce and
use hugetlb_add_file_rmap() instead.  We won't be adding a
"hugetlb_dup_file_rmap()" functon for the fork() case, as it would be
doing the same: "dup" is just an optimization for "add".

What remains is a single page_dup_file_rmap() call in fork() code.

Add sanity checks that we end up with the right folios in the right
functions.

Link: https://lkml.kernel.org/r/20231220224504.646757-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    8 ++++++++
 mm/hugetlb.c         |    6 +++---
 mm/migrate.c         |    2 +-
 mm/rmap.c            |    1 +
 4 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-introduce-and-use-hugetlb_add_file_rmap
+++ a/include/linux/rmap.h
@@ -211,6 +211,14 @@ void hugetlb_add_anon_rmap(struct folio
 void hugetlb_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
 
+static inline void hugetlb_add_file_rmap(struct folio *folio)
+{
+	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
+
+	atomic_inc(&folio->_entire_mapcount);
+}
+
 static inline void hugetlb_remove_rmap(struct folio *folio)
 {
 	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
--- a/mm/hugetlb.c~mm-rmap-introduce-and-use-hugetlb_add_file_rmap
+++ a/mm/hugetlb.c
@@ -5408,7 +5408,7 @@ again:
 			 * sleep during the process.
 			 */
 			if (!folio_test_anon(pte_folio)) {
-				page_dup_file_rmap(&pte_folio->page, true);
+				hugetlb_add_file_rmap(pte_folio);
 			} else if (page_try_dup_anon_rmap(&pte_folio->page,
 							  true, src_vma)) {
 				pte_t src_pte_old = entry;
@@ -6279,7 +6279,7 @@ static vm_fault_t hugetlb_no_page(struct
 	if (anon_rmap)
 		hugetlb_add_new_anon_rmap(folio, vma, haddr);
 	else
-		page_dup_file_rmap(&folio->page, true);
+		hugetlb_add_file_rmap(folio);
 	new_pte = make_huge_pte(vma, &folio->page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
 	/*
@@ -6730,7 +6730,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		goto out_release_unlock;
 
 	if (folio_in_pagecache)
-		page_dup_file_rmap(&folio->page, true);
+		hugetlb_add_file_rmap(folio);
 	else
 		hugetlb_add_new_anon_rmap(folio, dst_vma, dst_addr);
 
--- a/mm/migrate.c~mm-rmap-introduce-and-use-hugetlb_add_file_rmap
+++ a/mm/migrate.c
@@ -252,7 +252,7 @@ static bool remove_migration_pte(struct
 				hugetlb_add_anon_rmap(folio, vma, pvmw.address,
 						      rmap_flags);
 			else
-				page_dup_file_rmap(new, true);
+				hugetlb_add_file_rmap(folio);
 			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte,
 					psize);
 		} else
--- a/mm/rmap.c~mm-rmap-introduce-and-use-hugetlb_add_file_rmap
+++ a/mm/rmap.c
@@ -1395,6 +1395,7 @@ void folio_add_file_rmap_range(struct fo
 	unsigned int nr_pmdmapped = 0, first;
 	int nr = 0;
 
+	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_FOLIO(compound && !folio_test_pmd_mappable(folio), folio);
 
 	/* Is page being mapped by PTE? Is this its first map to be added? */
_

Patches currently in -mm which might be from david@redhat.com are


