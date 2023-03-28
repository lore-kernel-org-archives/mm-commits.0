Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432FAC77B6C
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjC1XWN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjC1XWC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B54030EF
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA84EB81F55
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86995C4339B;
        Tue, 28 Mar 2023 23:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045705;
        bh=yImhTqJW3KIp0Rl61yZnTgmns0ltJAOOnXdUJD93Rvg=;
        h=Date:To:From:Subject:From;
        b=KHHeI7xY8mKePWOjeRImBQHfDQyS+BxXAPEDqnC2NzWV5jRtICbZQECdhYQBEbuin
         xCiImfUQJXPBL9UwLdGbys+d0LefwlnbIFBdScTMk1qRUJxYtkDy0Edjf43g9rtjiy
         jFcj6SoVL+pqH7j/js6JbUUARv3aeCKOfVTMEwHU=
Date:   Tue, 28 Mar 2023 16:21:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-prevent-memoryswappiness-load-store-tearing.patch removed from -mm tree
Message-Id: <20230328232145.86995C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, memcg: prevent memory.swappiness load/store tearing
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memoryswappiness-load-store-tearing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yue Zhao <findns94@gmail.com>
Subject: mm, memcg: Prevent memory.swappiness load/store tearing
Date: Mon, 6 Mar 2023 23:41:36 +0800

The knob for cgroup v1 memory controller: memory.swappiness is not
protected by any locking so it can be modified while it is used.  This is
not an actual problem because races are unlikely.  But it is better to use
[READ|WRITE]_ONCE to prevent compiler from doing anything funky.

The access of memcg->swappiness and vm_swappiness is lockless, so both of
them can be concurrently set at the same time as we are trying to read
them.  All occurrences of memcg->swappiness and vm_swappiness are updated
with [READ|WRITE]_ONCE.

[findns94@gmail.com: v3]
  Link: https://lkml.kernel.org/r/20230308162555.14195-3-findns94@gmail.com
Link: https://lkml.kernel.org/r/20230306154138.3775-3-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    8 ++++----
 mm/memcontrol.c      |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/swap.h~mm-memcg-prevent-memoryswappiness-load-store-tearing
+++ a/include/linux/swap.h
@@ -620,18 +620,18 @@ static inline int mem_cgroup_swappiness(
 {
 	/* Cgroup2 doesn't have per-cgroup swappiness */
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return vm_swappiness;
+		return READ_ONCE(vm_swappiness);
 
 	/* root ? */
 	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return vm_swappiness;
+		return READ_ONCE(vm_swappiness);
 
-	return memcg->swappiness;
+	return READ_ONCE(memcg->swappiness);
 }
 #else
 static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
 {
-	return vm_swappiness;
+	return READ_ONCE(vm_swappiness);
 }
 #endif
 
--- a/mm/memcontrol.c~mm-memcg-prevent-memoryswappiness-load-store-tearing
+++ a/mm/memcontrol.c
@@ -4179,9 +4179,9 @@ static int mem_cgroup_swappiness_write(s
 		return -EINVAL;
 
 	if (!mem_cgroup_is_root(memcg))
-		memcg->swappiness = val;
+		WRITE_ONCE(memcg->swappiness, val);
 	else
-		vm_swappiness = val;
+		WRITE_ONCE(vm_swappiness, val);
 
 	return 0;
 }
@@ -5353,7 +5353,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
-		memcg->swappiness = mem_cgroup_swappiness(parent);
+		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->oom_kill_disable = parent->oom_kill_disable;
 
 		page_counter_init(&memcg->memory, &parent->memory);
_

Patches currently in -mm which might be from findns94@gmail.com are


