From: akpm@linux-foundation.org
Subject: + mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
 added to -mm tree
Date: Mon, 15 May 2017 14:27:06 -0700
Message-ID: <591a1d2a.Sh45xhgK8k2d8NWT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758883AbdEOV1I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: skip reporting offline pages in pagetypeinfo
has been added to the -mm tree.  Its filename is
     mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmstat: skip reporting offline pages in pagetypeinfo

pagetypeinfo_showblockcount_print skips over invalid pfns but it would
report pages which are offline because those have a valid pfn.  Their
migrate type is misleading at best.  Now that we have pfn_to_online_page()
we can use it instead of pfn_valid() and fix this.

Link: http://lkml.kernel.org/r/20170515085827.16474-11-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Joonsoo Kim <js1304@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo
+++ a/mm/vmstat.c
@@ -1223,11 +1223,9 @@ static void pagetypeinfo_showblockcount_
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		struct page *page;
 
-		if (!pfn_valid(pfn))
+		if (!pfn_to_online_page(pfn))
 			continue;
 
-		page = pfn_to_page(pfn);
