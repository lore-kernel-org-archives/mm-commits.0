From: akpm@linux-foundation.org
Subject: - cgroups-fix-a-serious-bug-in-cgroupstats.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:28 -0800
Message-ID: <200811202043.mAKKhS4h007509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536AbYKTUoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, menage@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix a serious bug in cgroupstats
has been removed from the -mm tree.  Its filename was
     cgroups-fix-a-serious-bug-in-cgroupstats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix a serious bug in cgroupstats
From: Li Zefan <lizf@cn.fujitsu.com>

Try this, and you'll get oops immediately:
 # cd Documentation/accounting/
 # gcc -o getdelays getdelays.c
 # mount -t cgroup -o debug xxx /mnt
 # ./getdelays -C /mnt/tasks

Because a normal file's dentry->d_fsdata is a pointer to struct cftype,
not struct cgroup.

After the patch, it returns EINVAL if we try to get cgroupstats
from a normal file.

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-fix-a-serious-bug-in-cgroupstats kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-a-serious-bug-in-cgroupstats
+++ a/kernel/cgroup.c
@@ -2039,10 +2039,13 @@ int cgroupstats_build(struct cgroupstats
 	struct cgroup *cgrp;
 	struct cgroup_iter it;
 	struct task_struct *tsk;
+
 	/*
-	 * Validate dentry by checking the superblock operations
+	 * Validate dentry by checking the superblock operations,
+	 * and make sure it's a directory.
 	 */
-	if (dentry->d_sb->s_op != &cgroup_ops)
+	if (dentry->d_sb->s_op != &cgroup_ops ||
+	    !S_ISDIR(dentry->d_inode->i_mode))
 		 goto err;
 
 	ret = 0;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-swap-cgroup-for-remembering-usage-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchy-feature-selector-v4.patch

