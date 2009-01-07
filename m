From: akpm@linux-foundation.org
Subject: - cgroups-make-cgroup_path-rcu-safe-fixlet.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:07:35 -0800
Message-ID: <200901072307.n07N7ZDY026208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbZAGXHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:07:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     a fixlet for cgroups-make-cgroup_path-rcu-safe.patch
has been removed from the -mm tree.  Its filename was
     cgroups-make-cgroup_path-rcu-safe-fixlet.patch

This patch was dropped because it was folded into cgroups-make-cgroup_path-rcu-safe.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: a fixlet for cgroups-make-cgroup_path-rcu-safe.patch
From: Li Zefan <lizf@cn.fujitsu.com>

With cgroups-make-cgroup_path-rcu-safe.patch applied, I can trigger kernel
panic easily using this test program:

	for ((; ;))
	{
		mount -t cgroup -o debug xxx /mnt
		mkdir /mnt/0
		rmdir /mnt/0
		umount /mnt
	}

It's caused by the deactive_super() in rcu callback.

This patch restores the original code that call deactive_super() in
cgroup_diput().

Also remove duplicated comment in cgroup.h added by the patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    6 ------
 kernel/cgroup.c        |   11 ++++++-----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-make-cgroup_path-rcu-safe-fixlet include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-make-cgroup_path-rcu-safe-fixlet
+++ a/include/linux/cgroup.h
@@ -308,12 +308,6 @@ int cgroup_add_files(struct cgroup *cgrp
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
-/*
- * cgroup_path() fills in a filesystem-like path for the given cgroup
- * into "buf", up to "buflen" characters. Should be called with
- * cgroup_mutex held, or else in an RCU section with an RCU-protected
- * cgroup reference
- */
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
diff -puN kernel/cgroup.c~cgroups-make-cgroup_path-rcu-safe-fixlet kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-make-cgroup_path-rcu-safe-fixlet
+++ a/kernel/cgroup.c
@@ -598,11 +598,6 @@ static void cgroup_call_pre_destroy(stru
 static void free_cgroup_rcu(struct rcu_head *obj)
 {
 	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
-	/*
-	 * Drop the active superblock reference that we took when we
-	 * created the cgroup
-	 */
-	deactivate_super(cgrp->root->sb);
 
 	kfree(cgrp);
 }
@@ -632,6 +627,12 @@ static void cgroup_diput(struct dentry *
 		cgrp->root->number_of_cgroups--;
 		mutex_unlock(&cgroup_mutex);
 
+		/*
+		 * Drop the active superblock reference that we took when we
+		 * created the cgroup
+		 */
+		deactivate_super(cgrp->root->sb);
+
 		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
 	}
 	iput(inode);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-make-cgroup_path-rcu-safe.patch
cgroups-make-cgroup_path-rcu-safe-fixlet.patch
devices-cgroup-allow-mkfifo.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-swapout-refcnt-fix.patch
memcg-fix-double-free-and-make-refcnt-sane.patch
memcg-use-css_tryget-in-memcg.patch
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_sprintf_cpulist.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_can_attach.patch
cpuset-convert-cpuset_attach-to-use-cpumask_var_t.patch
cpuset-dont-allocate-trial-cpuset-on-stack.patch
cpuset-convert-cpuset-cpus_allowed-to-cpumask_var_t.patch
cpuset-remove-remaining-pointers-to-cpumask_t.patch

