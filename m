From: akpm@linux-foundation.org
Subject: [merged] proc-kcore-update-statst_size-after-memory-hotplug.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:18 -0700
Message-ID: <200909231957.n8NJvI2V006666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811AbZIWT7x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     /proc/kcore: update stat.st_size after memory hotplug
has been removed from the -mm tree.  Its filename was
     proc-kcore-update-statst_size-after-memory-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/kcore: update stat.st_size after memory hotplug
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

After memory hotplug (or other events in future), kcore size can be
modified.

To update inode->i_size, we have to know inode/dentry but we can't get it
from inside /proc directly.  But considerinyg memory hotplug, kcore image
is updated only when it's opened.  Then, updating inode->i_size at open()
is enough.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/proc/kcore.c~proc-kcore-update-statst_size-after-memory-hotplug fs/proc/kcore.c
--- a/fs/proc/kcore.c~proc-kcore-update-statst_size-after-memory-hotplug
+++ a/fs/proc/kcore.c
@@ -546,6 +546,11 @@ static int open_kcore(struct inode *inod
 		return -EPERM;
 	if (kcore_need_update)
 		kcore_update_ram();
+	if (i_size_read(inode) != proc_root_kcore->size) {
+		mutex_lock(&inode->i_mutex);
+		i_size_write(inode, proc_root_kcore->size);
+		mutex_unlock(&inode->i_mutex);
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

