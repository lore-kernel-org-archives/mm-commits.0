Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C30E3655EE
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 19:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779909768; cv=none; b=AiLVCyycXpYk7FLF3tmv3QEuaavj6PWdOItVYp4LdJzh1i+hD0s6iXM71Wb/wptEPLeIivJMLy5mSEh2xOHsEOIBhSGi7coVt8oxdydgDan761esWR2/JB/L8y1WvyuiLSM2z6MOPbMdQSspYwge6YL72svFA3x+FeCt1SgqRhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779909768; c=relaxed/simple;
	bh=UXZUfUnB48NMv5CslFDRZWQf9Mg2n2gF8qAKr2JUO2E=;
	h=Date:To:From:Subject:Message-Id; b=rCY/fziAyMnGQ5BMCZ6C6oYwPz90eGqcDPdfX85sQJbVTZfudJt0iapm3K4HmRVhfSzeVdRIqa6ZKOdQDLQ95BDJxbwBJ+LjSWelxDCIdn0RcwgiiHDeaG1B3AtHs7Qv7dfqxz9ZDRU+dt0wLPDmRkW7SwOSbOCCewk/NyAV6qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z4y15cJS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z4y15cJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939EE1F000E9;
	Wed, 27 May 2026 19:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779909766;
	bh=T+838lbidLnSykmGp39gAjmwKShqZFKQKUsnJ8qsU8o=;
	h=Date:To:From:Subject;
	b=z4y15cJSibBubjPme5wLMsit2CjjwC+/6ew8uUwTAUtzw2zNhYTy+i8LorCQL0mo/
	 WZFzB+GWV0RvgQRWNYB06tFw/0bAztJ3LAHOaHFN4IKKhHKQz7PtFgCGZKniwfcs0P
	 XUU0cNn9r03aUydbMHEz1wZ3WeFeKYFR1ZYRKDpo=
Date: Wed, 27 May 2026 12:22:46 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,michael.bommarito@gmail.com,ljs@kernel.org,liam@infradead.org,gganji11@naver.com,devnexen@gmail.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] userfaultfd-snapshot-vma-state-across-uffdio_copy-retry.patch removed from -mm tree
Message-Id: <20260527192246.939EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: snapshot VMA state across UFFDIO_COPY retry
has been removed from the -mm tree.  Its filename was
     userfaultfd-snapshot-vma-state-across-uffdio_copy-retry.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: snapshot VMA state across UFFDIO_COPY retry
Date: Tue, 19 May 2026 08:25:16 +0300

mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
reacquires it afterwards.  The destination VMA can be replaced during that
window.

The existing check compares vma_uffd_ops() before and after the retry, but
if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
MAP_PRIVATE (or vice versa) the replacement goes undetected.

The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
with shmem_alloc_folio() as anonymous and this will cause BUG() when
mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().

The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
the page cache of the original VMA.

Introduce helpers for more comprehensive comparison of VMA state:
- vma_snapshot_get() to save the relevant VMA state into a struct
  vma_snapshot (original uffd_ops, actual uffd_ops, relevant VMA flags,
  vm_file and pgoff) before dropping the lock
- vma_snapshot_changed() to compare the saved state with the state of the
  VMA acquired after retaking the locks
- vma_snapshot_put() to release vm_file pinning.

Use DEFINE_FREE() cleanup to wrap vma_snapshot_put() to avoid complicating
error handling paths in mfill_copy_folio_retry().

Add vma_uffd_copy_ops() to avoid code duplication when original ops of
shmem VMA with MAP_PRIVATE are replaced with anon_uffd_ops.

Link: https://lore.kernel.org/20260519052516.3315196-1-rppt@kernel.org
Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Co-developed-by: David Carlier <devnexen@gmail.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
Tested-by: Heechan Kang <gganji11@naver.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   99 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 79 insertions(+), 20 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-snapshot-vma-state-across-uffdio_copy-retry
+++ a/mm/userfaultfd.c
@@ -14,6 +14,8 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
+#include <linux/file.h>
+#include <linux/cleanup.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include "internal.h"
@@ -69,6 +71,24 @@ static const struct vm_uffd_ops *vma_uff
 	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
 }
 
+static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)
+{
+	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
+
+	if (!ops)
+		return NULL;
+
+	/*
+	 * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
+	 * memory. This is an effective ops override, so retry validation must
+	 * compare the override result, not just vma->vm_ops->uffd_ops.
+	 */
+	if (!(vma->vm_flags & VM_SHARED))
+		return &anon_uffd_ops;
+
+	return ops;
+}
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -443,14 +463,70 @@ static int mfill_copy_folio_locked(struc
 	return ret;
 }
 
+#define VMA_SNAPSHOT_FLAGS append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
+
+struct vma_snapshot {
+	const struct vm_uffd_ops *copy_ops;
+	const struct vm_uffd_ops *ops;
+	struct file *file;
+	vma_flags_t flags;
+	pgoff_t pgoff;
+};
+
+static void vma_snapshot_get(struct vma_snapshot *s, struct vm_area_struct *vma)
+{
+	s->flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
+	s->copy_ops = vma_uffd_copy_ops(vma);
+	s->ops = vma_uffd_ops(vma);
+	s->pgoff = vma->vm_pgoff;
+
+	if (vma->vm_file)
+		s->file = get_file(vma->vm_file);
+}
+
+static bool vma_snapshot_changed(struct vma_snapshot *s,
+				 struct vm_area_struct *vma)
+{
+	vma_flags_t flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
+
+	if (!vma_flags_same_pair(&s->flags, &flags))
+		return true;
+
+	/* VMA type or effective uffd_ops changed while the lock was dropped */
+	if (s->ops != vma_uffd_ops(vma) || s->copy_ops != vma_uffd_copy_ops(vma))
+		return true;
+
+	/* VMA was anonymous before; changed only if it no longer is */
+	if (!s->file)
+		return !vma_is_anonymous(vma);
+
+	/* VMA was file backed, but inode or offset has changed */
+	if (!vma->vm_file || vma->vm_file->f_inode != s->file->f_inode ||
+	    vma->vm_pgoff != s->pgoff)
+		return true;
+
+	return false;
+}
+
+static void vma_snapshot_put(struct vma_snapshot *s)
+{
+	if (s->file)
+		fput(s->file);
+}
+
+DEFINE_FREE(snapshot_put, struct vma_snapshot *, if (_T) vma_snapshot_put(_T));
+
 static int mfill_copy_folio_retry(struct mfill_state *state,
 				  struct folio *folio)
 {
-	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
+	struct vma_snapshot s = { 0 };
+	struct vma_snapshot *p __free(snapshot_put) = &s;
 	unsigned long src_addr = state->src_addr;
 	void *kaddr;
 	int err;
 
+	vma_snapshot_get(&s, state->vma);
+
 	/* retry copying with mm_lock dropped */
 	mfill_put_vma(state);
 
@@ -467,12 +543,7 @@ static int mfill_copy_folio_retry(struct
 	if (err)
 		return err;
 
-	/*
-	 * The VMA type may have changed while the lock was dropped
-	 * (e.g. replaced with a hugetlb mapping), making the caller's
-	 * ops pointer stale.
-	 */
-	if (vma_uffd_ops(state->vma) != orig_ops)
+	if (vma_snapshot_changed(&s, state->vma))
 		return -EAGAIN;
 
 	err = mfill_establish_pmd(state);
@@ -545,19 +616,7 @@ err_folio_put:
 
 static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
-
-	/*
-	 * The normal page fault path for a MAP_PRIVATE mapping in a
-	 * file-backed VMA will invoke the fault, fill the hole in the file and
-	 * COW it right away. The result generates plain anonymous memory.
-	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
-	 * generate anonymous memory directly without actually filling the
-	 * hole. For the MAP_PRIVATE case the robustness check only happens in
-	 * the pagetable (to verify it's still none) and not in the page cache.
-	 */
-	if (!(state->vma->vm_flags & VM_SHARED))
-		ops = &anon_uffd_ops;
+	const struct vm_uffd_ops *ops = vma_uffd_copy_ops(state->vma);
 
 	return __mfill_atomic_pte(state, ops);
 }
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
lib-raid-use-kvmalloc-in-calibrate_xor_blocks.patch
lib-raid6-use-kvmalloc-in-raid6_select_algo.patch

