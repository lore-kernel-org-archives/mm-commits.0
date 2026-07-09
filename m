Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D759E391E7B
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 03:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783568155; cv=none; b=AJSqlx7QGXKk9U9LERuyMd+ZdcAtm61//d2NaBzMhrHUe87RucqDDtu4okgJ90i3dncG7J/4hzEjgfWF1af6SkMSpUhsnEHqxq4JxSE2Sdy0wsUWtJ17KhTdP5G1QRdl5TznUGoV45CtsKb3A+yAjJGhUKeejgm6lR95ZDDBCXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783568155; c=relaxed/simple;
	bh=IfjVtnFhWlUNRjn+ox95VE57ArURrFU7NP68ajymolo=;
	h=Date:To:From:Subject:Message-Id; b=cp5plFy2DY1yWJiF/kYbieKidOeJMn0co47Vow4u5gLNfbUJF8LQlu27HIPQnfy8WVtraRni1z4ws2Fw9nRBCOGN01CPAw4InaP2jEZD8VyWwK6roNzDYrMOJrTsxhV3uy0RourJlt94Cs+iYvMJbhGAAkg6VJE/vU74Wmjva3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OPqT1sRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OPqT1sRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5679F1F000E9;
	Thu,  9 Jul 2026 03:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783568153;
	bh=4/b3KI2V4Bjk9FYcBlT30cJgQApdjCgBqxAUwr2ua4o=;
	h=Date:To:From:Subject;
	b=OPqT1sRl9LGBtekCcfZ58vt5kEOpWue0uruEIW6RIE70dddFXC+NLwtWxCO/8MGP1
	 jmxj/qcCselSYjmJYzTEv3Ok/uHP/fhygQyLNrnvJQF/J93iM2rVxaYTRH8iHfV2XU
	 T9TLuzvEnQSL6zC84uln4U4oUwSbeAXZUUS22muo=
Date: Wed, 08 Jul 2026 20:35:52 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch removed from -mm tree
Message-Id: <20260709033553.5679F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
Date: Fri, 3 Jul 2026 17:18:33 +0100

copy_hugetlb_page_range() clears the uffd-wp bit of hwpoison and migration
entries with huge_pte_clear_uffd_wp(), which operates on the present-PTE
bit position.  Swap entries keep the uffd-wp state elsewhere -- the same
branches read and set it with pte_swp_uffd_wp() and pte_swp_mkuffd_wp() --
and the present-PTE position falls into the swap payload.  On x86-64 it
lands in the inverted swap offset, where a naturally-aligned hugetlb PFN
always has the affected bit set, so the clear advances the encoded PFN by
two pages.

No userfaultfd needs to be involved: the clear is guarded only by the
child VMA not being uffd-wp registered, so a plain fork() with an
in-flight hugetlb migration entry (or a poisoned hugetlb page) corrupts
the entry copied into the child.  Instrumenting the hwpoison branch and
forking after MADV_HWPOISON on a 2MB anon hugetlb page shows:

  offset before=120e00
  offset after =120e02

The fallout is mostly latent: rmap walks match migration entries by folio
range and remove_migration_pte() rebuilds the PTE from the folio, so a
within-folio PFN skew heals once migration completes.  But any path that
re-encodes the corrupted offset -- e.g.  hugetlb_change_protection()
rewriting a writable migration entry via
make_readable_migration_entry(swp_offset(entry)) -- propagates it, and an
hwpoison entry misidentifies which page is poisoned.

Use pte_swp_clear_uffd_wp(), matching copy_nonpresent_pte() and
move_huge_pte().

Link: https://lore.kernel.org/20260703161833.57416-1-kirill@shutemov.name
Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260703140011.99E601F000E9@smtp.kernel.org/
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork
+++ a/mm/hugetlb.c
@@ -4918,7 +4918,7 @@ again:
 		softleaf = softleaf_from_pte(entry);
 		if (unlikely(softleaf_is_hwpoison(softleaf))) {
 			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+				entry = pte_swp_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(softleaf_is_migration(softleaf))) {
 			bool uffd_wp = pte_swp_uffd_wp(entry);
@@ -4936,7 +4936,7 @@ again:
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

fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch
fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch
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

