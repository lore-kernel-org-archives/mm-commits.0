From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-memory-migration-of-shmem-swapcache.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:49 -0800
Message-ID: <201101142252.p0EMqdJx005644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775Ab1ANWw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix memory migration of shmem swapcache
has been removed from the -mm tree.  Its filename was
     memcg-fix-memory-migration-of-shmem-swapcache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix memory migration of shmem swapcache
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

In the current implementation mem_cgroup_end_migration() decides whether
the page migration has succeeded or not by checking "oldpage->mapping".

But if we are tring to migrate a shmem swapcache, the page->mapping of it
is NULL from the begining, so the check would be invalid.  As a result,
mem_cgroup_end_migration() assumes the migration has succeeded even if
it's not, so "newpage" would be freed while it's not uncharged.

This patch fixes it by passing mem_cgroup_end_migration() the result of
the page migration.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++---
 mm/memcontrol.c            |    5 ++---
 mm/migrate.c               |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-memory-migration-of-shmem-swapcache include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-memory-migration-of-shmem-swapcache
+++ a/include/linux/memcontrol.h
@@ -98,7 +98,7 @@ extern int
 mem_cgroup_prepare_migration(struct page *page,
 	struct page *newpage, struct mem_cgroup **ptr);
 extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
-	struct page *oldpage, struct page *newpage);
+	struct page *oldpage, struct page *newpage, bool migration_ok);
 
 /*
  * For memory reclaim.
@@ -251,8 +251,7 @@ mem_cgroup_prepare_migration(struct page
 }
 
 static inline void mem_cgroup_end_migration(struct mem_cgroup *mem,
-					struct page *oldpage,
-					struct page *newpage)
+		struct page *oldpage, struct page *newpage, bool migration_ok)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-fix-memory-migration-of-shmem-swapcache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-memory-migration-of-shmem-swapcache
+++ a/mm/memcontrol.c
@@ -2896,7 +2896,7 @@ int mem_cgroup_prepare_migration(struct 
 
 /* remove redundant charge if migration failed*/
 void mem_cgroup_end_migration(struct mem_cgroup *mem,
-	struct page *oldpage, struct page *newpage)
+	struct page *oldpage, struct page *newpage, bool migration_ok)
 {
 	struct page *used, *unused;
 	struct page_cgroup *pc;
@@ -2905,8 +2905,7 @@ void mem_cgroup_end_migration(struct mem
 		return;
 	/* blocks rmdir() */
 	cgroup_exclude_rmdir(&mem->css);
-	/* at migration success, oldpage->mapping is NULL. */
-	if (oldpage->mapping) {
+	if (!migration_ok) {
 		used = oldpage;
 		unused = newpage;
 	} else {
diff -puN mm/migrate.c~memcg-fix-memory-migration-of-shmem-swapcache mm/migrate.c
--- a/mm/migrate.c~memcg-fix-memory-migration-of-shmem-swapcache
+++ a/mm/migrate.c
@@ -768,7 +768,7 @@ skip_unmap:
 
 uncharge:
 	if (!charge)
-		mem_cgroup_end_migration(mem, page, newpage);
+		mem_cgroup_end_migration(mem, page, newpage, rc == 0);
 unlock:
 	unlock_page(page);
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch

