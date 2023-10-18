Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6B4CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbjJRVgH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbjJRVfs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDC5FE
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBFFC433AB;
        Wed, 18 Oct 2023 21:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664905;
        bh=7Sj4U7+xKhpi9rhKYM9OZ/UUWCv+OOSWvvdT3kNqSlo=;
        h=Date:To:From:Subject:From;
        b=C1v8SMSMIhWegldqC47DU62XsCfvDDq03ui8Tjm2Lnmukn2kz6BT32citMnBmtDnS
         5NniB1b5gI4Z9Kvygw+fCYEe+/Qwc5BEXgJNXmLYulWObGCEgvmlgkS58esl1aDltc
         NYDrYli/icLlXYnmEw13RaR6Y2ET/osAo9j+F3GI=
Date:   Wed, 18 Oct 2023 14:35:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch removed from -mm tree
Message-Id: <20231018213505.1CBFFC433AB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: shmem_acct_blocks() and shmem_inode_acct_blocks()
has been removed from the -mm tree.  Its filename was
     shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: shmem_acct_blocks() and shmem_inode_acct_blocks()
Date: Fri, 29 Sep 2023 20:30:03 -0700 (PDT)

By historical accident, shmem_acct_block() and shmem_inode_acct_block()
were never pluralized when the pages argument was added, despite their
complements being shmem_unacct_blocks() and shmem_inode_unacct_blocks()
all along.  It has been an irritation: fix their naming at last.

Link: https://lkml.kernel.org/r/9124094-e4ab-8be7-ef80-9a87bdc2e4fc@google.com
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

 mm/shmem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/shmem.c~shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks
+++ a/mm/shmem.c
@@ -189,10 +189,10 @@ static inline int shmem_reacct_size(unsi
 /*
  * ... whereas tmpfs objects are accounted incrementally as
  * pages are allocated, in order to allow large sparse files.
- * shmem_get_folio reports shmem_acct_block failure as -ENOSPC not -ENOMEM,
+ * shmem_get_folio reports shmem_acct_blocks failure as -ENOSPC not -ENOMEM,
  * so that a failure on a sparse tmpfs mapping will give SIGBUS not OOM.
  */
-static inline int shmem_acct_block(unsigned long flags, long pages)
+static inline int shmem_acct_blocks(unsigned long flags, long pages)
 {
 	if (!(flags & VM_NORESERVE))
 		return 0;
@@ -207,13 +207,13 @@ static inline void shmem_unacct_blocks(u
 		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
 }
 
-static int shmem_inode_acct_block(struct inode *inode, long pages)
+static int shmem_inode_acct_blocks(struct inode *inode, long pages)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	int err = -ENOSPC;
 
-	if (shmem_acct_block(info->flags, pages))
+	if (shmem_acct_blocks(info->flags, pages))
 		return err;
 
 	might_sleep();	/* when quotas */
@@ -447,7 +447,7 @@ bool shmem_charge(struct inode *inode, l
 {
 	struct address_space *mapping = inode->i_mapping;
 
-	if (shmem_inode_acct_block(inode, pages))
+	if (shmem_inode_acct_blocks(inode, pages))
 		return false;
 
 	/* nrpages adjustment first, then shmem_recalc_inode() when balanced */
@@ -1671,7 +1671,7 @@ static struct folio *shmem_alloc_and_acc
 		huge = false;
 	nr = huge ? HPAGE_PMD_NR : 1;
 
-	err = shmem_inode_acct_block(inode, nr);
+	err = shmem_inode_acct_blocks(inode, nr);
 	if (err)
 		goto failed;
 
@@ -2572,7 +2572,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 	int ret;
 	pgoff_t max_off;
 
-	if (shmem_inode_acct_block(inode, 1)) {
+	if (shmem_inode_acct_blocks(inode, 1)) {
 		/*
 		 * We may have got a page, returned -ENOENT triggering a retry,
 		 * and now we find ourselves with -ENOMEM. Release the page, to
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

