From: akpm@linux-foundation.org
Subject: [merged] mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:38 -0800
Message-ID: <20130225205438.C358631C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:42055 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3BYUyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:39 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so347938ggi.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mmzone: add pgdat_{end_pfn,is_empty}() helpers & consolidate.
has been removed from the -mm tree.  Its filename was
     mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mmzone: add pgdat_{end_pfn,is_empty}() helpers & consolidate.

Add pgdat_end_pfn() and pgdat_is_empty() helpers which match the similar
zone_*() functions.

Change node_end_pfn() to be a wrapper of pgdat_end_pfn().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN include/linux/mmzone.h~mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate include/linux/mmzone.h
--- a/include/linux/mmzone.h~mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate
+++ a/include/linux/mmzone.h
@@ -756,11 +756,17 @@ typedef struct pglist_data {
 #define nid_page_nr(nid, pagenr) 	pgdat_page_nr(NODE_DATA(nid),(pagenr))
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
+#define node_end_pfn(nid) pgdat_end_pfn(NODE_DATA(nid))
 
-#define node_end_pfn(nid) ({\
-	pg_data_t *__pgdat = NODE_DATA(nid);\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;\
-})
+static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
+{
+	return pgdat->node_start_pfn + pgdat->node_spanned_pages;
+}
+
+static inline bool pgdat_is_empty(pg_data_t *pgdat)
+{
+	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
+}
 
 #include <linux/memory_hotplug.h>
 
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch

