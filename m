Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182EBC3F6B0
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbiG3BIV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239575AbiG3BIS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B6B820DC
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C5DEB82925
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF646C433D7;
        Sat, 30 Jul 2022 01:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143295;
        bh=91ebt7uU27dcDR7lfV8iBjebOjfG8MbwAa0ZUQO3YHU=;
        h=Date:To:From:Subject:From;
        b=ZWCk2vDB1YaUd49pyRjvw91i7iDQ8NK00Cg7H2MdAgggIrcpdZV23c86qgJtNRg6Q
         yzvZ7MWatVUEZLXU/46Rp4128F0QQuJaNWxSBfLZydiTeS5K7NYASVumhxYWkcDzCX
         LzArscHyUECFrmJcEigJeM5biWP8PsgzZGNLfol8=
Date:   Fri, 29 Jul 2022 18:08:15 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, mhocko@suse.com, laoar.shao@gmail.com,
        hannes@cmpxchg.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch removed from -mm tree
Message-Id: <20220730010815.AF646C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations
Date: Fri, 1 Jul 2022 20:35:21 -0700

Yafang Shao reported an issue related to the accounting of bpf memory:
if a bpf map is charged indirectly for memory consumed from an
interrupt context and allocations are enforced, MEMCG_MAX events are
not raised.

It's not/less of an issue in a generic case because consequent
allocations from a process context will trigger the direct reclaim and
MEMCG_MAX events will be raised.  However a bpf map can belong to a
dying/abandoned memory cgroup, so there will be no allocations from a
process context and no MEMCG_MAX events will be triggered.

Link: https://lkml.kernel.org/r/20220702033521.64630-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reported-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations
+++ a/mm/memcontrol.c
@@ -2577,6 +2577,7 @@ static int try_charge_memcg(struct mem_c
 	bool passed_oom = false;
 	bool may_swap = true;
 	bool drained = false;
+	bool raised_max_event = false;
 	unsigned long pflags;
 
 retry:
@@ -2616,6 +2617,7 @@ retry:
 		goto nomem;
 
 	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
@@ -2683,6 +2685,13 @@ nomem:
 		return -ENOMEM;
 force:
 	/*
+	 * If the allocation has to be enforced, don't forget to raise
+	 * a MEMCG_MAX event.
+	 */
+	if (!raised_max_event)
+		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+
+	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
 	 * temporarily by force charging it.
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


