From: akpm@linux-foundation.org
Subject: - cgroups-fix-a-race-between-rmdir-and-remount.patch removed from -mm tree
Date: Tue, 16 Dec 2008 12:30:24 -0800
Message-ID: <200812162030.mBGKUOOG006511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbYLPUbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 15:31:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix a race between rmdir and remount
has been removed from the -mm tree.  Its filename was
     cgroups-fix-a-race-between-rmdir-and-remount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix a race between rmdir and remount
From: Paul Menage <menage@google.com>

When a cgroup is removed, it's unlinked from its parent's children list,
but not actually freed until the last dentry on it is released (at which
point cgrp->root->number_of_cgroups is decremented).

Currently rebind_subsystems checks for the top cgroup's child list being
empty in order to rebind subsystems into or out of a hierarchy - this can
result in the set of subsystems bound to a hierarchy being
removed-but-not-freed cgroup.

The simplest fix for this is to forbid remounts that change the set of
subsystems on a hierarchy that has removed-but-not-freed cgroups.  This
bug can be reproduced via:

mkdir /mnt/cg
mount -t cgroup -o ns,freezer cgroup /mnt/cg
mkdir /mnt/cg/foo
sleep 1h < /mnt/cg/foo &
rmdir /mnt/cg/foo
mount -t cgroup -o remount,ns,devices,freezer cgroup /mnt/cg
kill $!

Though the above will cause oops in -mm only but not mainline, but the bug
can cause memory leak in mainline (and even oops)

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-fix-a-race-between-rmdir-and-remount kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-a-race-between-rmdir-and-remount
+++ a/kernel/cgroup.c
@@ -702,7 +702,7 @@ static int rebind_subsystems(struct cgro
 	 * any child cgroups exist. This is theoretically supportable
 	 * but involves complex error handling, so it's being left until
 	 * later */
-	if (!list_empty(&cgrp->children))
+	if (root->number_of_cgroups > 1)
 		return -EBUSY;
 
 	/* Process each subsystem */
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
linux-next.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
devcgroup-use-list_for_each_entry_rcu.patch
devices-cgroup-allow-mkfifo.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch
add-a-refcount-check-in-dput.patch

