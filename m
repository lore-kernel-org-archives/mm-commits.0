Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E1FE7AD78
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjJCRCc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240555AbjJCRC3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:02:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4759B
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:02:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A44C433CA;
        Tue,  3 Oct 2023 17:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696352545;
        bh=PhYq9JjbAIaOLTIdX073bo2yVUDf2BMYF5xQduAbyXc=;
        h=Date:To:From:Subject:From;
        b=CeSblAITYTdJ2m1KBccrafNO2/Q7b8jAeIih4tsfD4Itv90wnI3niFQ8gClN9qjLT
         oGkNeaO0Tnrl+T+4x7bDGStKh0TVGD8/YUPxrJ+49AYkoAYORTCiUltmSnwIm7zGKT
         tmEuEu6MFqgNuBimHbrGKeaU7/2tl25B7tRa813E=
Date:   Tue, 03 Oct 2023 10:02:24 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, wangkefeng.wang@huawei.com,
        vishal.moola@gmail.com, tj@kernel.org, surenb@google.com,
        sidhartha.kumar@oracle.com, shy828301@gmail.com,
        mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch added to mm-unstable branch
Message-Id: <20231003170225.21A44C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy trivia: use pgoff_t in shared mempolicy tree
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch

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
Subject: mempolicy trivia: use pgoff_t in shared mempolicy tree
Date: Tue, 3 Oct 2023 02:21:34 -0700 (PDT)

Prefer the more explicit "pgoff_t" to "unsigned long" when dealing with a
shared mempolicy tree.  Delete confusing comment about pseudo mm vmas.

Link: https://lkml.kernel.org/r/5451157-3818-4af5-fd2c-5d26a5d1dc53@google.com
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

 include/linux/mempolicy.h |   20 +++++++-------------
 mm/mempolicy.c            |   12 ++++++------
 2 files changed, 13 insertions(+), 19 deletions(-)

--- a/include/linux/mempolicy.h~mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree
+++ a/include/linux/mempolicy.h
@@ -107,22 +107,16 @@ static inline bool mpol_equal(struct mem
 
 /*
  * Tree of shared policies for a shared memory region.
- * Maintain the policies in a pseudo mm that contains vmas. The vmas
- * carry the policy. As a special twist the pseudo mm is indexed in pages, not
- * bytes, so that we can work with shared memory segments bigger than
- * unsigned long.
  */
-
-struct sp_node {
-	struct rb_node nd;
-	unsigned long start, end;
-	struct mempolicy *policy;
-};
-
 struct shared_policy {
 	struct rb_root root;
 	rwlock_t lock;
 };
+struct sp_node {
+	struct rb_node nd;
+	pgoff_t start, end;
+	struct mempolicy *policy;
+};
 
 int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst);
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
@@ -130,7 +124,7 @@ int mpol_set_shared_policy(struct shared
 			   struct vm_area_struct *vma, struct mempolicy *mpol);
 void mpol_free_shared_policy(struct shared_policy *sp);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
-					    unsigned long idx);
+					    pgoff_t idx);
 
 struct mempolicy *get_task_policy(struct task_struct *p);
 struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
@@ -216,7 +210,7 @@ static inline void mpol_free_shared_poli
 }
 
 static inline struct mempolicy *
-mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
+mpol_shared_policy_lookup(struct shared_policy *sp, pgoff_t idx)
 {
 	return NULL;
 }
--- a/mm/mempolicy.c~mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree
+++ a/mm/mempolicy.c
@@ -2448,8 +2448,8 @@ bool __mpol_equal(struct mempolicy *a, s
  * lookup first element intersecting start-end.  Caller holds sp->lock for
  * reading or for writing
  */
-static struct sp_node *
-sp_lookup(struct shared_policy *sp, unsigned long start, unsigned long end)
+static struct sp_node *sp_lookup(struct shared_policy *sp,
+					pgoff_t start, pgoff_t end)
 {
 	struct rb_node *n = sp->root.rb_node;
 
@@ -2503,8 +2503,8 @@ static void sp_insert(struct shared_poli
 }
 
 /* Find shared policy intersecting idx */
-struct mempolicy *
-mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
+struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
+						pgoff_t idx)
 {
 	struct mempolicy *pol = NULL;
 	struct sp_node *sn;
@@ -2672,8 +2672,8 @@ static struct sp_node *sp_alloc(unsigned
 }
 
 /* Replace a policy range. */
-static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
-				 unsigned long end, struct sp_node *new)
+static int shared_policy_replace(struct shared_policy *sp, pgoff_t start,
+				 pgoff_t end, struct sp_node *new)
 {
 	struct sp_node *n;
 	struct sp_node *n_new = NULL;
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

