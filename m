Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5988C3F6B0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 20:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbiHXUNw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 16:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239670AbiHXUNw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 16:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998687170C
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 13:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44478B826A0
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 20:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7C6C433C1;
        Wed, 24 Aug 2022 20:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661372027;
        bh=U20Wg6mRROuW4mTKWFc30W210m0SFCAR2gwMkBlK9uI=;
        h=Date:To:From:Subject:From;
        b=sWooMJgRVAvS7lV7WSlJN7lv/mBvD/5KQK7eHWkGAzivS1qszO3PlxBMmKGgFtwTY
         7Oupsy9QyR8TQqM80Gw0Xnw7S0q54s0nXt9H4pvNLKXJfX0VGMX43oDKKuFwE6aEgu
         kYv4L4GvK+kaqVinOzAML6v9ml6P/KVFWrtPFa/E=
Date:   Wed, 24 Aug 2022 13:13:46 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        prakash.sangappa@oracle.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jthoughton@google.com,
        david@redhat.com, dave@stgolabs.net, axelrasmussen@google.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch added to mm-unstable branch
Message-Id: <20220824201347.AF7C6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: revert use i_mmap_rwsem to address page fault/truncate race
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch

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
Subject: hugetlbfs: revert use i_mmap_rwsem to address page fault/truncate race
Date: Wed, 24 Aug 2022 10:57:50 -0700

Patch series "hugetlb: Use new vma mutex for huge pmd sharing synchronization".

hugetlb fault scalability regressions have recently been reported [1]. 
This is not the first such report, as regressions were also noted when
commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
synchronization") was added [2] in v5.7.  At that time, a proposal to
address the regression was suggested [3] but went nowhere.

The regression and benefit of this patch series is not evident when
using the vm_scalability benchmark reported in [2] on a recent kernel.
Results from running,
"./usemem -n 48 --prealloc --prefault -O -U 3448054972"

			48 sample Avg
next-20220822		next-20220822			next-20220822
unmodified	revert i_mmap_sema locking	vma sema locking, this series
-----------------------------------------------------------------------------
494229 KB/s		495375 KB/s			495573 KB/s

The recent regression report [1] notes page fault and fork latency of
shared hugetlb mappings.  To measure this, I created two simple programs:
1) map a shared hugetlb area, write fault all pages, unmap area
   Do this in a continuous loop to measure faults per second
2) map a shared hugetlb area, write fault a few pages, fork and exit
   Do this in a continuous loop to measure forks per second
These programs were run on a 48 CPU VM with 320GB memory.  The shared
mapping size was 250GB.  For comparison, a single instance of the program
was run.  Then, multiple instances were run in parallel to introduce
lock contention.  Changing the locking scheme results in a significant
performance benefit.

test		instances	unmodified	revert		vma
--------------------------------------------------------------------------
faults per sec	1		397068		403411		394935
faults per sec  24		 68322		 83023		 82436
forks per sec   1		  2717		  2862		  2816
forks per sec   24		   404		   465		   499
Combined faults 24		  1528		 69090		 59544
Combined forks  24		   337		    66		   140

Combined test is when running both faulting program and forking program
simultaneously.

Patches 1 and 2 of this series revert c0d0381ade79 and 87bf91d39bb5 which
depends on c0d0381ade79.  Acquisition of i_mmap_rwsem is still required in
the fault path to establish pmd sharing, so this is moved back to
huge_pmd_share.  With c0d0381ade79 reverted, this race is exposed:

Faulting thread                                 Unsharing thread
...                                                  ...
ptep = huge_pte_offset()
      or
ptep = huge_pte_alloc()
...
                                                i_mmap_lock_write
                                                lock page table
ptep invalid   <------------------------        huge_pmd_unshare()
Could be in a previously                        unlock_page_table
sharing process or worse                        i_mmap_unlock_write
...
ptl = huge_pte_lock(ptep)
get/update pte
set_pte_at(pte, ptep)

Reverting 87bf91d39bb5 exposes races in page fault/file truncation.
Patches 3 and 4 of this series address those races.  This requires
using the hugetlb fault mutexes for more coordination between the fault
code and file page removal.

Patches 5 - 7 add infrastructure for a new vma based rw semaphore that
will be used for pmd sharing synchronization.  The idea is that this
semaphore will be held in read mode for the duration of fault processing,
and held in write mode for unmap operations which may call huge_pmd_unshare.
Acquiring i_mmap_rwsem is also still required to synchronize huge pmd
sharing.  However it is only required in the fault path when setting up
sharing, and will be acquired in huge_pmd_share().

Patch 8 makes use of this new vma lock.  Unfortunately, the fault code
and truncate/hole punch code would naturally take locks in the opposite
order which could lead to deadlock.  Since the performance of page faults
is more important, the truncation/hole punch code is modified to back
out and take locks in the correct order if necessary.

[1] https://lore.kernel.org/linux-mm/43faf292-245b-5db5-cce9-369d8fb6bd21@infradead.org/
[2] https://lore.kernel.org/lkml/20200622005551.GK5535@shao2-debian/
[3] https://lore.kernel.org/linux-mm/20200706202615.32111-1-mike.kravetz@oracle.com/


This patch (of 8):

Commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
synchronization") added code to take i_mmap_rwsem in read mode for the
duration of fault processing.  The use of i_mmap_rwsem to prevent
fault/truncate races depends on this.  However, this has been shown to
cause performance/scaling issues.  As a result, that code will be
reverted.  Since the use i_mmap_rwsem to address page fault/truncate races
depends on this, it must also be reverted.

In a subsequent patch, code will be added to detect the fault/truncate
race and back out operations as required.

Link: https://lkml.kernel.org/r/20220824175757.20590-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20220824175757.20590-2-mike.kravetz@oracle.com
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   30 +++++++++---------------------
 mm/hugetlb.c         |   23 ++++++++++++-----------
 2 files changed, 21 insertions(+), 32 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race
+++ a/fs/hugetlbfs/inode.c
@@ -419,9 +419,10 @@ hugetlb_vmdelete_list(struct rb_root_cac
  *	In this case, we first scan the range and release found pages.
  *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserve
  *	maps and global counts.  Page faults can not race with truncation
- *	in this routine.  hugetlb_no_page() holds i_mmap_rwsem and prevents
- *	page faults in the truncated range by checking i_size.  i_size is
- *	modified while holding i_mmap_rwsem.
+ *	in this routine.  hugetlb_no_page() prevents page faults in the
+ *	truncated range.  It checks i_size before allocation, and again after
+ *	with the page table lock for the page held.  The same lock must be
+ *	acquired to unmap a page.
  * hole punch is indicated if end is not LLONG_MAX
  *	In the hole punch case we scan the range and release found pages.
  *	Only when releasing a page is the associated region/reserve map
@@ -451,16 +452,8 @@ static void remove_inode_hugepages(struc
 			u32 hash = 0;
 
 			index = folio->index;
-			if (!truncate_op) {
-				/*
-				 * Only need to hold the fault mutex in the
-				 * hole punch case.  This prevents races with
-				 * page faults.  Races are not possible in the
-				 * case of truncation.
-				 */
-				hash = hugetlb_fault_mutex_hash(mapping, index);
-				mutex_lock(&hugetlb_fault_mutex_table[hash]);
-			}
+			hash = hugetlb_fault_mutex_hash(mapping, index);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
 			 * If folio is mapped, it was faulted in after being
@@ -504,8 +497,7 @@ static void remove_inode_hugepages(struc
 			}
 
 			folio_unlock(folio);
-			if (!truncate_op)
-				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
 		folio_batch_release(&fbatch);
 		cond_resched();
@@ -543,8 +535,8 @@ static void hugetlb_vmtruncate(struct in
 	BUG_ON(offset & ~huge_page_mask(h));
 	pgoff = offset >> PAGE_SHIFT;
 
-	i_mmap_lock_write(mapping);
 	i_size_write(inode, offset);
+	i_mmap_lock_write(mapping);
 	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
 				      ZAP_FLAG_DROP_MARKER);
@@ -703,11 +695,7 @@ static long hugetlbfs_fallocate(struct f
 		/* addr is the offset within the file (zero based) */
 		addr = index * hpage_size;
 
-		/*
-		 * fault mutex taken here, protects against fault path
-		 * and hole punch.  inode_lock previously taken protects
-		 * against truncation.
-		 */
+		/* mutex taken here, fault path and hole punch */
 		hash = hugetlb_fault_mutex_hash(mapping, index);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
--- a/mm/hugetlb.c~hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race
+++ a/mm/hugetlb.c
@@ -5559,17 +5559,16 @@ static vm_fault_t hugetlb_no_page(struct
 	}
 
 	/*
-	 * We can not race with truncation due to holding i_mmap_rwsem.
-	 * i_size is modified when holding i_mmap_rwsem, so check here
-	 * once for faults beyond end of file.
+	 * Use page lock to guard against racing truncation before we get
+	 * page_table_lock.
 	 */
-	size = i_size_read(mapping->host) >> huge_page_shift(h);
-	if (idx >= size)
-		goto out;
-
 	new_page = false;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
+		size = i_size_read(mapping->host) >> huge_page_shift(h);
+		if (idx >= size)
+			goto out;
+
 		/* Check for page in userfault range */
 		if (userfaultfd_missing(vma)) {
 			ret = hugetlb_handle_userfault(vma, mapping, idx,
@@ -5665,6 +5664,10 @@ static vm_fault_t hugetlb_no_page(struct
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
+	size = i_size_read(mapping->host) >> huge_page_shift(h);
+	if (idx >= size)
+		goto backout;
+
 	ret = 0;
 	/* If pte changed from under us, retry */
 	if (!pte_same(huge_ptep_get(ptep), old_pte))
@@ -5773,10 +5776,8 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	/*
 	 * Acquire i_mmap_rwsem before calling huge_pte_alloc and hold
-	 * until finished with ptep.  This serves two purposes:
-	 * 1) It prevents huge_pmd_unshare from being called elsewhere
-	 *    and making the ptep no longer valid.
-	 * 2) It synchronizes us with i_size modifications during truncation.
+	 * until finished with ptep.  This prevents huge_pmd_unshare from
+	 * being called elsewhere and making the ptep no longer valid.
 	 *
 	 * ptep could have already be assigned via huge_pte_offset.  That
 	 * is OK, as huge_pte_alloc will return the same value unless
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
hugetlbfs-revert-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch
hugetlb-handle-truncate-racing-with-page-faults.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch

