From: akpm@linux-foundation.org
Subject: - bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:50 -0800
Message-ID: <200802080803.m1883VPB014128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933574AbYBHI1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:27:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     bugfix for memory cgroup controller: migration under memory controller fix
has been removed from the -mm tree.  Its filename was
     bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bugfix for memory cgroup controller: migration under memory controller fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

While using memory control cgroup, page-migration under it works as following.
==
 1. uncharge all refs at try to unmap.
 2. charge regs again remove_migration_ptes()
==
This is simple but has following problems.
==
 The page is uncharged and charged back again if *mapped*.
    - This means that cgroup before migration can be different from one after
      migration
    - If page is not mapped but charged as page cache, charge is just ignored
      (because not mapped, it will not be uncharged before migration)
      This is memory leak.
==
This patch tries to keep memory cgroup at page migration by increasing
one refcnt during it. 3 functions are added.

 mem_cgroup_prepare_migration() --- increase refcnt of page->page_cgroup
 mem_cgroup_end_migration()     --- decrease refcnt of page->page_cgroup
 mem_cgroup_page_migration() --- copy page->page_cgroup from old page to
                                 new page.

During migration
  - old page is under PG_locked.
  - new page is under PG_locked, too.
  - both old page and new page is not on LRU.

These 3 facts guarantee that page_cgroup() migration has no race.

Tested and worked well in x86_64/fake-NUMA box.

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

 include/linux/memcontrol.h |   19 +++++++++++++++
 mm/memcontrol.c            |   43 +++++++++++++++++++++++++++++++++++
 mm/migrate.c               |   13 ++++++++--
 3 files changed, 72 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix
+++ a/include/linux/memcontrol.h
@@ -60,6 +60,10 @@ static inline void mem_cgroup_uncharge_p
 	mem_cgroup_uncharge(page_get_page_cgroup(page));
 }
 
+extern int mem_cgroup_prepare_migration(struct page *page);
+extern void mem_cgroup_end_migration(struct page *page);
+extern void mem_cgroup_page_migration(struct page *page, struct page *newpage);
+
 #else /* CONFIG_CGROUP_MEM_CONT */
 static inline void mm_init_cgroup(struct mm_struct *mm,
 					struct task_struct *p)
@@ -117,6 +121,21 @@ static inline int task_in_mem_cgroup(str
 	return 1;
 }
 
+static inline int mem_cgroup_prepare_migration(struct page *page)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_end_migration(struct page *page)
+{
+}
+
+static inline void
+mem_cgroup_page_migration(struct page *page, struct page *newpage)
+{
+}
+
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix mm/memcontrol.c
--- a/mm/memcontrol.c~bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix
+++ a/mm/memcontrol.c
@@ -492,6 +492,49 @@ void mem_cgroup_uncharge(struct page_cgr
 		}
 	}
 }
+/*
+ * Returns non-zero if a page (under migration) has valid page_cgroup member.
+ * Refcnt of page_cgroup is incremented.
+ */
+
+int mem_cgroup_prepare_migration(struct page *page)
+{
+	struct page_cgroup *pc;
+	int ret = 0;
+	lock_page_cgroup(page);
+	pc = page_get_page_cgroup(page);
+	if (pc && atomic_inc_not_zero(&pc->ref_cnt))
+		ret = 1;
+	unlock_page_cgroup(page);
+	return ret;
+}
+
+void mem_cgroup_end_migration(struct page *page)
+{
+	struct page_cgroup *pc = page_get_page_cgroup(page);
+	mem_cgroup_uncharge(pc);
+}
+/*
+ * We know both *page* and *newpage* are now not-on-LRU and Pg_locked.
+ * And no race with uncharge() routines because page_cgroup for *page*
+ * has extra one reference by mem_cgroup_prepare_migration.
+ */
+
+void mem_cgroup_page_migration(struct page *page, struct page *newpage)
+{
+	struct page_cgroup *pc;
+retry:
+	pc = page_get_page_cgroup(page);
+	if (!pc)
+		return;
+	if (clear_page_cgroup(page, pc) != pc)
+		goto retry;
+	pc->page = newpage;
+	lock_page_cgroup(newpage);
+	page_assign_page_cgroup(newpage, pc);
+	unlock_page_cgroup(newpage);
+	return;
+}
 
 int mem_cgroup_write_strategy(char *buf, unsigned long long *tmp)
 {
diff -puN mm/migrate.c~bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix mm/migrate.c
--- a/mm/migrate.c~bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix
+++ a/mm/migrate.c
@@ -593,9 +593,10 @@ static int move_to_new_page(struct page 
 	else
 		rc = fallback_migrate_page(mapping, newpage, page);
 
-	if (!rc)
+	if (!rc) {
+		mem_cgroup_page_migration(page, newpage);
 		remove_migration_ptes(page, newpage);
-	else
+	} else
 		newpage->mapping = NULL;
 
 	unlock_page(newpage);
@@ -614,6 +615,7 @@ static int unmap_and_move(new_page_t get
 	int *result = NULL;
 	struct page *newpage = get_new_page(page, private, &result);
 	int rcu_locked = 0;
+	int charge = 0;
 
 	if (!newpage)
 		return -ENOMEM;
@@ -673,14 +675,19 @@ static int unmap_and_move(new_page_t get
 		goto rcu_unlock;
 	}
 
+	charge = mem_cgroup_prepare_migration(page);
 	/* Establish migration ptes or remove ptes */
 	try_to_unmap(page, 1);
 
 	if (!page_mapped(page))
 		rc = move_to_new_page(newpage, page);
 
-	if (rc)
+	if (rc) {
 		remove_migration_ptes(page, page);
+		if (charge)
+			mem_cgroup_end_migration(page);
+	} else if (charge)
+ 		mem_cgroup_end_migration(newpage);
 rcu_unlock:
 	if (rcu_locked)
 		rcu_read_unlock();
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
