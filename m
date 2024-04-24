Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C155156973
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713992729; cv=none; b=lF63FcDPGg7gHybAp+tCTpdr73NOfQf06CSUI2U+ZnG/nD9Jn6fbG52dexGzv0siecHAZtznYZ8j9Gl/NpVXm/oNe7o+/PNPr2S6O6+4kEcHoDhIamby0ybBSw3rzDggZe2xH8MmgkE0pYjQ3iPMck8934YgKz3sua8wp+pwhSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713992729; c=relaxed/simple;
	bh=wHFKotxs+A0YPp24MmQOsreVYqH5zVW6pF6GVrSm+1k=;
	h=Date:To:From:Subject:Message-Id; b=FxHzN3I2bwLIa/o+UMKAYlpr56BwOFG4fg1EWFYg/FCQbxg+Pv7TuS9/K6KmfuVp2mR98P+KmGveVWdHpWVPWe/81IuHf3yhA9DKCS1YhmoekQpglvRd6zqwxaqp5ZBDzdr7n8kDppwMEXZceFsV27BS1FJtlDTjDd9TD3pUUP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I9N06q0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I9N06q0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A9FC113CD;
	Wed, 24 Apr 2024 21:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713992728;
	bh=wHFKotxs+A0YPp24MmQOsreVYqH5zVW6pF6GVrSm+1k=;
	h=Date:To:From:Subject:From;
	b=I9N06q0IM+Jzbmy9wqkActvbn/qSXTDsRcYx0GKytsEgQepVSt7ByGHCFiHdQrGXS
	 TTK3esfr3p+NY/jNtc14iS9BGxb2ALPmZigAxkhh51nVawnUSCAj2/jltdGPakF9zl
	 TJAV5mjUoDys1MaUMDGH6q+k9b7x1JvqbpU5SAsg=
Date: Wed, 24 Apr 2024 14:05:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang.shi@linux.alibaba.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,corbet@lwn.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch added to mm-unstable branch
Message-Id: <20240424210528.97A9FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: replace page_mapcount() check by folio_likely_mapped_shared()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/khugepaged: replace page_mapcount() check by folio_likely_mapped_shared()
Date: Wed, 24 Apr 2024 14:26:30 +0200

We want to limit the use of page_mapcount() to places where absolutely
required, to prepare for kernel configs where we won't keep track of
per-page mapcounts in large folios.

khugepaged is one of the remaining "more challenging" page_mapcount()
users, but we might be able to move away from page_mapcount() without
resulting in a significant behavior change that would warrant
special-casing based on kernel configs.

In 2020, we first added support to khugepaged for collapsing COW-shared
pages via commit 9445689f3b61 ("khugepaged: allow to collapse a page
shared across fork"), followed by support for collapsing PTE-mapped THP in
commit 5503fbf2b0b8 ("khugepaged: allow to collapse PTE-mapped compound
pages") and limiting the memory waste via the "page_count() > 1" check in
commit 71a2c112a0f6 ("khugepaged: introduce 'max_ptes_shared' tunable").

As a default, khugepaged will allow up to half of the PTEs to map shared
pages: where page_mapcount() > 1.  MADV_COLLAPSE ignores the khugepaged
setting.

khugepaged does currently not care about swapcache page references, and
does not check under folio lock: so in some corner cases the "shared vs. 
exclusive" detection might be a bit off, making us detect "exclusive" when
it's actually "shared".

Most of our anonymous folios in the system are usually exclusive.  We
frequently see sharing of anonymous folios for a short period of time,
after which our short-lived suprocesses either quit or exec().

There are some famous examples, though, where child processes exist for a
long time, and where memory is COW-shared with a lot of processes
(webservers, webbrowsers, sshd, ...) and COW-sharing is crucial for
reducing the memory footprint.  We don't want to suddenly change the
behavior to result in a significant increase in memory waste.

Interestingly, khugepaged will only collapse an anonymous THP if at least
one PTE is writable.  After fork(), that means that something (usually a
page fault) populated at least a single exclusive anonymous THP in that
PMD range.

So ...  what happens when we switch to "is this folio mapped shared"
instead of "is this page mapped shared" by using
folio_likely_mapped_shared()?

For "not-COW-shared" folios, small folios and for THPs (large folios) that
are completely mapped into at least one process, switching to
folio_likely_mapped_shared() will not result in a change.

We'll only see a change for COW-shared PTE-mapped THPs that are partially
mapped into all involved processes.

There are two cases to consider:

(A) folio_likely_mapped_shared() returns "false" for a PTE-mapped THP

  If the folio is detected as exclusive, and it actually is exclusive,
  there is no change: page_mapcount() == 1. This is the common case
  without fork() or with short-lived child processes.

  folio_likely_mapped_shared() might currently still detect a folio as
  exclusive although it is shared (false negatives): if the first page is
  not mapped multiple times and if the average per-page mapcount is smaller
  than 1, implying that (1) the folio is partially mapped and (2) if we are
  responsible for many mapcounts by mapping many pages others can't
  ("mostly exclusive") (3) if we are not responsible for many mapcounts by
  mapping little pages ("mostly shared") it won't make a big impact on the
  end result.

  So while we might now detect a page as "exclusive" although it isn't,
  it's not expected to make a big difference in common cases.

(B) folio_likely_mapped_shared() returns "true" for a PTE-mapped THP

  folio_likely_mapped_shared() will never detect a large anonymous folio
  as shared although it is exclusive: there are no false positives.

  If we detect a THP as shared, at least one page of the THP is mapped by
  another process. It could well be that some pages are actually exclusive.
  For example, our child processes could have unmapped/COW'ed some pages
  such that they would now be exclusive to out process, which we now
  would treat as still-shared.

  Examples:
  (1) Parent maps all pages of a THP, child maps some pages. We detect
      all pages in the parent as shared although some are actually
      exclusive.
  (2) Parent maps all but some page of a THP, child maps the remainder.
      We detect all pages of the THP that the parent maps as shared
      although they are all exclusive.

  In (1) we wouldn't collapse a THP right now already: no PTE
  is writable, because a write fault would have resulted in COW of a
  single page and the parent would no longer map all pages of that THP.

  For (2) we would have collapsed a THP in the parent so far, now we
  wouldn't as long as the child process is still alive: unless the child
  process unmaps the remaining THP pages or we decide to split that THP.

  Possibly, the child COW'ed many pages, meaning that it's likely that
  we can populate a THP for our child first, and then for our parent.

  For (2), we are making really bad use of the THP in the first
  place (not even mapped completely in at least one process). If the
  THP would be completely partially mapped, it would be on the deferred
  split queue where we would split it lazily later.

  For short-running child processes, we don't particularly care. For
  long-running processes, the expectation is that such scenarios are
  rather rare: further, a THP might be best placed if most data in the
  PMD range is actually written, implying that we'll have to COW more
  pages first before khugepaged would collapse it.

To summarize, in the common case, this change is not expected to matter
much.  The more common application of khugepaged operates on exclusive
pages, either before fork() or after a child quit.

Can we improve (A)?  Yes, if we implement more precise tracking of "mapped
shared" vs.  "mapped exclusively", we could get rid of the false negatives
completely.

Can we improve (B)?  We could count how many pages of a large folio we map
inside the current page table and detect that we are responsible for most
of the folio mapcount and conclude "as good as exclusive", which might
help in some cases.  ...  but likely, some other mechanism should detect
that the THP is not a good use in the scenario (not even mapped completely
in a single process) and try splitting that folio lazily etc.

We'll move the folio_test_anon() check before our "shared" check, so we
might get more expressive results for SCAN_EXCEED_SHARED_PTE: this order
of checks now matches the one in __collapse_huge_page_isolate().  Extend
documentation.

Link: https://lkml.kernel.org/r/20240424122630.495788-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    3 +-
 mm/khugepaged.c                            |   22 ++++++++++++-------
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -278,7 +278,8 @@ collapsed, resulting fewer pages being c
 THPs, and lower memory access performance.
 
 ``max_ptes_shared`` specifies how many pages can be shared across multiple
-processes. Exceeding the number would block the collapse::
+processes. khugepaged might treat pages of THPs as shared if any page of
+that THP is shared. Exceeding the number would block the collapse::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_shared
 
--- a/mm/khugepaged.c~mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared
+++ a/mm/khugepaged.c
@@ -583,7 +583,8 @@ static int __collapse_huge_page_isolate(
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
-		if (page_mapcount(page) > 1) {
+		/* See hpage_collapse_scan_pmd(). */
+		if (folio_likely_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
 			    shared > khugepaged_max_ptes_shared) {
@@ -1317,8 +1318,20 @@ static int hpage_collapse_scan_pmd(struc
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
+		folio = page_folio(page);
 
-		if (page_mapcount(page) > 1) {
+		if (!folio_test_anon(folio)) {
+			result = SCAN_PAGE_ANON;
+			goto out_unmap;
+		}
+
+		/*
+		 * We treat a single page as shared if any part of the THP
+		 * is shared. "False negatives" from
+		 * folio_likely_mapped_shared() are not expected to matter
+		 * much in practice.
+		 */
+		if (folio_likely_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
 			    shared > khugepaged_max_ptes_shared) {
@@ -1328,7 +1341,6 @@ static int hpage_collapse_scan_pmd(struc
 			}
 		}
 
-		folio = page_folio(page);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
@@ -1349,10 +1361,6 @@ static int hpage_collapse_scan_pmd(struc
 			result = SCAN_PAGE_LOCK;
 			goto out_unmap;
 		}
-		if (!folio_test_anon(folio)) {
-			result = SCAN_PAGE_ANON;
-			goto out_unmap;
-		}
 
 		/*
 		 * Check if the page has any GUP (or other external) pins.
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch
drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

