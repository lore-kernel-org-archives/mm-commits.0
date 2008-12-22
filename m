From: akpm@linux-foundation.org
Subject: + cgroups-make-cgroup_path-rcu-safe-fixlet.patch added to -mm tree
Date: Mon, 22 Dec 2008 15:28:02 -0800
Message-ID: <200812222328.mBMNS2nK027693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbYLVX2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 18:28:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, menage@google.com


The patch titled
     a fixlet for cgroups-make-cgroup_path-rcu-safe.patch
has been added to the -mm tree.  Its filename is
     cgroups-make-cgroup_path-rcu-safe-fixlet.patch

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

 include/linux/cgroup.h      |    6 ------
 include/linux/cgroup.h.orig |    6 ++++++
 kernel/cgroup.c             |   11 ++++++-----
 3 files changed, 12 insertions(+), 11 deletions(-)

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
diff -puN include/linux/cgroup.h.orig~cgroups-make-cgroup_path-rcu-safe-fixlet include/linux/cgroup.h.orig
--- a/include/linux/cgroup.h.orig~cgroups-make-cgroup_path-rcu-safe-fixlet
+++ a/include/linux/cgroup.h.orig
@@ -308,6 +308,12 @@ int cgroup_add_files(struct cgroup *cgrp
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
+/*
+ * cgroup_path() fills in a filesystem-like path for the given cgroup
+ * into "buf", up to "buflen" characters. Should be called with
+ * cgroup_mutex held, or else in an RCU section with an RCU-protected
+ * cgroup reference
+ */
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

linux-next.patch
cpuacct-refactoring-cpuusage_read-cpuusage_write.patch
cpuacct-export-percpu-cpuacct-cgroup-stats.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
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
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch

