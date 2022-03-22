Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CEDC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbiCVVl6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiCVVlv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:41:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DA75EBCF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1E6FB81DAF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCEBC340F3;
        Tue, 22 Mar 2022 21:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985220;
        bh=YfZYAxqg2c4a5w0CyZsCfpyonl3kxXWETzWlCY61GNk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=F5Ln4NJtuKnhu2Lwh5H2Bf/T145sdCH6xebNlw4SpiJUkj2Xn8hJ6D0trbNj0wZFD
         YIuHkoscx5lxetp2yGYftJPu9bidj39LtxtmoXLbUJhG8f3/UZhpsIr6qtq+t6Pi9x
         GMmu1PGUown78x/bCAEOJYfH+eTNlWa/uAcPr6O4=
Date:   Tue, 22 Mar 2022 14:40:19 -0700
To:     roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        guro@fb.com, chris@chrisdown.name, shakeelb@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 036/227] memcg: refactor mem_cgroup_oom
Message-Id: <20220322214020.7FCEBC340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
