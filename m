From: akpm@linux-foundation.org
Subject: + mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch
 added to -mm tree
Date: Mon, 12 Aug 2013 12:41:35 -0700
Message-ID: <52093a6f.6a2FiGcGW2AgNyS/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab3HLTlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Aug 2013 15:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cody@linux.vnet.ibm.com, qiuxishi@huawei.com

Subject: + mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch added to -mm tree
To: qiuxishi@huawei.com,cody@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 12 Aug 2013 12:41:35 -0700


The patch titled
     Subject: mm: use zone_is_empty() instead of if(zone->spanned_pages)
has been added to the -mm tree.  Its filename is
     mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: use zone_is_empty() instead of if(zone->spanned_pages)

Use "zone_is_empty()" instead of "if (zone->spanned_pages)".
Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++---
 mm/page_alloc.c     |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-use-zone_is_empty-instead-of-ifzone-spanned_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-use-zone_is_empty-instead-of-ifzone-spanned_pages
+++ a/mm/memory_hotplug.c
@@ -230,7 +230,7 @@ static void grow_zone_span(struct zone *
 	zone_span_writelock(zone);
 
 	old_zone_end_pfn = zone_end_pfn(zone);
-	if (!zone->spanned_pages || start_pfn < zone->zone_start_pfn)
+	if (zone_is_empty(zone) || start_pfn < zone->zone_start_pfn)
 		zone->zone_start_pfn = start_pfn;
 
 	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
@@ -305,7 +305,7 @@ static int __meminit move_pfn_range_left
 		goto out_fail;
 
 	/* use start_pfn for z1's start_pfn if z1 is empty */
-	if (z1->spanned_pages)
+	if (!zone_is_empty(z1))
 		z1_start_pfn = z1->zone_start_pfn;
 	else
 		z1_start_pfn = start_pfn;
@@ -347,7 +347,7 @@ static int __meminit move_pfn_range_righ
 		goto out_fail;
 
 	/* use end_pfn for z2's end_pfn if z2 is empty */
-	if (z2->spanned_pages)
+	if (!zone_is_empty(z2))
 		z2_end_pfn = zone_end_pfn(z2);
 	else
 		z2_end_pfn = end_pfn;
diff -puN mm/page_alloc.c~mm-use-zone_is_empty-instead-of-ifzone-spanned_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-zone_is_empty-instead-of-ifzone-spanned_pages
+++ a/mm/page_alloc.c
@@ -1306,7 +1306,7 @@ void mark_free_pages(struct zone *zone)
 	int order, t;
 	struct list_head *curr;
 
-	if (!zone->spanned_pages)
+	if (zone_is_empty(zone))
 		return;
 
 	spin_lock_irqsave(&zone->lock, flags);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch
mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch
kexec-remove-unnecessary-return.patch

