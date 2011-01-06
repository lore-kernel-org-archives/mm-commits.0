From: akpm@linux-foundation.org
Subject: + memcg-fix-memory-migration-of-shmem-swapcache.patch added to -mm tree
Date: Thu, 06 Jan 2011 13:41:25 -0800
Message-ID: <201101062141.p06LfPNb017118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935Ab1AFVln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jan 2011 16:41:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     memcg: fix memory migration of shmem swapcache
has been added to the -mm tree.  Its filename is
     memcg-fix-memory-migration-of-shmem-swapcache.patch

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
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -761,7 +761,7 @@ rcu_unlock:
 		rcu_read_unlock();
 uncharge:
 	if (!charge)
-		mem_cgroup_end_migration(mem, page, newpage);
+		mem_cgroup_end_migration(mem, page, newpage, rc == 0);
 unlock:
 	unlock_page(page);
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-compound_trans_order-fix.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch
memcg-fix-deadlock-between-cpuset-and-memcg.patch
memcg-fix-deadlock-between-cpuset-and-memcg-fix.patch
memcg-fix-memory-migration-of-shmem-swapcache.patch

