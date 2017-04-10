From: akpm@linux-foundation.org
Subject: [merged] fix-print-order-in-show_free_areas.patch removed from
 -mm tree
Date: Mon, 10 Apr 2017 11:50:50 -0700
Message-ID: <58ebd40a.ds1nM7lVwPT5rko/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752662AbdDJSuv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 14:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apolyakov@beget.ru, apolyakov@beget.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix print order in show_free_areas()
has been removed from the -mm tree.  Its filename was
     fix-print-order-in-show_free_areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from apolyakov@beget.ru are


