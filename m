Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A47AECAAD3
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 23:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiINXBW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 19:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiINXBT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 19:01:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49B052FD8
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 16:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FD42B81D04
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 23:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A062C433C1;
        Wed, 14 Sep 2022 23:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663196470;
        bh=iolMK6qnaVkdawH3/3aH2O7JxWa2yiGDzqQvhX7dKhY=;
        h=Date:To:From:Subject:From;
        b=y/RVJmZpKgaJSTX2pFww8UDr4ie1YKR+4lZyE74z0XdxCbPVuNTboKZPhs5oVNOdo
         LPS1nReRKQRTM8COxt54LHNYiWNk/lbPtuqK4fyTXgsJRWXo73aucC8+SYirAn6mUp
         Xj/qsi5hV8bNmcr65jOMeKGKZ6tGsUlUf02jgg6A=
Date:   Wed, 14 Sep 2022 16:01:09 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com,
        songmuchun@bytedance.com, prakash.sangappa@oracle.com,
        peterx@redhat.com, pasha.tatashin@soleen.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jthoughton@google.com,
        david@redhat.com, dave@stgolabs.net, axelrasmussen@google.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-add-vma-based-lock-for-pmd-sharing.patch added to mm-unstable branch
Message-Id: <20220914230110.0A062C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add vma based lock for pmd sharing
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-add-vma-based-lock-for-pmd-sharing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-add-vma-based-lock-for-pmd-sharing.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: add vma based lock for pmd sharing
Date: Wed, 14 Sep 2022 15:18:07 -0700

Allocate a new hugetlb_vma_lock structure and hang off vm_private_data for
synchronization use by vmas that could be involved in pmd sharing.  This
data structure contains a rw semaphore that is the primary tool used for
synchronization.

This new structure is ref counted, so that it can exist when NOT attached
to a vma.  This is only helpful in resolving lock ordering issues where
code may need to obtain the vma_lock while there are no guarantees the vma
may go away.  By obtaining a ref on the structure, it can be guaranteed
that at least the rw semaphore will not go away.

Only add infrastructure for the new lock here.  Actual use will be added
in subsequent patches.

Link: https://lkml.kernel.org/r/20220914221810.95771-7-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   43 +++++++-
 kernel/fork.c           |    6 -
 mm/hugetlb.c            |  202 ++++++++++++++++++++++++++++++++++----
 mm/rmap.c               |    8 +
 4 files changed, 235 insertions(+), 24 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-add-vma-based-lock-for-pmd-sharing
+++ a/include/linux/hugetlb.h
@@ -115,6 +115,12 @@ struct file_region {
 #endif
 };
 
+struct hugetlb_vma_lock {
+	struct kref refs;
+	struct rw_semaphore rw_sema;
+	struct vm_area_struct *vma;
+};
+
 extern struct resv_map *resv_map_alloc(void);
 void resv_map_release(struct kref *ref);
 
@@ -127,7 +133,7 @@ struct hugepage_subpool *hugepage_new_su
 						long min_hpages);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
-void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
+void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
 int hugetlb_sysctl_handler(struct ctl_table *, int, void *, size_t *, loff_t *);
 int hugetlb_overcommit_handler(struct ctl_table *, int, void *, size_t *,
@@ -215,6 +221,14 @@ struct page *follow_huge_pud(struct mm_s
 struct page *follow_huge_pgd(struct mm_struct *mm, unsigned long address,
 			     pgd_t *pgd, int flags);
 
+void hugetlb_vma_lock_read(struct vm_area_struct *vma);
+void hugetlb_vma_unlock_read(struct vm_area_struct *vma);
+void hugetlb_vma_lock_write(struct vm_area_struct *vma);
+void hugetlb_vma_unlock_write(struct vm_area_struct *vma);
+int hugetlb_vma_trylock_write(struct vm_area_struct *vma);
+void hugetlb_vma_assert_locked(struct vm_area_struct *vma);
+void hugetlb_vma_lock_release(struct kref *kref);
+
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pud);
 unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
@@ -226,7 +240,7 @@ void hugetlb_unshare_all_pmds(struct vm_
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
-static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
+static inline void hugetlb_dup_vma_private(struct vm_area_struct *vma)
 {
 }
 
@@ -337,6 +351,31 @@ static inline int prepare_hugepage_range
 	return -EINVAL;
 }
 
+static inline void hugetlb_vma_lock_read(struct vm_area_struct *vma)
+{
+}
+
+static inline void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
+{
+}
+
+static inline void hugetlb_vma_lock_write(struct vm_area_struct *vma)
+{
+}
+
+static inline void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
+{
+}
+
+static inline int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
+{
+	return 1;
+}
+
+static inline void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
+{
+}
+
 static inline int pmd_huge(pmd_t pmd)
 {
 	return 0;
--- a/kernel/fork.c~hugetlb-add-vma-based-lock-for-pmd-sharing
+++ a/kernel/fork.c
@@ -675,12 +675,10 @@ static __latent_entropy int dup_mmap(str
 		}
 
 		/*
-		 * Clear hugetlb-related page reserves for children. This only
-		 * affects MAP_PRIVATE mappings. Faults generated by the child
-		 * are not guaranteed to succeed, even if read-only
+		 * Copy/update hugetlb private vma information.
 		 */
 		if (is_vm_hugetlb_page(tmp))
-			reset_vma_resv_huge_pages(tmp);
+			hugetlb_dup_vma_private(tmp);
 
 		/* Link the vma into the MT */
 		mas.index = tmp->vm_start;
--- a/mm/hugetlb.c~hugetlb-add-vma-based-lock-for-pmd-sharing
+++ a/mm/hugetlb.c
@@ -91,6 +91,8 @@ struct mutex *hugetlb_fault_mutex_table
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
+static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
+static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -859,7 +861,7 @@ __weak unsigned long vma_mmu_pagesize(st
  * faults in a MAP_PRIVATE mapping. Only the process that called mmap()
  * is guaranteed to have their future faults succeed.
  *
- * With the exception of reset_vma_resv_huge_pages() which is called at fork(),
+ * With the exception of hugetlb_dup_vma_private() which is called at fork(),
  * the reserve counters are updated with the hugetlb_lock held. It is safe
  * to reset the VMA at fork() time as it is not in use yet and there is no
  * chance of the global counters getting corrupted as a result of the values.
@@ -1006,12 +1008,20 @@ static int is_vma_resv_set(struct vm_are
 	return (get_vma_private_data(vma) & flag) != 0;
 }
 
-/* Reset counters to 0 and clear all HPAGE_RESV_* flags */
-void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
+void hugetlb_dup_vma_private(struct vm_area_struct *vma)
 {
 	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
+	/*
+	 * Clear vm_private_data
+	 * - For MAP_PRIVATE mappings, this is the reserve map which does
+	 *   not apply to children.  Faults generated by the children are
+	 *   not guaranteed to succeed, even if read-only.
+	 * - For shared mappings this is a per-vma semaphore that may be
+	 *   allocated in a subsequent call to hugetlb_vm_op_open.
+	 */
+	vma->vm_private_data = (void *)0;
 	if (!(vma->vm_flags & VM_MAYSHARE))
-		vma->vm_private_data = (void *)0;
+		return;
 }
 
 /*
@@ -1042,7 +1052,7 @@ void clear_vma_resv_huge_pages(struct vm
 		kref_put(&reservations->refs, resv_map_release);
 	}
 
-	reset_vma_resv_huge_pages(vma);
+	hugetlb_dup_vma_private(vma);
 }
 
 /* Returns true if the VMA has associated reserve pages */
@@ -4623,16 +4633,21 @@ static void hugetlb_vm_op_open(struct vm
 		resv_map_dup_hugetlb_cgroup_uncharge_info(resv);
 		kref_get(&resv->refs);
 	}
+
+	hugetlb_vma_lock_alloc(vma);
 }
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 {
 	struct hstate *h = hstate_vma(vma);
-	struct resv_map *resv = vma_resv_map(vma);
+	struct resv_map *resv;
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	unsigned long reserve, start, end;
 	long gbl_reserve;
 
+	hugetlb_vma_lock_free(vma);
+
+	resv = vma_resv_map(vma);
 	if (!resv || !is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		return;
 
@@ -6440,6 +6455,11 @@ bool hugetlb_reserve_pages(struct inode
 	}
 
 	/*
+	 * vma specific semaphore used for pmd sharing synchronization
+	 */
+	hugetlb_vma_lock_alloc(vma);
+
+	/*
 	 * Only apply hugepage reservation if asked. At fault time, an
 	 * attempt will be made for VM_NORESERVE to allocate a page
 	 * without using reserves
@@ -6462,12 +6482,11 @@ bool hugetlb_reserve_pages(struct inode
 		resv_map = inode_resv_map(inode);
 
 		chg = region_chg(resv_map, from, to, &regions_needed);
-
 	} else {
 		/* Private mapping. */
 		resv_map = resv_map_alloc();
 		if (!resv_map)
-			return false;
+			goto out_err;
 
 		chg = to - from;
 
@@ -6562,6 +6581,7 @@ out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
 out_err:
+	hugetlb_vma_lock_free(vma);
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		/* Only call region_abort if the region_chg succeeded but the
 		 * region_add failed or didn't run.
@@ -6641,14 +6661,34 @@ static unsigned long page_table_shareabl
 }
 
 static bool __vma_aligned_range_pmd_shareable(struct vm_area_struct *vma,
-				unsigned long start, unsigned long end)
+				unsigned long start, unsigned long end,
+				bool check_vma_lock)
 {
+#ifdef CONFIG_USERFAULTFD
+	if (uffd_disable_huge_pmd_share(vma))
+		return false;
+#endif
 	/*
 	 * check on proper vm_flags and page table alignment
 	 */
-	if (vma->vm_flags & VM_MAYSHARE && range_in_vma(vma, start, end))
-		return true;
-	return false;
+	if (!(vma->vm_flags & VM_MAYSHARE))
+		return false;
+	if (check_vma_lock && !vma->vm_private_data)
+		return false;
+	if (!range_in_vma(vma, start, end))
+		return false;
+	return true;
+}
+
+static bool vma_pmd_shareable(struct vm_area_struct *vma)
+{
+	unsigned long start = ALIGN(vma->vm_start, PUD_SIZE),
+		      end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
+
+	if (start >= end)
+		return false;
+
+	return __vma_aligned_range_pmd_shareable(vma, start, end, false);
 }
 
 static bool vma_addr_pmd_shareable(struct vm_area_struct *vma,
@@ -6657,15 +6697,11 @@ static bool vma_addr_pmd_shareable(struc
 	unsigned long start = addr & PUD_MASK;
 	unsigned long end = start + PUD_SIZE;
 
-	return __vma_aligned_range_pmd_shareable(vma, start, end);
+	return __vma_aligned_range_pmd_shareable(vma, start, end, true);
 }
 
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
 {
-#ifdef CONFIG_USERFAULTFD
-	if (uffd_disable_huge_pmd_share(vma))
-		return false;
-#endif
 	return vma_addr_pmd_shareable(vma, addr);
 }
 
@@ -6696,6 +6732,130 @@ void adjust_range_if_pmd_sharing_possibl
 		*end = ALIGN(*end, PUD_SIZE);
 }
 
+static bool __vma_shareable_flags_pmd(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
+		vma->vm_private_data;
+}
+
+void hugetlb_vma_lock_read(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_flags_pmd(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_read(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_flags_pmd(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		up_read(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_lock_write(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_flags_pmd(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_write(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_flags_pmd(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		up_write(&vma_lock->rw_sema);
+	}
+}
+
+int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
+{
+	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+	if (!__vma_shareable_flags_pmd(vma))
+		return 1;
+
+	return down_write_trylock(&vma_lock->rw_sema);
+}
+
+void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_flags_pmd(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		lockdep_assert_held(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_lock_release(struct kref *kref)
+{
+	struct hugetlb_vma_lock *vma_lock = container_of(kref,
+			struct hugetlb_vma_lock, refs);
+
+	kfree(vma_lock);
+}
+
+static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
+{
+	/*
+	 * Only present in sharable vmas.  See comment in
+	 * __unmap_hugepage_range_final about how VM_SHARED could
+	 * be set without VM_MAYSHARE.  As a result, we need to
+	 * check if either is set in the free path.
+	 */
+	if (!vma || !(vma->vm_flags & (VM_MAYSHARE | VM_SHARED)))
+		return;
+
+	if (vma->vm_private_data) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		/*
+		 * vma_lock structure may or not be released, but it
+		 * certainly will no longer be attached to vma so clear
+		 * pointer.
+		 */
+		vma_lock->vma = NULL;
+		kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
+		vma->vm_private_data = NULL;
+	}
+}
+
+static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
+{
+	struct hugetlb_vma_lock *vma_lock;
+
+	/* Only establish in (flags) sharable vmas */
+	if (!vma || !(vma->vm_flags & VM_MAYSHARE))
+		return;
+
+	/* Should never get here with non-NULL vm_private_data */
+	if (vma->vm_private_data)
+		return;
+
+	/* Check size/alignment for pmd sharing possible */
+	if (!vma_pmd_shareable(vma))
+		return;
+
+	vma_lock = kmalloc(sizeof(*vma_lock), GFP_KERNEL);
+	if (!vma_lock)
+		/*
+		 * If we can not allocate structure, then vma can not
+		 * participate in pmd sharing.
+		 */
+		return;
+
+	kref_init(&vma_lock->refs);
+	init_rwsem(&vma_lock->rw_sema);
+	vma_lock->vma = vma;
+	vma->vm_private_data = vma_lock;
+}
+
 /*
  * Search for a shareable pmd page for hugetlb. In any case calls pmd_alloc()
  * and returns the corresponding pte. While this is not necessary for the
@@ -6782,6 +6942,14 @@ int huge_pmd_unshare(struct mm_struct *m
 }
 
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
+static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
+{
+}
+
+static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
+{
+}
+
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {
--- a/mm/rmap.c~hugetlb-add-vma-based-lock-for-pmd-sharing
+++ a/mm/rmap.c
@@ -24,7 +24,7 @@
  *   mm->mmap_lock
  *     mapping->invalidate_lock (in filemap_fault)
  *       page->flags PG_locked (lock_page)
- *         hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share)
+ *         hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
  *           mapping->i_mmap_rwsem
  *             anon_vma->rwsem
  *               mm->page_table_lock or pte_lock
@@ -44,6 +44,12 @@
  * anon_vma->rwsem,mapping->i_mmap_rwsem   (memory_failure, collect_procs_anon)
  *   ->tasklist_lock
  *     pte map lock
+ *
+ * hugetlbfs PageHuge() take locks in this order:
+ *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
+ *     vma_lock (hugetlb specific lock for pmd_sharing)
+ *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
+ *         page->flags PG_locked (lock_page)
  */
 
 #include <linux/mm.h>
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
hugetlbfs-revert-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch
hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch
hugetlb-clean-up-code-checking-for-fault-truncation-races.patch

