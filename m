From: akpm@linux-foundation.org
Subject: [patch 051/108] mm: __first_valid_page skip over offline
 pages
Date: Thu, 06 Jul 2017 15:38:04 -0700
Message-ID: <20170706223804.OkkeihHFg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752784AbdGFWiV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm: __first_valid_page skip over offline pages

__first_valid_page skips over invalid pfns in the range but it might still
stumble over offline pages.  At least start_isolate_page_range will mark
those set_migratetype_isolate.  This doesn't represent any immediate
AFAICS because alloc_contig_range will fail to isolate those pages but it
relies on not fully initialized page which will become a problem later
when we stop associating offline pages to zones.  Use pfn_to_online_page
to handle this.

This is more a preparatory patch than a fix.

Link: http://lkml.kernel.org/r/20170515085827.16474-10-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
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
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff -puN mm/page_isolation.c~mm-__first_valid_page-skip-over-offline-pages mm/page_isolation.c
--- a/mm/page_isolation.c~mm-__first_valid_page-skip-over-offline-pages
+++ a/mm/page_isolation.c
@@ -138,12 +138,18 @@ static inline struct page *
 __first_valid_page(unsigned long pfn, unsigned long nr_pages)
 {
 	int i;
-	for (i = 0; i < nr_pages; i++)
-		if (pfn_valid_within(pfn + i))
-			break;
-	if (unlikely(i == nr_pages))
-		return NULL;
-	return pfn_to_page(pfn + i);
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page;
+
+		if (!pfn_valid_within(pfn + i))
+			continue;
+		page = pfn_to_online_page(pfn + i);
+		if (!page)
+			continue;
+		return page;
+	}
+	return NULL;
 }
 
 /*
@@ -184,8 +190,12 @@ int start_isolate_page_range(unsigned lo
 undo:
 	for (pfn = start_pfn;
 	     pfn < undo_pfn;
-	     pfn += pageblock_nr_pages)
-		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
+	     pfn += pageblock_nr_pages) {
+		struct page *page = pfn_to_online_page(pfn);
+		if (!page)
+			continue;
+		unset_migratetype_isolate(page, migratetype);
+	}
 
 	return -EBUSY;
 }
_
