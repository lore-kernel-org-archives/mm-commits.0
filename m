From: akpm@linux-foundation.org
Subject: + mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch added to -mm tree
Date: Thu, 13 Dec 2012 13:49:45 -0800
Message-ID: <20121213214946.A3FF7200065@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:37583 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab2LMVtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Dec 2012 16:49:49 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so140042eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Dec 2012 13:49:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wujianguo@huawei.com, aneesh.kumar@linux.vnet.ibm.com, jiang.liu@huawei.com, mhocko@suse.cz, stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: create hugetlb cgroup file in hugetlb_init
has been added to the -mm tree.  Its filename is
     mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/hugetlb: create hugetlb cgroup file in hugetlb_init

Build kernel with CONFIG_HUGETLBFS=y,CONFIG_HUGETLB_PAGE=y and
CONFIG_CGROUP_HUGETLB=y, then specify hugepagesz=xx boot option, system
will fail to boot.

This failure is caused by following code path:
setup_hugepagesz
	hugetlb_add_hstate
		hugetlb_cgroup_file_init
			cgroup_add_cftypes
				kzalloc <--slab is *not available* yet

For this path, slab is not available yet, so memory allocated will be
failed, and cause WARN_ON() in hugetlb_cgroup_file_init().

So I move hugetlb_cgroup_file_init() into hugetlb_init().

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |    7 ++-----
 mm/hugetlb.c                   |   11 +----------
 mm/hugetlb_cgroup.c            |   18 ++++++++++++++++--
 3 files changed, 19 insertions(+), 17 deletions(-)

diff -puN include/linux/hugetlb_cgroup.h~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init
+++ a/include/linux/hugetlb_cgroup.h
@@ -62,7 +62,7 @@ extern void hugetlb_cgroup_uncharge_page
 					 struct page *page);
 extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg);
-extern int hugetlb_cgroup_file_init(int idx) __init;
+extern void hugetlb_cgroup_file_init(void) __init;
 extern void hugetlb_cgroup_migrate(struct page *oldhpage,
 				   struct page *newhpage);
 
@@ -111,10 +111,7 @@ hugetlb_cgroup_uncharge_cgroup(int idx, 
 	return;
 }
 
-static inline int __init hugetlb_cgroup_file_init(int idx)
-{
-	return 0;
-}
+static inline void __init hugetlb_cgroup_file_init() {}
 
 static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
 					  struct page *newhpage)
diff -puN mm/hugetlb.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init
+++ a/mm/hugetlb.c
@@ -1906,14 +1906,12 @@ static int __init hugetlb_init(void)
 		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
 
 	hugetlb_init_hstates();
-
 	gather_bootmem_prealloc();
-
 	report_hugepages();
 
 	hugetlb_sysfs_init();
-
 	hugetlb_register_all_nodes();
+	hugetlb_cgroup_file_init();
 
 	return 0;
 }
@@ -1943,13 +1941,6 @@ void __init hugetlb_add_hstate(unsigned 
 	h->next_nid_to_free = first_node(node_states[N_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
-	/*
-	 * Add cgroup control files only if the huge page consists
-	 * of more than two normal pages. This is because we use
-	 * page[2].lru.next for storing cgoup details.
-	 */
-	if (order >= HUGETLB_CGROUP_MIN_ORDER)
-		hugetlb_cgroup_file_init(hugetlb_max_hstate - 1);
 
 	parsed_hstate = h;
 }
diff -puN mm/hugetlb_cgroup.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init
+++ a/mm/hugetlb_cgroup.c
@@ -333,7 +333,7 @@ static char *mem_fmt(char *buf, int size
 	return buf;
 }
 
-int __init hugetlb_cgroup_file_init(int idx)
+static void __init __hugetlb_cgroup_file_init(int idx)
 {
 	char buf[32];
 	struct cftype *cft;
@@ -375,7 +375,21 @@ int __init hugetlb_cgroup_file_init(int 
 
 	WARN_ON(cgroup_add_cftypes(&hugetlb_subsys, h->cgroup_files));
 
-	return 0;
+	return;
+}
+
+void __init hugetlb_cgroup_file_init()
+{
+	struct hstate *h;
+
+	for_each_hstate(h)
+		/*
+		 * Add cgroup control files only if the huge page consists
+		 * of more than two normal pages. This is because we use
+		 * page[2].lru.next for storing cgroup details.
+		 */
+		if (huge_page_order(h) >= HUGETLB_CGROUP_MIN_ORDER)
+			__hugetlb_cgroup_file_init(hstate_index(h));
 }
 
 /*
_

Patches currently in -mm which might be from wujianguo@huawei.com are

mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch

