Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473653016F1
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 19:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439592; cv=none; b=L+2aRnTEIvGFIlSLGlSFUW6xs7rKVqk+REv4wWF4gT32bCku9hC5z9Rx4MNMqN2qXN/Rd9IiwUXALwniZuk6k4OXVX9k4bKuBoBoeRmCPTSX7v1oPPsQ0HBtj808RughpCl0mvQzK7nrlQpdiHvYeRFCtkBz3bFQefLqtJIMFBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439592; c=relaxed/simple;
	bh=8BijbfBe7GDHdAOQyvY8VOPVc9mZoU4uk9Z73hJDlr4=;
	h=Date:To:From:Subject:Message-Id; b=qMCu/hXOnW3d0qE/dRdAOCxd8w0JktBkedzVweCeSzqSNv+wXnXZwLkf72zdZUQjmMpFgxqpNbCQ3aRUoSVvvRSPLeTfvj0UiUYtA1qpABOw/9eev5Cwviby7FKO81lLJct0zohcIbLSH84B5QSI2bYstwU9BM5bCrdwSAVayWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tZQEnxFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tZQEnxFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B184A1F000E9;
	Thu, 30 Jul 2026 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785439587;
	bh=QSoS3DFeLq6A2Z+s5Gj8eMq28HjmXIbVLDXLYQNmqYE=;
	h=Date:To:From:Subject;
	b=tZQEnxFmetHn4LzQDXmDm/FJiatE75/Rp/yL2LJK1Za9RqEhkt2IQ6VjHZ2nxfSI0
	 gSqAYFYeomcbYIQi+hcJQ+3gf9ODq8PnRp1j1JE6VL/wYUHT+/36hea0/hoHURuI5Z
	 QP/t7UMZMvWPxCZ8ONY9DiMGfxhkAaRV1wuaz9b8=
Date: Thu, 30 Jul 2026 12:26:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-convert-page-folio-for-hwpoison-checks.patch added to mm-unstable branch
Message-Id: <20260730192627.B184A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: convert page -> folio for hwpoison checks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-convert-page-folio-for-hwpoison-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-convert-page-folio-for-hwpoison-checks.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: convert page -> folio for hwpoison checks
Date: Thu, 30 Jul 2026 09:45:52 +0000

Patch series "mm/rmap: Refactor try_to_unmap_one", v4.

In preparation for batching anonymous large folio unmapping to optimize
it, refactor try_to_unmap_one.  This series refactors hugetlb,
anon-lazyfree and anon-swapbacked logic into their own functions,
significantly reducing the length of the huge try_to_unmap_one.


This patch (of 5):

try_to_unmap() receives hugetlb folios only from the hwpoison path. 
hugetlb_update_hwpoison() sets the hugetlb folio's head-page hwpoison bit,
and page_vma_mapped_walk() reports the hugetlb mapping at the head PFN, so
the previous PageHWPoison(subpage) check happened to work for hugetlb.

For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
folios before calling try_to_unmap().  Hence it is always the case that if
try_to_unmap_one() handles an hwpoisoned folio, then the head page is
marked with the poison bit.

Therefore, convert the poisoned subpage checks to folio_test_hwpoison().

No functional change intended, except that, while at it,
convert VM_BUG_* to VM_WARN_*.

Link: https://lore.kernel.org/20260730094559.418003-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260730094559.418003-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-convert-page-folio-for-hwpoison-checks
+++ a/mm/rmap.c
@@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct foli
 			bool anon = folio_test_anon(folio);
 
 			/*
-			 * The try_to_unmap() is only passed a hugetlb page
-			 * in the case where the hugetlb page is poisoned.
+			 * The try_to_unmap() is only passed a hugetlb folio
+			 * in the case where the hugetlb folio contains a
+			 * poisoned page.
 			 */
-			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
+			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -2204,7 +2205,8 @@ static bool try_to_unmap_one(struct foli
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
+		/* unmap_poisoned_folio() only refs order-0 or hugetlb folios */
+		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_poisoned_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

