Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4DCC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D0D2206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027053;
	bh=ciXd0Hydi3B7YhpjLv9dDy1+D+C3qB0StF7fhepEtAk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=iWvEMNEMPEA9dVVpWHZEtw6i4GgFoRhbwv2mr2UgkvsEy3varARwP78Au/YITZ+Cr
	 j2D6FEI3RzXQgrlkHVbTebArIDezId2JbPriPe/ML2T5bzbu7k2i/toAsXVQxlHujM
	 bzLeBlv1LaD7XIzv2QB41QAMgXXFY9NuZ/ewLUMk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgHJChd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJChc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 961AB2065D;
        Mon, 10 Aug 2020 02:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027051;
        bh=ciXd0Hydi3B7YhpjLv9dDy1+D+C3qB0StF7fhepEtAk=;
        h=Date:From:To:Subject:From;
        b=dxODwQHIAtX0232uSIXWNtprx20G87y73Qoj2v/fBdibIiD8xvVFcl4yatPl9h2PM
         U9eBvA6+YsyQX6YPfrKz2cs1+tS0q5sew5Ub6KFIppLEBisnDNpVYLgETD6eMP2mqg
         qf7lJUmddG0/VPhIvQGMIRq1e5Q9JXWKRlCw2QOE=
Date:   Sun, 09 Aug 2020 19:37:31 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure.patch
 removed from -mm tree
Message-ID: <20200810023731.wXB97qLZp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: don't count limit-setting reclaim as memory pressure
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: don't count limit-setting reclaim as memory pressure

When an outside process lowers one of the memory limits of a cgroup (or
uses the force_empty knob in cgroup1), direct reclaim is performed in the
context of the write(), in order to directly enforce the new limit and
have it being met by the time the write() returns.

Currently, this reclaim activity is accounted as memory pressure in the
cgroup that the writer(!) belongs to.  This is unexpected.  It
specifically causes problems for senpai
(https://github.com/facebookincubator/senpai), which is an agent that
routinely adjusts the memory limits and performs associated reclaim work
in tens or even hundreds of cgroups running on the host.  The cgroup that
senpai is running in itself will report elevated levels of memory
pressure, even though it itself is under no memory shortage or any sort of
distress.

Move the psi annotation from the central cgroup reclaim function to
callsites in the allocation context, and thereby no longer count any
limit-setting reclaim as memory pressure.  If the newly set limit causes
the workload inside the cgroup into direct reclaim, that of course will
continue to count as memory pressure.

Link: http://lkml.kernel.org/r/20200728135210.379885-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++++-
 mm/vmscan.c     |    6 ------
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure
+++ a/mm/memcontrol.c
@@ -2374,12 +2374,18 @@ static unsigned long reclaim_high(struct
 	unsigned long nr_reclaimed = 0;
 
 	do {
+		unsigned long pflags;
+
 		if (page_counter_read(&memcg->memory) <=
 		    READ_ONCE(memcg->memory.high))
 			continue;
+
 		memcg_memory_event(memcg, MEMCG_HIGH);
+
+		psi_memstall_enter(&pflags);
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							     gfp_mask, true);
+		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
 
@@ -2621,10 +2627,11 @@ static int try_charge(struct mem_cgroup
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
+	enum oom_status oom_status;
 	unsigned long nr_reclaimed;
 	bool may_swap = true;
 	bool drained = false;
-	enum oom_status oom_status;
+	unsigned long pflags;
 
 	if (mem_cgroup_is_root(memcg))
 		return 0;
@@ -2684,8 +2691,10 @@ retry:
 
 	memcg_memory_event(mem_over_limit, MEMCG_MAX);
 
+	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, may_swap);
+	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		goto retry;
--- a/mm/vmscan.c~mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure
+++ a/mm/vmscan.c
@@ -3310,7 +3310,6 @@ unsigned long try_to_free_mem_cgroup_pag
 					   bool may_swap)
 {
 	unsigned long nr_reclaimed;
-	unsigned long pflags;
 	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
@@ -3331,17 +3330,12 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-
 	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
-
-	psi_memstall_enter(&pflags);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
-	psi_memstall_leave(&pflags);
-
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 	set_task_reclaim_state(current, NULL);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


