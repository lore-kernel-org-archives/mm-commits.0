Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 676B7C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 22:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjLFWdH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 17:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjLFWdG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 17:33:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D5ED46
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 14:33:13 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA12BC433C7;
        Wed,  6 Dec 2023 22:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701901992;
        bh=z7+pG/AymqY14FDoPhdoCihJY4mfrnPUZJ3hLsFsXNU=;
        h=Date:To:From:Subject:From;
        b=2YFAox8R4evNCRJgxnF8Vwgh/yvJEYRSbTQwRyGpzkurRwz8jxd10vz+Uo1CGeqjt
         ceWel/ppVORQpyAJJBP0uSLXMEGBJjkFqYfZNNrgs3kt9YWY2VZWhNUcDpr1JaWUrX
         qT07Tr2W8ifN+9142DnH+8ouCxabqjW8wPYex/XE=
Date:   Wed, 06 Dec 2023 14:33:11 -0800
To:     mm-commits@vger.kernel.org, weixugc@google.com, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, ivan@cloudflare.com, hannes@cmpxchg.org,
        gthelen@google.com, chrisl@kernel.org, cerasuolodomenico@gmail.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-restore-subtree-stats-flushing-fix-2.patch added to mm-unstable branch
Message-Id: <20231206223312.AA12BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: remove stats flushing mutex
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-restore-subtree-stats-flushing-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-restore-subtree-stats-flushing-fix-2.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: remove stats flushing mutex
Date: Mon, 4 Dec 2023 23:43:29 +0000

The mutex was intended to make the waiters sleep instead of spin, and such
that we can check the update thresholds again after acquiring the mutex. 
However, the mutex has a risk of priority inversion, especially since the
underlying rstat lock can de dropped while the mutex is held.

Synthetic testing with high concurrency of flushers shows no regressions
without the mutex, so remove it.

Link: https://lkml.kernel.org/r/CAJD7tkZgP3m-VVPn+fF_YuvXeQYK=tZZjJHj=dzD=CcSSpp2qg@mail.gmail.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-restore-subtree-stats-flushing-fix-2
+++ a/mm/memcontrol.c
@@ -749,21 +749,14 @@ static void do_flush_stats(struct mem_cg
  */
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
-	static DEFINE_MUTEX(memcg_stats_flush_mutex);
-
 	if (mem_cgroup_disabled())
 		return;
 
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
-	if (memcg_should_flush_stats(memcg)) {
-		mutex_lock(&memcg_stats_flush_mutex);
-		/* Check again after locking, another flush may have occurred */
-		if (memcg_should_flush_stats(memcg))
-			do_flush_stats(memcg);
-		mutex_unlock(&memcg_stats_flush_mutex);
-	}
+	if (memcg_should_flush_stats(memcg))
+		do_flush_stats(memcg);
 }
 
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-change-flush_next_time-to-flush_last_time.patch
mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch
mm-memcg-make-stats-flushing-threshold-per-memcg.patch
mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
mm-memcg-restore-subtree-stats-flushing.patch
mm-memcg-restore-subtree-stats-flushing-fix-2.patch

