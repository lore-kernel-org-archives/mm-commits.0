From: akpm@linux-foundation.org
Subject: [merged] mm-update-the-description-for-vm_total_pages.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:37 -0700
Message-ID: <53e3dc11.u8tt3UsInSQNSlyw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46064 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaHGUFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:38 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so605869vcb.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update the description for vm_total_pages
has been removed from the -mm tree.  Its filename was
     mm-update-the-description-for-vm_total_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm: update the description for vm_total_pages

vm_total_pages is calculated by nr_free_pagecache_pages(), which counts
the number of pages which are beyond the high watermark within all zones. 
So vm_total_pages is not equal to total number of pages which the VM
controls.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-update-the-description-for-vm_total_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-update-the-description-for-vm_total_pages
+++ a/mm/vmscan.c
@@ -137,7 +137,11 @@ struct scan_control {
  * From 0 .. 100.  Higher means more swappy.
  */
 int vm_swappiness = 60;
-unsigned long vm_total_pages;	/* The total number of pages which the VM controls */
+/*
+ * The total number of pages which are beyond the high watermark within all
+ * zones.
+ */
+unsigned long vm_total_pages;
 
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
_

Patches currently in -mm which might be from shhuiw@gmail.com are

origin.patch

