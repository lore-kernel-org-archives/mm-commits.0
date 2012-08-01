From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:47 -0700
Message-ID: <20120801201748.43EF15C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43100 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab2HAURv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:51 -0400
Received: by wgbdt11 with SMTP id dt11so342605wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: fix compaction/migration failing due to memcg limits
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: fix compaction/migration failing due to memcg limits

Compaction (and page migration in general) can currently be hindered
through pages being owned by memory cgroups that are at their limits and
unreclaimable.

The reason is that the replacement page is being charged against the limit
while the page being replaced is also still charged.  But this seems
unnecessary, given that only one of the two pages will still be in use
after migration finishes.

This patch changes the memcg migration sequence so that the replacement
page is not charged.  Whatever page is still in use after successful or
failed migration gets to keep the charge of the page that was going to be
replaced.

The replacement page will still show up temporarily in the rss/cache
statistics, this can be fixed in a later patch as it's less urgent.

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 ++---
 mm/memcontrol.c            |   67 ++++++++++++++++++-----------------
 mm/migrate.c               |   11 +----
 3 files changed, 43 insertions(+), 46 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits
+++ a/include/linux/memcontrol.h
@@ -98,9 +98,9 @@ int mm_match_cgroup(const struct mm_stru
 
 extern struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg);
 
-extern int
-mem_cgroup_prepare_migration(struct page *page,
-	struct page *newpage, struct mem_cgroup **memcgp, gfp_t gfp_mask);
+extern void
+mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
+			     struct mem_cgroup **memcgp);
 extern void mem_cgroup_end_migration(struct mem_cgroup *memcg,
 	struct page *oldpage, struct page *newpage, bool migration_ok);
 
@@ -276,11 +276,10 @@ static inline struct cgroup_subsys_state
 	return NULL;
 }
 
-static inline int
+static inline void
 mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
-	struct mem_cgroup **memcgp, gfp_t gfp_mask)
+			     struct mem_cgroup **memcgp)
 {
-	return 0;
 }
 
 static inline void mem_cgroup_end_migration(struct mem_cgroup *memcg,
diff -puN mm/memcontrol.c~mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits
+++ a/mm/memcontrol.c
@@ -2976,7 +2976,8 @@ direct_uncharge:
  * uncharge if !page_mapped(page)
  */
 static struct mem_cgroup *
-__mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
+__mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype,
+			     bool end_migration)
 {
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
@@ -3020,7 +3021,16 @@ __mem_cgroup_uncharge_common(struct page
 		/* fallthrough */
 	case MEM_CGROUP_CHARGE_TYPE_DROP:
 		/* See mem_cgroup_prepare_migration() */
-		if (page_mapped(page) || PageCgroupMigration(pc))
+		if (page_mapped(page))
+			goto unlock_out;
+		/*
+		 * Pages under migration may not be uncharged.  But
+		 * end_migration() /must/ be the one uncharging the
+		 * unused post-migration page and so it has to call
+		 * here with the migration bit still set.  See the
+		 * res_counter handling below.
+		 */
+		if (!end_migration && PageCgroupMigration(pc))
 			goto unlock_out;
 		break;
 	case MEM_CGROUP_CHARGE_TYPE_SWAPOUT:
@@ -3054,7 +3064,12 @@ __mem_cgroup_uncharge_common(struct page
 		mem_cgroup_swap_statistics(memcg, true);
 		mem_cgroup_get(memcg);
 	}
-	if (!mem_cgroup_is_root(memcg))
+	/*
+	 * Migration does not charge the res_counter for the
+	 * replacement page, so leave it alone when phasing out the
+	 * page that is unused after the migration.
+	 */
+	if (!end_migration && !mem_cgroup_is_root(memcg))
 		mem_cgroup_do_uncharge(memcg, nr_pages, ctype);
 
 	return memcg;
@@ -3070,14 +3085,14 @@ void mem_cgroup_uncharge_page(struct pag
 	if (page_mapped(page))
 		return;
 	VM_BUG_ON(page->mapping && !PageAnon(page));
-	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON);
+	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON, false);
 }
 
 void mem_cgroup_uncharge_cache_page(struct page *page)
 {
 	VM_BUG_ON(page_mapped(page));
 	VM_BUG_ON(page->mapping);
-	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
+	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE, false);
 }
 
 /*
@@ -3141,7 +3156,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 	if (!swapout) /* this was a swap cache but the swap is unused ! */
 		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
 
-	memcg = __mem_cgroup_uncharge_common(page, ctype);
+	memcg = __mem_cgroup_uncharge_common(page, ctype, false);
 
 	/*
 	 * record memcg information,  if swapout && memcg != NULL,
@@ -3231,19 +3246,18 @@ static inline int mem_cgroup_move_swap_a
  * Before starting migration, account PAGE_SIZE to mem_cgroup that the old
  * page belongs to.
  */
-int mem_cgroup_prepare_migration(struct page *page,
-	struct page *newpage, struct mem_cgroup **memcgp, gfp_t gfp_mask)
+void mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
+				  struct mem_cgroup **memcgp)
 {
 	struct mem_cgroup *memcg = NULL;
 	struct page_cgroup *pc;
 	enum charge_type ctype;
-	int ret = 0;
 
 	*memcgp = NULL;
 
 	VM_BUG_ON(PageTransHuge(page));
 	if (mem_cgroup_disabled())
-		return 0;
+		return;
 
 	pc = lookup_page_cgroup(page);
 	lock_page_cgroup(pc);
@@ -3288,24 +3302,9 @@ int mem_cgroup_prepare_migration(struct 
 	 * we return here.
 	 */
 	if (!memcg)
-		return 0;
+		return;
 
 	*memcgp = memcg;
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, 1, memcgp, false);
-	css_put(&memcg->css);/* drop extra refcnt */
-	if (ret) {
-		if (PageAnon(page)) {
-			lock_page_cgroup(pc);
-			ClearPageCgroupMigration(pc);
-			unlock_page_cgroup(pc);
-			/*
-			 * The old page may be fully unmapped while we kept it.
-			 */
-			mem_cgroup_uncharge_page(page);
-		}
-		/* we'll need to revisit this error code (we have -EINTR) */
-		return -ENOMEM;
-	}
 	/*
 	 * We charge new page before it's used/mapped. So, even if unlock_page()
 	 * is called before end_migration, we can catch all events on this new
@@ -3318,8 +3317,12 @@ int mem_cgroup_prepare_migration(struct 
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
+	/*
+	 * The page is committed to the memcg, but it's not actually
+	 * charged to the res_counter since we plan on replacing the
+	 * old one and only one page is going to be left afterwards.
+	 */
 	__mem_cgroup_commit_charge(memcg, newpage, 1, ctype, false);
-	return ret;
 }
 
 /* remove redundant charge if migration failed*/
@@ -3341,6 +3344,12 @@ void mem_cgroup_end_migration(struct mem
 		used = newpage;
 		unused = oldpage;
 	}
+	anon = PageAnon(used);
+	__mem_cgroup_uncharge_common(unused,
+		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
+		     : MEM_CGROUP_CHARGE_TYPE_CACHE,
+		true);
+	css_put(&memcg->css);
 	/*
 	 * We disallowed uncharge of pages under migration because mapcount
 	 * of the page goes down to zero, temporarly.
@@ -3350,10 +3359,6 @@ void mem_cgroup_end_migration(struct mem
 	lock_page_cgroup(pc);
 	ClearPageCgroupMigration(pc);
 	unlock_page_cgroup(pc);
-	anon = PageAnon(used);
-	__mem_cgroup_uncharge_common(unused,
-		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
-		     : MEM_CGROUP_CHARGE_TYPE_CACHE);
 
 	/*
 	 * If a page is a file cache, radix-tree replacement is very atomic
diff -puN mm/migrate.c~mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits mm/migrate.c
--- a/mm/migrate.c~mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits
+++ a/mm/migrate.c
@@ -683,7 +683,6 @@ static int __unmap_and_move(struct page 
 {
 	int rc = -EAGAIN;
 	int remap_swapcache = 1;
-	int charge = 0;
 	struct mem_cgroup *mem;
 	struct anon_vma *anon_vma = NULL;
 
@@ -725,12 +724,7 @@ static int __unmap_and_move(struct page 
 	}
 
 	/* charge against new page */
-	charge = mem_cgroup_prepare_migration(page, newpage, &mem, GFP_KERNEL);
-	if (charge == -ENOMEM) {
-		rc = -ENOMEM;
-		goto unlock;
-	}
-	BUG_ON(charge);
+	mem_cgroup_prepare_migration(page, newpage, &mem);
 
 	if (PageWriteback(page)) {
 		/*
@@ -820,8 +814,7 @@ skip_unmap:
 		put_anon_vma(anon_vma);
 
 uncharge:
-	if (!charge)
-		mem_cgroup_end_migration(mem, page, newpage, rc == 0);
+	mem_cgroup_end_migration(mem, page, newpage, rc == 0);
 unlock:
 	unlock_page(page);
 out:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-slab-remove-duplicate-check.patch

