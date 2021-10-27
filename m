Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C883C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 22:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B4D610CB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 22:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhJ0W1c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 18:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhJ0W1c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 18:27:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E841D610C8;
        Wed, 27 Oct 2021 22:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635373506;
        bh=B+XrgZ9ZpapKlt8Ipp/d6WSpaCOVzT/CqtMyg2nOotg=;
        h=Date:From:To:Subject:From;
        b=xOkQgYjwnhkKqahp0Kcsi5zfhnxiwstxvHLXWLnRUtUXd/UR1K6p43Nax9xvqDu7s
         oNwlLKdyi5lJK2PtQwjV5kqlsF05R6GSRoH9OGD9ZToYxQxhKw1qs0m3RHAE1tIDpa
         TNF6HBO+3TEcxhft32FI4Tp6LOQIoD3MTnFEbWNI=
Date:   Wed, 27 Oct 2021 15:25:05 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  [to-be-updated]
 memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch
 removed from -mm tree
Message-ID: <20211027222505.apYBCwrti%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: prohibit unconditional exceeding the limit of dying tasks
has been removed from the -mm tree.  Its filename was
     memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: prohibit unconditional exceeding the limit of dying tasks

Memory cgroup charging allows killed or exiting tasks to exceed the
hard limit.  It is assumed that the amount of the memory charged by
those tasks is bound and most of the memory will get released while the
task is exiting.  This is resembling a heuristic for the global OOM
situation when tasks get access to memory reserves.  There is no global
memory shortage at the memcg level so the memcg heuristic is more
relieved.

The above assumption is overly optimistic though.  E.g.  vmalloc can
scale to really large requests and the heuristic would allow that.  We
used to have an early break in the vmalloc allocator for killed tasks
but this has been reverted by b8c8a338f75e (Revert "vmalloc: back off
when the current task is killed").  There are likely other similar code
paths which do not check for fatal signals in an allocation&charge
loop.  Also there are some kernel objects charged to a memcg which are
not bound to a process life time.  

It has been observed that it is not really hard to trigger these
bypasses and cause global OOM situation.

One potential way to address these runaways would be to limit the
amount of excess (similar to the global OOM with limited oom reserves).
This is certainly possible but it is not really clear how much of an
excess is desirable and still protects from global OOMs as that would
have to consider the overall memcg configuration.

This patch is addressing the problem by removing the heuristic
altogether.  Bypass is only allowed for requests which either cannot
fail or where the failure is not desirable while excess should be still
limited (e.g.  atomic requests).  Implementation wise a killed or dying
task fails to charge if it has passed the OOM killer stage.  That
should give all forms of reclaim chance to restore the limit before the
failure (ENOMEM) and tell the caller to back off.

{mhocko@suse.com: new changelog]
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
@@ -234,7 +234,7 @@ enum res_type {
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-static inline bool should_force_charge(void)
+static inline bool task_is_dying(void)
 {
 	return tsk_is_oom_victim(current) || fatal_signal_pending(current) ||
 		(current->flags & PF_EXITING);
@@ -1624,7 +1624,7 @@ static bool mem_cgroup_out_of_memory(str
 	 * A few threads which were not waiting at mutex_lock_killable() can
 	 * fail to bail out. Therefore, check again after holding oom_lock.
 	 */
-	ret = should_force_charge() || out_of_memory(&oc);
+	ret = task_is_dying() || out_of_memory(&oc);
 
 unlock:
 	mutex_unlock(&oom_lock);
@@ -2579,6 +2579,7 @@ static int try_charge_memcg(struct mem_c
 	struct page_counter *counter;
 	enum oom_status oom_status;
 	unsigned long nr_reclaimed;
+	bool passed_oom = false;
 	bool may_swap = true;
 	bool drained = false;
 	unsigned long pflags;
@@ -2614,15 +2615,6 @@ retry:
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
@@ -2679,8 +2671,9 @@ retry:
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
-	if (fatal_signal_pending(current))
-		goto force;
+	/* Avoid endless loop for tasks bypassed by the oom killer */
+	if (passed_oom && task_is_dying())
+		goto nomem;
 
 	/*
 	 * keep retrying as long as the memcg oom killer is able to make
@@ -2689,14 +2682,10 @@ retry:
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

mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch
vmalloc-back-off-when-the-current-task-is-oom-killed.patch

