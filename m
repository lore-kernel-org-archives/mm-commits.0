From: akpm@linux-foundation.org
Subject: + hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch added to -mm tree
Date: Mon, 16 Apr 2012 16:16:23 -0700
Message-ID: <20120416231623.EC185A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:65522 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2DPXQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 19:16:24 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so662232ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 16:16:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb: migrate memcg info from oldpage to new page during migration
has been added to the -mm tree.  Its filename is
     hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -464,6 +464,8 @@ extern int mem_cgroup_move_hugetlb_paren
 					  struct page *page);
 extern bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup);
 
+extern void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+					struct page *newhpage);
 #else
 static inline int
 mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
@@ -510,6 +512,12 @@ static inline bool mem_cgroup_have_huget
 {
 	return 0;
 }
+
+static inline  void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+						struct page *newhpage)
+{
+	return;
+}
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN mm/memcontrol.c~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration mm/memcontrol.c
--- a/mm/memcontrol.c~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration
+++ a/mm/memcontrol.c
@@ -3379,6 +3379,34 @@ err_out:
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
@@ -928,6 +928,10 @@ static int unmap_and_move_huge_page(new_
 
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
Subject: Subject: hugetlb: migrate memcg info from oldpage to new page during migration

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-lockdep-annotate-root-inode-properly.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch

