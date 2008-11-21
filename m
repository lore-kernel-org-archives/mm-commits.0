From: akpm@linux-foundation.org
Subject: + ns_cgroup-remove-unused-spinlock.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:12:47 -0800
Message-ID: <200811212312.mALNClF4016227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbYKUXNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:13:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     ns_cgroup: remove unused spinlock
has been added to the -mm tree.  Its filename is
     ns_cgroup-remove-unused-spinlock.patch

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
Subject: ns_cgroup: remove unused spinlock
From: Li Zefan <lizf@cn.fujitsu.com>

I happened to find the spinlock in struct ns_cgroup is never used.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ns_cgroup.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/ns_cgroup.c~ns_cgroup-remove-unused-spinlock kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~ns_cgroup-remove-unused-spinlock
+++ a/kernel/ns_cgroup.c
@@ -13,7 +13,6 @@
 
 struct ns_cgroup {
 	struct cgroup_subsys_state css;
-	spinlock_t lock;
 };
 
 struct cgroup_subsys ns_subsys;
@@ -84,7 +83,6 @@ static struct cgroup_subsys_state *ns_cr
 	ns_cgroup = kzalloc(sizeof(*ns_cgroup), GFP_KERNEL);
 	if (!ns_cgroup)
 		return ERR_PTR(-ENOMEM);
-	spin_lock_init(&ns_cgroup->lock);
 	return &ns_cgroup->css;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
linux-next.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
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
memory-cgroup-hierarchy-feature-selector-v4-fix.patch

