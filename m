From: akpm@linux-foundation.org
Subject: + userfaultfd-propagate-the-full-address-in-thp-faults.patch
 added to -mm tree
Date: Wed, 08 Jul 2015 15:42:14 -0700
Message-ID: <559da746.CXicowuo9OcJUi0n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbbGHWmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: propagate the full address in THP faults
has been added to the -mm tree.  Its filename is
     userfaultfd-propagate-the-full-address-in-thp-faults.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-propagate-the-full-address-in-thp-faults.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-propagate-the-full-address-in-thp-faults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: propagate the full address in THP faults

The THP faults were not propagating the original fault address.  The
latest version of the API with uffd.arg.pagefault.address is supposed to
propagate the full address through THP faults.

This was not a kernel crashing bug and it wouldn't risk to corrupt user
memory, but it would cause a SIGBUS failure because the wrong page was
being copied.

For various reasons this wasn't easily reproducible in the qemu workload,
but the strestest exposed the problem immediately.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~userfaultfd-propagate-the-full-address-in-thp-faults mm/huge_memory.c
--- a/mm/huge_memory.c~userfaultfd-propagate-the-full-address-in-thp-faults
+++ a/mm/huge_memory.c
@@ -717,13 +717,14 @@ static inline pmd_t mk_huge_pmd(struct p
 
 static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 					struct vm_area_struct *vma,
-					unsigned long haddr, pmd_t *pmd,
+					unsigned long address, pmd_t *pmd,
 					struct page *page, gfp_t gfp,
 					unsigned int flags)
 {
 	struct mem_cgroup *memcg;
 	pgtable_t pgtable;
 	spinlock_t *ptl;
+	unsigned long haddr = address & HPAGE_PMD_MASK;
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
@@ -765,7 +766,7 @@ static int __do_huge_pmd_anonymous_page(
 			mem_cgroup_cancel_charge(page, memcg);
 			put_page(page);
 			pte_free(mm, pgtable);
-			ret = handle_userfault(vma, haddr, flags,
+			ret = handle_userfault(vma, address, flags,
 					       VM_UFFD_MISSING);
 			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			return ret;
@@ -841,7 +842,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		if (pmd_none(*pmd)) {
 			if (userfaultfd_missing(vma)) {
 				spin_unlock(ptl);
-				ret = handle_userfault(vma, haddr, flags,
+				ret = handle_userfault(vma, address, flags,
 						       VM_UFFD_MISSING);
 				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			} else {
@@ -865,7 +866,8 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	return __do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page, gfp, flags);
+	return __do_huge_pmd_anonymous_page(mm, vma, address, pmd, page, gfp,
+					    flags);
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt-fix.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-uapi-add-missing-include-typesh.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-optimize-read-and-poll-to-be-o1-fix.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-activate-syscall-fix.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
userfaultfd-require-uffdio_api-before-other-ioctls.patch
userfaultfd-allow-signals-to-interrupt-a-userfault.patch
userfaultfd-propagate-the-full-address-in-thp-faults.patch
userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch
userfaultfd-selftest.patch
fs-userfaultfdc-work-around-i386-build-error.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

