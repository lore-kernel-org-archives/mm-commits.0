From: akpm@linux-foundation.org
Subject: +
 userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch added to -mm tree
Date: Tue, 19 May 2015 14:39:05 -0700
Message-ID: <555bad79.G6ABmJTYVcc8RCUd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbESVjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 17:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation
has been added to the -mm tree.  Its filename is
     userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch

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
Subject: userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation

This implements mcopy_atomic and mfill_zeropage that are the lowlevel
VM methods that are invoked respectively by the UFFDIO_COPY and
UFFDIO_ZEROPAGE userfaultfd commands.

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

 include/linux/userfaultfd_k.h |    6 
 mm/Makefile                   |    1 
 mm/userfaultfd.c              |  269 ++++++++++++++++++++++++++++++++
 3 files changed, 276 insertions(+)

diff -puN include/linux/userfaultfd_k.h~userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation
+++ a/include/linux/userfaultfd_k.h
@@ -30,6 +30,12 @@
 extern int handle_userfault(struct vm_area_struct *vma, unsigned long address,
 			    unsigned int flags, unsigned long reason);
 
+extern ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
+			    unsigned long src_start, unsigned long len);
+extern ssize_t mfill_zeropage(struct mm_struct *dst_mm,
+			      unsigned long dst_start,
+			      unsigned long len);
+
 /* mm helpers */
 static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 					struct vm_userfaultfd_ctx vm_ctx)
diff -puN mm/Makefile~userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation mm/Makefile
--- a/mm/Makefile~userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation
+++ a/mm/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
+obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
diff -puN /dev/null mm/userfaultfd.c
--- /dev/null
+++ a/mm/userfaultfd.c
@@ -0,0 +1,269 @@
+/*
+ *  mm/userfaultfd.c
+ *
+ *  Copyright (C) 2015  Red Hat, Inc.
+ *
+ *  This work is licensed under the terms of the GNU GPL, version 2. See
+ *  the COPYING file in the top-level directory.
+ */
+
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/rmap.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
+#include <linux/userfaultfd_k.h>
+#include <linux/mmu_notifier.h>
+#include <asm/tlbflush.h>
+#include "internal.h"
+
+static int mcopy_atomic_pte(struct mm_struct *dst_mm,
+			    pmd_t *dst_pmd,
+			    struct vm_area_struct *dst_vma,
+			    unsigned long dst_addr,
+			    unsigned long src_addr)
+{
+	struct mem_cgroup *memcg;
+	pte_t _dst_pte, *dst_pte;
+	spinlock_t *ptl;
+	struct page *page;
+	void *page_kaddr;
+	int ret;
+
+	ret = -ENOMEM;
+	page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, dst_vma, dst_addr);
+	if (!page)
+		goto out;
+
+	page_kaddr = kmap(page);
+	ret = -EFAULT;
+	if (copy_from_user(page_kaddr, (const void __user *) src_addr,
+			   PAGE_SIZE))
+		goto out_kunmap_release;
+	kunmap(page);
+
+	/*
+	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * preceeding stores to the page contents become visible before
+	 * the set_pte_at() write.
+	 */
+	__SetPageUptodate(page);
+
+	ret = -ENOMEM;
+	if (mem_cgroup_try_charge(page, dst_mm, GFP_KERNEL, &memcg))
+		goto out_release;
+
+	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
+	if (dst_vma->vm_flags & VM_WRITE)
+		_dst_pte = pte_mkwrite(pte_mkdirty(_dst_pte));
+
+	ret = -EEXIST;
+	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
+	if (!pte_none(*dst_pte))
+		goto out_release_uncharge_unlock;
+
+	inc_mm_counter(dst_mm, MM_ANONPAGES);
+	page_add_new_anon_rmap(page, dst_vma, dst_addr);
+	mem_cgroup_commit_charge(page, memcg, false);
+	lru_cache_add_active_or_unevictable(page, dst_vma);
+
+	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
+
+	/* No need to invalidate - it was non-present before */
+	update_mmu_cache(dst_vma, dst_addr, dst_pte);
+
+	pte_unmap_unlock(dst_pte, ptl);
+	ret = 0;
+out:
+	return ret;
+out_release_uncharge_unlock:
+	pte_unmap_unlock(dst_pte, ptl);
+	mem_cgroup_cancel_charge(page, memcg);
+out_release:
+	page_cache_release(page);
+	goto out;
+out_kunmap_release:
+	kunmap(page);
+	goto out_release;
+}
+
+static int mfill_zeropage_pte(struct mm_struct *dst_mm,
+			      pmd_t *dst_pmd,
+			      struct vm_area_struct *dst_vma,
+			      unsigned long dst_addr)
+{
+	pte_t _dst_pte, *dst_pte;
+	spinlock_t *ptl;
+	int ret;
+
+	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
+					 dst_vma->vm_page_prot));
+	ret = -EEXIST;
+	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
+	if (!pte_none(*dst_pte))
+		goto out_unlock;
+	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
+	/* No need to invalidate - it was non-present before */
+	update_mmu_cache(dst_vma, dst_addr, dst_pte);
+	ret = 0;
+out_unlock:
+	pte_unmap_unlock(dst_pte, ptl);
+	return ret;
+}
+
+static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd = NULL;
+
+	pgd = pgd_offset(mm, address);
+	pud = pud_alloc(mm, pgd, address);
+	if (pud)
+		/*
+		 * Note that we didn't run this because the pmd was
+		 * missing, the *pmd may be already established and in
+		 * turn it may also be a trans_huge_pmd.
+		 */
+		pmd = pmd_alloc(mm, pud, address);
+	return pmd;
+}
+
+static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
+					      unsigned long dst_start,
+					      unsigned long src_start,
+					      unsigned long len,
+					      bool zeropage)
+{
+	struct vm_area_struct *dst_vma;
+	ssize_t err;
+	pmd_t *dst_pmd;
+	unsigned long src_addr, dst_addr;
+	long copied = 0;
+
+	/*
+	 * Sanitize the command parameters:
+	 */
+	BUG_ON(dst_start & ~PAGE_MASK);
+	BUG_ON(len & ~PAGE_MASK);
+
+	/* Does the address range wrap, or is the span zero-sized? */
+	BUG_ON(src_start + len <= src_start);
+	BUG_ON(dst_start + len <= dst_start);
+
+	down_read(&dst_mm->mmap_sem);
+
+	/*
+	 * Make sure the vma is not shared, that the dst range is
+	 * both valid and fully within a single existing vma.
+	 */
+	err = -EINVAL;
+	dst_vma = find_vma(dst_mm, dst_start);
+	if (!dst_vma || (dst_vma->vm_flags & VM_SHARED))
+		goto out;
+	if (dst_start < dst_vma->vm_start ||
+	    dst_start + len > dst_vma->vm_end)
+		goto out;
+
+	/*
+	 * Be strict and only allow __mcopy_atomic on userfaultfd
+	 * registered ranges to prevent userland errors going
+	 * unnoticed. As far as the VM consistency is concerned, it
+	 * would be perfectly safe to remove this check, but there's
+	 * no useful usage for __mcopy_atomic ouside of userfaultfd
+	 * registered ranges. This is after all why these are ioctls
+	 * belonging to the userfaultfd and not syscalls.
+	 */
+	if (!dst_vma->vm_userfaultfd_ctx.ctx)
+		goto out;
+
+	/*
+	 * FIXME: only allow copying on anonymous vmas, tmpfs should
+	 * be added.
+	 */
+	if (dst_vma->vm_ops)
+		goto out;
+
+	/*
+	 * Ensure the dst_vma has a anon_vma or this page
+	 * would get a NULL anon_vma when moved in the
+	 * dst_vma.
+	 */
+	err = -ENOMEM;
+	if (unlikely(anon_vma_prepare(dst_vma)))
+		goto out;
+
+	for (src_addr = src_start, dst_addr = dst_start;
+	     src_addr < src_start + len; ) {
+		pmd_t dst_pmdval;
+		BUG_ON(dst_addr >= dst_start + len);
+		dst_pmd = mm_alloc_pmd(dst_mm, dst_addr);
+		if (unlikely(!dst_pmd)) {
+			err = -ENOMEM;
+			break;
+		}
+
+		dst_pmdval = pmd_read_atomic(dst_pmd);
+		/*
+		 * If the dst_pmd is mapped as THP don't
+		 * override it and just be strict.
+		 */
+		if (unlikely(pmd_trans_huge(dst_pmdval))) {
+			err = -EEXIST;
+			break;
+		}
+		if (unlikely(pmd_none(dst_pmdval)) &&
+		    unlikely(__pte_alloc(dst_mm, dst_vma, dst_pmd,
+					 dst_addr))) {
+			err = -ENOMEM;
+			break;
+		}
+		/* If an huge pmd materialized from under us fail */
+		if (unlikely(pmd_trans_huge(*dst_pmd))) {
+			err = -EFAULT;
+			break;
+		}
+
+		BUG_ON(pmd_none(*dst_pmd));
+		BUG_ON(pmd_trans_huge(*dst_pmd));
+
+		if (!zeropage)
+			err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
+					       dst_addr, src_addr);
+		else
+			err = mfill_zeropage_pte(dst_mm, dst_pmd, dst_vma,
+						 dst_addr);
+
+		cond_resched();
+
+		if (!err) {
+			dst_addr += PAGE_SIZE;
+			src_addr += PAGE_SIZE;
+			copied += PAGE_SIZE;
+
+			if (fatal_signal_pending(current))
+				err = -EINTR;
+		}
+		if (err)
+			break;
+	}
+
+out:
+	up_read(&dst_mm->mmap_sem);
+	BUG_ON(copied < 0);
+	BUG_ON(err > 0);
+	BUG_ON(!copied && !err);
+	return copied ? copied : err;
+}
+
+ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
+		     unsigned long src_start, unsigned long len)
+{
+	return __mcopy_atomic(dst_mm, dst_start, src_start, len, false);
+}
+
+ssize_t mfill_zeropage(struct mm_struct *dst_mm, unsigned long start,
+		       unsigned long len)
+{
+	return __mcopy_atomic(dst_mm, start, 0, len, true);
+}
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

