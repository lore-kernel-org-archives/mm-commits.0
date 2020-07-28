Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637AAC433E5
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD772075D
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595969882;
	bh=f3lin5cvBRmFILUd//+TegMixdPmkRfLUhspvf2If0M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NxvYM12qPnLDcrpO/FoSBHNXP4Iep4nOHOyTtwvISePL8UP+sg74diGSz5OOIxfEq
	 D3G8+tqvFb2kHcQ7dOyh5ktIpPAsmotOfmTNlhop5XjGogH4yuGN0c/1hTaHX2LT6o
	 +VL4dcJEXxEO033pW6Lgt/wNj1Cs+kjNIc5SoylU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgG1U6B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 16:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbgG1U6B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 16:58:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC7A820714;
        Tue, 28 Jul 2020 20:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595969880;
        bh=f3lin5cvBRmFILUd//+TegMixdPmkRfLUhspvf2If0M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=H7zjoVws7EbuVzFGZP9wT2rVbaQYWXnLiQyAH0dJmV/uSeyYSMEsQffzNckgVfMgM
         us8ImClQ3Ub4lmRbC2ybsKPGg398wcvcWYFCgPKA3oJBVNJhiFFsx5tPsHVZ9Eelkc
         VXdEklRquSpwPOmeDHdqG8cR6j9mwhrowF0l9IsU=
Date:   Tue, 28 Jul 2020 13:58:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  +
 mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure.patch
 added to -mm tree
Message-ID: <20200728205800.63g9CUrcp%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: don't count limit-setting reclaim as memory pressure
has been added to the -mm tree.  Its filename is
     mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++++-
 mm/vmscan.c     |    6 ------
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure
+++ a/mm/memcontrol.c
@@ -2376,12 +2376,18 @@ static unsigned long reclaim_high(struct
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
 
@@ -2623,10 +2629,11 @@ static int try_charge(struct mem_cgroup
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
@@ -2686,8 +2693,10 @@ retry:
 
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

mm-memcontrol-decouple-reference-counting-from-page-accounting.patch
mm-memcontrol-dont-count-limit-setting-reclaim-as-memory-pressure.patch

