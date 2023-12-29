Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ABF13FF0
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0MOyunOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25A2C433C8;
	Fri, 29 Dec 2023 20:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880102;
	bh=SsN+9pBjM/9EKnyImH5b4vTOXKWt5fit+dq2HaK7wp4=;
	h=Date:To:From:Subject:From;
	b=0MOyunOqeXanm39CJxmvFqSdf/UUUxJj1qHnh8sKVSnTGCik/+rJc3MmT/eO3fkpE
	 FEAFf2+IoB95rNAN8B5Ed14zYc3xxL4KDJ5KeYuaSEoMUxz9W+yAd5gFyoxeXeVq2I
	 AbYTe1GbSVy+QoElpkZFFyAfgmwFUh9AHIjI6U6U=
Date: Fri, 29 Dec 2023 12:01:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200141.F25A2C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/ksm: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:42 +0100

Let's convert replace_page().  While at it, perform some folio conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-19-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte
+++ a/mm/ksm.c
@@ -1369,6 +1369,7 @@ out:
 static int replace_page(struct vm_area_struct *vma, struct page *page,
 			struct page *kpage, pte_t orig_pte)
 {
+	struct folio *kfolio = page_folio(kpage);
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
 	pmd_t *pmd;
@@ -1408,15 +1409,16 @@ static int replace_page(struct vm_area_s
 		goto out_mn;
 	}
 	VM_BUG_ON_PAGE(PageAnonExclusive(page), page);
-	VM_BUG_ON_PAGE(PageAnon(kpage) && PageAnonExclusive(kpage), kpage);
+	VM_BUG_ON_FOLIO(folio_test_anon(kfolio) && PageAnonExclusive(kpage),
+			kfolio);
 
 	/*
 	 * No need to check ksm_use_zero_pages here: we can only have a
 	 * zero_page here if ksm_use_zero_pages was enabled already.
 	 */
 	if (!is_zero_pfn(page_to_pfn(kpage))) {
-		get_page(kpage);
-		page_add_anon_rmap(kpage, vma, addr, RMAP_NONE);
+		folio_get(kfolio);
+		folio_add_anon_rmap_pte(kfolio, kpage, vma, addr, RMAP_NONE);
 		newpte = mk_pte(kpage, vma->vm_page_prot);
 	} else {
 		/*
_

Patches currently in -mm which might be from david@redhat.com are


