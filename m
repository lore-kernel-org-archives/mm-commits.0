Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961D214018
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wwn7CGUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D32C433C7;
	Fri, 29 Dec 2023 20:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880120;
	bh=zFpLeOuy11sL/pev1X6/BKtHQuDFZN0/uehqaAZSWNA=;
	h=Date:To:From:Subject:From;
	b=wwn7CGUmYyFKFoBSh7frmS5tncT+NEUukFOBy9lfuCS+iB85odbJ0apCG7WCObJ2i
	 f8U6DoB3DIq39EnYtWnTRCjEBRqK7OQiNrebV3PaAqv9ze28e/+KSpYVOzt98QA6Aq
	 YTVYRnTTvYd+JjY7AIaktYXC5XoBOGuH0XQtWdco=
Date: Fri, 29 Dec 2023 12:01:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200200.64D32C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: page_try_dup_anon_rmap() -> folio_try_dup_anon_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: page_try_dup_anon_rmap() -> folio_try_dup_anon_rmap_pte()
Date: Wed, 20 Dec 2023 23:45:00 +0100

Let's convert copy_nonpresent_pte().  While at it, perform some more folio
conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-37-david@redhat.com
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

 mm/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte
+++ a/mm/memory.c
@@ -785,6 +785,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 	unsigned long vm_flags = dst_vma->vm_flags;
 	pte_t orig_pte = ptep_get(src_pte);
 	pte_t pte = orig_pte;
+	struct folio *folio;
 	struct page *page;
 	swp_entry_t entry = pte_to_swp_entry(orig_pte);
 
@@ -829,6 +830,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		}
 	} else if (is_device_private_entry(entry)) {
 		page = pfn_swap_entry_to_page(entry);
+		folio = page_folio(page);
 
 		/*
 		 * Update rss count even for unaddressable pages, as
@@ -839,10 +841,10 @@ copy_nonpresent_pte(struct mm_struct *ds
 		 * for unaddressable pages, at some point. But for now
 		 * keep things as they are.
 		 */
-		get_page(page);
+		folio_get(folio);
 		rss[mm_counter(page)]++;
 		/* Cannot fail as these pages cannot get pinned. */
-		BUG_ON(page_try_dup_anon_rmap(page, false, src_vma));
+		folio_try_dup_anon_rmap_pte(folio, page, src_vma);
 
 		/*
 		 * We do not preserve soft-dirty information, because so
@@ -956,7 +958,7 @@ copy_present_pte(struct vm_area_struct *
 		 * future.
 		 */
 		folio_get(folio);
-		if (unlikely(page_try_dup_anon_rmap(page, false, src_vma))) {
+		if (unlikely(folio_try_dup_anon_rmap_pte(folio, page, src_vma))) {
 			/* Page may be pinned, we have to copy. */
 			folio_put(folio);
 			return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
_

Patches currently in -mm which might be from david@redhat.com are


