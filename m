From: akpm@linux-foundation.org
Subject: + cgroups-avoid-accessing-uninitialized-data-in-failure-path.patch added to -mm tree
Date: Tue, 23 Dec 2008 12:21:42 -0800
Message-ID: <200812232021.mBNKLg46010739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbYLWUVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Dec 2008 15:21:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com


The patch titled
     cgroups: avoid accessing uninitialized data in failure path
has been added to the -mm tree.  Its filename is
     cgroups-avoid-accessing-uninitialized-data-in-failure-path.patch

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
Subject: cgroups: avoid accessing uninitialized data in failure path
From: Li Zefan <lizf@cn.fujitsu.com>

If cgroup_get_rootdir() failed, free_cg_links() will be called in the
failure path, but tmp_cg_links hasn't been initialized at that time.

I introduced this bug in the 2.6.27 merge window.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-avoid-accessing-uninitialized-data-in-failure-path kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-avoid-accessing-uninitialized-data-in-failure-path
+++ a/kernel/cgroup.c
@@ -1036,7 +1036,7 @@ static int cgroup_get_sb(struct file_sys
 		if (ret == -EBUSY) {
 			mutex_unlock(&cgroup_mutex);
 			mutex_unlock(&inode->i_mutex);
-			goto drop_new_super;
+			goto free_cg_links;
 		}
 
 		/* EBUSY should be the only error here */
@@ -1074,10 +1074,11 @@ static int cgroup_get_sb(struct file_sys
 
 	return simple_set_mnt(mnt, sb);
 
+ free_cg_links:
+	free_cg_links(&tmp_cg_links);
  drop_new_super:
 	up_write(&sb->s_umount);
 	deactivate_super(sb);
-	free_cg_links(&tmp_cg_links);
 	return ret;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroups-avoid-accessing-uninitialized-data-in-failure-path.patch
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
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch

