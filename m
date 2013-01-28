From: akpm@linux-foundation.org
Subject: + cfq-fix-lock-imbalance-with-failed-allocations.patch added to -mm tree
Date: Mon, 28 Jan 2013 13:43:27 -0800
Message-ID: <20130128214327.CCAFF31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36081 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3A1Vn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 16:43:29 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so324268ggi.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 13:43:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, axboe@kernel.dk, tj@kernel.org


The patch titled
     Subject: cfq: fix lock imbalance with failed allocations
has been added to the -mm tree.  Its filename is
     cfq-fix-lock-imbalance-with-failed-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: cfq: fix lock imbalance with failed allocations

While stress-running very-small container scenarios with the Kernel Memory
Controller, I've run into a lockdep-detected lock imbalance in
cfq-iosched.c.

I'll apologize beforehand for not posting a backlog: I didn't anticipate
it would be so hard to reproduce, so I didn't save my serial output and
went directly on debugging.  Turns out that it did not happen again in
more than 20 runs, making it a quite rare pattern.

But here is my analysis:

When we are in very low-memory situations, we will arrive at
cfq_find_alloc_queue and may not find a queue, having to resort to the oom
queue, in an rcu-locked condition:

  if (!cfqq || cfqq == &cfqd->oom_cfqq)
      [ ... ]

Next, we will release the rcu lock, and try to allocate a queue, retrying
if we succeed:

  rcu_read_unlock();
  spin_unlock_irq(cfqd->queue->queue_lock);
  new_cfqq = kmem_cache_alloc_node(cfq_pool,
                  gfp_mask | __GFP_ZERO,
                  cfqd->queue->node);
   spin_lock_irq(cfqd->queue->queue_lock);
   if (new_cfqq)
       goto retry;

We are unlocked at this point, but it should be fine, since we will
reacquire the rcu_read_lock when we retry.

Except of course, that we may not retry: the allocation may very well fail
and we'll keep on going through the flow:

The next branch is:

    if (cfqq) {
	[ ... ]
    } else
        cfqq = &cfqd->oom_cfqq;

And right before exiting, we'll issue rcu_read_unlock().

Being already unlocked, this is the likely source of our imbalance.  Since
cfqq is either already NULL or made NULL in the first statement of the
outter branch, the only viable alternative here seems to be to return the
oom queue right away in case of allocation failure.

Please review the following patch and apply if you agree with my analysis.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN block/cfq-iosched.c~cfq-fix-lock-imbalance-with-failed-allocations block/cfq-iosched.c
--- a/block/cfq-iosched.c~cfq-fix-lock-imbalance-with-failed-allocations
+++ a/block/cfq-iosched.c
@@ -3594,6 +3594,8 @@ retry:
 			spin_lock_irq(cfqd->queue->queue_lock);
 			if (new_cfqq)
 				goto retry;
+			else
+				return &cfqd->oom_cfqq;
 		} else {
 			cfqq = kmem_cache_alloc_node(cfq_pool,
 					gfp_mask | __GFP_ZERO,
_

Patches currently in -mm which might be from glommer@parallels.com are

memcg-fix-typo-in-kmemcg-cache-walk-macro.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

