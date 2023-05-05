Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE6FC77B75
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjEEWpK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjEEWpK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:45:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4764EC6
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E3C2635C7
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91ACC433D2;
        Fri,  5 May 2023 22:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326708;
        bh=EAqxXKm5anD7R2WIRRWluDQcNH9MaAvc8KyamjSy2FI=;
        h=Date:To:From:Subject:From;
        b=q1fiFs4THf/YUvf31TgMHuXDnVrNfipC7Zzi4xyoyE0sv/t/D4YFJMXH8V5cJrpZI
         XU99WaxIbbqOdHDGz6mo3c9ckR+eLG3DgoiYyGQEMzL1wu4uVi0v36uIYNWts4Vl0e
         Ra3j1hd2/qMZVqV7Em5de04nLJ7SPg28lDTRT0g8=
Date:   Fri, 05 May 2023 15:45:07 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, longman@redhat.com,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] cpuset-clean-up-cpuset_node_allowed.patch removed from -mm tree
Message-Id: <20230505224507.D91ACC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cpuset: clean up cpuset_node_allowed
has been removed from the -mm tree.  Its filename was
     cpuset-clean-up-cpuset_node_allowed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: cpuset: clean up cpuset_node_allowed
Date: Tue, 28 Feb 2023 08:35:37 +0000

Commit 002f290627c2 ("cpuset: use static key better and convert to new
API") used __cpuset_node_allowed() instead of cpuset_node_allowed() to
check whether we can allocate on a memory node.  Now this function isn't
used by anyone, so we can do the follow things to clean it up.

1. remove unused codes
2. rename __cpuset_node_allowed() to cpuset_node_allowed()
3. update comments in mm/page_alloc.c

Link: https://lkml.kernel.org/r/20230228083537.102665-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: Waiman Long <longman@redhat.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   16 ++--------------
 kernel/cgroup/cpuset.c |    4 ++--
 mm/page_alloc.c        |    4 ++--
 3 files changed, 6 insertions(+), 18 deletions(-)

--- a/include/linux/cpuset.h~cpuset-clean-up-cpuset_node_allowed
+++ a/include/linux/cpuset.h
@@ -80,18 +80,11 @@ extern nodemask_t cpuset_mems_allowed(st
 void cpuset_init_current_mems_allowed(void);
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
-extern bool __cpuset_node_allowed(int node, gfp_t gfp_mask);
-
-static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
-{
-	if (cpusets_enabled())
-		return __cpuset_node_allowed(node, gfp_mask);
-	return true;
-}
+extern bool cpuset_node_allowed(int node, gfp_t gfp_mask);
 
 static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 {
-	return __cpuset_node_allowed(zone_to_nid(z), gfp_mask);
+	return cpuset_node_allowed(zone_to_nid(z), gfp_mask);
 }
 
 static inline bool cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
@@ -223,11 +216,6 @@ static inline int cpuset_nodemask_valid_
 	return 1;
 }
 
-static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
-{
-	return true;
-}
-
 static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 {
 	return true;
--- a/kernel/cgroup/cpuset.c~cpuset-clean-up-cpuset_node_allowed
+++ a/kernel/cgroup/cpuset.c
@@ -3941,7 +3941,7 @@ static struct cpuset *nearest_hardwall_a
 }
 
 /*
- * __cpuset_node_allowed - Can we allocate on a memory node?
+ * cpuset_node_allowed - Can we allocate on a memory node?
  * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
@@ -3980,7 +3980,7 @@ static struct cpuset *nearest_hardwall_a
  *	GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  */
-bool __cpuset_node_allowed(int node, gfp_t gfp_mask)
+bool cpuset_node_allowed(int node, gfp_t gfp_mask)
 {
 	struct cpuset *cs;		/* current cpuset ancestors */
 	bool allowed;			/* is allocation in zone z allowed? */
--- a/mm/page_alloc.c~cpuset-clean-up-cpuset_node_allowed
+++ a/mm/page_alloc.c
@@ -3394,7 +3394,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-	 * See also __cpuset_node_allowed() comment in kernel/cgroup/cpuset.c.
+	 * See also cpuset_node_allowed() comment in kernel/cgroup/cpuset.c.
 	 */
 	no_fallback = alloc_flags & ALLOC_NOFRAGMENT;
 	z = ac->preferred_zoneref;
@@ -4068,7 +4068,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
 		/*
 		 * Ignore cpuset mems for non-blocking __GFP_HIGH (probably
 		 * GFP_ATOMIC) rather than fail, see the comment for
-		 * __cpuset_node_allowed().
+		 * cpuset_node_allowed().
 		 */
 		if (alloc_flags & ALLOC_MIN_RESERVE)
 			alloc_flags &= ~ALLOC_CPUSET;
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch
memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch

