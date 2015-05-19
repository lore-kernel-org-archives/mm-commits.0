From: akpm@linux-foundation.org
Subject: + userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch added to -mm tree
Date: Tue, 19 May 2015 14:39:08 -0700
Message-ID: <555bad7c.kEAHEcFtG4elMA8C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbESVjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 17:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: avoid mmap_sem read recursion in mcopy_atomic
has been added to the -mm tree.  Its filename is
     userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch

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
Subject: userfaultfd: avoid mmap_sem read recursion in mcopy_atomic

If the rwsem starves writers it wasn't strictly a bug but lockdep
doesn't like it and this avoids depending on lowlevel implementation
details of the lock.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   92 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 66 insertions(+), 26 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic
+++ a/mm/userfaultfd.c
@@ -21,26 +21,39 @@ static int mcopy_atomic_pte(struct mm_st
 			    pmd_t *dst_pmd,
 			    struct vm_area_struct *dst_vma,
 			    unsigned long dst_addr,
-			    unsigned long src_addr)
+			    unsigned long src_addr,
+			    struct page **pagep)
 {
 	struct mem_cgroup *memcg;
 	pte_t _dst_pte, *dst_pte;
 	spinlock_t *ptl;
-	struct page *page;
 	void *page_kaddr;
 	int ret;
+	struct page *page;
 
-	ret = -ENOMEM;
-	page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, dst_vma, dst_addr);
-	if (!page)
-		goto out;
-
-	page_kaddr = kmap(page);
-	ret = -EFAULT;
-	if (copy_from_user(page_kaddr, (const void __user *) src_addr,
-			   PAGE_SIZE))
-		goto out_kunmap_release;
-	kunmap(page);
+	if (!*pagep) {
+		ret = -ENOMEM;
+		page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, dst_vma, dst_addr);
+		if (!page)
+			goto out;
+
+		page_kaddr = kmap_atomic(page);
+		ret = copy_from_user(page_kaddr,
+				     (const void __user *) src_addr,
+				     PAGE_SIZE);
+		kunmap_atomic(page_kaddr);
+
+		/* fallback to copy_from_user outside mmap_sem */
+		if (unlikely(ret)) {
+			ret = -EFAULT;
+			*pagep = page;
+			/* don't free the page */
+			goto out;
+		}
+	} else {
+		page = *pagep;
+		*pagep = NULL;
+	}
 
 	/*
 	 * The memory barrier inside __SetPageUptodate makes sure that
@@ -82,9 +95,6 @@ out_release_uncharge_unlock:
 out_release:
 	page_cache_release(page);
 	goto out;
-out_kunmap_release:
-	kunmap(page);
-	goto out_release;
 }
 
 static int mfill_zeropage_pte(struct mm_struct *dst_mm,
@@ -139,7 +149,8 @@ static __always_inline ssize_t __mcopy_a
 	ssize_t err;
 	pmd_t *dst_pmd;
 	unsigned long src_addr, dst_addr;
-	long copied = 0;
+	long copied;
+	struct page *page;
 
 	/*
 	 * Sanitize the command parameters:
@@ -151,6 +162,11 @@ static __always_inline ssize_t __mcopy_a
 	BUG_ON(src_start + len <= src_start);
 	BUG_ON(dst_start + len <= dst_start);
 
+	src_addr = src_start;
+	dst_addr = dst_start;
+	copied = 0;
+	page = NULL;
+retry:
 	down_read(&dst_mm->mmap_sem);
 
 	/*
@@ -160,10 +176,10 @@ static __always_inline ssize_t __mcopy_a
 	err = -EINVAL;
 	dst_vma = find_vma(dst_mm, dst_start);
 	if (!dst_vma || (dst_vma->vm_flags & VM_SHARED))
-		goto out;
+		goto out_unlock;
 	if (dst_start < dst_vma->vm_start ||
 	    dst_start + len > dst_vma->vm_end)
-		goto out;
+		goto out_unlock;
 
 	/*
 	 * Be strict and only allow __mcopy_atomic on userfaultfd
@@ -175,14 +191,14 @@ static __always_inline ssize_t __mcopy_a
 	 * belonging to the userfaultfd and not syscalls.
 	 */
 	if (!dst_vma->vm_userfaultfd_ctx.ctx)
-		goto out;
+		goto out_unlock;
 
 	/*
 	 * FIXME: only allow copying on anonymous vmas, tmpfs should
 	 * be added.
 	 */
 	if (dst_vma->vm_ops)
-		goto out;
+		goto out_unlock;
 
 	/*
 	 * Ensure the dst_vma has a anon_vma or this page
@@ -191,12 +207,13 @@ static __always_inline ssize_t __mcopy_a
 	 */
 	err = -ENOMEM;
 	if (unlikely(anon_vma_prepare(dst_vma)))
-		goto out;
+		goto out_unlock;
 
-	for (src_addr = src_start, dst_addr = dst_start;
-	     src_addr < src_start + len; ) {
+	while (src_addr < src_start + len) {
 		pmd_t dst_pmdval;
+
 		BUG_ON(dst_addr >= dst_start + len);
+
 		dst_pmd = mm_alloc_pmd(dst_mm, dst_addr);
 		if (unlikely(!dst_pmd)) {
 			err = -ENOMEM;
@@ -229,13 +246,33 @@ static __always_inline ssize_t __mcopy_a
 
 		if (!zeropage)
 			err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
-					       dst_addr, src_addr);
+					       dst_addr, src_addr, &page);
 		else
 			err = mfill_zeropage_pte(dst_mm, dst_pmd, dst_vma,
 						 dst_addr);
 
 		cond_resched();
 
+		if (unlikely(err == -EFAULT)) {
+			void *page_kaddr;
+
+			BUILD_BUG_ON(zeropage);
+			up_read(&dst_mm->mmap_sem);
+			BUG_ON(!page);
+
+			page_kaddr = kmap(page);
+			err = copy_from_user(page_kaddr,
+					     (const void __user *) src_addr,
+					     PAGE_SIZE);
+			kunmap(page);
+			if (unlikely(err)) {
+				err = -EFAULT;
+				goto out;
+			}
+			goto retry;
+		} else
+			BUG_ON(page);
+
 		if (!err) {
 			dst_addr += PAGE_SIZE;
 			src_addr += PAGE_SIZE;
@@ -248,8 +285,11 @@ static __always_inline ssize_t __mcopy_a
 			break;
 	}
 
-out:
+out_unlock:
 	up_read(&dst_mm->mmap_sem);
+out:
+	if (page)
+		page_cache_release(page);
 	BUG_ON(copied < 0);
 	BUG_ON(err > 0);
 	BUG_ON(!copied && !err);
_

Patches currently in -mm which might be from aarcange@redhat.com are

thp-cleanup-how-khugepaged-enters-freezer.patch
mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
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

