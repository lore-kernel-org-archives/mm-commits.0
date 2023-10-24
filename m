Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 783CAC00A8F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Oct 2023 16:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343692AbjJXQUx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Oct 2023 12:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234765AbjJXQUt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Oct 2023 12:20:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DBC10D1
        for <mm-commits@vger.kernel.org>; Tue, 24 Oct 2023 09:20:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDE4C433CC;
        Tue, 24 Oct 2023 16:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698164442;
        bh=t7Culnysa1GMZ43qlju1tl3usthsYUc94UhE5nFLV7o=;
        h=Date:To:From:Subject:From;
        b=giqZ8gv1E4EkyUyoNF5En9nPTaengdbz6LtOudaAdprGeTJQa+ZAvpmVP/N/EFUPs
         VYB7DA6Iekdc1DVuAGqzOTWourR+oljxJJNHanMZsErtjN4OHdLvQUqhqTVtXIxol5
         bgAjH94UF1GiTwIL3ULCtGvpapH8UMC81upNe5oY=
Date:   Tue, 24 Oct 2023 09:20:41 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, tj@kernel.org, surenb@google.com,
        sidhartha.kumar@oracle.com, shy828301@gmail.com, nphamcs@gmail.com,
        mimmocerasuolo@gmail.com, mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        gregkh@linuxfoundation.org, david@redhat.com, cl@linux.com,
        ak@linux.intel.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-alloc_pages_mpol-for-numa-policy-without-vma-fix.patch added to mm-unstable branch
Message-Id: <20231024162042.8FDE4C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: alloc_pages_mpol() for NUMA policy without vma: fix
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-alloc_pages_mpol-for-numa-policy-without-vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-alloc_pages_mpol-for-numa-policy-without-vma-fix.patch

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
Subject: mempolicy: alloc_pages_mpol() for NUMA policy without vma: fix
Date: Tue, 24 Oct 2023 09:09:39 -0700 (PDT)

mm-unstable commit 48a7bd12d57f ("mempolicy: alloc_pages_mpol() for NUMA
policy without vma") ended read_swap_cache_async() supporting NULL vma -
okay; but missed the NULL mpol being passed to __read_swap_cache_async()
by zswap_writeback_entry() - oops!

Since its other callers all give good mpol, add get_task_policy(current)
there in mm/zswap.c, to produce the same good-enough behaviour as before
(and task policy, acted on in current task, does not require the refcount
to be dup'ed).

But if that policy is (quite reasonably) MPOL_INTERLEAVE, then ilx must be
NO_INTERLEAVE_INDEX rather than 0, to provide the same distribution as
before: move that definition from mempolicy.c to mempolicy.h.

Link: https://lkml.kernel.org/r/ea419956-4751-0102-21f7-9c93cb957892@google.com
Fixes: 48a7bd12d57f ("mempolicy: alloc_pages_mpol() for NUMA policy without vma")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Domenico Cerasuolo <mimmocerasuolo@gmail.com>
Closes: https://lore.kernel.org/linux-mm/74e34633-6060-f5e3-aee-7040d43f2e93@google.com/T/#mf08c877d1884fc7867f9e328cdf02257ff3b3ae9
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
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
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    7 +++++++
 mm/mempolicy.c            |    2 --
 mm/zswap.c                |    7 +++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/include/linux/mempolicy.h~mempolicy-alloc_pages_mpol-for-numa-policy-without-vma-fix
+++ a/include/linux/mempolicy.h
@@ -17,6 +17,8 @@
 
 struct mm_struct;
 
+#define NO_INTERLEAVE_INDEX (-1UL)	/* use task il_prev for interleaving */
+
 #ifdef CONFIG_NUMA
 
 /*
@@ -179,6 +181,11 @@ extern bool apply_policy_zone(struct mem
 
 struct mempolicy {};
 
+static inline struct mempolicy *get_task_policy(struct task_struct *p)
+{
+	return NULL;
+}
+
 static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
 	return true;
--- a/mm/mempolicy.c~mempolicy-alloc_pages_mpol-for-numa-policy-without-vma-fix
+++ a/mm/mempolicy.c
@@ -114,8 +114,6 @@
 #define MPOL_MF_INVERT       (MPOL_MF_INTERNAL << 1)	/* Invert check for nodemask */
 #define MPOL_MF_WRLOCK       (MPOL_MF_INTERNAL << 2)	/* Write-lock walked vmas */
 
-#define NO_INTERLEAVE_INDEX (-1UL)
-
 static struct kmem_cache *policy_cache;
 static struct kmem_cache *sn_cache;
 
--- a/mm/zswap.c~mempolicy-alloc_pages_mpol-for-numa-policy-without-vma-fix
+++ a/mm/zswap.c
@@ -24,6 +24,7 @@
 #include <linux/swap.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
+#include <linux/mempolicy.h>
 #include <linux/mempool.h>
 #include <linux/zpool.h>
 #include <crypto/acompress.h>
@@ -1057,6 +1058,7 @@ static int zswap_writeback_entry(struct
 {
 	swp_entry_t swpentry = entry->swpentry;
 	struct page *page;
+	struct mempolicy *mpol;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct zpool *pool = zswap_find_zpool(entry);
@@ -1075,8 +1077,9 @@ static int zswap_writeback_entry(struct
 	}
 
 	/* try to allocate swap cache page */
-	page = __read_swap_cache_async(swpentry, GFP_KERNEL, NULL, 0,
-				       &page_was_allocated);
+	mpol = get_task_policy(current);
+	page = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
+				NO_INTERLEAVE_INDEX, &page_was_allocated);
 	if (!page) {
 		ret = -ENOMEM;
 		goto fail;
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
mempolicy-alloc_pages_mpol-for-numa-policy-without-vma-fix.patch
mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch
mempolicy-migration-attempt-to-match-interleave-nodes.patch
mempolicy-migration-attempt-to-match-interleave-nodes-fix.patch
ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch
mm-mlock-avoid-folio_within_range-on-ksm-pages.patch

