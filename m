From: akpm@linux-foundation.org
Subject: - bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:53 -0800
Message-ID: <200802080803.m1883YQX014134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932074AbYBHIYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:24:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     bugfix for memory cgroup controller: avoid !PageLRU page in mem_cgroup_isolate_pages
has been removed from the -mm tree.  Its filename was
     bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bugfix for memory cgroup controller: avoid !PageLRU page in mem_cgroup_isolate_pages
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch makes mem_cgroup_isolate_pages() to be

  - ignore !PageLRU pages.
  - fixes the bug that isolation makes no progress if page_zone(page) != zone
    page once find. (just increment scan in this case.)

kswapd and memory migration removes a page from list when it handles
a page for reclaiming/migration.

Because __isolate_lru_page() doesn't moves page !PageLRU pages, it will
be safe to avoid touching !PageLRU() page and its page_cgroup.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

 mm/memcontrol.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages mm/memcontrol.c
--- a/mm/memcontrol.c~bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages
+++ a/mm/memcontrol.c
@@ -250,7 +250,7 @@ unsigned long mem_cgroup_isolate_pages(u
 	unsigned long scan;
 	LIST_HEAD(pc_list);
 	struct list_head *src;
-	struct page_cgroup *pc;
+	struct page_cgroup *pc, *tmp;
 
 	if (active)
 		src = &mem_cont->active_list;
@@ -258,11 +258,18 @@ unsigned long mem_cgroup_isolate_pages(u
 		src = &mem_cont->inactive_list;
 
 	spin_lock(&mem_cont->lru_lock);
-	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
-		pc = list_entry(src->prev, struct page_cgroup, lru);
+	scan = 0;
+	list_for_each_entry_safe_reverse(pc, tmp, src, lru) {
+		if (scan++ > nr_to_scan)
+			break;
 		page = pc->page;
 		VM_BUG_ON(!pc);
 
+		if (unlikely(!PageLRU(page))) {
+			scan--;
+			continue;
+		}
+
 		if (PageActive(page) && !active) {
 			__mem_cgroup_move_lists(pc, true);
 			scan--;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
