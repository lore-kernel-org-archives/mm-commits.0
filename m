From: akpm@linux-foundation.org
Subject: [merged] hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:02 -0700
Message-ID: <20120801201302.ADBD8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:03 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: remove exclude and wakeup rmdir calls from migrate
has been removed from the -mm tree.  Its filename was
     hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: remove exclude and wakeup rmdir calls from migrate

We already hold the hugetlb_lock.  That should prevent a parallel cgroup
rmdir from touching page's hugetlb cgroup.  So remove the exclude and
wakeup calls.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate
+++ a/mm/hugetlb_cgroup.c
@@ -385,6 +385,10 @@ int __init hugetlb_cgroup_file_init(int 
 	return 0;
 }
 
+/*
+ * hugetlb_lock will make sure a parallel cgroup rmdir won't happen
+ * when we migrate hugepages
+ */
 void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 {
 	struct hugetlb_cgroup *h_cg;
@@ -397,13 +401,11 @@ void hugetlb_cgroup_migrate(struct page 
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
-	cgroup_exclude_rmdir(&h_cg->css);
 
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(newhpage, h_cg);
 	list_move(&newhpage->lru, &h->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
-	cgroup_release_and_wakeup_rmdir(&h_cg->css);
 	return;
 }
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch

