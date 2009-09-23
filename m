From: akpm@linux-foundation.org
Subject: [merged] kcore-more-fixes-for-init.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:13 -0700
Message-ID: <200909231957.n8NJvDeD006464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779AbZIWT5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kcore: more fixes for init
has been removed from the -mm tree.  Its filename was
     kcore-more-fixes-for-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore: more fixes for init
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

proc_kcore_init() doesn't check NULL case.  fix it and remove unnecessary
comments.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~kcore-more-fixes-for-init fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-more-fixes-for-init
+++ a/fs/proc/kcore.c
@@ -606,6 +606,10 @@ static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
 				      &proc_kcore_operations);
+	if (!proc_root_kcore) {
+		printk(KERN_ERR "couldn't create /proc/kcore\n");
+		return 0; /* Always returns 0. */
+	}
 	/* Store text area if it's special */
 	proc_kcore_text_init();
 	/* Store vmalloc area */
@@ -615,7 +619,6 @@ static int __init proc_kcore_init(void)
 	/* Store direct-map area from physical memory map */
 	kcore_update_ram();
 	hotplug_memory_notifier(kcore_callback, 0);
-	/* Other special area, area-for-module etc is arch specific. */
 
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

