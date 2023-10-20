Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F13C07480
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 17:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377926AbjJTR0o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjJTR0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 13:26:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B6D10C1
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 10:26:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C43FC433C7;
        Fri, 20 Oct 2023 17:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697822800;
        bh=nN3EuFMy4wqnwJ//roihyt3+mD/DTtkEIVf8m/x3DAs=;
        h=Date:To:From:Subject:From;
        b=F8mZan3Z2/vtSgS3V8Xo3YD87W34m+RsIyNwtxIvF6VKl/LOJMal7S4PLoQyCnFTL
         /Sf4jqxIo3MGkaPHBDMXmgdP6aNj1O4dTXNt/B3VLjImyKycz8H0mHhTjz/3LBAxAz
         nDdWYhIGaawAFAkW8UO8Un+hxtZ9/vkx1x/UFkfI=
Date:   Fri, 20 Oct 2023 10:26:39 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com, tj@kernel.org,
        surenb@google.com, sidhartha.kumar@oracle.com, shy828301@gmail.com,
        nphamcs@gmail.com, mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch added to mm-unstable branch
Message-Id: <20231020172640.0C43FC433C7@smtp.kernel.org>
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

 include/linux/mempolicy.h |   20 +++++++-------------
 mm/mempolicy.c            |   12 ++++++------
 2 files changed, 13 insertions(+), 19 deletions(-)

--- a/include/linux/mempolicy.h~mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree
+++ a/include/linux/mempolicy.h
@@ -105,22 +105,16 @@ static inline bool mpol_equal(struct mem
 
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
@@ -128,7 +122,7 @@ int mpol_set_shared_policy(struct shared
 			   struct vm_area_struct *vma, struct mempolicy *mpol);
 void mpol_free_shared_policy(struct shared_policy *sp);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
-					    unsigned long idx);
+					    pgoff_t idx);
 
 struct mempolicy *get_task_policy(struct task_struct *p);
 struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
@@ -214,7 +208,7 @@ static inline void mpol_free_shared_poli
 }
 
 static inline struct mempolicy *
-mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
+mpol_shared_policy_lookup(struct shared_policy *sp, pgoff_t idx)
 {
 	return NULL;
 }
--- a/mm/mempolicy.c~mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree
+++ a/mm/mempolicy.c
@@ -2428,8 +2428,8 @@ bool __mpol_equal(struct mempolicy *a, s
  * lookup first element intersecting start-end.  Caller holds sp->lock for
  * reading or for writing
  */
-static struct sp_node *
-sp_lookup(struct shared_policy *sp, unsigned long start, unsigned long end)
+static struct sp_node *sp_lookup(struct shared_policy *sp,
+					pgoff_t start, pgoff_t end)
 {
 	struct rb_node *n = sp->root.rb_node;
 
@@ -2483,8 +2483,8 @@ static void sp_insert(struct shared_poli
 }
 
 /* Find shared policy intersecting idx */
-struct mempolicy *
-mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
+struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
+						pgoff_t idx)
 {
 	struct mempolicy *pol = NULL;
 	struct sp_node *sn;
@@ -2652,8 +2652,8 @@ static struct sp_node *sp_alloc(unsigned
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

