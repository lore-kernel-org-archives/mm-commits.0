From: akpm@linux-foundation.org
Subject: + mm-memcg-fix-inconsistent-oom-event-behavior.patch
 added to -mm tree
Date: Mon, 04 May 2020 16:05:10 -0700
Message-ID: <20200504230510.faDPuPtMh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgEDXFL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 May 2020 19:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm, memcg: fix inconsistent oom event behavior
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-inconsistent-oom-event-behavior.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-inconsistent-oom-event-behavior.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-inconsistent-oom-event-behavior.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, memcg: fix inconsistent oom event behavior

A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
memory.events") changes the behavior of memcg events, which will consider
subtrees in memory.events.  But oom_kill event is a special one as it is
used in both cgroup1 and cgroup2.  In cgroup1, it is displayed in
memory.oom_control.  The file memory.oom_control is in both root memcg and
non root memcg, that is different with memory.event as it only in non-root
memcg.  That commit is okay for cgroup2, but it is not okay for cgroup1 as
it will cause inconsistent behavior between root memcg and non-root memcg.

Here's an example on why this behavior is inconsistent in cgroup1.
     root memcg
     /
  memcg foo
   /
memcg bar

Suppose there's an oom_kill in memcg bar, then the oon_kill will be

     root memcg : memory.oom_control(oom_kill)  0
     /
  memcg foo : memory.oom_control(oom_kill)  1
   /
memcg bar : memory.oom_control(oom_kill)  1

For the non-root memcg, its memory.oom_control(oom_kill) includes its
descendants' oom_kill, but for root memcg, it doesn't include its
descendants' oom_kill.  That means, memory.oom_control(oom_kill) has
different meanings in different memcgs.  That is inconsistent.  Then the
user has to know whether the memcg is root or not.

If we can't fully support it in cgroup1, for example by adding
memory.events.local into cgroup1 as well, then let's don't touch its
original behavior.

Link: http://lkml.kernel.org/r/20200502141055.7378-1-laoar.shao@gmail.com
Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcg-fix-inconsistent-oom-event-behavior
+++ a/include/linux/memcontrol.h
@@ -783,6 +783,8 @@ static inline void memcg_memory_event(st
 		atomic_long_inc(&memcg->memory_events[event]);
 		cgroup_file_notify(&memcg->events_file);
 
+		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+			break;
 		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
 			break;
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc.patch
mm-memcg-fix-inconsistent-oom-event-behavior.patch
mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection.patch
mm-memcg-add-workingset_restore-in-memorystat.patch
