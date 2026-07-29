Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811A3212FAD
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298378; cv=none; b=m7s6S68NcfHRcpc0q+6xp90PkYWQLp+cVHpQT/T0V8+A408RDcjyyXktqYb0gN6Jm5/IxjRMRo/6nXnRoUVxEEWxz0pbEJr0QnGpZtTBJ1D85ufhzXVMYlXPxZTtlKlXu9pOmYjADcgTVyMlDnhR3abCTRH/ybQxpVBW6qU6b4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298378; c=relaxed/simple;
	bh=eQTI7SZDyK1ztr3BL7rldbEfKaxiRvfYunKj5HMXZoA=;
	h=Date:To:From:Subject:Message-Id; b=g2Dp69H+GqiPy6mF4+DqP2+Zss6KGrePoyk+33eYv1Bm402H21THyrP2v8ComT4XyNzUJiuR6XIlwxUS1sYHx8cUNxYR5drWJm6NQ4zwgtCLHusoQE48LaBBVvaJ4cQqpy0LbNST0HZvFzaYWBjpLcb2Ck8Tz/gHov32qk4k4BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R/TlzWbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R/TlzWbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2ED1F000E9;
	Wed, 29 Jul 2026 04:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298377;
	bh=FFl8hP5prGb66TjkZkhm2fbAOdz1V72TUKQ5P3rQYGE=;
	h=Date:To:From:Subject;
	b=R/TlzWbSMwET6bNTm8lBxD6OCg3KQGOaG0VMAIjIQ20wuycyPO5FCTaQkqMjAYITn
	 w1AYvNSC39sCSb8gqiBkNMfLHLkiK95Cc45+k+3zzRTOHed/Y4alGO00uzYmNXOFBL
	 5dPVA/+emPav1qR9+91DT5P02vZcnrltsmZ49tPQ=
Date: Tue, 28 Jul 2026 21:12:56 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,pfalcato@suse.de,nphamcs@gmail.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch removed from -mm tree
Message-Id: <20260729041257.1A2ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
has been removed from the -mm tree.  Its filename was
     mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
Date: Tue, 23 Jun 2026 12:57:21 +0000

Patch series "mm: drop "sub" prefix from various places".

Patch 1 converts subpage->page : folios have pages, not subpages.

Patch 2 drops "sub" from a function and a variable because the context
is clear enough.


This patch (of 2):

Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.

Link: https://lore.kernel.org/20260623125723.2503832-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260623125723.2503832-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h     |    4 ++--
 mm/swapfile.c |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap
+++ a/mm/swapfile.c
@@ -1781,7 +1781,7 @@ again:
 /**
  * folio_dup_swap() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
- * @subpage: if not NULL, only increase the swap count of this subpage.
+ * @page: if not NULL, only increase the swap count of this page.
  *
  * Typically called when the folio is unmapped and have its swap entry to
  * take its place: Swap entries allocated to a folio has count == 0 and pinned
@@ -1795,7 +1795,7 @@ again:
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *subpage)
+int folio_dup_swap(struct folio *folio, struct page *page)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -1803,8 +1803,8 @@ int folio_dup_swap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
+	if (page) {
+		entry.val += folio_page_idx(folio, page);
 		nr_pages = 1;
 	}
 
@@ -1815,13 +1815,13 @@ int folio_dup_swap(struct folio *folio,
 /**
  * folio_put_swap() - Decrease swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded, must be in swap cache and locked.
- * @subpage: if not NULL, only decrease the swap count of this subpage.
+ * @page: if not NULL, only decrease the swap count of this page.
  *
  * This won't free the swap slots even if swap count drops to zero, they are
  * still pinned by the swap cache. User may call folio_free_swap to free them.
  * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-void folio_put_swap(struct folio *folio, struct page *subpage)
+void folio_put_swap(struct folio *folio, struct page *page)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -1830,8 +1830,8 @@ void folio_put_swap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
+	if (page) {
+		entry.val += folio_page_idx(folio, page);
 		nr_pages = 1;
 	}
 
--- a/mm/swap.h~mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap
+++ a/mm/swap.h
@@ -230,8 +230,8 @@ extern int swap_retry_table_alloc(swp_en
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *subpage);
-void folio_put_swap(struct folio *folio, struct page *subpage);
+int folio_dup_swap(struct folio *folio, struct page *page);
+void folio_put_swap(struct folio *folio, struct page *page);
 
 /* For internal use */
 extern void __swap_cluster_free_entries(struct swap_info_struct *si,
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

