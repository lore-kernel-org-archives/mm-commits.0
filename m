Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC83E7AD77
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbjJCRCY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240690AbjJCRCX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:02:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2306A7
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:02:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F519C433C7;
        Tue,  3 Oct 2023 17:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696352536;
        bh=PNKe87B4o3RpWotcOp3bSefYcTMPysxRNJTKhQ2yns4=;
        h=Date:To:From:Subject:From;
        b=nQ0MF8u15FvSH46f+JIvTn8L9LDmqggH3TFLq3XszwaxspP3EeYYONCGCDxc9u8Rw
         Muh5L+wyn3+iotgUVrE9eOAbYrRYxH5oAKJ/Y9PHLRpJ+dpXtdCEKi1HdNGkx+aGva
         lH/wDZDa2zddauOrPzEL0edMi8gC/F4nr3ogagEg=
Date:   Tue, 03 Oct 2023 10:02:15 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, wangkefeng.wang@huawei.com,
        vishal.moola@gmail.com, tj@kernel.org, surenb@google.com,
        sidhartha.kumar@oracle.com, shy828301@gmail.com,
        mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernfs-drop-shared-numa-mempolicy-hooks.patch added to mm-unstable branch
Message-Id: <20231003170216.6F519C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernfs: drop shared NUMA mempolicy hooks
has been added to the -mm mm-unstable branch.  Its filename is
     kernfs-drop-shared-numa-mempolicy-hooks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernfs-drop-shared-numa-mempolicy-hooks.patch

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
Subject: kernfs: drop shared NUMA mempolicy hooks
Date: Tue, 3 Oct 2023 02:16:29 -0700 (PDT)

It seems strange that kernfs should be an outlier with a set_policy and
get_policy in its kernfs_vm_ops.  Ah, it dates back to v2.6.30's commit
095160aee954 ("sysfs: fix some bin_vm_ops errors"), when I had crashed on
powerpc's pci_mmap_legacy_page_range() fallback to shmem_zero_setup().

Well, that was commendably thorough, to give sysfs-bin a set_policy and
get_policy, just to avoid the way it was coded resulting in EINVAL from
mmap when CONFIG_NUMA; but somehow feels a bit over-the-top to me now.

It's easier to say that nobody should expect to manage a shmem object's
shared NUMA mempolicy via some kernfs backdoor to that object: delete that
code (and there's no longer an EINVAL from mmap in the NUMA case).

This then leaves set_policy/get_policy as implemented only by shmem -
though importantly also by SysV SHM, which has to interface with shmem
which implements them, and with SHM_HUGETLB which does not.

Link: https://lkml.kernel.org/r/302164-a760-4a9e-879b-6870c9b4013@google.com
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

 fs/kernfs/file.c |   49 ---------------------------------------------
 1 file changed, 49 deletions(-)

--- a/fs/kernfs/file.c~kernfs-drop-shared-numa-mempolicy-hooks
+++ a/fs/kernfs/file.c
@@ -429,60 +429,11 @@ static int kernfs_vma_access(struct vm_a
 	return ret;
 }
 
-#ifdef CONFIG_NUMA
-static int kernfs_vma_set_policy(struct vm_area_struct *vma,
-				 struct mempolicy *new)
-{
-	struct file *file = vma->vm_file;
-	struct kernfs_open_file *of = kernfs_of(file);
-	int ret;
-
-	if (!of->vm_ops)
-		return 0;
-
-	if (!kernfs_get_active(of->kn))
-		return -EINVAL;
-
-	ret = 0;
-	if (of->vm_ops->set_policy)
-		ret = of->vm_ops->set_policy(vma, new);
-
-	kernfs_put_active(of->kn);
-	return ret;
-}
-
-static struct mempolicy *kernfs_vma_get_policy(struct vm_area_struct *vma,
-					       unsigned long addr)
-{
-	struct file *file = vma->vm_file;
-	struct kernfs_open_file *of = kernfs_of(file);
-	struct mempolicy *pol;
-
-	if (!of->vm_ops)
-		return vma->vm_policy;
-
-	if (!kernfs_get_active(of->kn))
-		return vma->vm_policy;
-
-	pol = vma->vm_policy;
-	if (of->vm_ops->get_policy)
-		pol = of->vm_ops->get_policy(vma, addr);
-
-	kernfs_put_active(of->kn);
-	return pol;
-}
-
-#endif
-
 static const struct vm_operations_struct kernfs_vm_ops = {
 	.open		= kernfs_vma_open,
 	.fault		= kernfs_vma_fault,
 	.page_mkwrite	= kernfs_vma_page_mkwrite,
 	.access		= kernfs_vma_access,
-#ifdef CONFIG_NUMA
-	.set_policy	= kernfs_vma_set_policy,
-	.get_policy	= kernfs_vma_get_policy,
-#endif
 };
 
 static int kernfs_fop_mmap(struct file *file, struct vm_area_struct *vma)
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

