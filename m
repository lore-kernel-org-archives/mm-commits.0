From: akpm@linux-foundation.org
Subject: + memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch added to -mm tree
Date: Sun, 14 Mar 2010 18:38:58 -0400
Message-ID: <201003150139.o2F1dVn6002922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883Ab0COBju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 14 Mar 2010 21:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, benh@kernel.crashing.org, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, sachinp@in.ibm.com


The patch titled
     memcg: avoid use cmpxchg in swap cgroup maintainance
has been added to the -mm tree.  Its filename is
     memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch

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
Subject: memcg: avoid use cmpxchg in swap cgroup maintainance
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

swap_cgroup uses 2bytes data and uses cmpxchg in a new operation.  2byte
cmpxchg/xchg is not available on some archs.  This patch replaces
cmpxchg/xchg with operations under lock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Sachin Sant <sachinp@in.ibm.com> wrote:
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN mm/page_cgroup.c~memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance
+++ a/mm/page_cgroup.c
@@ -284,6 +284,7 @@ static DEFINE_MUTEX(swap_cgroup_mutex);
 struct swap_cgroup_ctrl {
 	struct page **map;
 	unsigned long length;
+	spinlock_t	lock;
 };
 
 struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
@@ -353,16 +354,22 @@ unsigned short swap_cgroup_cmpxchg(swp_e
 	struct swap_cgroup_ctrl *ctrl;
 	struct page *mappage;
 	struct swap_cgroup *sc;
+	unsigned long flags;
+	unsigned short retval;
 
 	ctrl = &swap_cgroup_ctrl[type];
 
 	mappage = ctrl->map[idx];
 	sc = page_address(mappage);
 	sc += pos;
-	if (cmpxchg(&sc->id, old, new) == old)
-		return old;
+	spin_lock_irqsave(&ctrl->lock, flags);
+	retval = sc->id;
+	if (retval == old)
+		sc->id = new;
 	else
-		return 0;
+		retval = 0;
+	spin_unlock_irqrestore(&ctrl->lock, flags);
+	return retval;
 }
 
 /**
@@ -383,13 +390,17 @@ unsigned short swap_cgroup_record(swp_en
 	struct page *mappage;
 	struct swap_cgroup *sc;
 	unsigned short old;
+	unsigned long flags;
 
 	ctrl = &swap_cgroup_ctrl[type];
 
 	mappage = ctrl->map[idx];
 	sc = page_address(mappage);
 	sc += pos;
-	old = xchg(&sc->id, id);
+	spin_lock_irqsave(&ctrl->lock, flags);
+	old = sc->id;
+	sc->id = id;
+	spin_unlock_irqrestore(&ctrl->lock, flags);
 
 	return old;
 }
@@ -441,6 +452,7 @@ int swap_cgroup_swapon(int type, unsigne
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl->length = length;
 	ctrl->map = array;
+	spin_lock_init(&ctrl->lock);
 	if (swap_cgroup_prepare(type)) {
 		/* memory shortage */
 		ctrl->map = NULL;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

nommu-fix-build-breakage.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-unloading.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-improve-performance-in-moving-swap-charge.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-oom-kill-behavior-v3.patch
memcg-update-maintainer-list.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch
linux-next.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch

