Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160BA3CC323;
	Wed, 13 May 2026 23:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778714106; cv=none; b=QRMpFE9LPoKZ1rSq0wn4yI/TU1w6X4bYG2H2S3wIPtRX7EIe/h/MICs/SIbOIBqaLiyyx9FPdJ3Bp4xM1xKVXXElse26uw064u00q4D7QF4Wsdjqk14hKSczorbl8dYTH/QnBLxopmN0jOh+5/hqCfo/2yqfNeIc9pXaBHzQyyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778714106; c=relaxed/simple;
	bh=EWlxknBUuLAJpNU9FCMY/xu4GoSwo/c7hcv48hFJA5I=;
	h=Date:To:From:Subject:Message-Id; b=rEuo4yG0G4ALZbPeQcfXb3tbQRdkxCn9jIXcL+V+wjNu4jtSXKHb+NAHMUxd5uDRbxed7wcbIu6kPF+L0efcKjB1HD6IIT9BCFDAMTz9IhY+YECtOiccW5rcvUBtsajW0CB/djn/7ERttIL0QKcWz3xhA6IvghrdJiv9NYqm968=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lFXyBoMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lFXyBoMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE9EC19425;
	Wed, 13 May 2026 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778714105;
	bh=EWlxknBUuLAJpNU9FCMY/xu4GoSwo/c7hcv48hFJA5I=;
	h=Date:To:From:Subject:From;
	b=lFXyBoMoogaWZIEPcYqqm7oaQbVAYoR2JI5bMWsp4f4C/xV1yeE9MTYibwoML/SyT
	 vvWlwRworwQIB+JG/5ZZRmaQtvst9vTYyRif982BMrzFepjXP3l5LDOUjC+mcnE1Lf
	 FKuLPIXzMd0nNWx3oC9x72kic6lqxGiIWvoCaBKg=
Date: Wed, 13 May 2026 16:15:04 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,peterx@redhat.com,jack@suse.cz,david@kernel.org,brauner@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-ensure-mremap_userfaultfd_fail-releases-mmap_changing.patch added to mm-new branch
Message-Id: <20260513231505.6DE9EC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: ensure mremap_userfaultfd_fail() releases mmap_changing
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-ensure-mremap_userfaultfd_fail-releases-mmap_changing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-ensure-mremap_userfaultfd_fail-releases-mmap_changing.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: userfaultfd: ensure mremap_userfaultfd_fail() releases mmap_changing
Date: Wed, 13 May 2026 11:14:16 +0300

Sashiko says:

  mremap_userfaultfd_prep() increments ctx->mmap_changing to stall
  concurrent operations, but mremap_userfaultfd_fail() does not
  decrement it before dropping the context reference.

If an mremap operation fails, ctx->mmap_changing remains elevated. This
will causes subsequent userfaultfd operations like a UFFDIO_COPY to fail
with -EAGAIN.

Decrement ctx->mmap_changing in mremap_userfaultfd_fail().

Link: https://sashiko.dev/#/patchset/20260430113512.115938-1-rppt@kernel.org
Link: https://lore.kernel.org/20260513081416.495963-1-rppt@kernel.org
Fixes: df2cc96e7701 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/userfaultfd.c~userfaultfd-ensure-mremap_userfaultfd_fail-releases-mmap_changing
+++ a/fs/userfaultfd.c
@@ -786,6 +786,8 @@ void mremap_userfaultfd_fail(struct vm_u
 	if (!ctx)
 		return;
 
+	atomic_dec(&ctx->mmap_changing);
+	VM_WARN_ON_ONCE(atomic_read(&ctx->mmap_changing) < 0);
 	userfaultfd_ctx_put(ctx);
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
sh-fix-fallout-from-zero_page-consolidation.patch
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
userfaultfd-ensure-mremap_userfaultfd_fail-releases-mmap_changing.patch

