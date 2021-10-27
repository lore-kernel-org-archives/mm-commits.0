Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2822C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 22:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A03AB610E7
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 22:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhJ0Wiu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 18:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhJ0Wiu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 18:38:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1404B610CB;
        Wed, 27 Oct 2021 22:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635374184;
        bh=7EzPxkY3MGpBRPc6nuSB6MXC9MMuOeYE33dJlWoCrg0=;
        h=Date:From:To:Subject:From;
        b=WYuaw+RPPzK1BjGbNuHj/hAMyE5wek6QH/RPN8Hbce3CErR/UGQXHAPQZocMsNxCc
         O5qrdG3JrJh+KwA4K5JawUl0gfPzaU35V7NfRPA0fUPO5ILz2uS73qKLSCQTjXuuZi
         cJLGVPp0briPq0uA36tHGM6w1Q5feQuIn4l7/gsw=
Date:   Wed, 27 Oct 2021 15:36:23 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, shakeelb@google.com,
        urezki@gmail.com, vbabka@suse.cz, vdavydov.dev@gmail.com,
        vvs@virtuozzo.com
Subject:  +
 mm-oom-pagefault_out_of_memory-dont-force-global-oom-for-dying-tasks.patch
 added to -mm tree
Message-ID: <20211027223623.RiX3Tkgod%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks
has been added to the -mm tree.  Its filename is
     mm-oom-pagefault_out_of_memory-dont-force-global-oom-for-dying-tasks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom-pagefault_out_of_memory-dont-force-global-oom-for-dying-tasks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-pagefault_out_of_memory-dont-force-global-oom-for-dying-tasks.patch

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
Subject: mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

Patch series "memcg: prohibit unconditional exceeding the limit of dying tasks", v3.

Memory cgroup charging allows killed or exiting tasks to exceed the hard
limit.  It can be misused and allowed to trigger global OOM from inside a
memcg-limited container.  On the other hand if memcg fails allocation,
called from inside #PF handler it triggers global OOM from inside
pagefault_out_of_memory().

To prevent these problems this patchset:
a) removes execution of out_of_memory() from pagefault_out_of_memory(),
   becasue nobody can explain why it is necessary.
b) allow memcg to fail allocation of dying/killed tasks.


This patch (of 3):

Any allocation failure during the #PF path will return with VM_FAULT_OOM
which in turn results in pagefault_out_of_memory which in turn executes
out_out_memory() and can kill a random task.

An allocation might fail when the current task is the oom victim and there
are no memory reserves left.  The OOM killer is already handled at the
page allocator level for the global OOM and at the charging level for the
memcg one.  Both have much more information about the scope of
allocation/charge request.  This means that either the OOM killer has been
invoked properly and didn't lead to the allocation success or it has been
skipped because it couldn't have been invoked.  In both cases triggering
it from here is pointless and even harmful.

It makes much more sense to let the killed task die rather than to wake up
an eternally hungry oom-killer and send him to choose a fatter victim for
breakfast.

Link: https://lkml.kernel.org/r/0828a149-786e-7c06-b70a-52d086818ea3@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/oom_kill.c~mm-oom-pagefault_out_of_memory-dont-force-global-oom-for-dying-tasks
+++ a/mm/oom_kill.c
@@ -1137,6 +1137,9 @@ void pagefault_out_of_memory(void)
 	if (mem_cgroup_oom_synchronize(true))
 		return;
 
+	if (fatal_signal_pending(current))
+		return;
+
 	if (!mutex_trylock(&oom_lock))
 		return;
 	out_of_memory(&oc);
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

mm-oom-pagefault_out_of_memory-dont-force-global-oom-for-dying-tasks.patch
memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch
mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch
vmalloc-back-off-when-the-current-task-is-oom-killed.patch

