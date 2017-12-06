From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-walk-the-zone-in-pageblock_nr_pages-steps.patch removed from -mm tree
Date: Tue, 05 Dec 2017 17:41:57 -0800
Message-ID: <5a274ae5.sk5P4ASOB9NwhQb7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50388 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753798AbdLFBl7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 20:41:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: walk the zone in pageblock_nr_pages steps
has been removed from the -mm tree.  Its filename was
     mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/vmstat.c: walk the zone in pageblock_nr_pages steps

when walking the zone, we can happens to the holes. we should not
align MAX_ORDER_NR_PAGES, so it can skip the normal memory.

In addition, pagetypeinfo_showmixedcount_print reflect fragmentization.
we hope to get more accurate data. therefore, I decide to fix it.

Link: http://lkml.kernel.org/r/1469502526-24486-2-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_owner.c~mm-walk-the-zone-in-pageblock_nr_pages-steps mm/page_owner.c
--- a/mm/page_owner.c~mm-walk-the-zone-in-pageblock_nr_pages-steps
+++ a/mm/page_owner.c
@@ -274,7 +274,7 @@ void pagetypeinfo_showmixedcount_print(s
 	 */
 	for (; pfn < end_pfn; ) {
 		if (!pfn_valid(pfn)) {
-			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
+			pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 			continue;
 		}
 
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-page_owner-align-with-pageblock_nr_pages.patch
mm-page_owner-align-with-pageblock_nr-pages.patch

