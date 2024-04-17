Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520013D966
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 20:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713386866; cv=none; b=b4tHcq8fPPYevKbxNnWGlpEVj9J5KsmXEs3hCNjGKqnzz06iAJjUQHz+TNE72A5dHm+IfcR5DUxwEEF/EPy9C9DTustPCjOcc02L5vD5/ekyqhao1adk/sRb+MMQsHfPSchoFtRh0i1zGrSgSXenYwmdUEIMgMwK/od/HE1srss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713386866; c=relaxed/simple;
	bh=fFSI3t2rKBYoewwsu5v2E18OOgC1bouQKN/0eLH8uGw=;
	h=Date:To:From:Subject:Message-Id; b=lVw1ZldFwmTVrRkmorC+KC1mmqZ+yKWEEwMtBiqydt1IvBhIbgZWNJcFxp5uxqKTRnEyaoJsxuN1dbXUbh/xQ0O+Q8LIFz3+bSLR4IBUByxoxLtH3rVn9uv3cgcXeIO9Y9WABbbHP13hH4+LUb4FZUzEayXLVBc5LAqYhD9ybjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xzh4GJjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xzh4GJjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D85C072AA;
	Wed, 17 Apr 2024 20:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713386865;
	bh=fFSI3t2rKBYoewwsu5v2E18OOgC1bouQKN/0eLH8uGw=;
	h=Date:To:From:Subject:From;
	b=xzh4GJjvw7HG++GF8PoBqTboyldp9yO63rnLX+DADDLHvvJWfagmZRJsUvmiYXREn
	 ZPnG7lqoIc6Ny6mGnaXM3Na0Jh9fITlV2kAdQ/Hteum485xiTvdWY6zf3NEYIHQ8d0
	 KLTvOSdngtLYvkpcjiRveBvt1OLKn+vAF6XCVaNM=
Date: Wed, 17 Apr 2024 13:47:45 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch added to mm-unstable branch
Message-Id: <20240417204745.B7D85C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: convert pagemap_hugetlb_range() to work on folios
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch

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
Subject: fs/proc/task_mmu: convert pagemap_hugetlb_range() to work on folios
Date: Wed, 17 Apr 2024 11:23:12 +0200

Patch series "fs/proc/task_mmu: convert hugetlb functions to work on folis".

Let's convert two more functions, getting rid of two more page_mapcount()
calls.


This patch (of 2):

Let's get rid of another page_mapcount() check and simply use
folio_likely_mapped_shared(), which is precise for hugetlb folios.

While at it, also check for PMD table sharing, like we do in
smaps_hugetlb_range().

No functional change intended, except that we would now detect hugetlb
folios shared via PMD table sharing correctly.

Link: https://lkml.kernel.org/r/20240417092313.753919-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240417092313.753919-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios
+++ a/fs/proc/task_mmu.c
@@ -1578,12 +1578,13 @@ static int pagemap_hugetlb_range(pte_t *
 
 	pte = huge_ptep_get(ptep);
 	if (pte_present(pte)) {
-		struct page *page = pte_page(pte);
+		struct folio *folio = page_folio(pte_page(pte));
 
-		if (!PageAnon(page))
+		if (!folio_test_anon(folio))
 			flags |= PM_FILE;
 
-		if (page_mapcount(page) == 1)
+		if (!folio_likely_mapped_shared(folio) &&
+		    !hugetlb_pmd_shared(ptep))
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		if (huge_pte_uffd_wp(pte))
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
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

