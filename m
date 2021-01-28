Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEACEC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9313564DCC
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhA1AST (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhA1ARb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:17:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D820264D99;
        Thu, 28 Jan 2021 00:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611793010;
        bh=dMbA5B3GIlcNI3LBVUSt51vYTtyvZanvi9WPIwcXHo8=;
        h=Date:From:To:Subject:From;
        b=dNm6VOulzfuN2CnnECV42i9+FfUsKs1GEKy5x0T1M6QB0kL3wRwvhHo8umZQ4fpxj
         J1eqD4eTzXZ2pNe3FHiN4KVYxkSmLmqTfl7Jq4AmyDMH6ARUzI88+olyBTv91jQz0P
         sruyyg6wzKYuRg7e5t8syYxEZOSJ/3eNSfLeba9Q=
Date:   Wed, 27 Jan 2021 16:16:49 -0800
From:   akpm@linux-foundation.org
To:     acme@kernel.org, juri.lelli@redhat.com,
        mathieu.desnoyers@efficios.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org,
        vincent.guittot@linaro.org, will@kernel.org
Subject:  + kernel-delete-repeated-words-in-comments.patch added to
 -mm tree
Message-ID: <20210128001649.y_ic9vCHi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: delete repeated words in comments
has been added to the -mm tree.  Its filename is
     kernel-delete-repeated-words-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-delete-repeated-words-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-delete-repeated-words-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel: delete repeated words in comments

Drop repeated words in kernel/events/.
{if, the, that, with, time}

Drop repeated words in kernel/locking/.
{it, no, the}

Drop repeated words in kernel/sched/.
{in, not}

Link: https://lkml.kernel.org/r/20210127023412.26292-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Will Deacon <will@kernel.org>	[kernel/locking/]
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/core.c       |    8 ++++----
 kernel/events/uprobes.c    |    2 +-
 kernel/locking/rtmutex.c   |    4 ++--
 kernel/locking/rwsem.c     |    2 +-
 kernel/locking/semaphore.c |    2 +-
 kernel/sched/fair.c        |    2 +-
 kernel/sched/membarrier.c  |    2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

--- a/kernel/events/core.c~kernel-delete-repeated-words-in-comments
+++ a/kernel/events/core.c
@@ -268,7 +268,7 @@ static void event_function_call(struct p
 	if (!event->parent) {
 		/*
 		 * If this is a !child event, we must hold ctx::mutex to
-		 * stabilize the the event->ctx relation. See
+		 * stabilize the event->ctx relation. See
 		 * perf_event_ctx_lock().
 		 */
 		lockdep_assert_held(&ctx->mutex);
@@ -1301,7 +1301,7 @@ static void put_ctx(struct perf_event_co
  * life-time rules separate them. That is an exiting task cannot fork, and a
  * spawning task cannot (yet) exit.
  *
- * But remember that that these are parent<->child context relations, and
+ * But remember that these are parent<->child context relations, and
  * migration does not affect children, therefore these two orderings should not
  * interact.
  *
@@ -1440,7 +1440,7 @@ static u64 primary_event_id(struct perf_
 /*
  * Get the perf_event_context for a task and lock it.
  *
- * This has to cope with with the fact that until it is locked,
+ * This has to cope with the fact that until it is locked,
  * the context could get moved to another task.
  */
 static struct perf_event_context *
@@ -2499,7 +2499,7 @@ static void perf_set_shadow_time(struct
 	 * But this is a bit hairy.
 	 *
 	 * So instead, we have an explicit cgroup call to remain
-	 * within the time time source all along. We believe it
+	 * within the time source all along. We believe it
 	 * is cleaner and simpler to understand.
 	 */
 	if (is_cgroup_event(event))
--- a/kernel/events/uprobes.c~kernel-delete-repeated-words-in-comments
+++ a/kernel/events/uprobes.c
@@ -1735,7 +1735,7 @@ void uprobe_free_utask(struct task_struc
 }
 
 /*
- * Allocate a uprobe_task object for the task if if necessary.
+ * Allocate a uprobe_task object for the task if necessary.
  * Called when the thread hits a breakpoint.
  *
  * Returns:
--- a/kernel/locking/rtmutex.c~kernel-delete-repeated-words-in-comments
+++ a/kernel/locking/rtmutex.c
@@ -1438,7 +1438,7 @@ rt_mutex_fasttrylock(struct rt_mutex *lo
 }
 
 /*
- * Performs the wakeup of the the top-waiter and re-enables preemption.
+ * Performs the wakeup of the top-waiter and re-enables preemption.
  */
 void rt_mutex_postunlock(struct wake_q_head *wake_q)
 {
@@ -1833,7 +1833,7 @@ struct task_struct *rt_mutex_next_owner(
  *			been started.
  * @waiter:		the pre-initialized rt_mutex_waiter
  *
- * Wait for the the lock acquisition started on our behalf by
+ * Wait for the lock acquisition started on our behalf by
  * rt_mutex_start_proxy_lock(). Upon failure, the caller must call
  * rt_mutex_cleanup_proxy_lock().
  *
--- a/kernel/locking/rwsem.c~kernel-delete-repeated-words-in-comments
+++ a/kernel/locking/rwsem.c
@@ -1048,7 +1048,7 @@ rwsem_down_write_slowpath(struct rw_sema
 
 		/*
 		 * If there were already threads queued before us and:
-		 *  1) there are no no active locks, wake the front
+		 *  1) there are no active locks, wake the front
 		 *     queued process(es) as the handoff bit might be set.
 		 *  2) there are no active writers and some readers, the lock
 		 *     must be read owned; so we try to wake any read lock
--- a/kernel/locking/semaphore.c~kernel-delete-repeated-words-in-comments
+++ a/kernel/locking/semaphore.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(down_killable);
  * @sem: the semaphore to be acquired
  *
  * Try to acquire the semaphore atomically.  Returns 0 if the semaphore has
- * been acquired successfully or 1 if it it cannot be acquired.
+ * been acquired successfully or 1 if it cannot be acquired.
  *
  * NOTE: This return value is inverted from both spin_trylock and
  * mutex_trylock!  Be careful about this when converting code.
--- a/kernel/sched/fair.c~kernel-delete-repeated-words-in-comments
+++ a/kernel/sched/fair.c
@@ -5133,7 +5133,7 @@ static void do_sched_cfs_slack_timer(str
 /*
  * When a group wakes up we want to make sure that its quota is not already
  * expired/exceeded, otherwise it may be allowed to steal additional ticks of
- * runtime as update_curr() throttling can not not trigger until it's on-rq.
+ * runtime as update_curr() throttling can not trigger until it's on-rq.
  */
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 {
--- a/kernel/sched/membarrier.c~kernel-delete-repeated-words-in-comments
+++ a/kernel/sched/membarrier.c
@@ -454,7 +454,7 @@ static int sync_runqueues_membarrier_sta
 
 	/*
 	 * For each cpu runqueue, if the task's mm match @mm, ensure that all
-	 * @mm's membarrier state set bits are also set in in the runqueue's
+	 * @mm's membarrier state set bits are also set in the runqueue's
 	 * membarrier state. This ensures that a runqueue scheduling
 	 * between threads which are users of @mm has its membarrier state
 	 * updated.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

hexagon-remove-config_experimental-from-defconfigs.patch
ntfs-layouth-delete-duplicated-words.patch
fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
alpha-remove-config_experimental-from-defconfigs.patch
kernel-delete-repeated-words-in-comments.patch

