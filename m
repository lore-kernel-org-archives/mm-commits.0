Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCCB14006
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ef5rMe5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07061C433C9;
	Fri, 29 Dec 2023 20:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880104;
	bh=vWCNTKlEKS0WWV3y+SNmtXNzAHO4lbqixnaZ60fdDsw=;
	h=Date:To:From:Subject:From;
	b=Ef5rMe5lVuSjtFjs8ODEfxMn8tVv3D8fkMnwBgdyayugtZI2l1ks5AK5wIrM8Oh9M
	 uodUFAOMh4/mEx5+Oom3reIy3BNG0yk0GqV55tbJk73/6JdAI1OGH+s4tzgb79dU5Q
	 1BltAcIpgNwhO4f9LYz5SFUTeQSc2wapg2xMN7kQ=
Date: Fri, 29 Dec 2023 12:01:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-page_add_anon_rmap-folio_add_anon_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200144.07061C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-page_add_anon_rmap-folio_add_anon_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:44 +0100

Let's convert restore_exclusive_pte() and do_swap_page().  While at it,
perform some folio conversion in restore_exclusive_pte().

Link: https://lkml.kernel.org/r/20231220224504.646757-21-david@redhat.com
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

 mm/memory.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-page_add_anon_rmap-folio_add_anon_rmap_pte
+++ a/mm/memory.c
@@ -710,6 +710,7 @@ static void restore_exclusive_pte(struct
 				  struct page *page, unsigned long address,
 				  pte_t *ptep)
 {
+	struct folio *folio = page_folio(page);
 	pte_t orig_pte;
 	pte_t pte;
 	swp_entry_t entry;
@@ -725,14 +726,15 @@ static void restore_exclusive_pte(struct
 	else if (is_writable_device_exclusive_entry(entry))
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 
-	VM_BUG_ON(pte_write(pte) && !(PageAnon(page) && PageAnonExclusive(page)));
+	VM_BUG_ON_FOLIO(pte_write(pte) && (!folio_test_anon(folio) &&
+					   PageAnonExclusive(page)), folio);
 
 	/*
 	 * No need to take a page reference as one was already
 	 * created when the swap entry was made.
 	 */
-	if (PageAnon(page))
-		page_add_anon_rmap(page, vma, address, RMAP_NONE);
+	if (folio_test_anon(folio))
+		folio_add_anon_rmap_pte(folio, page, vma, address, RMAP_NONE);
 	else
 		/*
 		 * Currently device exclusive access only supports anonymous
@@ -4076,7 +4078,8 @@ vm_fault_t do_swap_page(struct vm_fault
 		folio_add_new_anon_rmap(folio, vma, vmf->address);
 		folio_add_lru_vma(folio, vma);
 	} else {
-		page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
+		folio_add_anon_rmap_pte(folio, page, vma, vmf->address,
+					rmap_flags);
 	}
 
 	VM_BUG_ON(!folio_test_anon(folio) ||
_

Patches currently in -mm which might be from david@redhat.com are


