From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-a-overflow-in-test_pages_in_a_zone-fix.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:42:49 -0800
Message-ID: <58b0b6e9.wte+3m/updtQFjZu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWmv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:42:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, mgorman@techsingularity.net, vbabka@suse.cz, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-a-overflow-in-test_pages_in_a_zone-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-a-overflow-in-test_pages_in_a_zone-fix.patch

This patch was dropped because it was folded into mm-fix-a-overflow-in-test_pages_in_a_zone.patch

------------------------------------------------------
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: mm-fix-a-overflow-in-test_pages_in_a_zone-fix

remove assumption that end_pfn is aligned by MAX_ORDER_NR_PAGES

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-fix-a-overflow-in-test_pages_in_a_zone-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-a-overflow-in-test_pages_in_a_zone-fix
+++ a/mm/memory_hotplug.c
@@ -1509,7 +1509,7 @@ int test_pages_in_a_zone(unsigned long s
 			while ((i < MAX_ORDER_NR_PAGES) &&
 				!pfn_valid_within(pfn + i))
 				i++;
-			if (i == MAX_ORDER_NR_PAGES)
+			if (i == MAX_ORDER_NR_PAGES || pfn + i >= end_pfn)
 				continue;
 			page = pfn_to_page(pfn + i);
 			if (zone && page_zone(page) != zone)
_

Patches currently in -mm which might be from toshi.kani@hpe.com are

mm-fix-a-overflow-in-test_pages_in_a_zone.patch

