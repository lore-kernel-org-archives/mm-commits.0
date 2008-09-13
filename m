From: akpm@linux-foundation.org
Subject: - sched-reinitialise-rt_rq-rt_throttled-in-__enable_runtime.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:46:44 -0700
Message-ID: <200809130746.m8D7kiPd026872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317AbYIMHrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:47:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: reinitialise rt_rq->rt_throttled in  __enable_runtime()
has been removed from the -mm tree.  Its filename was
     sched-reinitialise-rt_rq-rt_throttled-in-__enable_runtime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

