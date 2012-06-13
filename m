From: akpm@linux-foundation.org
Subject: + hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:46:23 -0700
Message-ID: <20120613204624.0A259A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:64279 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607Ab2FMUq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jun 2012 16:46:27 -0400
Received: by lagr15 with SMTP id r15so54270lag.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:46:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: hugetlb/cgroup: migrate hugetlb cgroup info from oldpage to new page during migration
has been added to the -mm tree.  Its filename is
     hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch

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
Subject: hugetlb/cgroup: migrate hugetlb cgroup info from oldpage to new page during migration

With HugeTLB pages, hugetlb cgroup is uncharged in compound page
destructor.  Since we are holding a hugepage reference, we can be sure
that old page won't get uncharged till the last put_page().

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |    8 ++++++++
 mm/hugetlb_cgroup.c            |   20 ++++++++++++++++++++
 mm/migrate.c                   |    5 +++++
 3 files changed, 33 insertions(+)

diff -puN include/linux/hugetlb_cgroup.h~hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration
+++ a/include/linux/hugetlb_cgroup.h
@@ -63,6 +63,8 @@ extern void hugetlb_cgroup_uncharge_page
 extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg);
 extern int hugetlb_cgroup_file_init(int idx) __init;
+extern void hugetlb_cgroup_migrate(struct page *oldhpage,
+				   struct page *newhpage);
 
 #else
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
@@ -114,5 +116,11 @@ static inline int __init hugetlb_cgroup_
 	return 0;
 }
 
+static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
+					  struct page *newhpage)
+{
+	return;
+}
+
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif
diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration
+++ a/mm/hugetlb_cgroup.c
@@ -388,6 +388,26 @@ int __init hugetlb_cgroup_file_init(int 
 	return 0;
 }
 
+void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
+{
+	struct hugetlb_cgroup *h_cg;
+
+	if (hugetlb_cgroup_disabled())
+		return;
+
+	VM_BUG_ON(!PageHuge(oldhpage));
+	spin_lock(&hugetlb_lock);
+	h_cg = hugetlb_cgroup_from_page(oldhpage);
+	set_hugetlb_cgroup(oldhpage, NULL);
+	cgroup_exclude_rmdir(&h_cg->css);
+
+	/* move the h_cg details to new cgroup */
+	set_hugetlb_cgroup(newhpage, h_cg);
+	spin_unlock(&hugetlb_lock);
+	cgroup_release_and_wakeup_rmdir(&h_cg->css);
+	return;
+}
+
 struct cgroup_subsys hugetlb_subsys = {
 	.name = "hugetlb",
 	.create     = hugetlb_cgroup_create,
diff -puN mm/migrate.c~hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration mm/migrate.c
--- a/mm/migrate.c~hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration
+++ a/mm/migrate.c
@@ -33,6 +33,7 @@
 #include <linux/memcontrol.h>
 #include <linux/syscalls.h>
 #include <linux/hugetlb.h>
+#include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
 
 #include <asm/tlbflush.h>
@@ -935,6 +936,10 @@ static int unmap_and_move_huge_page(new_
 
 	if (anon_vma)
 		put_anon_vma(anon_vma);
+
+	if (!rc)
+		hugetlb_cgroup_migrate(hpage, new_hpage);
+
 	unlock_page(hpage);
 out:
 	put_page(new_hpage);
_
Subject: Subject: hugetlb/cgroup: migrate hugetlb cgroup info from oldpage to new page during migration

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch

