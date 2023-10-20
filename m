Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E9DC00A98
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 17:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377916AbjJTR1D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377934AbjJTR05 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 13:26:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B769C1A3
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 10:26:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9A6C433C9;
        Fri, 20 Oct 2023 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697822814;
        bh=6C8Me2WaS+tbw32H1N9i8MaJoLFpgoCdeFEIuEm/fY4=;
        h=Date:To:From:Subject:From;
        b=S87YFzsyr4wX0EYaP+as+eP+rP0eucCNtb1BKiVBwmMzMjQbpZ5SlHo7gMzZ6VsjG
         BKS+s5GfKyPEf5ObuQs2bg8joq6JmJRdnFFqwbq2L9b+X4QpaYvlv4VRaKOQFJbxLc
         dsYV9LRLCUbCC9VZj+0tcDHgoQq8jD98S1gP8Kow=
Date:   Fri, 20 Oct 2023 10:26:53 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com, tj@kernel.org,
        surenb@google.com, sidhartha.kumar@oracle.com, shy828301@gmail.com,
        nphamcs@gmail.com, mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch added to mm-unstable branch
Message-Id: <20231020172654.4C9A6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: mmap_lock is not needed while migrating folios
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mempolicy: mmap_lock is not needed while migrating folios
Date: Tue, 3 Oct 2023 02:27:47 -0700 (PDT)

mbind(2) holds down_write of current task's mmap_lock throughout
(exclusive because it needs to set the new mempolicy on the vmas);
migrate_pages(2) holds down_read of pid's mmap_lock throughout.

They both hold mmap_lock across the internal migrate_pages(), under which
all new page allocations (huge or small) are made.  I'm nervous about it;
and migrate_pages() certainly does not need mmap_lock itself.  It's done
this way for mbind(2), because its page allocator is vma_alloc_folio() or
alloc_hugetlb_folio_vma(), both of which depend on vma and address.

Now that we have alloc_pages_mpol(), depending on (refcounted) memory
policy and interleave index, mbind(2) can be modified to use that or
alloc_hugetlb_folio_nodemask(), and then not need mmap_lock across the
internal migrate_pages() at all: add alloc_migration_target_by_mpol() to
replace mbind's new_page().

(After that change, alloc_hugetlb_folio_vma() is used by nothing but a
userfaultfd function: move it out of hugetlb.h and into the #ifdef.)

migrate_pages(2) has chosen its target node before migrating, so can
continue to use the standard alloc_migration_target(); but let it take and
drop mmap_lock just around migrate_to_node()'s queue_pages_range():
neither the node-to-node calculations nor the page migrations need it.

It seems unlikely, but it is conceivable that some userspace depends on
the kernel's mmap_lock exclusion here, instead of doing its own locking:
more likely in a testsuite than in real life.  It is also possible, of
course, that some pages on the list will be munmapped by another thread
before they are migrated, or a newer memory policy applied to the range by
that time: but such races could happen before, as soon as mmap_lock was
dropped, so it does not appear to be a concern.

Link: https://lkml.kernel.org/r/21e564e8-269f-6a89-7ee2-fd612831c289@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun heo <tj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    9 ----
 mm/hugetlb.c            |   38 +++++++++--------
 mm/mempolicy.c          |   83 +++++++++++++++++++-------------------
 3 files changed, 63 insertions(+), 67 deletions(-)

--- a/include/linux/hugetlb.h~mempolicy-mmap_lock-is-not-needed-while-migrating-folios
+++ a/include/linux/hugetlb.h
@@ -748,8 +748,6 @@ struct folio *alloc_hugetlb_folio(struct
 				unsigned long addr, int avoid_reserve);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask);
-struct folio *alloc_hugetlb_folio_vma(struct hstate *h, struct vm_area_struct *vma,
-				unsigned long address);
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
@@ -1071,13 +1069,6 @@ alloc_hugetlb_folio_nodemask(struct hsta
 {
 	return NULL;
 }
-
-static inline struct folio *alloc_hugetlb_folio_vma(struct hstate *h,
-					       struct vm_area_struct *vma,
-					       unsigned long address)
-{
-	return NULL;
-}
 
 static inline int __alloc_bootmem_huge_page(struct hstate *h)
 {
--- a/mm/hugetlb.c~mempolicy-mmap_lock-is-not-needed-while-migrating-folios
+++ a/mm/hugetlb.c
@@ -2497,24 +2497,6 @@ struct folio *alloc_hugetlb_folio_nodema
 	return alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid, nmask);
 }
 
-/* mempolicy aware migration callback */
-struct folio *alloc_hugetlb_folio_vma(struct hstate *h, struct vm_area_struct *vma,
-		unsigned long address)
-{
-	struct mempolicy *mpol;
-	nodemask_t *nodemask;
-	struct folio *folio;
-	gfp_t gfp_mask;
-	int node;
-
-	gfp_mask = htlb_alloc_mask(h);
-	node = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-	folio = alloc_hugetlb_folio_nodemask(h, node, nodemask, gfp_mask);
-	mpol_cond_put(mpol);
-
-	return folio;
-}
-
 /*
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
@@ -6349,6 +6331,26 @@ out_mutex:
 
 #ifdef CONFIG_USERFAULTFD
 /*
+ * Can probably be eliminated, but still used by hugetlb_mfill_atomic_pte().
+ */
+static struct folio *alloc_hugetlb_folio_vma(struct hstate *h,
+		struct vm_area_struct *vma, unsigned long address)
+{
+	struct mempolicy *mpol;
+	nodemask_t *nodemask;
+	struct folio *folio;
+	gfp_t gfp_mask;
+	int node;
+
+	gfp_mask = htlb_alloc_mask(h);
+	node = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
+	folio = alloc_hugetlb_folio_nodemask(h, node, nodemask, gfp_mask);
+	mpol_cond_put(mpol);
+
+	return folio;
+}
+
+/*
  * Used by userfaultfd UFFDIO_* ioctls. Based on userfaultfd's mfill_atomic_pte
  * with modifications for hugetlb pages.
  */
--- a/mm/mempolicy.c~mempolicy-mmap_lock-is-not-needed-while-migrating-folios
+++ a/mm/mempolicy.c
@@ -417,6 +417,8 @@ static const struct mempolicy_operations
 
 static bool migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 				unsigned long flags);
+static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *pol,
+				pgoff_t ilx, int *nid);
 
 static bool strictly_unmovable(unsigned long flags)
 {
@@ -1023,6 +1025,8 @@ static long migrate_to_node(struct mm_st
 	node_set(source, nmask);
 
 	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
+
+	mmap_read_lock(mm);
 	vma = find_vma(mm, 0);
 
 	/*
@@ -1033,6 +1037,7 @@ static long migrate_to_node(struct mm_st
 	 */
 	nr_failed = queue_pages_range(mm, vma->vm_start, mm->task_size, &nmask,
 				      flags | MPOL_MF_DISCONTIG_OK, &pagelist);
+	mmap_read_unlock(mm);
 
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, alloc_migration_target, NULL,
@@ -1061,8 +1066,6 @@ int do_migrate_pages(struct mm_struct *m
 
 	lru_cache_disable();
 
-	mmap_read_lock(mm);
-
 	/*
 	 * Find a 'source' bit set in 'tmp' whose corresponding 'dest'
 	 * bit in 'to' is not also set in 'tmp'.  Clear the found 'source'
@@ -1142,7 +1145,6 @@ int do_migrate_pages(struct mm_struct *m
 		if (err < 0)
 			break;
 	}
-	mmap_read_unlock(mm);
 
 	lru_cache_enable();
 	if (err < 0)
@@ -1151,44 +1153,38 @@ int do_migrate_pages(struct mm_struct *m
 }
 
 /*
- * Allocate a new page for page migration based on vma policy.
- * Start by assuming the page is mapped by the same vma as contains @start.
- * Search forward from there, if not.  N.B., this assumes that the
- * list of pages handed to migrate_pages()--which is how we get here--
- * is in virtual address order.
+ * Allocate a new folio for page migration, according to NUMA mempolicy.
  */
-static struct folio *new_folio(struct folio *src, unsigned long start)
+static struct folio *alloc_migration_target_by_mpol(struct folio *src,
+						    unsigned long private)
 {
-	struct vm_area_struct *vma;
-	unsigned long address;
-	VMA_ITERATOR(vmi, current->mm, start);
-	gfp_t gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL;
-
-	for_each_vma(vmi, vma) {
-		address = page_address_in_vma(&src->page, vma);
-		if (address != -EFAULT)
-			break;
-	}
+	struct mempolicy *pol = (struct mempolicy *)private;
+	pgoff_t ilx = 0;	/* improve on this later */
+	struct page *page;
+	unsigned int order;
+	int nid = numa_node_id();
+	gfp_t gfp;
 
-	/*
-	 * __get_vma_policy() now expects a genuine non-NULL vma. Return NULL
-	 * when the page can no longer be located in a vma: that is not ideal
-	 * (migrate_pages() will give up early, presuming ENOMEM), but good
-	 * enough to avoid a crash by syzkaller or concurrent holepunch.
-	 */
-	if (!vma)
-		return NULL;
+	order = folio_order(src);
+	ilx += src->index >> order;
 
 	if (folio_test_hugetlb(src)) {
-		return alloc_hugetlb_folio_vma(folio_hstate(src),
-				vma, address);
+		nodemask_t *nodemask;
+		struct hstate *h;
+
+		h = folio_hstate(src);
+		gfp = htlb_alloc_mask(h);
+		nodemask = policy_nodemask(gfp, pol, ilx, &nid);
+		return alloc_hugetlb_folio_nodemask(h, nid, nodemask, gfp);
 	}
 
 	if (folio_test_large(src))
 		gfp = GFP_TRANSHUGE;
+	else
+		gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL | __GFP_COMP;
 
-	return vma_alloc_folio(gfp, folio_order(src), vma, address,
-			folio_test_large(src));
+	page = alloc_pages_mpol(gfp, order, pol, ilx, nid);
+	return page_rmappable_folio(page);
 }
 #else
 
@@ -1204,7 +1200,8 @@ int do_migrate_pages(struct mm_struct *m
 	return -ENOSYS;
 }
 
-static struct folio *new_folio(struct folio *src, unsigned long start)
+static struct folio *alloc_migration_target_by_mpol(struct folio *src,
+						    unsigned long private)
 {
 	return NULL;
 }
@@ -1278,6 +1275,7 @@ static long do_mbind(unsigned long start
 
 	if (nr_failed < 0) {
 		err = nr_failed;
+		nr_failed = 0;
 	} else {
 		vma_iter_init(&vmi, mm, start);
 		prev = vma_prev(&vmi);
@@ -1288,19 +1286,24 @@ static long do_mbind(unsigned long start
 		}
 	}
 
-	if (!err) {
-		if (!list_empty(&pagelist)) {
-			nr_failed |= migrate_pages(&pagelist, new_folio, NULL,
-				start, MIGRATE_SYNC, MR_MEMPOLICY_MBIND, NULL);
+	mmap_write_unlock(mm);
+
+	if (!err && !list_empty(&pagelist)) {
+		/* Convert MPOL_DEFAULT's NULL to task or default policy */
+		if (!new) {
+			new = get_task_policy(current);
+			mpol_get(new);
 		}
-		if (nr_failed && (flags & MPOL_MF_STRICT))
-			err = -EIO;
+		nr_failed |= migrate_pages(&pagelist,
+				alloc_migration_target_by_mpol, NULL,
+				(unsigned long)new, MIGRATE_SYNC,
+				MR_MEMPOLICY_MBIND, NULL);
 	}
 
+	if (nr_failed && (flags & MPOL_MF_STRICT))
+		err = -EIO;
 	if (!list_empty(&pagelist))
 		putback_movable_pages(&pagelist);
-
-	mmap_write_unlock(mm);
 mpol_out:
 	mpol_put(new);
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
_

Patches currently in -mm which might be from hughd@google.com are

hugetlbfs-drop-shared-numa-mempolicy-pretence.patch
kernfs-drop-shared-numa-mempolicy-hooks.patch
mempolicy-fix-migrate_pages2-syscall-return-nr_failed.patch
mempolicy-trivia-delete-those-ancient-pr_debugs.patch
mempolicy-trivia-slightly-more-consistent-naming.patch
mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch
mempolicy-mpol_shared_policy_init-without-pseudo-vma.patch
mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch
mm-add-page_rmappable_folio-wrapper.patch
mempolicy-alloc_pages_mpol-for-numa-policy-without-vma.patch
mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch
mempolicy-migration-attempt-to-match-interleave-nodes.patch

