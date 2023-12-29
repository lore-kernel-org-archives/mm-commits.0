Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982DB13AE4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CAtyQxEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661C2C433C7;
	Fri, 29 Dec 2023 20:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880119;
	bh=tqTAd9ftNM0Xw0+AgDw9O0HEyTVpK5C/VEr/OQTpboU=;
	h=Date:To:From:Subject:From;
	b=CAtyQxEOzSzmZEjMvsWXv5m4h3HE5D/m5XJ3jNxpvMpeydYojplehIbNSjs0dlFOy
	 ItFdv0qvYrTULOOGyXk3UsjqOKAsOme1S8UWWB+zw8a1u5vB/wFrbCzHWNVyUIoVet
	 JcU+zP/KtWGflHr59nHaoHAgeV0J5sAydqN5N+lY=
Date: Fri, 29 Dec 2023 12:01:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pmd.patch removed from -mm tree
Message-Id: <20231229200159.661C2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: page_try_dup_anon_rmap() -> folio_try_dup_anon_rmap_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: page_try_dup_anon_rmap() -> folio_try_dup_anon_rmap_pmd()
Date: Wed, 20 Dec 2023 23:44:59 +0100

Let's convert copy_huge_pmd() and fixup the comment in copy_huge_pud(). 
While at it, perform more folio conversion in copy_huge_pmd().

Link: https://lkml.kernel.org/r/20231220224504.646757-36-david@redhat.com
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

 mm/huge_memory.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pmd
+++ a/mm/huge_memory.c
@@ -1275,6 +1275,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 {
 	spinlock_t *dst_ptl, *src_ptl;
 	struct page *src_page;
+	struct folio *src_folio;
 	pmd_t pmd;
 	pgtable_t pgtable = NULL;
 	int ret = -ENOMEM;
@@ -1341,11 +1342,12 @@ int copy_huge_pmd(struct mm_struct *dst_
 
 	src_page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
+	src_folio = page_folio(src_page);
 
-	get_page(src_page);
-	if (unlikely(page_try_dup_anon_rmap(src_page, true, src_vma))) {
+	folio_get(src_folio);
+	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, src_vma))) {
 		/* Page maybe pinned: split and retry the fault on PTEs. */
-		put_page(src_page);
+		folio_put(src_folio);
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
@@ -1454,8 +1456,8 @@ int copy_huge_pud(struct mm_struct *dst_
 	}
 
 	/*
-	 * TODO: once we support anonymous pages, use page_try_dup_anon_rmap()
-	 * and split if duplicating fails.
+	 * TODO: once we support anonymous pages, use
+	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 	 */
 	pudp_set_wrprotect(src_mm, addr, src_pud);
 	pud = pud_mkold(pud_wrprotect(pud));
_

Patches currently in -mm which might be from david@redhat.com are


