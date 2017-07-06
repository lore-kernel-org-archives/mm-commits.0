From: akpm@linux-foundation.org
Subject: [patch 052/108] mm, vmstat: skip reporting offline pages
 in pagetypeinfo
Date: Thu, 06 Jul 2017 15:38:07 -0700
Message-ID: <20170706223807.HHzkO0xPR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbdGFWiW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmstat: skip reporting offline pages in pagetypeinfo

pagetypeinfo_showblockcount_print skips over invalid pfns but it would
report pages which are offline because those have a valid pfn.  Their
migrate type is misleading at best.  Now that we have pfn_to_online_page()
we can use it instead of pfn_valid() and fix this.

[mhocko@suse.com: fix build]
  Link: http://lkml.kernel.org/r/20170519072225.GA13041@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/20170515085827.16474-11-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Joonsoo Kim <js1304@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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

 mm/vmstat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo
+++ a/mm/vmstat.c
@@ -1223,11 +1223,10 @@ static void pagetypeinfo_showblockcount_
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		struct page *page;
 
-		if (!pfn_valid(pfn))
+		page = pfn_to_online_page(pfn);
+		if (!page)
 			continue;
 
-		page = pfn_to_page(pfn);
