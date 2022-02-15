Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27518C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiBOUtK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:49:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbiBOUtJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:49:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6BABC14
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:48:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2416CE2386
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F410AC340EB;
        Tue, 15 Feb 2022 20:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958135;
        bh=a+Y6vMjWX+ndFtYHbu4dvUDPQHcAWeinvbky51oh6Ag=;
        h=Date:To:From:Subject:From;
        b=XCwnl7pmuu/Zf8+ZW6V+Tbuje/LpHmWJJqCYpef7AWVQYLuOvotCKix0597wDpj2J
         GAjv96dQRrHnPuNvLYu8H85gHc8GNCtYrnwePvVfZnl4IoTXuFD/tzfDoDlaQDzOPn
         mCvbox9F3FDU1UMt5pV7t2Fa2ILMvFz+injnTNvY=
Date:   Tue, 15 Feb 2022 12:48:54 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        guro@fb.com, chris@chrisdown.name, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-refactor-mem_cgroup_oom.patch added to -mm tree
Message-Id: <20220215204854.F410AC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: refactor mem_cgroup_oom
has been added to the -mm tree.  Its filename is
     memcg-refactor-mem_cgroup_oom.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-refactor-mem_cgroup_oom.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-refactor-mem_cgroup_oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-replace-in_interrupt-with-in_task.patch
memcg-refactor-mem_cgroup_oom.patch
memcg-unify-force-charging-conditions.patch
selftests-memcg-test-high-limit-for-single-entry-allocation.patch
memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch

