From: akpm@linux-foundation.org
Subject: [folded] memcg-move-charges-of-anonymous-swap-fix-3.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:54:42 -0800
Message-ID: <201003102254.o2AMsgna008742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757385Ab0CJWyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:54:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-move-charges-of-anonymous-swap-fix-3
has been removed from the -mm tree.  Its filename was
     memcg-move-charges-of-anonymous-swap-fix-3.patch

This patch was dropped because it was folded into memcg-move-charges-of-anonymous-swap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-move-charges-of-anonymous-swap-fix-3
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

"move charges at task migration" feature depends on page tables. So, it doesn't
work in !CONIFG_MMU environments.
This patch moves "task move" codes under CONIFG_MMU.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    2 +
 mm/memcontrol.c                  |   31 +++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-move-charges-of-anonymous-swap-fix-3 Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-move-charges-of-anonymous-swap-fix-3
+++ a/Documentation/cgroups/memory.txt
@@ -420,6 +420,8 @@ NOTE2: It is recommended to set the soft
 
 Users can move charges associated with a task along with task migration, that
 is, uncharge task's pages from the old cgroup and charge them to the new cgroup.
+This feature is not supporetd in !CONFIG_MMU environmetns because of lack of
+page tables.
 
 8.1 Interface
 
diff -puN mm/memcontrol.c~memcg-move-charges-of-anonymous-swap-fix-3 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-charges-of-anonymous-swap-fix-3
+++ a/mm/memcontrol.c
@@ -2998,6 +2998,7 @@ static u64 mem_cgroup_move_charge_read(s
 	return mem_cgroup_from_cont(cgrp)->move_charge_at_immigrate;
 }
 
+#ifdef CONFIG_MMU
 static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
 					struct cftype *cft, u64 val)
 {
@@ -3016,6 +3017,13 @@ static int mem_cgroup_move_charge_write(
 
 	return 0;
 }
+#else
+static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
+					struct cftype *cft, u64 val)
+{
+	return -ENOSYS;
+}
+#endif
 
 
 /* For read statistics */
@@ -3538,6 +3546,7 @@ static int mem_cgroup_populate(struct cg
 	return ret;
 }
 
+#ifdef CONFIG_MMU
 /* Handlers for move charge at task migration. */
 #define PRECHARGE_COUNT_AT_ONCE	256
 static int mem_cgroup_do_precharge(unsigned long count)
@@ -3593,6 +3602,28 @@ one_by_one:
 	}
 	return ret;
 }
+#else	/* !CONFIG_MMU */
+static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
+				struct cgroup *cgroup,
+				struct task_struct *p,
+				bool threadgroup)
+{
+	return 0;
+}
+static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
+				struct cgroup *cgroup,
+				struct task_struct *p,
+				bool threadgroup)
+{
+}
+static void mem_cgroup_move_task(struct cgroup_subsys *ss,
+				struct cgroup *cont,
+				struct cgroup *old_cont,
+				struct task_struct *p,
+				bool threadgroup)
+{
+}
+#endif
 
 /**
  * is_target_pte_for_mc - check a pte whether it is valid for move charge
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix-3.patch
memcg-move-charges-of-anonymous-swap-fix-3-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-remove-events-before-destroying-subsystem-state-objects.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-oom-kill-behavior-v3.patch
memcg-fix-oom-kill-behavior-v4.patch
memcg-update-maintainer-list.patch

