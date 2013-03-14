From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting.patch added to -mm tree
Date: Thu, 14 Mar 2013 13:43:30 -0700
Message-ID: <20130314204330.924675A40E5__11063.3024051369$1363293841$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:41452 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3CNUnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 16:43:32 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so270246vea.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 13:43:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwanp@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix total hugetlbfs pages count when using memory overcommit accouting
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>		[3.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting
+++ a/mm/hugetlb.c
@@ -2124,8 +2124,11 @@ int hugetlb_report_node_meminfo(int nid,
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
-	struct hstate *h = &default_hstate;
-	return h->nr_huge_pages * pages_per_huge_page(h);
+	struct hstate *h;
+	unsigned long nr_total_pages = 0;
+	for_each_hstate(h)
+		nr_total_pages += h->nr_huge_pages * pages_per_huge_page(h);
+	return nr_total_pages;
 }
 
 static int hugetlb_acct_memory(struct hstate *h, long delta)
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting.patch
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

