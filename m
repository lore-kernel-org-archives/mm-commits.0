From: akpm@linux-foundation.org
Subject: + memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:59:50 -0700
Message-ID: <200710312159.l9VLxo6b030936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54670 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760410AbXJaWBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 18:01:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memory cgroup enhancements: remember "a page is on active list of cgroup or not"
has been added to the -mm tree.  Its filename is
     memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -425,7 +429,7 @@ noreclaim:
 	atomic_set(&pc->ref_cnt, 1);
 	pc->mem_cgroup = mem;
 	pc->page = page;
-	pc->flags = 0;
+	pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
 		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
 	if (page_cgroup_assign_new_page_cgroup(page, pc)) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

git-sh.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force-empty-at-rmdir.patch
