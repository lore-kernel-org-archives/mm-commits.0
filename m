From: akpm@linux-foundation.org
Subject: [folded-merged] mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:15:46 -0800
Message-ID: <20121218221547.AC777200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:42613 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2LRWPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:15:50 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so67730wib.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:15:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, jiang.liu@huawei.com, mhocko@suse.cz, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch

This patch was dropped because it was folded into mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix

tweak coding-style, remove pointless __init on inlined function

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |    4 +++-
 mm/hugetlb_cgroup.c            |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb_cgroup.h~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix
+++ a/include/linux/hugetlb_cgroup.h
@@ -111,7 +111,9 @@ hugetlb_cgroup_uncharge_cgroup(int idx, 
 	return;
 }
 
-static inline void __init hugetlb_cgroup_file_init() {}
+static inline void hugetlb_cgroup_file_init()
+{
+}
 
 static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
 					  struct page *newhpage)
diff -puN mm/hugetlb_cgroup.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix
+++ a/mm/hugetlb_cgroup.c
@@ -382,7 +382,7 @@ void __init hugetlb_cgroup_file_init()
 {
 	struct hstate *h;
 
-	for_each_hstate(h)
+	for_each_hstate(h) {
 		/*
 		 * Add cgroup control files only if the huge page consists
 		 * of more than two normal pages. This is because we use
@@ -390,6 +390,7 @@ void __init hugetlb_cgroup_file_init()
 		 */
 		if (huge_page_order(h) >= HUGETLB_CGROUP_MIN_ORDER)
 			__hugetlb_cgroup_file_init(hstate_index(h));
+	}
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch

