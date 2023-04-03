Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDD7C76188
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 21:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbjDCVYC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 17:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjDCVXp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 17:23:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131D149CC
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 14:23:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B323B62C2E
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 21:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9BFC433EF;
        Mon,  3 Apr 2023 21:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680556992;
        bh=X0kl8CkVYZjOon6FLac7L02UddABFV4/j07B6g1lNls=;
        h=Date:To:From:Subject:From;
        b=0/DvkJpbA/7YEoTdOGOp5WADk4mlLy1pJgYeJfK/cIX6Kr2aJSo+ak5foqqHUw424
         1MFUAEnsgMdIxqpgFKIRoL6N15s8Ah1vDXes03TYTg0gz5OgWjha0X26dz6ZjOpBc1
         BX/SwWTiuKbaScGp49MwIiRsZsioBTcsmBZMU/io=
Date:   Mon, 03 Apr 2023 14:23:11 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, lizefan.x@bytedance.com, josef@toxicpanda.com,
        hannes@cmpxchg.org, axboe@kernel.dk, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic.patch added to mm-unstable branch
Message-Id: <20230403212312.0B9BFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: rename cgroup_rstat_flush_"irqsafe" to "atomic"
has been added to the -mm mm-unstable branch.  Its filename is
     cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic.patch

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
Subject: cgroup: rename cgroup_rstat_flush_"irqsafe" to "atomic"
Date: Thu, 30 Mar 2023 19:17:54 +0000

Patch series "memcg: avoid flushing stats atomically where possible", v3.

rstat flushing is an expensive operation that scales with the number of
cpus and the number of cgroups in the system.  The purpose of this series
is to minimize the contexts where we flush stats atomically.

Patches 1 and 2 are cleanups requested during reviews of prior versions of
this series.

Patch 3 makes sure we never try to flush from within an irq context.

Patches 4 to 7 introduce separate variants of mem_cgroup_flush_stats() for
atomic and non-atomic flushing, and make sure we only flush the stats
atomically when necessary.

Patch 8 is a slightly tangential optimization that limits the work done by
rstat flushing in some scenarios.


This patch (of 8):

cgroup_rstat_flush_irqsafe() can be a confusing name.  It may read as
"irqs are disabled throughout", which is what the current implementation
does (currently under discussion [1]), but is not the intention.  The
intention is that this function is safe to call from atomic contexts. 
Name it as such.

Link: https://lkml.kernel.org/r/20230330191801.1967435-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20230330191801.1967435-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    2 +-
 kernel/cgroup/rstat.c  |    4 ++--
 mm/memcontrol.c        |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/cgroup.h~cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic
+++ a/include/linux/cgroup.h
@@ -692,7 +692,7 @@ static inline void cgroup_path_from_kern
  */
 void cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
 void cgroup_rstat_flush(struct cgroup *cgrp);
-void cgroup_rstat_flush_irqsafe(struct cgroup *cgrp);
+void cgroup_rstat_flush_atomic(struct cgroup *cgrp);
 void cgroup_rstat_flush_hold(struct cgroup *cgrp);
 void cgroup_rstat_flush_release(void);
 
--- a/kernel/cgroup/rstat.c~cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic
+++ a/kernel/cgroup/rstat.c
@@ -241,12 +241,12 @@ __bpf_kfunc void cgroup_rstat_flush(stru
 }
 
 /**
- * cgroup_rstat_flush_irqsafe - irqsafe version of cgroup_rstat_flush()
+ * cgroup_rstat_flush_atomic- atomic version of cgroup_rstat_flush()
  * @cgrp: target cgroup
  *
  * This function can be called from any context.
  */
-void cgroup_rstat_flush_irqsafe(struct cgroup *cgrp)
+void cgroup_rstat_flush_atomic(struct cgroup *cgrp)
 {
 	unsigned long flags;
 
--- a/mm/memcontrol.c~cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic
+++ a/mm/memcontrol.c
@@ -643,7 +643,7 @@ static void __mem_cgroup_flush_stats(voi
 		return;
 
 	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
-	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
+	cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
 	spin_unlock_irqrestore(&stats_flush_lock, flag);
 }
_

Patches currently in -mm which might be from yosryahmed@google.com are

cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic.patch
memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited.patch
memcg-do-not-flush-stats-in-irq-context.patch
memcg-replace-stats_flush_lock-with-an-atomic.patch
memcg-sleep-during-flushing-stats-in-safe-contexts.patch
workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch
vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch
memcg-do-not-modify-rstat-tree-for-zero-updates.patch

