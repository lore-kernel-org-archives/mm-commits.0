From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:04:50 -0700
Message-ID: <55ef2342.MFt47+sYDAo2qJpC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbbIHSEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: avoid mmap_sem read recursion in mcopy_atomic
has been removed from the -mm tree.  Its filename was
     userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: avoid mmap_sem read recursion in mcopy_atomic

If the rwsem starves writers it wasn't strictly a bug but lockdep
doesn't like it and this avoids depending on lowlevel implementation
details of the lock.

[akpm@linux-foundation.org: delete weird BUILD_BUG_ON()]
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

 mm/userfaultfd.c |   91 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 65 insertions(+), 26 deletions(-)

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
@@ -229,13 +246,32 @@ static __always_inline ssize_t __mcopy_a
 
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
@@ -248,8 +284,11 @@ static __always_inline ssize_t __mcopy_a
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

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

