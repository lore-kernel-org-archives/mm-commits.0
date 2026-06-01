Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B0C30ACE3
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 04:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780289468; cv=none; b=es5lH08xoXDiGpoceVN91PY8xoNxywNzuerjJNDQYgTNtSbfmZYNJzxCSWEhzqQ3h6H/DXw0akoGQhhew99IKCHowuFXDD2cesWY6jYOI6Xky/Z11m930y4zEcabzRmLEPvEiECT8vXwIj5QjdedPqRjA/CIsH1XX0+BabCX1FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780289468; c=relaxed/simple;
	bh=yTwlWy/h2aVBUyLG4Tytzp+F6DeHRyCNJFMs9tMaD7E=;
	h=Date:To:From:Subject:Message-Id; b=FvV8iE11dXUR6SHZe+nb6LwSxcoLlarUQ/w+VSr5ILdkcEREvYYOGEgcq2/wxg/jIfIWapMLJwBexcXRkL2f5+oEOfMu/jEjWUYTA9kVvRhA4NFu8WvZd/YHKVYDpOeFYQEE7nqWtobz1yOtD31HqdWo1KHeQp4/AJU/k1FkWHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SuP1ktV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SuP1ktV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0041F00898;
	Mon,  1 Jun 2026 04:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780289466;
	bh=V6Bq9IHzSaOuxRoys4KpSWzjSxiGrpDP5GcUgUrJNCM=;
	h=Date:To:From:Subject;
	b=SuP1ktV6DtLMaS8zFrnr6J2L41bBqj6oJBHhkZBTpMgDAdJn7g7sNe/s5syjNl9Es
	 p9IzMrfAfgjeoDe63MFRyTb00SC+w9nwxUIQsdwt08fjRrhbJYE6CiZtDC0il7BPbL
	 KquOiazfBdxtfJzFXgJM/jrP5kOZc4OK9SXTfksg=
Date: Sun, 31 May 2026 21:51:06 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,michael.bommarito@gmail.com,ljs@kernel.org,liam@infradead.org,devnexen@gmail.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-refuse-to-__mfill_atomic_pte-for-unsupported-vmas.patch removed from -mm tree
Message-Id: <20260601045106.9E0041F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: refuse to __mfill_atomic_pte() for unsupported VMAs
has been removed from the -mm tree.  Its filename was
     userfaultfd-refuse-to-__mfill_atomic_pte-for-unsupported-vmas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: David CARLIER <devnexen@gmail.com>
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
xor-use-kmalloc-in-calibrate_xor_blocks.patch
raid6-use-kmalloc-in-raid6_select_algo.patch

