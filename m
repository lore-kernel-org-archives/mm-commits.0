Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7CCEEAA55
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 16:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241555AbjINQCy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241556AbjINQCe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 12:02:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67A42128;
        Thu, 14 Sep 2023 09:02:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EE5C433C8;
        Thu, 14 Sep 2023 16:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694707332;
        bh=9S5dEFwze1BwipEEnoaZ0WNJ8rCGVYUJxrrobpl2m2w=;
        h=Date:To:From:Subject:From;
        b=QfhcMFk8D6cxIKcJdEQEvZVbpb2CQ7n8MKJRDU8rlJ1ujdc3MJPtbfy1C4/UE57oX
         JrqAePsTeBKntOAZfhcLzyYevl9MeENsSpogMqafHkaVDMUZwoSyItykJ72qhkkXDK
         IMGDjs+jitaC30WRmCYu7zAX1UYPmEBkpRGMGQAw=
Date:   Thu, 14 Sep 2023 09:02:11 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, leitao@debian.org,
        josef@toxicpanda.com, hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-gfp_nofs-recursion-in-memoryhigh-enforcement.patch added to mm-hotfixes-unstable branch
Message-Id: <20230914160212.71EE5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix GFP_NOFS recursion in memory.high enforcement
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-fix-gfp_nofs-recursion-in-memoryhigh-enforcement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-gfp_nofs-recursion-in-memoryhigh-enforcement.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix GFP_NOFS recursion in memory.high enforcement
Date: Thu, 14 Sep 2023 11:21:39 -0400

Breno and Josef report a deadlock scenario from cgroup reclaim
re-entering the filesystem:

[  361.546690] ======================================================
[  361.559210] WARNING: possible circular locking dependency detected
[  361.571703] 6.5.0-0_fbk700_debug_rc0_kbuilder_13159_gbf787a128001 #1 Tainted: G S          E
[  361.589704] ------------------------------------------------------
[  361.602277] find/9315 is trying to acquire lock:
[  361.611625] ffff88837ba140c0 (&delayed_node->mutex){+.+.}-{4:4}, at: __btrfs_release_delayed_node+0x68/0x4f0
[  361.631437]
[  361.631437] but task is already holding lock:
[  361.643243] ffff8881765b8678 (btrfs-tree-01){++++}-{4:4}, at: btrfs_tree_read_lock+0x1e/0x40

[  362.904457]  mutex_lock_nested+0x1c/0x30
[  362.912414]  __btrfs_release_delayed_node+0x68/0x4f0
[  362.922460]  btrfs_evict_inode+0x301/0x770
[  362.982726]  evict+0x17c/0x380
[  362.988944]  prune_icache_sb+0x100/0x1d0
[  363.005559]  super_cache_scan+0x1f8/0x260
[  363.013695]  do_shrink_slab+0x2a2/0x540
[  363.021489]  shrink_slab_memcg+0x237/0x3d0
[  363.050606]  shrink_slab+0xa7/0x240
[  363.083382]  shrink_node_memcgs+0x262/0x3b0
[  363.091870]  shrink_node+0x1a4/0x720
[  363.099150]  shrink_zones+0x1f6/0x5d0
[  363.148798]  do_try_to_free_pages+0x19b/0x5e0
[  363.157633]  try_to_free_mem_cgroup_pages+0x266/0x370
[  363.190575]  reclaim_high+0x16f/0x1f0
[  363.208409]  mem_cgroup_handle_over_high+0x10b/0x270
[  363.246678]  try_charge_memcg+0xaf2/0xc70
[  363.304151]  charge_memcg+0xf0/0x350
[  363.320070]  __mem_cgroup_charge+0x28/0x40
[  363.328371]  __filemap_add_folio+0x870/0xd50
[  363.371303]  filemap_add_folio+0xdd/0x310
[  363.399696]  __filemap_get_folio+0x2fc/0x7d0
[  363.419086]  pagecache_get_page+0xe/0x30
[  363.427048]  alloc_extent_buffer+0x1cd/0x6a0
[  363.435704]  read_tree_block+0x43/0xc0
[  363.443316]  read_block_for_search+0x361/0x510
[  363.466690]  btrfs_search_slot+0xc8c/0x1520

This is caused by the mem_cgroup_handle_over_high() not respecting the
gfp_mask of the allocation context.  We used to only call this function on
resume to userspace, where no locks were held.  But c9afe31ec443 ("memcg:
synchronously enforce memory.high for large overcharges") added a call
from the allocation context without considering the gfp.

Link: https://lkml.kernel.org/r/20230914152139.100822-1-hannes@cmpxchg.org
Fixes: c9afe31ec443 ("memcg: synchronously enforce memory.high for large overcharges")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Breno Leitao <leitao@debian.org>
Reported-by: Josef Bacik <josef@toxicpanda.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h       |    4 ++--
 include/linux/resume_user_mode.h |    2 +-
 mm/memcontrol.c                  |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-fix-gfp_nofs-recursion-in-memoryhigh-enforcement
+++ a/include/linux/memcontrol.h
@@ -920,7 +920,7 @@ unsigned long mem_cgroup_get_zone_lru_si
 	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
 }
 
-void mem_cgroup_handle_over_high(void);
+void mem_cgroup_handle_over_high(gfp_t gfp_mask);
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
@@ -1458,7 +1458,7 @@ static inline void mem_cgroup_unlock_pag
 	rcu_read_unlock();
 }
 
-static inline void mem_cgroup_handle_over_high(void)
+static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 }
 
--- a/include/linux/resume_user_mode.h~mm-memcontrol-fix-gfp_nofs-recursion-in-memoryhigh-enforcement
+++ a/include/linux/resume_user_mode.h
@@ -55,7 +55,7 @@ static inline void resume_user_mode_work
 	}
 #endif
 
-	mem_cgroup_handle_over_high();
+	mem_cgroup_handle_over_high(GFP_KERNEL);
 	blkcg_maybe_throttle_current();
 
 	rseq_handle_notify_resume(NULL, regs);
--- a/mm/memcontrol.c~mm-memcontrol-fix-gfp_nofs-recursion-in-memoryhigh-enforcement
+++ a/mm/memcontrol.c
@@ -2555,7 +2555,7 @@ static unsigned long calculate_high_dela
  * Scheduled by try_charge() to be executed from the userland return path
  * and reclaims memory over the high limit.
  */
-void mem_cgroup_handle_over_high(void)
+void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 	unsigned long penalty_jiffies;
 	unsigned long pflags;
@@ -2583,7 +2583,7 @@ retry_reclaim:
 	 */
 	nr_reclaimed = reclaim_high(memcg,
 				    in_retry ? SWAP_CLUSTER_MAX : nr_pages,
-				    GFP_KERNEL);
+				    gfp_mask);
 
 	/*
 	 * memory.high is breached and reclaim is unable to keep up. Throttle
@@ -2819,7 +2819,7 @@ done_restock:
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
 	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask)) {
-		mem_cgroup_handle_over_high();
+		mem_cgroup_handle_over_high(gfp_mask);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch
mm-memcontrol-fix-gfp_nofs-recursion-in-memoryhigh-enforcement.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-consolidate-free-page-accounting.patch

