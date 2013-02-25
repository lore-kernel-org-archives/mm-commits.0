From: akpm@linux-foundation.org
Subject: [merged] mm-add-zone_is_empty-and-zone_is_initialized.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:32 -0800
Message-ID: <20130225205432.A83665A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:43473 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3BYUye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:34 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so347397ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add zone_is_empty() and zone_is_initialized()
has been removed from the -mm tree.  Its filename was
     mm-add-zone_is_empty-and-zone_is_initialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm: add zone_is_empty() and zone_is_initialized()

Factoring out these 2 checks makes it more clear what we are actually
checking for.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/mmzone.h~mm-add-zone_is_empty-and-zone_is_initialized include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-zone_is_empty-and-zone_is_initialized
+++ a/include/linux/mmzone.h
@@ -537,6 +537,16 @@ static inline bool zone_spans_pfn(const 
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
+static inline bool zone_is_initialized(struct zone *zone)
+{
+	return !!zone->wait_table;
+}
+
+static inline bool zone_is_empty(struct zone *zone)
+{
+	return zone->spanned_pages == 0;
+}
+
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
  * go. A value of 12 for DEF_PRIORITY implies that we will scan 1/4096th of the
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch

