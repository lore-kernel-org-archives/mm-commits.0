Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1D5C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjFIX1R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjFIX1D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3D430E5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7C8363E52
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2E0C433D2;
        Fri,  9 Jun 2023 23:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353221;
        bh=QSMfWUTVzbUIRdtKItk6Nrt/k4BdQvX6ouw3Ns/UYlI=;
        h=Date:To:From:Subject:From;
        b=LtUh2YipHm2xVEOqMp+DYnCtr7k520tzs7I0sfhV1iZx7oKOJrt8jp5LrlRdQnawd
         PpIlzTFhdhOe5C6492Qa91Jz6hg7A8FdCmllkerNoHEhqoEyXkRCva2x90NhbsDprF
         AzRY0P68gnC89kzAIed1S81tZn/S1yuAKqY+U0uk=
Date:   Fri, 09 Jun 2023 16:27:00 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        jack@suse.cz, hannes@cmpxchg.org, brauner@kernel.org,
        axboe@kernel.dk, yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-remove-cgroup_rstat_flush_atomic.patch removed from -mm tree
Message-Id: <20230609232701.1B2E0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cgroup: remove cgroup_rstat_flush_atomic()
has been removed from the -mm tree.  Its filename was
     cgroup-remove-cgroup_rstat_flush_atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: cgroup: remove cgroup_rstat_flush_atomic()
Date: Fri, 21 Apr 2023 17:40:20 +0000

Previous patches removed the only caller of cgroup_rstat_flush_atomic(). 
Remove the function and simplify the code.

Link: https://lkml.kernel.org/r/20230421174020.2994750-6-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 -
 kernel/cgroup/rstat.c  |   26 +++++---------------------
 2 files changed, 5 insertions(+), 22 deletions(-)

--- a/include/linux/cgroup.h~cgroup-remove-cgroup_rstat_flush_atomic
+++ a/include/linux/cgroup.h
@@ -692,7 +692,6 @@ static inline void cgroup_path_from_kern
  */
 void cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
 void cgroup_rstat_flush(struct cgroup *cgrp);
-void cgroup_rstat_flush_atomic(struct cgroup *cgrp);
 void cgroup_rstat_flush_hold(struct cgroup *cgrp);
 void cgroup_rstat_flush_release(void);
 
--- a/kernel/cgroup/rstat.c~cgroup-remove-cgroup_rstat_flush_atomic
+++ a/kernel/cgroup/rstat.c
@@ -171,7 +171,7 @@ __weak noinline void bpf_rstat_flush(str
 __diag_pop();
 
 /* see cgroup_rstat_flush() */
-static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
+static void cgroup_rstat_flush_locked(struct cgroup *cgrp)
 	__releases(&cgroup_rstat_lock) __acquires(&cgroup_rstat_lock)
 {
 	int cpu;
@@ -207,9 +207,8 @@ static void cgroup_rstat_flush_locked(st
 		}
 		raw_spin_unlock_irqrestore(cpu_lock, flags);
 
-		/* if @may_sleep, play nice and yield if necessary */
-		if (may_sleep && (need_resched() ||
-				  spin_needbreak(&cgroup_rstat_lock))) {
+		/* play nice and yield if necessary */
+		if (need_resched() || spin_needbreak(&cgroup_rstat_lock)) {
 			spin_unlock_irq(&cgroup_rstat_lock);
 			if (!cond_resched())
 				cpu_relax();
@@ -236,26 +235,11 @@ __bpf_kfunc void cgroup_rstat_flush(stru
 	might_sleep();
 
 	spin_lock_irq(&cgroup_rstat_lock);
-	cgroup_rstat_flush_locked(cgrp, true);
+	cgroup_rstat_flush_locked(cgrp);
 	spin_unlock_irq(&cgroup_rstat_lock);
 }
 
 /**
- * cgroup_rstat_flush_atomic- atomic version of cgroup_rstat_flush()
- * @cgrp: target cgroup
- *
- * This function can be called from any context.
- */
-void cgroup_rstat_flush_atomic(struct cgroup *cgrp)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cgroup_rstat_lock, flags);
-	cgroup_rstat_flush_locked(cgrp, false);
-	spin_unlock_irqrestore(&cgroup_rstat_lock, flags);
-}
-
-/**
  * cgroup_rstat_flush_hold - flush stats in @cgrp's subtree and hold
  * @cgrp: target cgroup
  *
@@ -269,7 +253,7 @@ void cgroup_rstat_flush_hold(struct cgro
 {
 	might_sleep();
 	spin_lock_irq(&cgroup_rstat_lock);
-	cgroup_rstat_flush_locked(cgrp, true);
+	cgroup_rstat_flush_locked(cgrp);
 }
 
 /**
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-support-exclusive-loads.patch

