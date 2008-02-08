From: akpm@linux-foundation.org
Subject: - memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:11 -0800
Message-ID: <200802080803.m1883qjP014154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864AbYBHIa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:30:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     memory cgroup enhancements: remember "a page is charged as page cache"
has been removed from the -mm tree.  Its filename was
     memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory cgroup enhancements: remember "a page is charged as page cache"
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add a flag to page_cgroup to remember "this page is
charged as cache."
cache here includes page caches and swap cache.
This is useful for implementing precise accounting in memory cgroup.
TODO:
  distinguish page-cache and swap-cache

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache
+++ a/mm/memcontrol.c
@@ -83,7 +83,9 @@ struct page_cgroup {
 	struct mem_cgroup *mem_cgroup;
 	atomic_t ref_cnt;		/* Helpful when pages move b/w  */
 					/* mapped and cached states     */
+	int	 flags;
 };
+#define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
 
 enum {
 	MEM_CGROUP_TYPE_UNSPEC = 0,
@@ -93,6 +95,11 @@ enum {
 	MEM_CGROUP_TYPE_MAX,
 };
 
+enum charge_type {
+	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
+	MEM_CGROUP_CHARGE_TYPE_MAPPED,
+};
+
 static struct mem_cgroup init_mem_cgroup;
 
 static inline
@@ -306,8 +313,8 @@ unsigned long mem_cgroup_isolate_pages(u
  * 0 if the charge was successful
  * < 0 if the cgroup is over its limit
  */
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask)
+static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
+				gfp_t gfp_mask, enum charge_type ctype)
 {
 	struct mem_cgroup *mem;
 	struct page_cgroup *pc;
@@ -409,6 +416,9 @@ noreclaim:
 	atomic_set(&pc->ref_cnt, 1);
 	pc->mem_cgroup = mem;
 	pc->page = page;
+	pc->flags = 0;
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
+		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
 	if (page_cgroup_assign_new_page_cgroup(page, pc)) {
 		/*
 		 * an another charge is added to this page already.
@@ -433,6 +443,13 @@ err:
 	return -ENOMEM;
 }
 
+int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
+			gfp_t gfp_mask)
+{
+	return mem_cgroup_charge_common(page, mm, gfp_mask,
+			MEM_CGROUP_CHARGE_TYPE_MAPPED);
+}
+
 /*
  * See if the cached pages should be charged at all?
  */
@@ -445,7 +462,8 @@ int mem_cgroup_cache_charge(struct page 
 
 	mem = rcu_dereference(mm->mem_cgroup);
 	if (mem->control_type == MEM_CGROUP_TYPE_ALL)
-		return mem_cgroup_charge(page, mm, gfp_mask);
+		return mem_cgroup_charge_common(page, mm, gfp_mask,
+				MEM_CGROUP_CHARGE_TYPE_CACHE);
 	else
 		return 0;
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
