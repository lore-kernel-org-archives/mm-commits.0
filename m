Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1343F0AB7;
	Tue, 21 Jul 2026 00:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594616; cv=none; b=CGdl6/2fh8tqo4+Qc1vd0VZrgGt77f4+/XyfgmeyMRSmFqJGsTilArLcSTdO2qzGiA3Kzn2Ta8mQEiIjUmzm5JIwRfSlR6zwkFpNBK2kebVhucfiEBFInkFp8HaC827hZxQqTyhEKtQ9LP6Q/4lnOwNOf3rkUug8MGvJIBkP5CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594616; c=relaxed/simple;
	bh=WfvzLftR8tS7PxbvL6lEs68Y9MKqIFDsya1pYUByWms=;
	h=Date:To:From:Subject:Message-Id; b=czdTPfI9QId3Ct7gS7zhFDXlb4alanOkg8hKN61JnHJPITqAgxDNlMY1IsYRdKoSMmx3Rvdi13acSWfrr4neZbd8jj2hZaALkb70ZYgmssQ9vlDhB5Jx6DM6P22CV2iAR6Usn/Make4adq59V80RZQSqYTBnjJKKJhGMzxhMEjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aVITXzDz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aVITXzDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02E01F00A3A;
	Tue, 21 Jul 2026 00:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594615;
	bh=8DfV0C9IJ3/tFLefGk/Kq8uGnNK0h6YC3Id3svHY+kg=;
	h=Date:To:From:Subject;
	b=aVITXzDzyCR7sHRvuQYPPY1lP+j4DNgj5J+OY54hwXMzZc0LQGp7fSEt/nBU/kfyJ
	 uy+LgxJMvDIRf1fqaOtNKpzki6rr4BqNbcKChaTwF5YGbZ4+OWbhLfrDFTBHrijvwG
	 RLUanJdDRu9Di/h/ohUKtRAdJGR0RH4uXAHvBbSs=
Date: Mon, 20 Jul 2026 17:43:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch removed from -mm tree
Message-Id: <20260721004334.F02E01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
Date: Wed, 8 Jul 2026 10:01:10 +0100

copy_hugetlb_page_range() clears the uffd-wp bit of migration and hwpoison
entries with huge_pte_clear_uffd_wp(), which operates on the present-PTE
bit position.  Swap entries keep the uffd-wp state elsewhere -- the
migration branch reads and sets it with pte_swp_uffd_wp() and
pte_swp_mkuffd_wp() -- and the present-PTE position falls into the swap
payload.  On x86-64 it lands in the inverted swap offset, where a
naturally-aligned hugetlb PFN always has the affected bit set, so the
clear advances the encoded PFN by two pages.

No userfaultfd needs to be involved: the clear is guarded only by the
child VMA not being uffd-wp registered, so a plain fork() with an
in-flight hugetlb migration entry (or a poisoned hugetlb page) corrupts
the entry copied into the child.  Instrumenting the clear and forking
after MADV_HWPOISON on a 2MB anon hugetlb page shows:

  offset before=120e00
  offset after =120e02

The fallout is mostly latent: rmap walks match migration entries by folio
range and remove_migration_pte() rebuilds the PTE from the folio, so a
within-folio PFN skew heals once migration completes.  But any path that
re-encodes the corrupted offset -- e.g.  hugetlb_change_protection()
rewriting a writable migration entry via
make_readable_migration_entry(swp_offset(entry)) -- propagates it.

Migration entries legitimately carry uffd-wp, so clear it with
pte_swp_clear_uffd_wp(), matching copy_nonpresent_pte() and
move_huge_pte().

A hwpoison entry, on the other hand, never carries the uffd-wp bit: it is
installed fresh by make_hwpoison_entry() (try_to_unmap_one() does not
preserve uffd-wp on the hwpoison path) and hugetlb_change_protection()
leaves hwpoison entries untouched.  There was nothing to clear there, only
the corruption, so drop the clear entirely.

Link: https://lore.kernel.org/20260708090110.136162-1-kirill@shutemov.name
Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260703140011.99E601F000E9@smtp.kernel.org/
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: Claude:claude-fable-5
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork
+++ a/mm/hugetlb.c
@@ -4917,8 +4917,12 @@ again:
 
 		softleaf = softleaf_from_pte(entry);
 		if (unlikely(softleaf_is_hwpoison(softleaf))) {
-			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+			/*
+			 * A hwpoison entry never carries the uffd-wp bit: it is
+			 * installed fresh by make_hwpoison_entry() and
+			 * hugetlb_change_protection() leaves it untouched, so
+			 * there is nothing to clear for the child.
+			 */
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(softleaf_is_migration(softleaf))) {
 			bool uffd_wp = pte_swp_uffd_wp(entry);
@@ -4936,7 +4940,7 @@ again:
 				set_huge_pte_at(src, addr, src_pte, entry, sz);
 			}
 			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+				entry = pte_swp_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(pte_is_marker(entry))) {
 			const pte_marker marker = copy_pte_marker(softleaf, dst_vma);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-unlock-i_mmap_rwsem-before-releasing-after-split-folios.patch
mm-decouple-protnone-helpers-from-config_numa_balancing.patch
mm-rename-uffd-wp-pte-bit-macros-to-uffd.patch
mm-rename-uffd-wp-pte-accessors-to-uffd.patch
userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch
mm-add-vm_uffd_rwp-vma-flag.patch
mm-add-mm_cp_uffd_rwp-change_protection-flag.patch
mm-preserve-rwp-marker-across-pte-rewrites.patch
mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch
userfaultfd-add-uffdio_register_mode_rwp-and-uffdio_rwprotect-plumbing.patch
mm-userfaultfd-add-rwp-fault-delivery-and-expose-uffdio_register_mode_rwp.patch
mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch
userfaultfd-add-uffd_feature_rwp_async-for-async-fault-resolution.patch
userfaultfd-add-uffdio_set_mode-for-runtime-sync-async-toggle.patch
selftests-mm-add-userfaultfd-rwp-tests.patch
documentation-userfaultfd-document-rwp-working-set-tracking.patch
selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch
mm-huge_memory-remove-unused-can_split_folio.patch
mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch

