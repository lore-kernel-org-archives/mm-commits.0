Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5B7C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5708E221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781317;
	bh=M/0MyN8poq5VJes0iC5bnxr2WvF5QR4caUDBSUFC6pU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BPeqg1DS+Q4PIJNA/V2u8KMmVRdhxk8iAHwXxHi7Pwy0QBgMmtA6/rc1vTBh0iQu9
	 ce4ptyZ8dehgaDa2dNumA28aAqac0LP9QHqW/96thA6GxVO0cY0g0jCmUmDor2gIXr
	 dytZL6pmjDgT2zAJ2Q3V0Bv+fu+00AIP3yp0fEj8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHGGV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGGV4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:21:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7436F22CB3;
        Fri,  7 Aug 2020 06:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781316;
        bh=M/0MyN8poq5VJes0iC5bnxr2WvF5QR4caUDBSUFC6pU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0Ytp3ECg0XdJ04xAqpzNCft9Mg6DFoPw9J/UoYWc6TYjYDi6So894qXsBcyQmIdmm
         SBD8GDU9+J+AYdf/ZJ5w4wWdlWGG+QkBJLSJXDWtGrRHojMv31xIT55YTwJZnVFBxp
         7ERx1IK4YWqm3hMBnptdzHSm2naJ8pjlzjfbjo+o=
Date:   Thu, 06 Aug 2020 23:21:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 086/163] mm, memcg: reclaim more aggressively
 before high allocator throttling
Message-ID: <20200807062154.skuN7Pgbg%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: reclaim more aggressively before high allocator throttling

Patch series "mm, memcg: reclaim harder before high throttling", v2.


This patch (of 2):

In Facebook production, we've seen cases where cgroups have been put into
allocator throttling even when they appear to have a lot of slack file
caches which should be trivially reclaimable.

Looking more closely, the problem is that we only try a single cgroup
reclaim walk for each return to usermode before calculating whether or not
we should throttle.  This single attempt doesn't produce enough pressure
to shrink for cgroups with a rapidly growing amount of file caches prior
to entering allocator throttling.

As an example, we see that threads in an affected cgroup are stuck in
allocator throttling:

    # for i in $(cat cgroup.threads); do
    >     grep over_high "/proc/$i/stack"
    > done
    [<0>] mem_cgroup_handle_over_high+0x10b/0x150
    [<0>] mem_cgroup_handle_over_high+0x10b/0x150
    [<0>] mem_cgroup_handle_over_high+0x10b/0x150

...however, there is no I/O pressure reported by PSI, despite a lot of
slack file pages:

    # cat memory.pressure
    some avg10=78.50 avg60=84.99 avg300=84.53 total=5702440903
    full avg10=78.50 avg60=84.99 avg300=84.53 total=5702116959
    # cat io.pressure
    some avg10=0.00 avg60=0.00 avg300=0.00 total=78051391
    full avg10=0.00 avg60=0.00 avg300=0.00 total=78049640
    # grep _file memory.stat
    inactive_file 1370939392
    active_file 661635072

This patch changes the behaviour to retry reclaim either until the current
task goes below the 10ms grace period, or we are making no reclaim
progress at all.  In the latter case, we enter reclaim throttling as
before.

To a user, there's no intuitive reason for the reclaim behaviour to differ
from hitting memory.high as part of a new allocation, as opposed to
hitting memory.high because someone lowered its value.  As such this also
brings an added benefit: it unifies the reclaim behaviour between the two.

There's precedent for this behaviour: we already do reclaim retries when
writing to memory.{high,max}, in max reclaim, and in the page allocator
itself.

Link: http://lkml.kernel.org/r/cover.1594640214.git.chris@chrisdown.name
Link: http://lkml.kernel.org/r/a4e23b59e9ef499b575ae73a8120ee089b7d3373.1594640214.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-reclaim-more-aggressively-before-high-allocator-throttling
+++ a/mm/memcontrol.c
@@ -73,6 +73,7 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 
 struct mem_cgroup *root_mem_cgroup __read_mostly;
 
+/* The number of times we should retry reclaim failures before giving up. */
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 
 /* Socket memory accounting disabled? */
@@ -2363,18 +2364,23 @@ static int memcg_hotplug_cpu_dead(unsign
 	return 0;
 }
 
-static void reclaim_high(struct mem_cgroup *memcg,
-			 unsigned int nr_pages,
-			 gfp_t gfp_mask)
+static unsigned long reclaim_high(struct mem_cgroup *memcg,
+				  unsigned int nr_pages,
+				  gfp_t gfp_mask)
 {
+	unsigned long nr_reclaimed = 0;
+
 	do {
 		if (page_counter_read(&memcg->memory) <=
 		    READ_ONCE(memcg->memory.high))
 			continue;
 		memcg_memory_event(memcg, MEMCG_HIGH);
-		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
+		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
+							     gfp_mask, true);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
+
+	return nr_reclaimed;
 }
 
 static void high_work_func(struct work_struct *work)
@@ -2530,16 +2536,32 @@ void mem_cgroup_handle_over_high(void)
 {
 	unsigned long penalty_jiffies;
 	unsigned long pflags;
+	unsigned long nr_reclaimed;
 	unsigned int nr_pages = current->memcg_nr_pages_over_high;
+	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup *memcg;
+	bool in_retry = false;
 
 	if (likely(!nr_pages))
 		return;
 
 	memcg = get_mem_cgroup_from_mm(current->mm);
-	reclaim_high(memcg, nr_pages, GFP_KERNEL);
 	current->memcg_nr_pages_over_high = 0;
 
+retry_reclaim:
+	/*
+	 * The allocating task should reclaim at least the batch size, but for
+	 * subsequent retries we only want to do what's necessary to prevent oom
+	 * or breaching resource isolation.
+	 *
+	 * This is distinct from memory.max or page allocator behaviour because
+	 * memory.high is currently batched, whereas memory.max and the page
+	 * allocator run every time an allocation is made.
+	 */
+	nr_reclaimed = reclaim_high(memcg,
+				    in_retry ? SWAP_CLUSTER_MAX : nr_pages,
+				    GFP_KERNEL);
+
 	/*
 	 * memory.high is breached and reclaim is unable to keep up. Throttle
 	 * allocators proactively to slow down excessive growth.
@@ -2567,6 +2589,16 @@ void mem_cgroup_handle_over_high(void)
 		goto out;
 
 	/*
+	 * If reclaim is making forward progress but we're still over
+	 * memory.high, we want to encourage that rather than doing allocator
+	 * throttling.
+	 */
+	if (nr_reclaimed || nr_retries--) {
+		in_retry = true;
+		goto retry_reclaim;
+	}
+
+	/*
 	 * If we exit early, we're guaranteed to die (since
 	 * schedule_timeout_killable sets TASK_KILLABLE). This means we don't
 	 * need to account for any ill-begotten jiffies to pay them off later.
_
