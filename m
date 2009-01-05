From: akpm@linux-foundation.org
Subject: - cgroups-fix-a-race-between-cgroup_clone-and-umount.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:40:39 -0800
Message-ID: <200901050640.n056edpf004715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbZAEGlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, menage@google.com, serue@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix a race between cgroup_clone and umount
has been removed from the -mm tree.  Its filename was
     cgroups-fix-a-race-between-cgroup_clone-and-umount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix a race between cgroup_clone and umount
From: Li Zefan <lizf@cn.fujitsu.com>

The race is calling cgroup_clone() while umounting the ns cgroup subsys,
and thus cgroup_clone() might access invalid cgroup_fs, or kill_sb() is
called after cgroup_clone() created a new dir in it.

The BUG I triggered is BUG_ON(root->number_of_cgroups != 1);

------------[ cut here ]------------
kernel BUG at kernel/cgroup.c:1093!
invalid opcode: 0000 [#1] SMP
...
Process umount (pid: 5177, ti=e411e000 task=e40c4670 task.ti=e411e000)
...
Call Trace:
 [<c0493df7>] ? deactivate_super+0x3f/0x51
 [<c04a3600>] ? mntput_no_expire+0xb3/0xdd
 [<c04a3ab2>] ? sys_umount+0x265/0x2ac
 [<c04a3b06>] ? sys_oldumount+0xd/0xf
 [<c0403911>] ? sysenter_do_call+0x12/0x31
...
EIP: [<c0456e76>] cgroup_kill_sb+0x23/0xe0 SS:ESP 0068:e411ef2c
---[ end trace c766c1be3bf944ac ]---

Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-fix-a-race-between-cgroup_clone-and-umount kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-a-race-between-cgroup_clone-and-umount
+++ a/kernel/cgroup.c
@@ -2945,7 +2945,11 @@ int cgroup_clone(struct task_struct *tsk
 	parent = task_cgroup(tsk, subsys->subsys_id);
 
 	/* Pin the hierarchy */
-	atomic_inc(&parent->root->sb->s_active);
+	if (!atomic_inc_not_zero(&parent->root->sb->s_active)) {
+		/* We race with the final deactivate_super() */
+		mutex_unlock(&cgroup_mutex);
+		return 0;
+	}
 
 	/* Keep the cgroup alive */
 	get_css_set(cg);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
vfs-factor-out-duplicated-code-in-get_fs_type.patch
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

