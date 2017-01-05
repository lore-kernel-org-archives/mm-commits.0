From: akpm@linux-foundation.org
Subject: +
 userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:53:56 -0800
Message-ID: <586d9924.ljZqJGw/vVvbX6Xv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934813AbdAEAyV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY

__mcopy_atomic_hugetlb performs the UFFDIO_COPY operation for huge pages. 
It is based on the existing __mcopy_atomic routine for normal pages. 
Unlike normal pages, there is no huge page support for the UFFDIO_ZEROPAGE
operation.

Link: http://lkml.kernel.org/r/20161216144821.5183-19-aarcange@redhat.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |  186 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 186 insertions(+)

diff -puN mm/userfaultfd.c~userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy
+++ a/mm/userfaultfd.c
@@ -14,6 +14,8 @@
 #include <linux/swapops.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mmu_notifier.h>
+#include <linux/hugetlb.h>
+#include <linux/pagemap.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
 
@@ -139,6 +141,183 @@ static pmd_t *mm_alloc_pmd(struct mm_str
 	return pmd;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+/*
+ * __mcopy_atomic processing for HUGETLB vmas.  Note that this routine is
+ * called with mmap_sem held, it will release mmap_sem before returning.
+ */
+static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
+					      struct vm_area_struct *dst_vma,
+					      unsigned long dst_start,
+					      unsigned long src_start,
+					      unsigned long len,
+					      bool zeropage)
+{
+	ssize_t err;
+	pte_t *dst_pte;
+	unsigned long src_addr, dst_addr;
+	long copied;
+	struct page *page;
+	struct hstate *h;
+	unsigned long vma_hpagesize;
+	pgoff_t idx;
+	u32 hash;
+	struct address_space *mapping;
+
+	/*
+	 * There is no default zero huge page for all huge page sizes as
+	 * supported by hugetlb.  A PMD_SIZE huge pages may exist as used
+	 * by THP.  Since we can not reliably insert a zero page, this
+	 * feature is not supported.
+	 */
+	if (zeropage) {
+		up_read(&dst_mm->mmap_sem);
+		return -EINVAL;
+	}
+
+	src_addr = src_start;
+	dst_addr = dst_start;
+	copied = 0;
+	page = NULL;
+	vma_hpagesize = vma_kernel_pagesize(dst_vma);
+
+	/*
+	 * Validate alignment based on huge page size
+	 */
+	err = -EINVAL;
+	if (dst_start & (vma_hpagesize - 1) || len & (vma_hpagesize - 1))
+		goto out_unlock;
+
+retry:
+	/*
+	 * On routine entry dst_vma is set.  If we had to drop mmap_sem and
+	 * retry, dst_vma will be set to NULL and we must lookup again.
+	 */
+	if (!dst_vma) {
+		err = -EINVAL;
+		dst_vma = find_vma(dst_mm, dst_start);
+		if (!dst_vma || !is_vm_hugetlb_page(dst_vma))
+			goto out_unlock;
+
+		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
+			goto out_unlock;
+
+		/*
+		 * Make sure the vma is not shared, that the remaining dst
+		 * range is both valid and fully within a single existing vma.
+		 */
+		if (dst_vma->vm_flags & VM_SHARED)
+			goto out_unlock;
+		if (dst_start < dst_vma->vm_start ||
+		    dst_start + len > dst_vma->vm_end)
+			goto out_unlock;
+	}
+
+	if (WARN_ON(dst_addr & (vma_hpagesize - 1) ||
+		    (len - copied) & (vma_hpagesize - 1)))
+		goto out_unlock;
+
+	/*
+	 * Only allow __mcopy_atomic_hugetlb on userfaultfd registered ranges.
+	 */
+	if (!dst_vma->vm_userfaultfd_ctx.ctx)
+		goto out_unlock;
+
+	/*
+	 * Ensure the dst_vma has a anon_vma.
+	 */
+	err = -ENOMEM;
+	if (unlikely(anon_vma_prepare(dst_vma)))
+		goto out_unlock;
+
+	h = hstate_vma(dst_vma);
+
+	while (src_addr < src_start + len) {
+		pte_t dst_pteval;
+
+		BUG_ON(dst_addr >= dst_start + len);
+		VM_BUG_ON(dst_addr & ~huge_page_mask(h));
+
+		/*
+		 * Serialize via hugetlb_fault_mutex
+		 */
+		idx = linear_page_index(dst_vma, dst_addr);
+		mapping = dst_vma->vm_file->f_mapping;
+		hash = hugetlb_fault_mutex_hash(h, dst_mm, dst_vma, mapping,
+								idx, dst_addr);
+		mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
+		err = -ENOMEM;
+		dst_pte = huge_pte_alloc(dst_mm, dst_addr, huge_page_size(h));
+		if (!dst_pte) {
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			goto out_unlock;
+		}
+
+		err = -EEXIST;
+		dst_pteval = huge_ptep_get(dst_pte);
+		if (!huge_pte_none(dst_pteval)) {
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			goto out_unlock;
+		}
+
+		err = hugetlb_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma,
+						dst_addr, src_addr, &page);
+
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+
+		cond_resched();
+
+		if (unlikely(err == -EFAULT)) {
+			up_read(&dst_mm->mmap_sem);
+			BUG_ON(!page);
+
+			err = copy_huge_page_from_user(page,
+						(const void __user *)src_addr,
+						pages_per_huge_page(h));
+			if (unlikely(err)) {
+				err = -EFAULT;
+				goto out;
+			}
+			down_read(&dst_mm->mmap_sem);
+
+			dst_vma = NULL;
+			goto retry;
+		} else
+			BUG_ON(page);
+
+		if (!err) {
+			dst_addr += vma_hpagesize;
+			src_addr += vma_hpagesize;
+			copied += vma_hpagesize;
+
+			if (fatal_signal_pending(current))
+				err = -EINTR;
+		}
+		if (err)
+			break;
+	}
+
+out_unlock:
+	up_read(&dst_mm->mmap_sem);
+out:
+	if (page)
+		put_page(page);
+	BUG_ON(copied < 0);
+	BUG_ON(err > 0);
+	BUG_ON(!copied && !err);
+	return copied ? copied : err;
+}
+#else /* !CONFIG_HUGETLB_PAGE */
+/* fail at build time if gcc attempts to use this */
+extern ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
+				      struct vm_area_struct *dst_vma,
+				      unsigned long dst_start,
+				      unsigned long src_start,
+				      unsigned long len,
+				      bool zeropage);
+#endif /* CONFIG_HUGETLB_PAGE */
+
 static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 					      unsigned long dst_start,
 					      unsigned long src_start,
@@ -182,6 +361,13 @@ retry:
 		goto out_unlock;
 
 	/*
+	 * If this is a HUGETLB vma, pass off to appropriate routine
+	 */
+	if (is_vm_hugetlb_page(dst_vma))
+		return  __mcopy_atomic_hugetlb(dst_mm, dst_vma, dst_start,
+						src_start, len, zeropage);
+
+	/*
 	 * Be strict and only allow __mcopy_atomic on userfaultfd
 	 * registered ranges to prevent userland errors going
 	 * unnoticed. As far as the VM consistency is concerned, it
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

userfaultfd-hugetlbfs-add-copy_huge_page_from_user-for-hugetlb-userfaultfd-support.patch
userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch
userfaultfd-hugetlbfs-add-userfaultfd-hugetlb-hook.patch
userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages.patch
userfaultfd-hugetlbfs-add-userfaultfd_hugetlb-test.patch
userfaultfd-hugetlbfs-userfaultfd_huge_must_wait-for-hugepmd-ranges.patch
userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch

