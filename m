From: akpm@linux-foundation.org
Subject: + mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch added to -mm tree
Date: Mon, 01 Dec 2014 16:28:20 -0800
Message-ID: <547d07a4.dzXotHxM7W4rGQw5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaLBA2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2014 19:28:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove lock validation check for MADV_FREE
has been added to the -mm tree.  Its filename is
     mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove lock validation check for MADV_FREE

Currently, madvise_free_pte_range is called only madvise path which
already holds an mmap_sem so it's pointless to add the lock validation
check.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called-fix-2 mm/madvise.c
--- a/mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called-fix-2
+++ a/mm/madvise.c
@@ -275,18 +275,9 @@ static int madvise_free_pte_range(pmd_t
 
 	next = pmd_addr_end(addr, end);
 	if (pmd_trans_huge(*pmd)) {
-		if (next - addr != HPAGE_PMD_SIZE) {
-#ifdef CONFIG_DEBUG_VM
-			if (!rwsem_is_locked(&mm->mmap_sem)) {
-				pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
-					__func__, addr, end,
-					vma->vm_start,
-					vma->vm_end);
-				BUG();
-			}
-#endif
+		if (next - addr != HPAGE_PMD_SIZE)
 			split_huge_page_pmd(vma, addr, pmd);
-		} else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
+		else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
 			goto next;
 		/* fall through */
 	}
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
zram-remove-bio-parameter-from-zram_bvec_rw.patch
zram-change-parameter-from-vaild_io_request.patch
zram-implement-rw_page-operation-of-zram.patch
zram-implement-rw_page-operation-of-zram-fix.patch
zram-implement-rw_page-operation-of-zram-fix-2.patch
zram-implement-rw_page-operation-of-zram-fix-2-cleanup.patch
zram-implement-rw_page-operation-of-zram-fix-3.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
zsmalloc-correct-fragile-_atomic-use.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch

