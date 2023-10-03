Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F779E7AD7A
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjJCRCu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240565AbjJCRCs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:02:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DB7EC
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:02:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CBCC433C7;
        Tue,  3 Oct 2023 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696352562;
        bh=fn0W+s9+acH6yM7ZcsWIzYeEETHeSzxrcuAqn+ufbAc=;
        h=Date:To:From:Subject:From;
        b=NS459bioKUXAIGRxfY2Onbgec5yJM3UHGnAJbSbEaad6pjgrzWgt0uGdPWeUAXyI6
         vcPxGr0aLVZ5sQXeAKlEfqhUE5iWKZROnLd2uQEB6VMFQvDIhrnZIhJukrJ835J0gY
         WEum1fLLfUiMDygP9yClccAtV7Dpzh6LvkIeOOOI=
Date:   Tue, 03 Oct 2023 10:02:41 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, wangkefeng.wang@huawei.com,
        vishal.moola@gmail.com, tj@kernel.org, surenb@google.com,
        sidhartha.kumar@oracle.com, shy828301@gmail.com,
        mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-migration-attempt-to-match-interleave-nodes.patch added to mm-unstable branch
Message-Id: <20231003170242.22CBCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: migration attempt to match interleave nodes
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-migration-attempt-to-match-interleave-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-migration-attempt-to-match-interleave-nodes.patch

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
Subject: mempolicy: migration attempt to match interleave nodes
Date: Tue, 3 Oct 2023 02:29:00 -0700 (PDT)

Improve alloc_migration_target_by_mpol()'s treatment of MPOL_INTERLEAVE.

Make an effort in do_mbind(), to identify the correct interleave index for
the first page to be migrated, so that it and all subsequent pages from
the same vma will be targeted to precisely their intended nodes.  Pages
from following vmas will still be interleaved from the requested nodemask,
but perhaps starting from a different base.

Whether this is worth doing at all, or worth improving further, is
arguable: queue_folio_required() is right not to care about the precise
placement on interleaved nodes; but this little effort seems appropriate.

Link: https://lkml.kernel.org/r/77954a5-9c9b-1c11-7d5c-3262c01b895f@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun heo <tj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   49 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mempolicy-migration-attempt-to-match-interleave-nodes
+++ a/mm/mempolicy.c
@@ -430,6 +430,11 @@ static bool strictly_unmovable(unsigned
 			 MPOL_MF_STRICT;
 }
 
+struct migration_mpol {		/* for alloc_migration_target_by_mpol() */
+	struct mempolicy *pol;
+	pgoff_t ilx;
+};
+
 struct queue_pages {
 	struct list_head *pagelist;
 	unsigned long flags;
@@ -1178,8 +1183,9 @@ int do_migrate_pages(struct mm_struct *m
 static struct folio *alloc_migration_target_by_mpol(struct folio *src,
 						    unsigned long private)
 {
-	struct mempolicy *pol = (struct mempolicy *)private;
-	pgoff_t ilx = 0;	/* improve on this later */
+	struct migration_mpol *mmpol = (struct migration_mpol *)private;
+	struct mempolicy *pol = mmpol->pol;
+	pgoff_t ilx = mmpol->ilx;
 	struct page *page;
 	unsigned int order;
 	int nid = numa_node_id();
@@ -1234,6 +1240,7 @@ static long do_mbind(unsigned long start
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
 	struct vma_iterator vmi;
+	struct migration_mpol mmpol;
 	struct mempolicy *new;
 	unsigned long end;
 	long err;
@@ -1314,9 +1321,45 @@ static long do_mbind(unsigned long start
 			new = get_task_policy(current);
 			mpol_get(new);
 		}
+		mmpol.pol = new;
+		mmpol.ilx = 0;
+
+		/*
+		 * In the interleaved case, attempt to allocate on exactly the
+		 * targeted nodes, for the first VMA to be migrated; for later
+		 * VMAs, the nodes will still be interleaved from the targeted
+		 * nodemask, but one by one may be selected differently.
+		 */
+		if (new->mode == MPOL_INTERLEAVE) {
+			struct page *page;
+			unsigned int order;
+			unsigned long addr = -EFAULT;
+
+			list_for_each_entry(page, &pagelist, lru) {
+				if (!PageKsm(page))
+					break;
+			}
+			if (!list_entry_is_head(page, &pagelist, lru)) {
+				vma_iter_init(&vmi, mm, start);
+				for_each_vma_range(vmi, vma, end) {
+					addr = page_address_in_vma(page, vma);
+					if (addr != -EFAULT)
+						break;
+				}
+			}
+			if (addr != -EFAULT) {
+				order = compound_order(page);
+				/* We already know the pol, but not the ilx */
+				mpol_cond_put(get_vma_policy(vma, addr, order,
+							     &mmpol.ilx));
+				/* Set base from which to increment by index */
+				mmpol.ilx -= page->index >> order;
+			}
+		}
+
 		nr_failed |= migrate_pages(&pagelist,
 				alloc_migration_target_by_mpol, NULL,
-				(unsigned long)new, MIGRATE_SYNC,
+				(unsigned long)&mmpol, MIGRATE_SYNC,
 				MR_MEMPOLICY_MBIND, NULL);
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch
shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch
shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch
shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch
shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch
shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch
shmem-_add_to_page_cache-before-shmem_inode_acct_blocks.patch
shmempercpu_counter-add-_limited_addfbc-limit-amount.patch
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

