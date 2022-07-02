Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF90C43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 04:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiGBENt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Jul 2022 00:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiGBENs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Jul 2022 00:13:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6128E34BAF
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 21:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFEB660B9C
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 04:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47546C34114;
        Sat,  2 Jul 2022 04:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656735226;
        bh=yEVG2zWD/fGr4szMkIkbgNkElcwaU8R6il4SKKjAxzU=;
        h=Date:To:From:Subject:From;
        b=xSKljdfOL8OOyGJWmybpiLW5zQQjmPz5Fhw15M1LVrQD7nrRE2SxF0ki2c2p+rO1U
         m+eI79d6/GscAuT/Xk5VtV7nS29C1WCz//aTj4WYapTcEtOpRnyy5wd31ZtOn9hAkc
         R4+2oPwtEUfdDROZqRL1lyZgAujOwLfopfCAzTtI=
Date:   Fri, 01 Jul 2022 21:13:45 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, mhocko@kernel.org, laoar.shao@gmail.com,
        hannes@cmpxchg.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch added to mm-unstable branch
Message-Id: <20220702041346.47546C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     do not miss MEMCG_MAX events for enforced allocations Date: Fri, 1 Jul
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch

This patch will later appear in the mm-unstable branch at
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
From: Roman Gushchin <roman.gushchin@linux.dev> Subject: mm: memcontrol:
do not miss MEMCG_MAX events for enforced allocations Date: Fri, 1 Jul
2022 20:35:21 -0700 Yafang Shao reported an issue related to the
accounting of bpf memory: if a bpf map is charged indirectly for memory
consumed from an interrupt context and allocations are enforced, MEMCG_MAX
events are not raised.

It's not/less of an issue in a generic case because consequent allocations
from a process context will trigger the reclaim and MEMCG_MAX events. 
However a bpf map can belong to a dying/abandoned memory cgroup, so it
might never happen.  So the cgroup can significantly exceed the memory.max
limit without even triggering MEMCG_MAX events.

Fix this by making sure that we never enforce allocations without raising
a MEMCG_MAX event.

Link: https://lkml.kernel.org/r/20220702033521.64630-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reported-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations
+++ a/mm/memcontrol.c
@@ -2712,6 +2712,7 @@ static int try_charge_memcg(struct mem_c
 	bool passed_oom = false;
 	bool may_swap = true;
 	bool drained = false;
+	bool raised_max_event = false;
 	unsigned long pflags;
 
 retry:
@@ -2751,6 +2752,7 @@ retry:
 		goto nomem;
 
 	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
@@ -2818,6 +2820,13 @@ nomem:
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

mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch
mm-shrinkers-provide-shrinkers-with-names.patch
mm-shrinkers-provide-shrinkers-with-names-fix.patch
mm-docs-document-shrinker-debugfs.patch
tools-add-memcg_shrinkerpy.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix.patch
mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch

