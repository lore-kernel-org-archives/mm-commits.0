Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9F014A4CC;
	Wed, 17 Jun 2026 19:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781725514; cv=none; b=OLG9BP3NzsQpk8XvrJzwGP6xmij4CZ7Dr5WK3gybgMe0uFb6Rx98mbnJqtV/AopqUqB47gEaqJm6ANJgVWUh0+/OBTrfku2sAT3BA103UIWdeVdN9TenGnCUghfk7l4uLLXGprBADLFGug6JqKlrgMG1x4nZoLAJnP4l1jsBOhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781725514; c=relaxed/simple;
	bh=F9qnglnWAC53wXQrdPbDPyp3B75hBVYP2fxri6sZxaU=;
	h=Date:To:From:Subject:Message-Id; b=AQTTB5U78eRAvqFKfvPLyuMvfX7Kiv6fBXqPS+Co49nDrfTlSLc+LzT0GKzKAaEHYRMJDSGUNr/Xpuyu0hkg97Zq+7G8tE84geDXE7cSmM2jftVf6u1cCEdbUE5v2r2BPZqHwV/eX0ILKRnR/fopT9YeSowHOMExyKf9+o+UHyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OhBugnXH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OhBugnXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1601F000E9;
	Wed, 17 Jun 2026 19:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781725512;
	bh=KkvxBlLcuxqxJoK01eZY/PrgiLcteuiu06d4u62evXM=;
	h=Date:To:From:Subject;
	b=OhBugnXHm8mi0yzG0qBCdPHwMYJ45KYiXXyyG7lhkKNs/UK74hqHovtJuPmqgFEeM
	 yDgHQlywHX5DoZnATlCcfomiC3d97aoXIocmsOLMaWFasaIPK6D3e/EgStyCGwW3Wr
	 Ds447O2Fotod9wJvHBUaimBCrS+CUY3YnObg8zHc=
Date: Wed, 17 Jun 2026 12:45:12 -0700
To: mm-commits@vger.kernel.org,vladimirelitokarev@gmail.com,viro@zeniv.linux.org.uk,torvalds@linuxfoundation.org,stable@vger.kernel.org,peterx@redhat.com,oleg@redhat.com,jack@suse.cz,david@kernel.org,brauner@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-prevent-registration-of-special-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20260617194512.BF1601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: prevent registration of special VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-prevent-registration-of-special-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-prevent-registration-of-special-vmas.patch

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
Subject: userfaultfd: prevent registration of special VMAs
Date: Wed, 17 Jun 2026 22:40:59 +0300

Vova Tokarev says:

  userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
  access, you can register on the shadow stack, discard a page ... and
  inject a page with chosen return addresses via UFFDIO_COPY.

Update vma_can_userfault() to reject VM_SHADOW_STACK.

While on it, also reject VM_IO, VM_MIXEDMAP and VM_PFNMAP so that if a
driver would implement vm_uffd_ops, it wouldn't be possible to register
special VMAs with userfaultfd.

Link: https://lore.kernel.org/20260617194059.2529406-1-rppt@kernel.org
Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-prevent-registration-of-special-vmas
+++ a/mm/userfaultfd.c
@@ -2095,7 +2095,8 @@ bool vma_can_userfault(struct vm_area_st
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	if (vma->vm_flags & (VM_DROPPABLE | VM_IO | VM_MIXEDMAP | VM_PFNMAP |
+			     VM_SHADOW_STACK))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-prevent-registration-of-special-vmas.patch
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

