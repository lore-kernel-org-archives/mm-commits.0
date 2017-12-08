From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-memoryoom_group-fix.patch added to -mm tree
Date: Thu, 07 Dec 2017 17:37:39 -0800
Message-ID: <5a29ece3.oNq9NU4kW+4emTLE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdLHBhn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 20:37:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: return error on access to memory.oom_group if groupoom is disabled
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-memoryoom_group-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-introduce-memoryoom_group-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-introduce-memoryoom_group-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm, oom: return error on access to memory.oom_group if groupoom is disabled

Cgroup-aware OOM killer depends on cgroup mount option and is turned off
by default, despite the user interface (memory.oom_group file) is always
present.  As it might be confusing to a user, let's return -ENOTSUPP on an
attempt to access to memory.oom_group if groupoom is not enabled globally.

Example:
  $ cd /sys/fs/cgroup/user.slice/
  $ cat memory.oom_group
    cat: memory.oom_group: Unknown error 524
  $ echo 1 > memory.oom_group
    -bash: echo: write error: Unknown error 524
  $ mount -o remount,groupoom /sys/fs/cgroup
  $ echo 1 > memory.oom_group
  $ cat memory.oom_group
    1

Link: http://lkml.kernel.org/r/20171201170004.GA27436@castle.DHCP.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/memcontrol.c~mm-oom-introduce-memoryoom_group-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-introduce-memoryoom_group-fix
+++ a/mm/memcontrol.c
@@ -5479,6 +5479,9 @@ static int memory_oom_group_show(struct
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 	bool oom_group = memcg->oom_group;
 
+	if (!(cgrp_dfl_root.flags & CGRP_GROUP_OOM))
+		return -ENOTSUPP;
+
 	seq_printf(m, "%d\n", oom_group);
 
 	return 0;
@@ -5492,6 +5495,9 @@ static ssize_t memory_oom_group_write(st
 	int oom_group;
 	int err;
 
+	if (!(cgrp_dfl_root.flags & CGRP_GROUP_OOM))
+		return -ENOTSUPP;
+
 	err = kstrtoint(strstrip(buf), 0, &oom_group);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from guro@fb.com are

mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch
mm-oom-refactor-the-oom_kill_process-function.patch
mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch
mm-oom-cgroup-aware-oom-killer.patch
mm-oom-introduce-memoryoom_group.patch
mm-oom-introduce-memoryoom_group-fix.patch
mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix.patch
cgroup-list-groupoom-in-cgroup-features.patch

