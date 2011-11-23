From: akpm@linux-foundation.org
Subject: [merged] cgroup_freezer-fix-freezing-groups-with-stopped-tasks.patch removed from -mm tree
Date: Wed, 23 Nov 2011 13:45:10 -0800
Message-ID: <201111232145.pANLjAsU026760@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:57550 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1KWVpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2011 16:45:14 -0500
Received: by vbbfr13 with SMTP id fr13so257206vbb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2011 13:45:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, htejun@gmail.com, lizf@cn.fujitsu.com, paul@paulmenage.org, tomasz.buchert@inria.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup_freezer: fix freezing groups with stopped tasks
has been removed from the -mm tree.  Its filename was
     cgroup_freezer-fix-freezing-groups-with-stopped-tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: cgroup_freezer: fix freezing groups with stopped tasks

2d3cbf8b ("cgroup_freezer: update_freezer_state() does incorrect state
transitions") removed is_task_frozen_enough and replaced it with a simple
frozen call.  This, however, breaks freezing for a group with stopped
tasks because those cannot be frozen and so the group remains in
CGROUP_FREEZING state (update_if_frozen doesn't count stopped tasks) and
never reaches CGROUP_FROZEN.

Let's add task_frozen_enough back and use it at the original locations
(update_if_frozen and try_to_freeze_cgroup).  Semantically we consider
stopped tasks as frozen enough so we should consider both cases when
testing frozen tasks.

Testcase:
mkdir /dev/freezer
mount -t cgroup -o freezer none /dev/freezer
mkdir /dev/freezer/foo
sleep 1h &
pid=$!
kill -STOP $pid
echo $pid > /dev/freezer/foo/tasks
echo FROZEN > /dev/freezer/foo/freezer.state
while true
do
        cat /dev/freezer/foo/freezer.state
        [ "`cat /dev/freezer/foo/freezer.state`" = "FROZEN" ] && break
        sleep 1
done
echo OK

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Tested-by: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup_freezer.c~cgroup_freezer-fix-freezing-groups-with-stopped-tasks kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~cgroup_freezer-fix-freezing-groups-with-stopped-tasks
+++ a/kernel/cgroup_freezer.c
@@ -153,6 +153,13 @@ static void freezer_destroy(struct cgrou
 	kfree(cgroup_freezer(cgroup));
 }
 
+/* Task is frozen or will freeze immediately when next it gets woken */
+static bool is_task_frozen_enough(struct task_struct *task)
+{
+	return frozen(task) ||
+		(task_is_stopped_or_traced(task) && freezing(task));
+}
+
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
  * a write to that file racing against an attach, and hence the
@@ -231,7 +238,7 @@ static void update_if_frozen(struct cgro
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		ntotal++;
-		if (frozen(task))
+		if (is_task_frozen_enough(task))
 			nfrozen++;
 	}
 
@@ -284,7 +291,7 @@ static int try_to_freeze_cgroup(struct c
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task, true))
 			continue;
-		if (frozen(task))
+		if (is_task_frozen_enough(task))
 			continue;
 		if (!freezing(task) && !freezer_should_skip(task))
 			num_cant_freeze_now++;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch

