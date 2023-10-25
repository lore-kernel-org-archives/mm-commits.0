Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C850C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjJYXip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjJYXip (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:38:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5825B13D
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:38:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E094BC433C8;
        Wed, 25 Oct 2023 23:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277123;
        bh=p2Qs9rySh0r1sZJB5ImdYuXGKozTh+94t78c42KeuPw=;
        h=Date:To:From:Subject:From;
        b=WdRyER43oem0ekLoe03bL1xSiW/EwYIBYtK+sFXGd4odIxxEP7HK4etbKSs8avZLj
         jKgo4OMNVsEfS0jmBIR6sshhqRYAteeKBrSPbnljKskOYkA1Yehmjc3OYQn+vX55zM
         djEnq0Piw40/VKOeGLSZMOOvRiZU5issY4fatnKs=
Date:   Wed, 25 Oct 2023 16:38:42 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, tj@kernel.org, surenb@google.com,
        sidhartha.kumar@oracle.com, shy828301@gmail.com, nphamcs@gmail.com,
        mimmocerasuolo@gmail.com, mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        gregkh@linuxfoundation.org, david@redhat.com, cl@linux.com,
        ak@linux.intel.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mempolicy-alloc_pages_mpol-for-numa-policy-without-vma-fix.patch removed from -mm tree
Message-Id: <20231025233842.E094BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mempolicy: alloc_pages_mpol() for NUMA policy without vma: fix
has been removed from the -mm tree.  Its filename was
     mempolicy-alloc_pages_mpol-for-numa-policy-without-vma-fix.patch

This patch was dropped because it was folded into mempolicy-alloc_pages_mpol-for-numa-policy-without-vma.patch

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

ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch
mm-mlock-avoid-folio_within_range-on-ksm-pages.patch
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
mempolicy-migration-attempt-to-match-interleave-nodes-fix.patch

