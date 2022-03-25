Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779D6C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357321AbiCYBcJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357354AbiCYBbu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E042CC8F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3D25617C7
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABC3C340EC;
        Fri, 25 Mar 2022 01:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171815;
        bh=hXHgmtHX7X/ML1jc2wm3e2rQsmluqt3xEr2cXtJYeM4=;
        h=Date:To:From:Subject:From;
        b=yagtzScCRQlTifP9x1G+bQpYEneT/wHK6jZrm645gwjENkiixket7l9byzagcnciY
         VLsMXe1UvoWUn6Ngft+BWtpfL9UoOsTG/4WFxHpfYDajuRl9hVRvg6Vt2JrwB/IuL4
         OWs/tNNF0lBIPqn9UZ8nSqRr2r6LnjMI5328MTXs=
Date:   Thu, 24 Mar 2022 18:30:14 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com,
        chris@chrisdown.name, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] memcg-refactor-mem_cgroup_oom.patch removed from -mm tree
Message-Id: <20220325013015.5ABC3C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: refactor mem_cgroup_oom
has been removed from the -mm tree.  Its filename was
     memcg-refactor-mem_cgroup_oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: refactor mem_cgroup_oom

Patch series "memcg: robust enforcement of memory.high", v2.

Due to the semantics of memory.high enforcement i.e.  throttle the
workload without oom-kill, we are trying to use it for right sizing the
workloads in our production environment.  However we observed the
mechanism fails for some specific applications which does big chunck of
allocations in a single syscall.  The reason behind this failure is due to
the limitation of the memory.high enforcement's current implementation.

This patch series solves this issue by enforcing the memory.high
synchronously if the current process has accumulated a large amount of
high overcharge.


This patch (of 4):

The function mem_cgroup_oom returns enum which has four possible values
but the caller does not care about such values and only cares if the
return value is OOM_SUCCESS or not.  So, remove the enum altogether and
make mem_cgroup_oom returns a simple bool.

Link: https://lkml.kernel.org/r/20220211064917.2028469-1-shakeelb@google.com
Link: https://lkml.kernel.org/r/20220211064917.2028469-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

--- a/mm/memcontrol.c~memcg-refactor-mem_cgroup_oom
+++ a/mm/memcontrol.c
@@ -1796,20 +1796,16 @@ static void memcg_oom_recover(struct mem
 		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
-enum oom_status {
-	OOM_SUCCESS,
-	OOM_FAILED,
-	OOM_ASYNC,
-	OOM_SKIPPED
-};
-
-static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
+/*
+ * Returns true if successfully killed one or more processes. Though in some
+ * corner cases it can return true even without killing any process.
+ */
+static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	enum oom_status ret;
-	bool locked;
+	bool locked, ret;
 
 	if (order > PAGE_ALLOC_COSTLY_ORDER)
-		return OOM_SKIPPED;
+		return false;
 
 	memcg_memory_event(memcg, MEMCG_OOM);
 
@@ -1832,14 +1828,13 @@ static enum oom_status mem_cgroup_oom(st
 	 * victim and then we have to bail out from the charge path.
 	 */
 	if (memcg->oom_kill_disable) {
-		if (!current->in_user_fault)
-			return OOM_SKIPPED;
-		css_get(&memcg->css);
-		current->memcg_in_oom = memcg;
-		current->memcg_oom_gfp_mask = mask;
-		current->memcg_oom_order = order;
-
-		return OOM_ASYNC;
+		if (current->in_user_fault) {
+			css_get(&memcg->css);
+			current->memcg_in_oom = memcg;
+			current->memcg_oom_gfp_mask = mask;
+			current->memcg_oom_order = order;
+		}
+		return false;
 	}
 
 	mem_cgroup_mark_under_oom(memcg);
@@ -1850,10 +1845,7 @@ static enum oom_status mem_cgroup_oom(st
 		mem_cgroup_oom_notify(memcg);
 
 	mem_cgroup_unmark_under_oom(memcg);
-	if (mem_cgroup_out_of_memory(memcg, mask, order))
-		ret = OOM_SUCCESS;
-	else
-		ret = OOM_FAILED;
+	ret = mem_cgroup_out_of_memory(memcg, mask, order);
 
 	if (locked)
 		mem_cgroup_oom_unlock(memcg);
@@ -2546,7 +2538,6 @@ static int try_charge_memcg(struct mem_c
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
-	enum oom_status oom_status;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
 	bool may_swap = true;
@@ -2649,9 +2640,8 @@ retry:
 	 * a forward progress or bypass the charge if the oom killer
 	 * couldn't make any progress.
 	 */
-	oom_status = mem_cgroup_oom(mem_over_limit, gfp_mask,
-		       get_order(nr_pages * PAGE_SIZE));
-	if (oom_status == OOM_SUCCESS) {
+	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
+			   get_order(nr_pages * PAGE_SIZE))) {
 		passed_oom = true;
 		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-sync-flush-only-if-periodic-flush-is-delayed.patch

