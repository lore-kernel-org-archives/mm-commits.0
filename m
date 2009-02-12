From: akpm@linux-foundation.org
Subject: [merged] cgroups-fix-lockdep-subclasses-overflow.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:45 -0800
Message-ID: <200902122025.n1CKPjhY015131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757824AbZBLU0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:26:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix lockdep subclasses overflow
has been removed from the -mm tree.  Its filename was
     cgroups-fix-lockdep-subclasses-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix lockdep subclasses overflow
From: Li Zefan <lizf@cn.fujitsu.com>

I enabled all cgroup subsystems when compiling kernel, and then:
 # mount -t cgroup -o net_cls xxx /mnt
 # mkdir /mnt/0

This showed up immediately:
 BUG: MAX_LOCKDEP_SUBCLASSES too low!
 turning off the locking correctness validator.

It's caused by the cgroup hierarchy lock:
	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
		struct cgroup_subsys *ss = subsys[i];
		if (ss->root == root)
			mutex_lock_nested(&ss->hierarchy_mutex, i);
	}

Now we have 9 cgroup subsystems, and the above 'i' for net_cls is 8, but
MAX_LOCKDEP_SUBCLASSES is 8.

This patch uses different lockdep keys for different subsystems.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/cgroup.h~cgroups-fix-lockdep-subclasses-overflow include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-fix-lockdep-subclasses-overflow
+++ a/include/linux/cgroup.h
@@ -378,6 +378,7 @@ struct cgroup_subsys {
 	 * - initiating hotplug events
 	 */
 	struct mutex hierarchy_mutex;
+	struct lock_class_key subsys_key;
 
 	/*
 	 * Link to parent, and list entry in parent's children.
diff -puN kernel/cgroup.c~cgroups-fix-lockdep-subclasses-overflow kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-lockdep-subclasses-overflow
+++ a/kernel/cgroup.c
@@ -2351,7 +2351,7 @@ static void cgroup_lock_hierarchy(struct
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 		if (ss->root == root)
-			mutex_lock_nested(&ss->hierarchy_mutex, i);
+			mutex_lock(&ss->hierarchy_mutex);
 	}
 }
 
@@ -2637,6 +2637,7 @@ static void __init cgroup_init_subsys(st
 	BUG_ON(!list_empty(&init_task.tasks));
 
 	mutex_init(&ss->hierarchy_mutex);
+	lockdep_set_class(&ss->hierarchy_mutex, &ss->subsys_key);
 	ss->active = 1;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cgroups-fix-possible-use-after-free.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
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
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch

