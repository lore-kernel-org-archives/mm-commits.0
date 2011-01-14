From: akpm@linux-foundation.org
Subject: [merged] memcg-add-lock-to-synchronize-page-accounting-and-migration.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:36 -0800
Message-ID: <201101142252.p0EMqQ1C005624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771Ab1ANWwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, gthelen@google.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commi


The patch titled
     memcg: add lock to synchronize page accounting and migration
has been removed from the -mm tree.  Its filename was
     memcg-add-lock-to-synchronize-page-accounting-and-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add lock to synchronize page accounting and migration
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Introduce a new bit spin lock, PCG_MOVE_LOCK, to synchronize the page
accounting and migration code.  This reworks the locking scheme of
_update_stat() and _move_account() by adding new lock bit PCG_MOVE_LOCK,
which is always taken under IRQ disable.

1. If pages are being migrated from a memcg, then updates to that
   memcg page statistics are protected by grabbing PCG_MOVE_LOCK using
   move_lock_page_cgroup().  In an upcoming commit, memcg dirty page
   accounting will be updating memcg page accounting (specifically: num
   writeback pages) from IRQ context (softirq).  Avoid a deadlocking
   nested spin lock attempt by disabling irq on the local processor when
   grabbing the PCG_MOVE_LOCK.

2. lock for update_page_stat is used only for avoiding race with
   move_account().  So, IRQ awareness of lock_page_cgroup() itself is not
   a problem.  The problem is between mem_cgroup_update_page_stat() and
   mem_cgroup_move_account_page().

Trade-off:
  * Changing lock_page_cgroup() to always disable IRQ (or
    local_bh) has some impacts on performance and I think
    it's bad to disable IRQ when it's not necessary.
  * adding a new lock makes move_account() slower.  Score is
    here.

Performance Impact: moving a 8G anon process.

Before:
	real    0m0.792s
	user    0m0.000s
	sys     0m0.780s

After:
	real    0m0.854s
	user    0m0.000s
	sys     0m0.842s

This score is bad but planned patches for optimization can reduce
this impact.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   31 ++++++++++++++++++++++++++++---
 mm/memcontrol.c             |    9 +++++++--
 2 files changed, 35 insertions(+), 5 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-add-lock-to-synchronize-page-accounting-and-migration include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-add-lock-to-synchronize-page-accounting-and-migration
+++ a/include/linux/page_cgroup.h
@@ -35,15 +35,18 @@ struct page_cgroup *lookup_page_cgroup(s
 
 enum {
 	/* flags for mem_cgroup */
-	PCG_LOCK,  /* page cgroup is locked */
+	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
 	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
-	PCG_ACCT_LRU, /* page has been accounted for */
+	PCG_MIGRATION, /* under page migration */
+	/* flags for mem_cgroup and file and I/O status */
+	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
 	PCG_FILE_DIRTY, /* page is dirty */
 	PCG_FILE_WRITEBACK, /* page is under writeback */
 	PCG_FILE_UNSTABLE_NFS, /* page is NFS unstable */
-	PCG_MIGRATION, /* under page migration */
+	/* No lock in page_cgroup */
+	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
 };
 
 #define TESTPCGFLAG(uname, lname)			\
@@ -117,6 +120,10 @@ static inline enum zone_type page_cgroup
 
 static inline void lock_page_cgroup(struct page_cgroup *pc)
 {
+	/*
+	 * Don't take this lock in IRQ context.
+	 * This lock is for pc->mem_cgroup, USED, CACHE, MIGRATION
+	 */
 	bit_spin_lock(PCG_LOCK, &pc->flags);
 }
 
@@ -130,6 +137,24 @@ static inline int page_is_cgroup_locked(
 	return bit_spin_is_locked(PCG_LOCK, &pc->flags);
 }
 
+static inline void move_lock_page_cgroup(struct page_cgroup *pc,
+	unsigned long *flags)
+{
+	/*
+	 * We know updates to pc->flags of page cache's stats are from both of
+	 * usual context or IRQ context. Disable IRQ to avoid deadlock.
+	 */
+	local_irq_save(*flags);
+	bit_spin_lock(PCG_MOVE_LOCK, &pc->flags);
+}
+
+static inline void move_unlock_page_cgroup(struct page_cgroup *pc,
+	unsigned long *flags)
+{
+	bit_spin_unlock(PCG_MOVE_LOCK, &pc->flags);
+	local_irq_restore(*flags);
+}
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
diff -puN mm/memcontrol.c~memcg-add-lock-to-synchronize-page-accounting-and-migration mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-lock-to-synchronize-page-accounting-and-migration
+++ a/mm/memcontrol.c
@@ -1606,6 +1606,7 @@ void mem_cgroup_update_page_stat(struct 
 	struct mem_cgroup *mem;
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 	bool need_unlock = false;
+	unsigned long uninitialized_var(flags);
 
 	if (unlikely(!pc))
 		return;
@@ -1617,7 +1618,7 @@ void mem_cgroup_update_page_stat(struct 
 	/* pc->mem_cgroup is unstable ? */
 	if (unlikely(mem_cgroup_stealed(mem))) {
 		/* take a lock against to access pc->mem_cgroup */
-		lock_page_cgroup(pc);
+		move_lock_page_cgroup(pc, &flags);
 		need_unlock = true;
 		mem = pc->mem_cgroup;
 		if (!mem || !PageCgroupUsed(pc))
@@ -1640,7 +1641,7 @@ void mem_cgroup_update_page_stat(struct 
 
 out:
 	if (unlikely(need_unlock))
-		unlock_page_cgroup(pc);
+		move_unlock_page_cgroup(pc, &flags);
 	rcu_read_unlock();
 	return;
 }
@@ -2211,9 +2212,13 @@ static int mem_cgroup_move_account(struc
 		struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge)
 {
 	int ret = -EINVAL;
+	unsigned long flags;
+
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc) && pc->mem_cgroup == from) {
+		move_lock_page_cgroup(pc, &flags);
 		__mem_cgroup_move_account(pc, from, to, uncharge);
+		move_unlock_page_cgroup(pc, &flags);
 		ret = 0;
 	}
 	unlock_page_cgroup(pc);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch

