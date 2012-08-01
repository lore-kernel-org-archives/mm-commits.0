From: akpm@linux-foundation.org
Subject: [merged] hugetlb-make-some-static-variables-global.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:12:23 -0700
Message-ID: <20120801201224.396215C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:59164 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949Ab2HAUM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:12:27 -0400
Received: by lagr15 with SMTP id r15so343798lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:12:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: make some static variables global
has been removed from the -mm tree.  Its filename was
     hugetlb-make-some-static-variables-global.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb: make some static variables global

We will use them later in hugetlb_cgroup.c

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |    7 ++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-make-some-static-variables-global include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-make-some-static-variables-global
+++ a/include/linux/hugetlb.h
@@ -21,6 +21,11 @@ struct hugepage_subpool {
 	long max_hpages, used_hpages;
 };
 
+extern spinlock_t hugetlb_lock;
+extern int hugetlb_max_hstate __read_mostly;
+#define for_each_hstate(h) \
+	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
+
 struct hugepage_subpool *hugepage_new_subpool(long nr_blocks);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
diff -puN mm/hugetlb.c~hugetlb-make-some-static-variables-global mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-make-some-static-variables-global
+++ a/mm/hugetlb.c
@@ -35,7 +35,7 @@ const unsigned long hugetlb_zero = 0, hu
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
-static int hugetlb_max_hstate;
+int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
@@ -46,13 +46,10 @@ static struct hstate * __initdata parsed
 static unsigned long __initdata default_hstate_max_huge_pages;
 static unsigned long __initdata default_hstate_size;
 
-#define for_each_hstate(h) \
-	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
