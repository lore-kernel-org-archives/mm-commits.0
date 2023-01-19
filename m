Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEFAC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjASBUh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjASBS6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54016C56D
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EE5EB81FB6
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250B3C433D2;
        Thu, 19 Jan 2023 01:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090964;
        bh=bK1zHCNfvPS4IbTXiQAJCQpZHxdYWjX0wtumR5quYMg=;
        h=Date:To:From:Subject:From;
        b=bI4jFEMiH7n9SgVmYi07ieeOYmRqYEuAQCDYE8ijKWxEpQWd233k6qxgu4cOBsDVm
         0htYg3KxynpYAQQC8Vt1MjQsB6LSLLpvOZVjYthQ0Fc7wQdp/N0QOWzm82+/zXMnN9
         p5F3ctploEDI3Tb7JM0ShM3aReUqvOjyQC7766oI=
Date:   Wed, 18 Jan 2023 17:16:03 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        nadav.amit@gmail.com, mike.kravetz@oracle.com,
        jthoughton@google.com, david@redhat.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-uffd-detect-pgtable-allocation-failures.patch removed from -mm tree
Message-Id: <20230119011604.250B3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: detect pgtable allocation failures
has been removed from the -mm tree.  Its filename was
     mm-uffd-detect-pgtable-allocation-failures.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: detect pgtable allocation failures
Date: Wed, 4 Jan 2023 17:52:07 -0500

Before this patch, when there's any pgtable allocation issues happened
during change_protection(), the error will be ignored from the syscall. 
For shmem, there will be an error dumped into the host dmesg.  Two issues
with that:

  (1) Doing a trace dump when allocation fails is not anything close to
      grace.

  (2) The user should be notified with any kind of such error, so the user
      can trap it and decide what to do next, either by retrying, or stop
      the process properly, or anything else.

For userfault users, this will change the API of UFFDIO_WRITEPROTECT when
pgtable allocation failure happened.  It should not normally break anyone,
though.  If it breaks, then in good ways.

One man-page update will be on the way to introduce the new -ENOMEM for
UFFDIO_WRITEPROTECT.  Not marking stable so we keep the old behavior on
the 5.19-till-now kernels.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/20230104225207.1066932-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: James Houghton <jthoughton@google.com>
Acked-by: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    2 -
 mm/hugetlb.c                  |    6 ++-
 mm/mempolicy.c                |    2 -
 mm/mprotect.c                 |   63 +++++++++++++++++++++-----------
 mm/userfaultfd.c              |   16 +++++---
 5 files changed, 59 insertions(+), 30 deletions(-)

--- a/include/linux/userfaultfd_k.h~mm-uffd-detect-pgtable-allocation-failures
+++ a/include/linux/userfaultfd_k.h
@@ -73,7 +73,7 @@ extern ssize_t mcopy_continue(struct mm_
 extern int mwriteprotect_range(struct mm_struct *dst_mm,
 			       unsigned long start, unsigned long len,
 			       bool enable_wp, atomic_t *mmap_changing);
-extern void uffd_wp_range(struct mm_struct *dst_mm, struct vm_area_struct *vma,
+extern long uffd_wp_range(struct mm_struct *dst_mm, struct vm_area_struct *vma,
 			  unsigned long start, unsigned long len, bool enable_wp);
 
 /* mm helpers */
--- a/mm/hugetlb.c~mm-uffd-detect-pgtable-allocation-failures
+++ a/mm/hugetlb.c
@@ -6660,8 +6660,10 @@ long hugetlb_change_protection(struct vm
 			 * pre-allocations to install pte markers.
 			 */
 			ptep = huge_pte_alloc(mm, vma, address, psize);
-			if (!ptep)
+			if (!ptep) {
+				pages = -ENOMEM;
 				break;
+			}
 		}
 		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, vma, address, ptep)) {
@@ -6751,7 +6753,7 @@ long hugetlb_change_protection(struct vm
 	hugetlb_vma_unlock_write(vma);
 	mmu_notifier_invalidate_range_end(&range);
 
-	return pages << h->order;
+	return pages > 0 ? (pages << h->order) : pages;
 }
 
 /* Return true if reservation was successful, false otherwise.  */
--- a/mm/mempolicy.c~mm-uffd-detect-pgtable-allocation-failures
+++ a/mm/mempolicy.c
@@ -636,7 +636,7 @@ unsigned long change_prot_numa(struct vm
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
 	nr_updated = change_protection(&tlb, vma, addr, end, MM_CP_PROT_NUMA);
-	if (nr_updated)
+	if (nr_updated > 0)
 		count_vm_numa_events(NUMA_PTE_UPDATES, nr_updated);
 
 	tlb_finish_mmu(&tlb);
--- a/mm/mprotect.c~mm-uffd-detect-pgtable-allocation-failures
+++ a/mm/mprotect.c
@@ -330,28 +330,34 @@ uffd_wp_protect_file(struct vm_area_stru
 /*
  * If wr-protecting the range for file-backed, populate pgtable for the case
  * when pgtable is empty but page cache exists.  When {pte|pmd|...}_alloc()
- * failed it means no memory, we don't have a better option but stop.
+ * failed we treat it the same way as pgtable allocation failures during
+ * page faults by kicking OOM and returning error.
  */
 #define  change_pmd_prepare(vma, pmd, cp_flags)				\
-	do {								\
+	({								\
+		long err = 0;						\
 		if (unlikely(uffd_wp_protect_file(vma, cp_flags))) {	\
-			if (WARN_ON_ONCE(pte_alloc(vma->vm_mm, pmd)))	\
-				break;					\
+			if (pte_alloc(vma->vm_mm, pmd))			\
+				err = -ENOMEM;				\
 		}							\
-	} while (0)
+		err;							\
+	})
+
 /*
  * This is the general pud/p4d/pgd version of change_pmd_prepare(). We need to
  * have separate change_pmd_prepare() because pte_alloc() returns 0 on success,
  * while {pmd|pud|p4d}_alloc() returns the valid pointer on success.
  */
 #define  change_prepare(vma, high, low, addr, cp_flags)			\
-	do {								\
+	  ({								\
+		long err = 0;						\
 		if (unlikely(uffd_wp_protect_file(vma, cp_flags))) {	\
 			low##_t *p = low##_alloc(vma->vm_mm, high, addr); \
-			if (WARN_ON_ONCE(p == NULL))			\
-				break;					\
+			if (p == NULL)					\
+				err = -ENOMEM;				\
 		}							\
-	} while (0)
+		err;							\
+	})
 
 static inline long change_pmd_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
@@ -367,11 +373,15 @@ static inline long change_pmd_range(stru
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		long this_pages;
+		long ret;
 
 		next = pmd_addr_end(addr, end);
 
-		change_pmd_prepare(vma, pmd, cp_flags);
+		ret = change_pmd_prepare(vma, pmd, cp_flags);
+		if (ret) {
+			pages = ret;
+			break;
+		}
 		/*
 		 * Automatic NUMA balancing walks the tables with mmap_lock
 		 * held for read. It's possible a parallel update to occur
@@ -401,7 +411,11 @@ static inline long change_pmd_range(stru
 				 * cleared; make sure pmd populated if
 				 * necessary, then fall-through to pte level.
 				 */
-				change_pmd_prepare(vma, pmd, cp_flags);
+				ret = change_pmd_prepare(vma, pmd, cp_flags);
+				if (ret) {
+					pages = ret;
+					break;
+				}
 			} else {
 				/*
 				 * change_huge_pmd() does not defer TLB flushes,
@@ -422,9 +436,8 @@ static inline long change_pmd_range(stru
 			}
 			/* fall through, the trans huge pmd just split */
 		}
-		this_pages = change_pte_range(tlb, vma, pmd, addr, next,
-					      newprot, cp_flags);
-		pages += this_pages;
+		pages += change_pte_range(tlb, vma, pmd, addr, next,
+					  newprot, cp_flags);
 next:
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);
@@ -443,12 +456,14 @@ static inline long change_pud_range(stru
 {
 	pud_t *pud;
 	unsigned long next;
-	long pages = 0;
+	long pages = 0, ret;
 
 	pud = pud_offset(p4d, addr);
 	do {
 		next = pud_addr_end(addr, end);
-		change_prepare(vma, pud, pmd, addr, cp_flags);
+		ret = change_prepare(vma, pud, pmd, addr, cp_flags);
+		if (ret)
+			return ret;
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		pages += change_pmd_range(tlb, vma, pud, addr, next, newprot,
@@ -464,12 +479,14 @@ static inline long change_p4d_range(stru
 {
 	p4d_t *p4d;
 	unsigned long next;
-	long pages = 0;
+	long pages = 0, ret;
 
 	p4d = p4d_offset(pgd, addr);
 	do {
 		next = p4d_addr_end(addr, end);
-		change_prepare(vma, p4d, pud, addr, cp_flags);
+		ret = change_prepare(vma, p4d, pud, addr, cp_flags);
+		if (ret)
+			return ret;
 		if (p4d_none_or_clear_bad(p4d))
 			continue;
 		pages += change_pud_range(tlb, vma, p4d, addr, next, newprot,
@@ -486,14 +503,18 @@ static long change_protection_range(stru
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
 	unsigned long next;
-	long pages = 0;
+	long pages = 0, ret;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
 	tlb_start_vma(tlb, vma);
 	do {
 		next = pgd_addr_end(addr, end);
-		change_prepare(vma, pgd, p4d, addr, cp_flags);
+		ret = change_prepare(vma, pgd, p4d, addr, cp_flags);
+		if (ret) {
+			pages = ret;
+			break;
+		}
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
 		pages += change_p4d_range(tlb, vma, pgd, addr, next, newprot,
--- a/mm/userfaultfd.c~mm-uffd-detect-pgtable-allocation-failures
+++ a/mm/userfaultfd.c
@@ -710,11 +710,12 @@ ssize_t mcopy_continue(struct mm_struct
 			      mmap_changing, 0);
 }
 
-void uffd_wp_range(struct mm_struct *dst_mm, struct vm_area_struct *dst_vma,
+long uffd_wp_range(struct mm_struct *dst_mm, struct vm_area_struct *dst_vma,
 		   unsigned long start, unsigned long len, bool enable_wp)
 {
 	unsigned int mm_cp_flags;
 	struct mmu_gather tlb;
+	long ret;
 
 	if (enable_wp)
 		mm_cp_flags = MM_CP_UFFD_WP;
@@ -730,8 +731,10 @@ void uffd_wp_range(struct mm_struct *dst
 	if (!enable_wp && vma_wants_manual_pte_write_upgrade(dst_vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	tlb_gather_mmu(&tlb, dst_mm);
-	change_protection(&tlb, dst_vma, start, start + len, mm_cp_flags);
+	ret = change_protection(&tlb, dst_vma, start, start + len, mm_cp_flags);
 	tlb_finish_mmu(&tlb);
+
+	return ret;
 }
 
 int mwriteprotect_range(struct mm_struct *dst_mm, unsigned long start,
@@ -740,7 +743,7 @@ int mwriteprotect_range(struct mm_struct
 {
 	struct vm_area_struct *dst_vma;
 	unsigned long page_mask;
-	int err;
+	long err;
 
 	/*
 	 * Sanitize the command parameters:
@@ -779,9 +782,12 @@ int mwriteprotect_range(struct mm_struct
 			goto out_unlock;
 	}
 
-	uffd_wp_range(dst_mm, dst_vma, start, len, enable_wp);
+	err = uffd_wp_range(dst_mm, dst_vma, start, len, enable_wp);
+
+	/* Return 0 on success, <0 on failures */
+	if (err > 0)
+		err = 0;
 
-	err = 0;
 out_unlock:
 	mmap_read_unlock(dst_mm);
 	return err;
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch

