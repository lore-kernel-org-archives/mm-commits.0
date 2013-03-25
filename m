From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:00 -0700
Message-ID: <20130325194500.7994131C1B3__28673.7525523224$1364240733$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:62274 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab3CYTpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:02 -0400
Received: by mail-ye0-f202.google.com with SMTP id l8so129942yen.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix total hugetlbfs pages count when using memory overcommit accouting
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hugetlb: fix total hugetlbfs pages count when using memory overcommit accouting

hugetlb_total_pages is used for overcommit calculations but the current
implementation considers only the default hugetlb page size (which is
either the first defined hugepage size or the one specified by
default_hugepagesz kernel boot parameter).

If the system is configured for more than one hugepage size, which is
possible since a137e1cc ("hugetlbfs: per mount huge page sizes") then the
overcommit estimation done by __vm_enough_memory() (resp.  shown by
meminfo_proc_show) is not precise - there is an impression of more
available/allowed memory.  This can lead to an unexpected ENOMEM/EFAULT
resp.  SIGSEGV when memory is accounted.

Testcase:
boot: hugepagesz=1G hugepages=1
the default overcommit ratio is 50
before patch:
egrep 'CommitLimit' /proc/meminfo
CommitLimit:     55434168 kB
after patch:
egrep 'CommitLimit' /proc/meminfo
CommitLimit:     54909880 kB

[akpm@linux-foundation.org: coding-style tweak]
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>		[3.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting
+++ a/mm/hugetlb.c
@@ -2124,8 +2124,12 @@ int hugetlb_report_node_meminfo(int nid,
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
-	struct hstate *h = &default_hstate;
-	return h->nr_huge_pages * pages_per_huge_page(h);
+	struct hstate *h;
+	unsigned long nr_total_pages = 0;
+
+	for_each_hstate(h)
+		nr_total_pages += h->nr_huge_pages * pages_per_huge_page(h);
+	return nr_total_pages;
 }
 
 static int hugetlb_acct_memory(struct hstate *h, long delta)
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

linux-next.patch
mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch
mm-frontswap-cleanup-code.patch
frontswap-get-rid-of-swap_lock-dependency.patch
mm-cleancache-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch
mm-cleancache-clean-up-cleancache_enabled.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch
memblock-add-assertion-for-zero-allocation-alignment.patch
mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim.patch

