Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A436FCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjJRVfv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbjJRVfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E7AD4B
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA39C433A9;
        Wed, 18 Oct 2023 21:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664902;
        bh=qjqv2nXsHsPg16pki0yPEiuzdmSQSd1UlF/BRpwDD8M=;
        h=Date:To:From:Subject:From;
        b=VxER9NvSq59jmIRGMv+kCOFRFYQJmJOhaI6xpEFaNhE+XX1NZvbAScqhpReBrHn9q
         W38BkU1qG3NkdendaXecMqBfYNnR3PwzweFXdNXXMo5VcPZoNXu+CVoHzFx2aXGjTO
         z3D3cB/eA0WKUF2W64TQCnLgjvtvPfKq2LLs9krA=
Date:   Wed, 18 Oct 2023 14:35:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch removed from -mm tree
Message-Id: <20231018213502.0BA39C433A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: remove vma arg from shmem_get_folio_gfp()
has been removed from the -mm tree.  Its filename was
     shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: remove vma arg from shmem_get_folio_gfp()
Date: Fri, 29 Sep 2023 20:26:53 -0700 (PDT)

The vma is already there in vmf->vma, so no need for a separate arg.

Link: https://lkml.kernel.org/r/d9ce6f65-a2ed-48f4-4299-fdb0544875c5@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/shmem.c~shmem-remove-vma-arg-from-shmem_get_folio_gfp
+++ a/mm/shmem.c
@@ -1921,14 +1921,13 @@ unlock:
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache.
  *
- * vma, vmf, and fault_type are only supplied by shmem_fault:
- * otherwise they are NULL.
+ * vmf and fault_type are only supplied by shmem_fault: otherwise they are NULL.
  */
 static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
-		struct vm_area_struct *vma, struct vm_fault *vmf,
-		vm_fault_t *fault_type)
+		struct vm_fault *vmf, vm_fault_t *fault_type)
 {
+	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
@@ -2141,7 +2140,7 @@ int shmem_get_folio(struct inode *inode,
 		enum sgp_type sgp)
 {
 	return shmem_get_folio_gfp(inode, index, foliop, sgp,
-			mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
+			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
 }
 
 /*
@@ -2225,7 +2224,7 @@ static vm_fault_t shmem_fault(struct vm_
 	}
 
 	err = shmem_get_folio_gfp(inode, vmf->pgoff, &folio, SGP_CACHE,
-				  gfp, vma, vmf, &ret);
+				  gfp, vmf, &ret);
 	if (err)
 		return vmf_error(err);
 	if (folio)
@@ -4893,7 +4892,7 @@ struct folio *shmem_read_folio_gfp(struc
 
 	BUG_ON(!shmem_mapping(mapping));
 	error = shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
-				  gfp, NULL, NULL, NULL);
+				    gfp, NULL, NULL);
 	if (error)
 		return ERR_PTR(error);
 
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

