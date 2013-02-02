From: akpm@linux-foundation.org
Subject: + mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch added to -mm tree
Date: Fri, 01 Feb 2013 16:39:52 -0800
Message-ID: <20130202003953.620EA31C1FA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:41586 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab3BBAjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 19:39:54 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so504170vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 16:39:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmesmon@gmail.com, catalin.marinas@arm.com, cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     Subject: mmzone: add pgdat_{end_pfn,is_empty}() helpers & consolidate.
has been added to the -mm tree.  Its filename is
     mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <jmesmon@gmail.com>
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

Patches currently in -mm which might be from jmesmon@gmail.com are

mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch
mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch
mm-add-helper-ensure_zone_is_initialized.patch

