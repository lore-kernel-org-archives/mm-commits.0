From: akpm@linux-foundation.org
Subject: + cls_cgroup-remove-unneeded-cgroup_lock.patch added to -mm tree
Date: Thu, 12 Mar 2009 15:18:36 -0700
Message-ID: <200903122218.n2CMIaEo011127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbZCLWUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 18:20:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, lizf@cn.fujitsuc.com, menage@google.com


The patch titled
     cls_cgroup: remove unneeded cgroup_lock
has been added to the -mm tree.  Its filename is
     cls_cgroup-remove-unneeded-cgroup_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cls_cgroup: remove unneeded cgroup_lock
From: Li Zefan <lizf@cn.fujitsu.com>

We can remove this lock here, since we are in cgroup write handler and
thus the cgrp is guaranteed to be valid, and no lock is needed when
writing a u32 variable.

Signed-off-by: Li Zefan <lizf@cn.fujitsuc.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/cls_cgroup.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN net/sched/cls_cgroup.c~cls_cgroup-remove-unneeded-cgroup_lock net/sched/cls_cgroup.c
--- a/net/sched/cls_cgroup.c~cls_cgroup-remove-unneeded-cgroup_lock
+++ a/net/sched/cls_cgroup.c
@@ -62,13 +62,7 @@ static u64 read_classid(struct cgroup *c
 
 static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
 {
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
-
 	cgrp_cls_state(cgrp)->classid = (u32) value;
-
-	cgroup_unlock();
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

vfs-add-missing-unlock-in-sget.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
memdup_user-introduce.patch
memdup_user-introduce-fix.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
cgroups-show-correct-file-mode-fix.patch
cgroups-dont-change-release_agent-when-remount-failed.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch
cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch

