From: akpm@linux-foundation.org
Subject: - memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:22 -0800
Message-ID: <200802080804.m18843e7014238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760961AbYBHI3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:29:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     memory cgroup enhancements: remember "a page is on active list of cgroup or not"
has been removed from the -mm tree.  Its filename was
     memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory cgroup enhancements: remember "a page is on active list of cgroup or not"
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Remember page_cgroup is on active_list or not in page_cgroup->flags.

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

 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not
+++ a/mm/memcontrol.c
@@ -86,6 +86,7 @@ struct page_cgroup {
 	int	 flags;
 };
 #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
+#define PAGE_CGROUP_FLAG_ACTIVE (0x2)	/* page is active in this cgroup */
 
 enum {
 	MEM_CGROUP_TYPE_UNSPEC = 0,
@@ -213,10 +214,13 @@ clear_page_cgroup(struct page *page, str
 
 static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
-	if (active)
+	if (active) {
+		pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
 		list_move(&pc->lru, &pc->mem_cgroup->active_list);
-	else
+	} else {
+		pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
 		list_move(&pc->lru, &pc->mem_cgroup->inactive_list);
+	}
 }
 
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
@@ -403,7 +407,7 @@ retry:
 	atomic_set(&pc->ref_cnt, 1);
 	pc->mem_cgroup = mem;
 	pc->page = page;
-	pc->flags = 0;
+	pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
 		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
