Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734C3CD8CAE
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 18:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbjJJSSa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbjJJSS3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 14:18:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02C794
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 11:18:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36DCC433C8;
        Tue, 10 Oct 2023 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696961907;
        bh=IKx6N0YW2PyO23DmgELgpHp7D7tsOYxecL900Ca9lzk=;
        h=Date:To:From:Subject:From;
        b=LDiSfmlN279dhsOGxQYVN7ogGkTmUeTi+nNweqmdiQjhPHWbJm6sdwQZ9hlRUhBL2
         1l9v8ujjymfyZfW2cSe2JkCQzZF8lcgbWg7RaQxrc4BiWTGmcPedPpiQP1OiLNmigy
         5P2vrMv7wxcGELFjDyu/InBdJIriI86v1OAWQQlg=
Date:   Tue, 10 Oct 2023 11:18:10 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, ivan@cloudflare.com, hannes@cmpxchg.org,
        gthelen@google.com, cerasuolodomenico@gmail.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-change-flush_next_time-to-flush_last_time.patch added to mm-unstable branch
Message-Id: <20231010181822.A36DCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: change flush_next_time to flush_last_time
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-change-flush_next_time-to-flush_last_time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-change-flush_next_time-to-flush_last_time.patch

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
Subject: mm: memcg: change flush_next_time to flush_last_time
Date: Tue, 10 Oct 2023 03:21:12 +0000

Patch series "mm: memcg: subtree stats flushing and thresholds", v2.

This series attempts to address shortages in today's approach for memcg
stats flushing, namely occasionally stale or expensive stat reads.  The
series does so by changing the threshold that we use to decide whether to
trigger a flush to be per memcg instead of global (patch 3), and then
changing flushing to be per memcg (i.e.  subtree flushes) instead of
global (patch 5).

Patch 3 & 5 are the core of the series, and they include more details
and testing results. The rest are either cleanups or prep work.

This series replaces the "memcg: more sophisticated stats flushing" series
[1], which also replaces another series, in a long list of attempts to
improve memcg stats flushing.  It is not a new version of the same
patchset as it is a completely different approach.  This is based on
collected feedback from discussions on lkml in all previous attempts. 
Hopefully, this is the final attempt.

[1]https://lore.kernel.org/lkml/20230913073846.1528938-1-yosryahmed@google.com/

Domenico Cerasuolo reported:

: We backported it on a 5.19-based kernel and ran it on a machine for almost
: a week now.  The goal was to fix a CPU utilization regression caused by
: memory stats readings, it seems that this series was the last bit needed
: to completely fix it and bring CPU utilization to 5.12 levels.


This patch (of 5):

flush_next_time is an inaccurate name.  It's not the next time that
periodic flushing will happen, it's rather the next time that ratelimited
flushing can happen if the periodic flusher is late.

Simplify its semantics by just storing the timestamp of the last flush
instead, flush_last_time.  Move the 2*FLUSH_TIME addition to
mem_cgroup_flush_stats_ratelimited(), and add a comment explaining it. 
This way, all the ratelimiting semantics live in one place.

No functional change intended.

Link: https://lkml.kernel.org/r/20231010032117.1577496-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20231010032117.1577496-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-change-flush_next_time-to-flush_last_time
+++ a/mm/memcontrol.c
@@ -590,7 +590,7 @@ static DECLARE_DEFERRABLE_WORK(stats_flu
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
-static u64 flush_next_time;
+static u64 flush_last_time;
 
 #define FLUSH_TIME (2UL*HZ)
 
@@ -650,7 +650,7 @@ static void do_flush_stats(void)
 	    atomic_xchg(&stats_flush_ongoing, 1))
 		return;
 
-	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
+	WRITE_ONCE(flush_last_time, jiffies_64);
 
 	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
 
@@ -666,7 +666,8 @@ void mem_cgroup_flush_stats(void)
 
 void mem_cgroup_flush_stats_ratelimited(void)
 {
-	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
+	/* Only flush if the periodic flusher is one full cycle late */
+	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
 		mem_cgroup_flush_stats();
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-refactor-page-state-unit-helpers.patch
mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated.patch
mm-memcg-change-flush_next_time-to-flush_last_time.patch
mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch
mm-memcg-make-stats-flushing-threshold-per-memcg.patch
mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
mm-memcg-restore-subtree-stats-flushing.patch

