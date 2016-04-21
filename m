From: akpm@linux-foundation.org
Subject: +
 memcg-remove-lru_add_drain_all-invocation-from-mem_cgroup_move_charge.patch added to -mm tree
Date: Thu, 21 Apr 2016 13:44:15 -0700
Message-ID: <57193b9f.slrfPKuL3u7cfzSe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbcDUUoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:44:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, chrubis@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com, pmladek@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove lru_add_drain_all() invocation from mem_cgroup_move_charge()
has been added to the -mm tree.  Its filename is
     memcg-remove-lru_add_drain_all-invocation-from-mem_cgroup_move_charge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-remove-lru_add_drain_all-invocation-from-mem_cgroup_move_charge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-remove-lru_add_drain_all-invocation-from-mem_cgroup_move_charge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memcg: remove lru_add_drain_all() invocation from mem_cgroup_move_charge()

mem_cgroup_move_charge() invokes lru_add_drain_all() so that the pvec
pages can be moved too.  lru_add_drain_all() schedules and flushes work
items on system_wq which depends on being able to create new kworkers to
make forward progress.  Since 1ed1328792ff ("sched, cgroup: replace
signal_struct->group_rwsem with a global percpu_rwsem"), a new task can't
be created while in the cgroup migration path and the described
lru_add_drain_all() invocation can easily lead to a deadlock.

Charge moving is best-effort and whether the pvec pages are migrated or
not doesn't really matter.  Don't call it during charge moving. 
Eventually, we want to move the actual charge moving outside the migration
path.

Fixes: 1ed1328792ff ("sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem")
Signed-off-by: Tejun Heo <tj@kernel.org>
Debugged-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>
Reported-by: Cyril Hrubis <chrubis@suse.cz>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[4.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-lru_add_drain_all-invocation-from-mem_cgroup_move_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-lru_add_drain_all-invocation-from-mem_cgroup_move_charge
+++ a/mm/memcontrol.c
@@ -4859,7 +4859,6 @@ static void mem_cgroup_move_charge(struc
 		.mm = mm,
 	};
 
-	lru_add_drain_all();
 	/*
 	 * Signal lock_page_memcg() to take the memcg's move_lock
 	 * while we're moving its pages to another memcg. Then wait
_

Patches currently in -mm which might be from tj@kernel.org are

memcg-remove-lru_add_drain_all-invocation-from-mem_cgroup_move_charge.patch

