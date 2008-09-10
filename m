From: akpm@linux-foundation.org
Subject: + sched-reinitialise-rt_rq-rt_throttled-in-__enable_runtime.patch added to -mm tree
Date: Wed, 10 Sep 2008 14:22:29 -0700
Message-ID: <200809102122.m8ALMUIp026877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbYIJVX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 17:23:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     sched: reinitialise rt_rq->rt_throttled in  __enable_runtime()
has been added to the -mm tree.  Its filename is
     sched-reinitialise-rt_rq-rt_throttled-in-__enable_runtime.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: reinitialise rt_rq->rt_throttled in  __enable_runtime()
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

On my tulsa x86-64 machine, kernel 2.6.25-rc5 couldn't boot randomly.

Basically, function __enable_runtime forgets to reset rt_rq->rt_throttled
to 0.  When every cpu is up, per-cpu migration_thread is created and it
runs very fast, sometimes to mark the corresponding rt_rq->rt_throttled to
1 very quickly.  After all cpus are up, with below calling chain,

  sched_init_smp
  ->arch_init_sched_domains
    ->build_sched_domains
      ->...
        ->cpu_attach_domain
          ->rq_attach_root
            ->set_rq_online
              ->...
                ->__enable_runtime

__enable_runtime is called against every rt_rq again, so rt_rq->rt_time is
reset to 0, but rt_rq->rt_throttled might be still 1.

Later on function do_sched_rt_period_timer couldn't reset it, and all RT
tasks couldn't be scheduled to run on that cpu.  Here is RT task
migration_thread which is woken up when a task is migrated to another cpu.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_rt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sched_rt.c~sched-reinitialise-rt_rq-rt_throttled-in-__enable_runtime kernel/sched_rt.c
--- a/kernel/sched_rt.c~sched-reinitialise-rt_rq-rt_throttled-in-__enable_runtime
+++ a/kernel/sched_rt.c
@@ -350,6 +350,7 @@ static void __enable_runtime(struct rq *
 		spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = rt_b->rt_runtime;
 		rt_rq->rt_time = 0;
+		rt_rq->rt_throttled = 0;
 		spin_unlock(&rt_rq->rt_runtime_lock);
 		spin_unlock(&rt_b->rt_runtime_lock);
 	}
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

sched-reinitialise-rt_rq-rt_throttled-in-__enable_runtime.patch

