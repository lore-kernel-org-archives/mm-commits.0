From: akpm@linux-foundation.org
Subject: [merged] mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:31 -0800
Message-ID: <20120113203331.B87411E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:58777 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab2AMUdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:33 -0500
Received: by qcsc20 with SMTP id c20so97363qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom_kill: remove memcg argument from oom_kill_task()
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: oom_kill: remove memcg argument from oom_kill_task()

The memcg argument of oom_kill_task() hasn't been used since 341aea2
'oom-kill: remove boost_dying_task_prio()'.  Kill it.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_kill-remove-memcg-argument-from-oom_kill_task mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-remove-memcg-argument-from-oom_kill_task
+++ a/mm/oom_kill.c
@@ -434,7 +434,7 @@ static void dump_header(struct task_stru
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
-static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
+static int oom_kill_task(struct task_struct *p)
 {
 	struct task_struct *q;
 	struct mm_struct *mm;
@@ -533,7 +533,7 @@ static int oom_kill_process(struct task_
 		}
 	} while_each_thread(p, t);
 
-	return oom_kill_task(victim, mem);
+	return oom_kill_task(victim);
 }
 
 /*
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

