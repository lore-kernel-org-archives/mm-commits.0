From: akpm@linux-foundation.org
Subject: [patch 079/124] mm/memory_hotplug.c: fix overflow in
 test_pages_in_a_zone()
Date: Fri, 24 Feb 2017 14:59:30 -0800
Message-ID: <58b0bad2.atUjbqMpTAwF6Ux+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38744 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbdBXW7b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhongjiang@huawei.com, mgorman@techsingularity.net, toshi.kani@hpe.com, vbabka@suse.cz

From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/memory_hotplug.c: fix overflow in test_pages_in_a_zone()

When mainline introduced a96dfddbcc04 ("base/memory, hotplug: fix a kernel
oops in show_valid_zones()"), it obtained the valid start and end pfn from
the given pfn range.  The valid start pfn can fix the actual issue, but it
introduced another issue.  The valid end pfn will may exceed the given
end_pfn.

Although the incorrect overflow will not result in actual problem at
present, but I think it need to be fixed.

[toshi.kani@hpe.com: remove assumption that end_pfn is aligned by MAX_ORDER_NR_PAGES]
Fixes: a96dfddbcc04 ("base/memory, hotplug: fix a kernel oops in show_valid_zones()")
Link: http://lkml.kernel.org/r/1486467299-22648-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~mm-fix-a-overflow-in-test_pages_in_a_zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-a-overflow-in-test_pages_in_a_zone
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
@@ -1523,7 +1523,7 @@ int test_pages_in_a_zone(unsigned long s
 
 	if (zone) {
 		*valid_start = start;
-		*valid_end = end;
+		*valid_end = min(end, end_pfn);
 		return 1;
 	} else {
 		return 0;
_
