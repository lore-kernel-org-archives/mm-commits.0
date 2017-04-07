From: akpm@linux-foundation.org
Subject: [patch 03/10] mm/page_alloc.c: fix print order in
 show_free_areas()
Date: Fri, 07 Apr 2017 16:04:45 -0700
Message-ID: <58e81b0d.lHGG47/rQWjQagzr%akpm__6436.96338306672$1491606293$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755242AbdDGXEq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 19:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, apolyakov@beget.ru, apolyakov@beget.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org, vbabka@suse.cz

From: Alexander Polakov <apolyakov@beget.ru>
Subject: mm/page_alloc.c: fix print order in show_free_areas()

Fixes: 11fb998986a72a ("mm: move most file-based accounting to the node")
Link: http://lkml.kernel.org/r/1490377730.30219.2.camel@beget.ru
Signed-off-by: Alexander Polyakov <apolyakov@beget.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~fix-print-order-in-show_free_areas mm/page_alloc.c
--- a/mm/page_alloc.c~fix-print-order-in-show_free_areas
+++ a/mm/page_alloc.c
@@ -4519,13 +4519,13 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_FILE_MAPPED)),
 			K(node_page_state(pgdat, NR_FILE_DIRTY)),
 			K(node_page_state(pgdat, NR_WRITEBACK)),
+			K(node_page_state(pgdat, NR_SHMEM)),
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			K(node_page_state(pgdat, NR_SHMEM_THPS) * HPAGE_PMD_NR),
 			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)
 					* HPAGE_PMD_NR),
 			K(node_page_state(pgdat, NR_ANON_THPS) * HPAGE_PMD_NR),
 #endif
-			K(node_page_state(pgdat, NR_SHMEM)),
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
 			node_page_state(pgdat, NR_PAGES_SCANNED),
_
