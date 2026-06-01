Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1037032E692
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 04:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780289469; cv=none; b=uWnFQK0hWr17h8PSRiwtG7Ak9djhqET+FxxN813e5H1d1Eas82LLoZZ9X8p/liIEweVcsd8JGQYvvwVZ1VoWbVo2Vn/Yh0Xw86ZGBnGyIVLBDP5qh5dCfUQZuaC253+w+oKzuqc4+HfmRUdZqXyz4LOvMjQBFHeEyI/fF5q6638=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780289469; c=relaxed/simple;
	bh=I4nfVbNZTxsJb2MSbvd6h1L9VDHYYetncxnR3F4dwQo=;
	h=Date:To:From:Subject:Message-Id; b=c54fPvHOhPs8yIixKXoQDbN/yE4Wngco1O5gqcnuJFR93ybYKGay+uLO6SYxhDraJRxGrUulERqeNYmrTBnXiIuA8euYgZlRcf6nGdRA8VMbIhSdvMWjyizsUp36+vhJmCtSVCdZ8fSRCiTwUcjOlK7BxomGZqOLuREQ1m1d4tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WPre/+Of; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WPre/+Of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89AF1F00893;
	Mon,  1 Jun 2026 04:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780289468;
	bh=OGJK7iOcWee/1exNogSLTVL1zdNwJ7KWhsUszJPPAak=;
	h=Date:To:From:Subject;
	b=WPre/+Of6HkJjygtTg4nLIzYHqtR+b8vN9/sw+7V0hPY4FMS1VdHApxnJLXIjoFYK
	 4A023GsVAt81GgdQnvx3Ic3OTotXEaccBBgNgIlOYZq8IFZ5AhPsi5Dtb6M0ejBkea
	 NA10zdp1XQaMBgzAEhHxJHDB3M3WxGTyRbZWqF5Y=
Date: Sun, 31 May 2026 21:51:07 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,michael.bommarito@gmail.com,ljs@kernel.org,liam@infradead.org,devnexen@gmail.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-remove-redundant-check-in-vm_uffd_ops.patch removed from -mm tree
Message-Id: <20260601045107.D89AF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: remove redundant check in vm_uffd_ops()
has been removed from the -mm tree.  Its filename was
     userfaultfd-remove-redundant-check-in-vm_uffd_ops.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: remove redundant check in vm_uffd_ops()
Date: Wed, 27 May 2026 21:47:51 +0300

Lorenzo says:

  static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
  {
          if (vma_is_anonymous(vma))
                  return &anon_uffd_ops;
          return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
  }

  This is doing a redundant check _and_ making life confusing, as if
  !vma->vm_ops is a condition that can be reached there, it can't, as
  vma_is_anonymous() is literally a !vma->vm_ops check :)

Remove the redundant check.

Link: https://lore.kernel.org/20260527184751.4147364-4-rppt@kernel.org
Fixes: 0f48947c4232 ("userfaultfd: introduce vm_uffd_ops")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-remove-redundant-check-in-vm_uffd_ops
+++ a/mm/userfaultfd.c
@@ -68,7 +68,7 @@ static const struct vm_uffd_ops *vma_uff
 {
 	if (vma_is_anonymous(vma))
 		return &anon_uffd_ops;
-	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
+	return vma->vm_ops->uffd_ops;
 }
 
 static __always_inline
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

