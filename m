Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7525C38AC85
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779910526; cv=none; b=d6MYbeO4/yV0t7uBeNBZeXI/QZ7EUYmpVCI6QjEgyv2gQcygE1fE5g/muXb63g217iyZqdUmA/1lh6VQmfHMo4N7qj8Gqs5A+1QfTAWJ35gteNqiTv30JMclat+2mfRoqd8mPA/BJ5xAHRyol6arqzPfHOZqhTDXciR1WMuisIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779910526; c=relaxed/simple;
	bh=WePPK/dd9Mpcs1GMsOL2qItgcVH7RfY+amhsBE4NHi4=;
	h=Date:To:From:Subject:Message-Id; b=UL2MHpqzvlIsxpHMt/1srAHGGzSz8YoVFeyn8iDDT0X0NGhUzGeE90n+9r8sMCPJEDaSMo6Q9X37LVyrM/2+ncW5FAENrVKyFeF6vfl136ouEI8Svvb63/wU3GSXWbjU9vwmp1kiyjZ1WWM4fjpmjXdSwMbbo+qXtFFyBcg/+tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gr9T76ly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gr9T76ly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8891F00A3D;
	Wed, 27 May 2026 19:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779910510;
	bh=ItlmK36eV+j/lETIBEOaG2yUzllaIfspv55q9ojwjdo=;
	h=Date:To:From:Subject;
	b=Gr9T76lyty/dY1OefW8+NNBkvP40YHXb9dxVGx2nRLk1mw0VeF8MvKYqCzd5bTZPs
	 eXzO2F/BSmhw1fl4iztAVACbObFLf7wtwHfU9WTG0HoQjEqzz+f1eYMoLO+vGfLRzu
	 rsJgxB/Z2cyu/hS0N2taqBtzjJtZzL9LGjX47AVY=
Date: Wed, 27 May 2026 12:35:09 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,michael.bommarito@gmail.com,ljs@kernel.org,liam@infradead.org,devnexen@gmail.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-verify-vma-state-across-uffdio_copy-retry.patch added to mm-hotfixes-unstable branch
Message-Id: <20260527193510.5A8891F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: verify VMA state across UFFDIO_COPY retry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-verify-vma-state-across-uffdio_copy-retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-verify-vma-state-across-uffdio_copy-retry.patch

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
Subject: userfaultfd: verify VMA state across UFFDIO_COPY retry
Date: Wed, 27 May 2026 21:47:49 +0300

Patch series "userfaultfd: verify VMA state across UFFDIO_COPY retry", v2.

... and two more small fixes.


This patch (of 3):

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

There is no need to change for hugetlb because it never uses
mfill_copy_folio_retry().

Introduce helpers for more comprehensive comparison of VMA state:
- mfill_retry_state_save() to save the relevant VMA state into a struct
  mfill_retry_state (original uffd_ops, relevant VMA flags, vm_file and
  pgoff) before dropping the lock
- mfill_retry_state_changed() to compare the saved state with the state
  of the VMA acquired after retaking the locks
- mfill_retry_state_put() to release vm_file pinning.

Use DEFINE_FREE() cleanup to wrap mfill_retry_state_put() to avoid
complicating error handling paths in mfill_copy_folio_retry().

Link: https://lore.kernel.org/20260527184751.4147364-1-rppt@kernel.org
Link: https://lore.kernel.org/20260527184751.4147364-2-rppt@kernel.org
Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Peter Xu <peterx@redhat.com>
Co-developed-by: David Carlier <devnexen@gmail.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   85 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 73 insertions(+), 12 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-verify-vma-state-across-uffdio_copy-retry
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
@@ -443,16 +445,80 @@ static int mfill_copy_folio_locked(struc
 	return ret;
 }
 
-static int mfill_copy_folio_retry(struct mfill_state *state,
+#define MFILL_RETRY_STATE_VMA_FLAGS \
+	append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
+
+/*
+ * VMA state saved before dropping the locks in mfill_copy_folio_retry().
+ * Used to detect VMA replacement or incompatible changes after reacquiring the
+ * locks.
+ */
+struct mfill_retry_state {
+	const struct vm_uffd_ops *ops;
+	struct file *file;
+	vma_flags_t flags;
+	pgoff_t pgoff;
+};
+
+static void mfill_retry_state_save(struct mfill_retry_state *s,
+				   struct vm_area_struct *vma)
+{
+	s->flags = vma_flags_and_mask(&vma->flags, MFILL_RETRY_STATE_VMA_FLAGS);
+	s->ops = vma_uffd_ops(vma);
+	s->pgoff = vma->vm_pgoff;
+
+	if (vma->vm_file)
+		s->file = get_file(vma->vm_file);
+}
+
+static bool mfill_retry_state_changed(struct mfill_retry_state *state,
+				      struct vm_area_struct *vma)
+{
+	vma_flags_t flags = vma_flags_and_mask(&vma->flags,
+					       MFILL_RETRY_STATE_VMA_FLAGS);
+
+	/* Have any UFFD flags (missing, WP, minor) changed? */
+	if (!vma_flags_same_pair(&state->flags, &flags))
+		return true;
+
+	/* VMA type or effective uffd_ops changed while the lock was dropped */
+	if (state->ops != vma_uffd_ops(vma))
+		return true;
+
+	/* VMA was anonymous before; changed only if it no longer is */
+	if (!state->file)
+		return !vma_is_anonymous(vma);
+
+	/* VMA was file backed, but file, inode or offset has changed */
+	if (!vma->vm_file || vma->vm_file->f_inode != state->file->f_inode ||
+	    state->file != vma->vm_file || vma->vm_pgoff != state->pgoff)
+		return true;
+
+	return false;
+}
+
+static void mfill_retry_state_put(struct mfill_retry_state *s)
+{
+	if (s->file)
+		fput(s->file);
+}
+
+DEFINE_FREE(retry_put, struct mfill_retry_state *,
+	    if (_T) mfill_retry_state_put(_T));
+
+static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
 				  struct folio *folio)
 {
-	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
-	unsigned long src_addr = state->src_addr;
+	struct mfill_retry_state retry_state = { 0 };
+	struct mfill_retry_state *for_free __free(retry_put) = &retry_state;
+	unsigned long src_addr = mfill_state->src_addr;
 	void *kaddr;
 	int err;
 
+	mfill_retry_state_save(&retry_state, mfill_state->vma);
+
 	/* retry copying with mm_lock dropped */
-	mfill_put_vma(state);
+	mfill_put_vma(mfill_state);
 
 	kaddr = kmap_local_folio(folio, 0);
 	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
@@ -463,19 +529,14 @@ static int mfill_copy_folio_retry(struct
 	flush_dcache_folio(folio);
 
 	/* reget VMA and PMD, they could change underneath us */
-	err = mfill_get_vma(state);
+	err = mfill_get_vma(mfill_state);
 	if (err)
 		return err;
 
-	/*
-	 * The VMA type may have changed while the lock was dropped
-	 * (e.g. replaced with a hugetlb mapping), making the caller's
-	 * ops pointer stale.
-	 */
-	if (vma_uffd_ops(state->vma) != orig_ops)
+	if (mfill_retry_state_changed(&retry_state, mfill_state->vma))
 		return -EAGAIN;
 
-	err = mfill_establish_pmd(state);
+	err = mfill_establish_pmd(mfill_state);
 	if (err)
 		return err;
 
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

