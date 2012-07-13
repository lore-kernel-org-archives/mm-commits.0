From: akpm@linux-foundation.org
Subject: + mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:29:23 -0700
Message-ID: <20120713212923.D48AA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59535 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab2GMV31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:29:27 -0400
Received: by lbbgp10 with SMTP id gp10so222498lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:29:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: fix compaction/migration failing due to memcg limits
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 mm/migrate.c               |   27 +++-----------
 3 files changed, 47 insertions(+), 58 deletions(-)

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
@@ -2977,7 +2977,8 @@ direct_uncharge:
  * uncharge if !page_mapped(page)
  */
 static struct mem_cgroup *
-__mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
+__mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype,
+			     bool end_migration)
 {
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
@@ -3021,7 +3022,16 @@ __mem_cgroup_uncharge_common(struct page
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
@@ -3055,7 +3065,12 @@ __mem_cgroup_uncharge_common(struct page
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
@@ -3071,14 +3086,14 @@ void mem_cgroup_uncharge_page(struct pag
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
@@ -3142,7 +3157,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 	if (!swapout) /* this was a swap cache but the swap is unused ! */
 		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
 
-	memcg = __mem_cgroup_uncharge_common(page, ctype);
+	memcg = __mem_cgroup_uncharge_common(page, ctype, false);
 
 	/*
 	 * record memcg information,  if swapout && memcg != NULL,
@@ -3232,19 +3247,18 @@ static inline int mem_cgroup_move_swap_a
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
@@ -3289,24 +3303,9 @@ int mem_cgroup_prepare_migration(struct 
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
@@ -3319,8 +3318,12 @@ int mem_cgroup_prepare_migration(struct 
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
@@ -3342,6 +3345,12 @@ void mem_cgroup_end_migration(struct mem
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
@@ -3351,10 +3360,6 @@ void mem_cgroup_end_migration(struct mem
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
@@ -687,7 +687,6 @@ static int __unmap_and_move(struct page 
 {
 	int rc = -EAGAIN;
 	int remap_swapcache = 1;
-	int charge = 0;
 	struct mem_cgroup *mem;
 	struct anon_vma *anon_vma = NULL;
 
@@ -729,12 +728,7 @@ static int __unmap_and_move(struct page 
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
@@ -824,8 +818,7 @@ skip_unmap:
 		put_anon_vma(anon_vma);
 
 uncharge:
-	if (!charge)
-		mem_cgroup_end_migration(mem, page, newpage, rc == 0);
+	mem_cgroup_end_migration(mem, page, newpage, rc == 0);
 unlock:
 	unlock_page(page);
 out:
@@ -1519,10 +1512,9 @@ migrate_misplaced_page(struct page *page
 {
 	struct page *oldpage = page, *newpage;
 	struct address_space *mapping = page_mapping(page);
-	struct mem_cgroup *mcg;
+	struct mem_cgroup *memcg;
 	unsigned int gfp;
 	int rc = 0;
-	int charge = -ENOMEM;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(page_mapcount(page));
@@ -1556,12 +1548,7 @@ migrate_misplaced_page(struct page *page
 	if (!trylock_page(newpage))
 		BUG();		/* new page should be unlocked!!! */
 
-	// XXX hnaz, is this right?
-	charge = mem_cgroup_prepare_migration(page, newpage, &mcg, gfp);
-	if (charge == -ENOMEM) {
-		rc = charge;
-		goto out;
-	}
+	mem_cgroup_prepare_migration(page, newpage, &memcg);
 
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
@@ -1581,11 +1568,9 @@ migrate_misplaced_page(struct page *page
 		page = newpage;
 	}
 
+	mem_cgroup_end_migration(memcg, oldpage, newpage, !rc);
 out:
-	if (!charge)
-		mem_cgroup_end_migration(mcg, oldpage, newpage, !rc);
-
-       if (oldpage != page)
+	if (oldpage != page)
                put_page(oldpage);
 
 	if (rc) {
_
Subject: Subject: mm: memcg: fix compaction/migration failing due to memcg limits

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
bootmem-make-___alloc_bootmem_node_nopanic-to-be-real-nopanic.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-slab-remove-duplicate-check.patch
vmalloc-walk-vmap_areas-by-sorted-list-instead-of-rb_next.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
memcg-remove-mem_cgroup_charge_type_force.patch
memcg-remove-check-for-signal_pending-during-rmdir.patch
memcg-clean-up-force_empty_list-return-value-check.patch
memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
memcg-fix-bad-behavior-in-use_hierarchy-file.patch
memcg-rename-mem_control_xxx-to-memcg_xxx.patch
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch
mm-swapfile-clean-up-unuse_pte-race-handling.patch
mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions.patch
mm-memcg-only-check-for-pageswapcache-when-uncharging-anon.patch
mm-memcg-move-swapin-charge-functions-above-callsites.patch
mm-memcg-remove-unneeded-shmem-charge-type.patch
mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging.patch
mm-memcg-split-swapin-charge-function-into-private-and-public-part.patch
mm-memcg-only-check-swap-cache-pages-for-repeated-charging.patch
mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache.patch

