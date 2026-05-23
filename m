Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105512DCBE3
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 18:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779560925; cv=none; b=P8Z8tSjZQPIOjO0vkybquOxw50LMUPO60nCaTKAK6C6w5pMzF5B/fovyce8Gq7lYnfpLNPPUFo8AotZqilEPyD/IeBySL4UudgcRXGmo2a6zY3Rl4E+rDpRL2M7U+EauBN6Rwv8sb5+rsNg+7ImYPup4sRtdWKqR7LocHEXTEa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779560925; c=relaxed/simple;
	bh=rIGo4LR5hq2zYg3K5Q2pCVpy3Q1vsuEubHqWhpCGiMs=;
	h=Date:To:From:Subject:Message-Id; b=hSIVRnY/YyUD6qG8XFkf9tCIa9nCeApHiPilcvUMdwiZBQdwYKwQ67aL2bni2J8im1rUs58RO4uAqZzcURwr08hI/8UZWUQWImuY/Ar59J5Zm2VomyrvU8379c708ebDvr8vUax31yCDMPxQ9u71VAornMzdpRJbMM8DF9YUKaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DOaPADj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DOaPADj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E781F00A3A;
	Sat, 23 May 2026 18:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779560923;
	bh=EecW/yFldRzOE4i51yRjJ9WWFDG4V9jrMjx9pi7fnDo=;
	h=Date:To:From:Subject;
	b=DOaPADj0XMZVfeBcM42TsSrAunen+hPgpnDqfA3sMZGKWSPkZzddVoNAwTSqjsx/9
	 nc8K+4Sw+g1hMwMKxZvu7GICorDZVlGr6s5py8R8Jzc4voC9DGf5O/DhxmSyai/m+o
	 EcN04jSl6ZJ+gkj/crHsoQaMOLAvXr4eLH7xIIA8=
Date: Sat, 23 May 2026 11:28:43 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,kirill@shutemov.name,jack@suse.cz,david@kernel.org,brauner@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-make-functions-that-are-not-used-outside-uffd-static.patch added to mm-new branch
Message-Id: <20260523182843.A5E781F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: make functions that are not used outside uffd static
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-make-functions-that-are-not-used-outside-uffd-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-make-functions-that-are-not-used-outside-uffd-static.patch

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
Subject: userfaultfd: make functions that are not used outside uffd static
Date: Sat, 23 May 2026 20:37:59 +0300

After merging fs/userfaultfd.c into mm/userfaultfd.c, several functions
that were previously shared between the two files are now only used within
mm/userfaultfd.c.

Make them static and remove their declarations from
include/linux/userfaultfd_k.h.

Link: https://lore.kernel.org/20260523173759.3964908-3-rppt@kernel.org
Assisted-by: Copilot:claude-opus-4-6
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |   36 --------------------------------
 mm/userfaultfd.c              |   24 ++++++++++-----------
 2 files changed, 12 insertions(+), 48 deletions(-)

--- a/include/linux/userfaultfd_k.h~userfaultfd-make-functions-that-are-not-used-outside-uffd-static
+++ a/include/linux/userfaultfd_k.h
@@ -147,26 +147,12 @@ static inline uffd_flags_t uffd_flags_se
 /* Flags controlling behavior. These behavior changes are mode-independent. */
 #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
 
-extern ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
-				 unsigned long src_start, unsigned long len,
-				 uffd_flags_t flags);
-extern ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
-				     unsigned long dst_start,
-				     unsigned long len);
-extern ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long dst_start,
-				     unsigned long len, uffd_flags_t flags);
-extern ssize_t mfill_atomic_poison(struct userfaultfd_ctx *ctx, unsigned long start,
-				   unsigned long len, uffd_flags_t flags);
-extern int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
-			       unsigned long len, bool enable_wp);
 extern long uffd_wp_range(struct vm_area_struct *vma,
 			  unsigned long start, unsigned long len, bool enable_wp);
 
 /* move_pages */
 void double_pt_lock(spinlock_t *ptl1, spinlock_t *ptl2);
 void double_pt_unlock(spinlock_t *ptl1, spinlock_t *ptl2);
-ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
-		   unsigned long src_start, unsigned long len, __u64 flags);
 int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pmd_t dst_pmdval,
 			struct vm_area_struct *dst_vma,
 			struct vm_area_struct *src_vma,
@@ -239,9 +225,6 @@ static inline bool userfaultfd_armed(str
 	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
-bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
-		       bool wp_async);
-
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
 	struct userfaultfd_ctx *uffd_ctx = vma->vm_userfaultfd_ctx.ctx;
@@ -271,25 +254,6 @@ extern void userfaultfd_unmap_complete(s
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
 
-void userfaultfd_reset_ctx(struct vm_area_struct *vma);
-
-struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
-					     struct vm_area_struct *prev,
-					     struct vm_area_struct *vma,
-					     unsigned long start,
-					     unsigned long end);
-
-int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
-			       struct vm_area_struct *vma,
-			       vm_flags_t vm_flags,
-			       unsigned long start, unsigned long end,
-			       bool wp_async);
-
-void userfaultfd_release_new(struct userfaultfd_ctx *ctx);
-
-void userfaultfd_release_all(struct mm_struct *mm,
-			     struct userfaultfd_ctx *ctx);
-
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
 	/* Only wr-protect mode uses pte markers */
--- a/mm/userfaultfd.c~userfaultfd-make-functions-that-are-not-used-outside-uffd-static
+++ a/mm/userfaultfd.c
@@ -1026,7 +1026,7 @@ out:
 	return copied ? copied : err;
 }
 
-ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
+static ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			  unsigned long src_start, unsigned long len,
 			  uffd_flags_t flags)
 {
@@ -1034,7 +1034,7 @@ ssize_t mfill_atomic_copy(struct userfau
 			    uffd_flags_set_mode(flags, MFILL_ATOMIC_COPY));
 }
 
-ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
+static ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
 			      unsigned long start,
 			      unsigned long len)
 {
@@ -1042,7 +1042,7 @@ ssize_t mfill_atomic_zeropage(struct use
 			    uffd_flags_set_mode(0, MFILL_ATOMIC_ZEROPAGE));
 }
 
-ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long start,
+static ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long start,
 			      unsigned long len, uffd_flags_t flags)
 {
 
@@ -1058,7 +1058,7 @@ ssize_t mfill_atomic_continue(struct use
 			    uffd_flags_set_mode(flags, MFILL_ATOMIC_CONTINUE));
 }
 
-ssize_t mfill_atomic_poison(struct userfaultfd_ctx *ctx, unsigned long start,
+static ssize_t mfill_atomic_poison(struct userfaultfd_ctx *ctx, unsigned long start,
 			    unsigned long len, uffd_flags_t flags)
 {
 	return mfill_atomic(ctx, start, 0, len,
@@ -1094,7 +1094,7 @@ long uffd_wp_range(struct vm_area_struct
 	return ret;
 }
 
-int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
+static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
 			unsigned long len, bool enable_wp)
 {
 	struct mm_struct *dst_mm = ctx->mm;
@@ -1924,7 +1924,7 @@ static void uffd_move_unlock(struct vm_a
  * in the regions or not, but preventing the risk of having to split
  * the hugepmd during the remap.
  */
-ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
+static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 		   unsigned long src_start, unsigned long len, __u64 mode)
 {
 	struct mm_struct *mm = ctx->mm;
@@ -2099,7 +2099,7 @@ out:
 	return moved ? moved : err;
 }
 
-bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 		       bool wp_async)
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
@@ -2156,12 +2156,12 @@ static void userfaultfd_set_ctx(struct v
 				 (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags);
 }
 
-void userfaultfd_reset_ctx(struct vm_area_struct *vma)
+static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
 {
 	userfaultfd_set_ctx(vma, NULL, 0);
 }
 
-struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
+static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 					     struct vm_area_struct *prev,
 					     struct vm_area_struct *vma,
 					     unsigned long start,
@@ -2200,7 +2200,7 @@ struct vm_area_struct *userfaultfd_clear
 }
 
 /* Assumes mmap write lock taken, and mm_struct pinned. */
-int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
+static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 			       struct vm_area_struct *vma,
 			       vm_flags_t vm_flags,
 			       unsigned long start, unsigned long end,
@@ -2264,7 +2264,7 @@ skip:
 	return 0;
 }
 
-void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
+static void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
 {
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *vma;
@@ -2279,7 +2279,7 @@ void userfaultfd_release_new(struct user
 	mmap_write_unlock(mm);
 }
 
-void userfaultfd_release_all(struct mm_struct *mm,
+static void userfaultfd_release_all(struct mm_struct *mm,
 			     struct userfaultfd_ctx *ctx)
 {
 	struct vm_area_struct *vma, *prev;
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-snapshot-vma-state-across-uffdio_copy-retry.patch
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
userfaultfd-merge-fs-userfaultfdc-into-mm-userfaultfdc.patch
userfaultfd-make-functions-that-are-not-used-outside-uffd-static.patch

