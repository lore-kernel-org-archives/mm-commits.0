From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-overflow-in-find_zone_movable_pfns_for_nodes.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 12:08:47 -0800
Message-ID: <563d08cf.atL1JFY/pdnIZtgW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033333AbbKFUIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, tangchen@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix overflow in find_zone_movable_pfns_for_nodes()
has been removed from the -mm tree.  Its filename was
     mm-fix-overflow-in-find_zone_movable_pfns_for_nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: fix overflow in find_zone_movable_pfns_for_nodes()

If the user set "movablecore=xx" to a large number, corepages will
overflow.  Fix the problem.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Tang Chen <tangchen@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-fix-overflow-in-find_zone_movable_pfns_for_nodes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-overflow-in-find_zone_movable_pfns_for_nodes
+++ a/mm/page_alloc.c
@@ -5666,6 +5666,7 @@ static void __init find_zone_movable_pfn
 		 */
 		required_movablecore =
 			roundup(required_movablecore, MAX_ORDER_NR_PAGES);
+		required_movablecore = min(totalpages, required_movablecore);
 		corepages = totalpages - required_movablecore;
 
 		required_kernelcore = max(required_kernelcore, corepages);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-skip-if-required_kernelcore-is-larger-than-totalpages.patch
kasan-use-is_aligned-in-memory_is_poisoned_8.patch

