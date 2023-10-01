Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AC5E7848B
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 19:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbjJAT4u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 15:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbjJAT4t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 15:56:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248EBDA
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 12:56:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD349C433C9;
        Sun,  1 Oct 2023 19:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696190206;
        bh=sVqLfmTikcDVa9YaV3955eCJ+g0GbSXzflc+3bUZcg8=;
        h=Date:To:From:Subject:From;
        b=Tglh+HcfDgOBd/CgL7WzhxYGIP8p0bLXM7qJFDPfPGG6CBv+3amrBG6aIr4Jnks2f
         O7X5XGp5Phkd/v2xp2WQSY3cvjlcpbHXyBnjPNjln7L8TR4bLmlgb9/yzCKB2YZJvI
         KKi+ApI1M6YG74ZK2BBXvcBXBac1pZTwK7wYLbdM=
Date:   Sun, 01 Oct 2023 12:56:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch added to mm-unstable branch
Message-Id: <20231001195646.AD349C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: shmem_acct_blocks() and shmem_inode_acct_blocks()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch

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
Subject: shmem: shmem_acct_blocks() and shmem_inode_acct_blocks()
Date: Fri, 29 Sep 2023 20:30:03 -0700 (PDT)

By historical accident, shmem_acct_block() and shmem_inode_acct_block()
were never pluralized when the pages argument was added, despite their
complements being shmem_unacct_blocks() and shmem_inode_unacct_blocks()
all along.  It has been an irritation: fix their naming at last.

Link: https://lkml.kernel.org/r/9124094-e4ab-8be7-ef80-9a87bdc2e4fc@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
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
@@ -1688,7 +1688,7 @@ static struct folio *shmem_alloc_and_acc
 		huge = false;
 	nr = huge ? HPAGE_PMD_NR : 1;
 
-	err = shmem_inode_acct_block(inode, nr);
+	err = shmem_inode_acct_blocks(inode, nr);
 	if (err)
 		goto failed;
 
@@ -2589,7 +2589,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 	int ret;
 	pgoff_t max_off;
 
-	if (shmem_inode_acct_block(inode, 1)) {
+	if (shmem_inode_acct_blocks(inode, 1)) {
 		/*
 		 * We may have got a page, returned -ENOENT triggering a retry,
 		 * and now we find ourselves with -ENOMEM. Release the page, to
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

