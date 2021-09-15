Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E970CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C13FD60F23
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhIODsQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhIODsQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A715E60F26;
        Wed, 15 Sep 2021 03:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631677617;
        bh=DnqgtBcqENgKACRwUUccdpASy7MNAX/UsLJDE5Zan/A=;
        h=Date:From:To:Subject:From;
        b=xSwVKoVaBBozFwmXaRqItbpbsoFEWSUc0L6pMLVtZyP1BUbtg00FHYMhXay2my8cH
         xO4Kl92Oq4lXMv1S2sONMQDhJb9L1pRZAlHCgL8XtnL90NdpYItnHtkEWiXxwyPvtx
         Azue9SqEk2n4eJbfEJ+BTtbvuBFY48+I390Y7x98=
Date:   Tue, 14 Sep 2021 20:46:57 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  +
 memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch added
 to -mm tree
Message-ID: <20210915034657.ereM83NMv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: prohibit unconditional exceeding the limit of dying tasks
has been added to the -mm tree.  Its filename is
     memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: prohibit unconditional exceeding the limit of dying tasks

The kernel currently allows dying tasks to exceed the memcg limits.  The
allocation is expected to be the last one and the occupied memory will be
freed soon.

This is not always true because it can be part of the huge vmalloc
allocation.  Allowed once, they will repeat over and over again.  Moreover
lifetime of the allocated object can differ from the lifetime of the dying
task.

Multiple such allocations running concurrently can not only overuse the
memcg limit, but can lead to a global out of memory and, in the worst
case, cause the host to panic.

This patch removes checks for exceeding of the memcg limit for dying
tasks.  Also it breaks endless loop for tasks bypassed by the oom killer. 
In addition, it renames should_force_charge() helper to task_is_dying()
because now its use do not lead to the forced charge.

Link: https://lkml.kernel.org/r/817a6ce2-4da9-72ac-c5b9-edd398d28a15@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks
+++ a/mm/memcontrol.c
@@ -242,7 +242,7 @@ enum res_type {
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-static inline bool should_force_charge(void)
+static inline bool task_is_dying(void)
 {
 	return tsk_is_oom_victim(current) || fatal_signal_pending(current) ||
 		(current->flags & PF_EXITING);
@@ -1580,7 +1580,7 @@ static bool mem_cgroup_out_of_memory(str
 	 * A few threads which were not waiting at mutex_lock_killable() can
 	 * fail to bail out. Therefore, check again after holding oom_lock.
 	 */
-	ret = should_force_charge() || out_of_memory(&oc);
+	ret = task_is_dying() || out_of_memory(&oc);
 
 unlock:
 	mutex_unlock(&oom_lock);
@@ -2535,6 +2535,7 @@ static int try_charge_memcg(struct mem_c
 	struct page_counter *counter;
 	enum oom_status oom_status;
 	unsigned long nr_reclaimed;
+	bool passed_oom = false;
 	bool may_swap = true;
 	bool drained = false;
 	unsigned long pflags;
@@ -2570,15 +2571,6 @@ retry:
 		goto force;
 
 	/*
-	 * Unlike in global OOM situations, memcg is not in a physical
-	 * memory shortage.  Allow dying and OOM-killed tasks to
-	 * bypass the last charges so that they can exit quickly and
-	 * free their memory.
-	 */
-	if (unlikely(should_force_charge()))
-		goto force;
-
-	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
 	 * but we prefer facilitating memory reclaim and getting back
@@ -2635,8 +2627,9 @@ retry:
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
-	if (fatal_signal_pending(current))
-		goto force;
+	/* Avoid endless loop for tasks bypassed by the oom killer */
+	if (passed_oom && task_is_dying())
+		goto nomem;
 
 	/*
 	 * keep retrying as long as the memcg oom killer is able to make
@@ -2645,14 +2638,10 @@ retry:
 	 */
 	oom_status = mem_cgroup_oom(mem_over_limit, gfp_mask,
 		       get_order(nr_pages * PAGE_SIZE));
-	switch (oom_status) {
-	case OOM_SUCCESS:
+	if (oom_status == OOM_SUCCESS) {
+		passed_oom = true;
 		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
-	case OOM_FAILED:
-		goto force;
-	default:
-		goto nomem;
 	}
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch

