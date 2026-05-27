Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BE0388E77
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779910525; cv=none; b=X05Ju4JRGMr6ccq9IG1lGFK7Q88MJsirp8BQKNRPxgLG2nI8+jYJ1PP51RoXrmsllrSPAtE5fnvMCHxcV5yCtf8VzXgcrNLv1+X/23GIJ+z2JGoGNowRGw8Xq9r1RjP8u2yLrL/N49mKZFeMVTWVyGfV2NCVMxmJEaDSoidbvfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779910525; c=relaxed/simple;
	bh=Fg6PncjcW0fbdVJxJbfW4j8nBxcuYabInenkrVN1rCo=;
	h=Date:To:From:Subject:Message-Id; b=SvHkwIc8Kx4RejxypUXjNzw6K1PI8KK3k+XpoXNW+DcwujJZ/34xrnOpoeu03UTOAOmaob9hqdwaALzeoDYT39YlLUZg9huGhd8bDj+QubG+IgbicZr+9J/DG4E5XkJJhY7Mz6BPm7t71vz/u8M6qCl9tXIyzQVJJfu3b0JKQP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qgDNOT/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qgDNOT/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DF71F000E9;
	Wed, 27 May 2026 19:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779910511;
	bh=U+eN9/k0TbdEGmlf8wuN/TVKuRXHunlusbXzuHqYoyE=;
	h=Date:To:From:Subject;
	b=qgDNOT/klTxSncZsv1R0DcXxg/btCOpPvfmtTNVcktiGcwe+QwDereXXuCU2HadXi
	 jpb1iamjQSgND/l4E3bjKQo25GoQOjL/wZ0xQo/F868pzpoU6CY1NEwPfpgLwnl8Nh
	 z2sEBuPA4DgP5YjtaJ1nboad++WgKuhOj2dVNl70=
Date: Wed, 27 May 2026 12:35:11 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,michael.bommarito@gmail.com,ljs@kernel.org,liam@infradead.org,devnexen@gmail.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-refuse-to-__mfill_atomic_pte-for-unsupported-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20260527193511.96DF71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: refuse to __mfill_atomic_pte() for unsupported VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-refuse-to-__mfill_atomic_pte-for-unsupported-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-refuse-to-__mfill_atomic_pte-for-unsupported-vmas.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: refuse to __mfill_atomic_pte() for unsupported VMAs
Date: Wed, 27 May 2026 21:47:50 +0300

__mfill_atomic_pte() unconditionally dereferences ops because there is an
assumption that VMAs that can undergo mfill_* operations are vetted on
registration and must have valid vm_uffd_ops.

Add a guard against potential bugs and make sure __mfill_atomic_pte()
bails out if ops is NULL.

Link: https://lore.kernel.org/20260527184751.4147364-3-rppt@kernel.org
Fixes: ad9ac3081332 ("userfaultfd: introduce vm_uffd_ops->alloc_folio()")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/userfaultfd.c~userfaultfd-refuse-to-__mfill_atomic_pte-for-unsupported-vmas
+++ a/mm/userfaultfd.c
@@ -552,6 +552,11 @@ static int __mfill_atomic_pte(struct mfi
 	struct folio *folio;
 	int ret;
 
+	if (!ops) {
+		VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");
+		return -EOPNOTSUPP;
+	}
+
 	folio = ops->alloc_folio(state->vma, state->dst_addr);
 	if (!folio)
 		return -ENOMEM;
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-verify-vma-state-across-uffdio_copy-retry.patch
userfaultfd-refuse-to-__mfill_atomic_pte-for-unsupported-vmas.patch
userfaultfd-remove-redundant-check-in-vm_uffd_ops.patch
userfaultfd-ensure-mremap_userfaultfd_fail-releases-mmap_changing.patch
userfaultfd-merge-fs-userfaultfdc-into-mm-userfaultfdc.patch
userfaultfd-make-functions-that-are-not-used-outside-uffd-static.patch
selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch
selftests-mm-migration-dont-assume-huge-page-is-twomeg.patch
selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch
selftests-mm-migration-properly-cleanup-forked-processes.patch
selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch
selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch
selftests-mm-rename-hugepage-tests-to-hugetlb.patch
selftests-mm-hugetlb-shm-use-kselftest-framework.patch
selftests-mm-hugetlb-vmemmap-use-kselftest-framework.patch
selftests-mm-hugetlb-madvise-use-kselftest-framework.patch
selftests-mm-hugetlb_madv_vs_map-use-kselftest-framework.patch
selftests-mm-hugetlb-read-hwpoison-use-kselftest-framework.patch
selftests-mm-khugepaged-group-tests-in-an-array.patch
selftests-mm-khugepaged-use-ksefltest-framework.patch
selftests-mm-khugepaged-use-ksefltest-framework-fix.patch
selftests-mm-ksm_tests-use-kselftest-framework.patch
selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch
selftests-mm-protection_keys-use-kselftest-framework.patch
selftests-mm-uffd-common-use-kselftest-framework.patch
selftests-mm-uffd-stress-use-kselftest-framework.patch
selftests-mm-uffd-unit-tests-use-kselftest-framework.patch
selftests-mm-va_high_addr_switch-use-kselftest-framework.patch
selftests-mm-add-atexit-and-signal-handlers-to-thp_settings.patch
selftests-mm-rename-thp_settings-to-hugepage_settings.patch
selftests-mm-move-hugetlb-helpers-to-hugepage_settings.patch
selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch
selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch
selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch
selftests-mm-hugepage_settings-add-apis-for-hugetlb-setup-and-teardown.patch
selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch
selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch
selftests-mm-compaction_test-use-hugetlb-helpers.patch
selftests-mm-cow-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch
selftests-mm-hmm-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-hugepage_dio-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch
selftests-mm-migration-add-setup-of-hugetlb-pages.patch
selftests-mm-pagemap_ioctl-add-setup-of-hugetlb-pages.patch
selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch
selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch
selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch
selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch
selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch
lib-raid-use-kvmalloc-in-calibrate_xor_blocks.patch
lib-raid6-use-kvmalloc-in-raid6_select_algo.patch

