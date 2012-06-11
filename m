From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:15 -0700
Message-ID: <20120611211015.73B3FA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:50760 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2FKVKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:18 -0400
Received: by wgbdt11 with SMTP id dt11so258011wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: migrate memcg info from oldpage to new page during migration
has been removed from the -mm tree.  Its filename was
     hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb: migrate memcg info from oldpage to new page during migration

With HugeTLB pages, memcg is uncharged in compound page destructor.  Since
we are holding a hugepage reference, we can be sure that old page won't
get uncharged till the last put_page().  On successful migrate, we can
move the memcg information to new page's page_cgroup and mark the old
page's page_cgroup unused.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 ++++++++
 mm/memcontrol.c            |   28 ++++++++++++++++++++++++++++
 mm/migrate.c               |    4 ++++
 3 files changed, 40 insertions(+)

diff -puN include/linux/memcontrol.h~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration
+++ a/include/linux/memcontrol.h
@@ -433,6 +433,8 @@ extern int mem_cgroup_move_hugetlb_paren
 					  struct page *page);
 extern bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup);
 
+extern void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+					struct page *newhpage);
 #else
 static inline int
 mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
@@ -468,6 +470,12 @@ static inline int mem_cgroup_hugetlb_fil
 	return 0;
 }
 
+static inline  void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+						struct page *newhpage)
+{
+	return;
+}
+
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN mm/memcontrol.c~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration mm/memcontrol.c
--- a/mm/memcontrol.c~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration
+++ a/mm/memcontrol.c
@@ -3337,6 +3337,34 @@ err_out:
 out:
 	return ret;
 }
+
+void  mem_cgroup_hugetlb_migrate(struct page *oldhpage, struct page *newhpage)
+{
+	struct mem_cgroup *memcg;
+	struct page_cgroup *pc;
+
+	VM_BUG_ON(!PageHuge(oldhpage));
+
+	if (mem_cgroup_disabled())
+		return;
+
+	pc = lookup_page_cgroup(oldhpage);
+	lock_page_cgroup(pc);
+	memcg = pc->mem_cgroup;
+	pc->mem_cgroup = root_mem_cgroup;
+	ClearPageCgroupUsed(pc);
+	cgroup_exclude_rmdir(&memcg->css);
+	unlock_page_cgroup(pc);
+
+	/* move the mem_cg details to new cgroup */
+	pc = lookup_page_cgroup(newhpage);
+	lock_page_cgroup(pc);
+	pc->mem_cgroup = memcg;
+	SetPageCgroupUsed(pc);
+	unlock_page_cgroup(pc);
+	cgroup_release_and_wakeup_rmdir(&memcg->css);
+	return;
+}
 #endif /* CONFIG_MEM_RES_CTLR_HUGETLB */
 
 /*
diff -puN mm/migrate.c~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration mm/migrate.c
--- a/mm/migrate.c~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration
+++ a/mm/migrate.c
@@ -935,6 +935,10 @@ static int unmap_and_move_huge_page(new_
 
 	if (anon_vma)
 		put_anon_vma(anon_vma);
+
+	if (!rc)
+		mem_cgroup_hugetlb_migrate(hpage, new_hpage);
+
 	unlock_page(hpage);
 out:
 	put_page(new_hpage);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

