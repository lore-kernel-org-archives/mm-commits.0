Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04C214018
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRXFCk+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3E6C433C8;
	Fri, 29 Dec 2023 20:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880089;
	bh=fAV51IvX4Tp5h0HTjiypTfEIN4+XtPcfSHtETiO6+RE=;
	h=Date:To:From:Subject:From;
	b=WRXFCk+nkkuXUT+k81FzI2wpML/zJXWGjKfKuPUK33moaB2VlF2t2fB2hL1Fhkhci
	 NDWAtCfnP7Lb00S7qBscfKRBZsoj7WPZ6h5CAyrBbPmAfVsGLNk7LbAuZWCfDhrbUP
	 /zKoWTlG+CvbORlL5cNtcqRT+l3W6axiBntC9kcw=
Date: Fri, 29 Dec 2023 12:01:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-add-hugetlb-sanity-checks-for-anon-rmap-handling.patch removed from -mm tree
Message-Id: <20231229200129.9B3E6C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: add hugetlb sanity checks for anon rmap handling
has been removed from the -mm tree.  Its filename was
     mm-rmap-add-hugetlb-sanity-checks-for-anon-rmap-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: add hugetlb sanity checks for anon rmap handling
Date: Wed, 20 Dec 2023 23:44:30 +0100

Let's make sure we end up with the right folios in the right functions
when adding an anon rmap, just like we already do in the other rmap
functions.

Link: https://lkml.kernel.org/r/20231220224504.646757-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/rmap.c~mm-rmap-add-hugetlb-sanity-checks-for-anon-rmap-handling
+++ a/mm/rmap.c
@@ -1262,6 +1262,8 @@ void page_add_anon_rmap(struct page *pag
 	bool compound = flags & RMAP_COMPOUND;
 	bool first;
 
+	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
+
 	/* Is page being mapped by PTE? Is this its first map to be added? */
 	if (likely(!compound)) {
 		first = atomic_inc_and_test(&page->_mapcount);
@@ -1343,6 +1345,7 @@ void folio_add_new_anon_rmap(struct foli
 {
 	int nr = folio_nr_pages(folio);
 
+	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 	VM_BUG_ON_VMA(address < vma->vm_start ||
 			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
 	__folio_set_swapbacked(folio);
@@ -2634,6 +2637,7 @@ void rmap_walk_locked(struct folio *foli
 void hugetlb_add_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		unsigned long address, rmap_t flags)
 {
+	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
 	atomic_inc(&folio->_entire_mapcount);
@@ -2646,6 +2650,8 @@ void hugetlb_add_anon_rmap(struct folio
 void hugetlb_add_new_anon_rmap(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long address)
 {
+	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+
 	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	/* increment count (starts at -1) */
 	atomic_set(&folio->_entire_mapcount, 0);
_

Patches currently in -mm which might be from david@redhat.com are


