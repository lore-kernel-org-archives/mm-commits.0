Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6D7E7AD78
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240678AbjJCRCS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240671AbjJCRCS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:02:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871B6A7
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:02:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1024DC433C7;
        Tue,  3 Oct 2023 17:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696352534;
        bh=cohXHqNODwDtXCYmDBxkuyFQLgi3lSBoOk7BV1BfZf4=;
        h=Date:To:From:Subject:From;
        b=BU57HgC0XeJFNqt0e1MaxM5VWKiFiDpT3n7adg5nx/viNj4YhGGhAO/E4n3o7ZvxA
         y52dSsYNDgr23BiCOZ/Mha4D16CWn0ZngvDEbj0X8sKvsQQgeokIUFfcG+vlf2UuGz
         S6JKURv/5hgZ8EkA5h1OAWLmQW4kFBpo1bYoKxzM=
Date:   Tue, 03 Oct 2023 10:02:13 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, wangkefeng.wang@huawei.com,
        vishal.moola@gmail.com, tj@kernel.org, surenb@google.com,
        sidhartha.kumar@oracle.com, shy828301@gmail.com,
        mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-drop-shared-numa-mempolicy-pretence.patch added to mm-unstable branch
Message-Id: <20231003170214.1024DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: drop shared NUMA mempolicy pretence
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-drop-shared-numa-mempolicy-pretence.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-drop-shared-numa-mempolicy-pretence.patch

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
Subject: hugetlbfs: drop shared NUMA mempolicy pretence
Date: Tue, 3 Oct 2023 02:15:09 -0700 (PDT)

A series of mempolicy patches.  Mostly cleanups in mm/mempolicy.c, but
finally removing the pseudo-vma from shmem folio allocation, and removing
the mmap_lock around folio migration for mbind and migrate_pages syscalls.


This patch (of 12):

hugetlbfs_fallocate() goes through the motions of pasting a shared NUMA
mempolicy onto its pseudo-vma, but how could there ever be a shared NUMA
mempolicy for this file?  hugetlb_vm_ops has never offered a set_policy
method, and hugetlbfs_parse_param() has never supported any mpol options
for a mount-wide default policy.

It's just an illusion: clean it away so as not to confuse others, giving
us more freedom to adjust shmem's set_policy/get_policy implementation. 
But hugetlbfs_inode_info is still required, just to accommodate seals.

Yes, shared NUMA mempolicy support could be added to hugetlbfs, with a
set_policy method and/or mpol mount option (Andi's first posting did
include an admitted-unsatisfactory hugetlb_set_policy()); but it seems
that nobody has bothered to add that in the nineteen years since v2.6.7
made it possible, and there is at least one company that has invested
enough into hugetlbfs, that I guess they have learnt well enough how to
manage its NUMA, without needing shared mempolicy.

Remove linux/mempolicy.h from linux/hugetlb.h: include linux/pagemap.h in
its place, because hugetlb.h's recently added use of filemap_lock_folio()
requires that (although most .configs and .c's get it in some other way).

Link: https://lkml.kernel.org/r/ebc0987e-beff-8bfb-9283-234c2cbd17c5@google.com
Link: https://lkml.kernel.org/r/cae82d4b-904a-faaf-282a-34fcc188c81f@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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

 fs/hugetlbfs/inode.c    |   41 --------------------------------------
 include/linux/hugetlb.h |    3 --
 2 files changed, 2 insertions(+), 42 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-drop-shared-numa-mempolicy-pretence
+++ a/fs/hugetlbfs/inode.c
@@ -83,29 +83,6 @@ static const struct fs_parameter_spec hu
 	{}
 };
 
-#ifdef CONFIG_NUMA
-static inline void hugetlb_set_vma_policy(struct vm_area_struct *vma,
-					struct inode *inode, pgoff_t index)
-{
-	vma->vm_policy = mpol_shared_policy_lookup(&HUGETLBFS_I(inode)->policy,
-							index);
-}
-
-static inline void hugetlb_drop_vma_policy(struct vm_area_struct *vma)
-{
-	mpol_cond_put(vma->vm_policy);
-}
-#else
-static inline void hugetlb_set_vma_policy(struct vm_area_struct *vma,
-					struct inode *inode, pgoff_t index)
-{
-}
-
-static inline void hugetlb_drop_vma_policy(struct vm_area_struct *vma)
-{
-}
-#endif
-
 /*
  * Mask used when checking the page offset value passed in via system
  * calls.  This value will be converted to a loff_t which is signed.
@@ -853,8 +830,7 @@ static long hugetlbfs_fallocate(struct f
 
 	/*
 	 * Initialize a pseudo vma as this is required by the huge page
-	 * allocation routines.  If NUMA is configured, use page index
-	 * as input to create an allocation policy.
+	 * allocation routines.
 	 */
 	vma_init(&pseudo_vma, mm);
 	vm_flags_init(&pseudo_vma, VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
@@ -902,9 +878,7 @@ static long hugetlbfs_fallocate(struct f
 		 * folios in these areas, we need to consume the reserves
 		 * to keep reservation accounting consistent.
 		 */
-		hugetlb_set_vma_policy(&pseudo_vma, inode, index);
 		folio = alloc_hugetlb_folio(&pseudo_vma, addr, 0);
-		hugetlb_drop_vma_policy(&pseudo_vma);
 		if (IS_ERR(folio)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			error = PTR_ERR(folio);
@@ -1283,18 +1257,6 @@ static struct inode *hugetlbfs_alloc_ino
 		hugetlbfs_inc_free_inodes(sbinfo);
 		return NULL;
 	}
-
-	/*
-	 * Any time after allocation, hugetlbfs_destroy_inode can be called
-	 * for the inode.  mpol_free_shared_policy is unconditionally called
-	 * as part of hugetlbfs_destroy_inode.  So, initialize policy here
-	 * in case of a quick call to destroy.
-	 *
-	 * Note that the policy is initialized even if we are creating a
-	 * private inode.  This simplifies hugetlbfs_destroy_inode.
-	 */
-	mpol_shared_policy_init(&p->policy, NULL);
-
 	return &p->vfs_inode;
 }
 
@@ -1306,7 +1268,6 @@ static void hugetlbfs_free_inode(struct
 static void hugetlbfs_destroy_inode(struct inode *inode)
 {
 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
-	mpol_free_shared_policy(&HUGETLBFS_I(inode)->policy);
 }
 
 static const struct address_space_operations hugetlbfs_aops = {
--- a/include/linux/hugetlb.h~hugetlbfs-drop-shared-numa-mempolicy-pretence
+++ a/include/linux/hugetlb.h
@@ -30,7 +30,7 @@ void free_huge_folio(struct folio *folio
 
 #ifdef CONFIG_HUGETLB_PAGE
 
-#include <linux/mempolicy.h>
+#include <linux/pagemap.h>
 #include <linux/shm.h>
 #include <asm/tlbflush.h>
 
@@ -513,7 +513,6 @@ static inline struct hugetlbfs_sb_info *
 }
 
 struct hugetlbfs_inode_info {
-	struct shared_policy policy;
 	struct inode vfs_inode;
 	unsigned int seals;
 };
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

