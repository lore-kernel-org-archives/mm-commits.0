From: akpm@linux-foundation.org
Subject: [to-be-updated] cgroup-allow-subsys-to-set-default-mode-of-its-own-file.patch removed from -mm tree
Date: Tue, 03 Mar 2009 12:16:20 -0800
Message-ID: <200903032016.n23KGK6m032076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739AbZCCURG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 15:17:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, lizf@cn.fujitsu.cn, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: allow subsys to set default mode of its own file
has been removed from the -mm tree.  Its filename was
     cgroup-allow-subsys-to-set-default-mode-of-its-own-file.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: allow subsys to set default mode of its own file
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

cgroup's subsys has "readonly" files, but default permission is always
rw-r--r--. This allows to create r--r--r-- file to subsys.
(The user can do chmod on this read-only file. But this behavior is not
 different from current pseudo file systems as /proc.)

Reason:

When I wrote tools for maintaining cgroups, I couldn't find which file was
a writable interface via cgroup file systems.  (finally, I did dirty
approach.)

IMHO, showing "this file is read-only" in explicit way is useful for
user-land (tools).  In other story, a file whose name sounds read-only may
have "trigger" operation and support reseting.  In this case, "writable"
is informative.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.cn>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    2 ++
 kernel/cgroup.c        |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/cgroup.h~cgroup-allow-subsys-to-set-default-mode-of-its-own-file include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-allow-subsys-to-set-default-mode-of-its-own-file
+++ a/include/linux/cgroup.h
@@ -245,6 +245,8 @@ struct cftype {
 	 * subsystem, followed by a period */
 	char name[MAX_CFTYPE_NAME];
 	int private;
+	/* if not 0, mode is set to mode, otherwise 0644 */
+	int mode;
 
 	/*
 	 * If non-zero, defines the maximum length of string that can
diff -puN kernel/cgroup.c~cgroup-allow-subsys-to-set-default-mode-of-its-own-file kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-allow-subsys-to-set-default-mode-of-its-own-file
+++ a/kernel/cgroup.c
@@ -1706,7 +1706,10 @@ int cgroup_add_file(struct cgroup *cgrp,
 	BUG_ON(!mutex_is_locked(&dir->d_inode->i_mutex));
 	dentry = lookup_one_len(name, dir, strlen(name));
 	if (!IS_ERR(dentry)) {
-		error = cgroup_create_file(dentry, 0644 | S_IFREG,
+		int mode = 0644;
+		if (cft->mode)
+			mode = cft->mode;
+		error = cgroup_create_file(dentry, mode | S_IFREG,
 						cgrp->root->sb);
 		if (!error)
 			dentry->d_fsdata = (void *)cft;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
cgroup-allow-subsys-to-set-default-mode-of-its-own-file.patch
cgroup-memcg-show-correct-file-mode.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
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
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch

