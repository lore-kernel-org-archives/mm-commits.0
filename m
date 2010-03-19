From: akpm@linux-foundation.org
Subject: [merged] memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch removed from -mm tree
Date: Fri, 19 Mar 2010 12:48:59 -0400
Message-ID: <201003191949.o2JJngPk008991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab0CSTt7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 15:49:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, benh@kernel.crashing.org, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, sachinp@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcg: avoid use cmpxchg in swap cgroup maintainance
has been removed from the -mm tree.  Its filename was
     memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid use cmpxchg in swap cgroup maintainance
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

swap_cgroup uses 2bytes data and uses cmpxchg in a new operation.  2byte
cmpxchg/xchg is not available on some archs.  This patch replaces
cmpxchg/xchg with operations under lock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Sachin Sant <sachinp@in.ibm.com> wrote:
Acked-by: Balbir Singh <balbir@in.ibm.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
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

origin.patch
memcg-disable-move-charge-in-no-mmu-case.patch
memcontrol-fix-potential-null-deref.patch
linux-next.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
memcg-oom-wakeup-filter.patch
memcg-oom-notifier.patch
memcg-oom-notifier-fix.patch
memcg-oom-kill-disable-and-oom-status.patch

