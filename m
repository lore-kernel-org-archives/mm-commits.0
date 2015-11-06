From: akpm@linux-foundation.org
Subject: [merged]
 mm-skip-if-required_kernelcore-is-larger-than-totalpages.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:16:00 -0800
Message-ID: <563d0a80.cuEH83b9YXdY9lKG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966168AbbKFUQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, tangchen@cn.fujitsu.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: skip ZONE_MOVABLE if required_kernelcore is larger than totalpages
has been removed from the -mm tree.  Its filename was
     mm-skip-if-required_kernelcore-is-larger-than-totalpages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm/page_alloc.c: skip ZONE_MOVABLE if required_kernelcore is larger than totalpages

If kernelcore was not specified, or the kernelcore size is zero
(required_movablecore >= totalpages), or the kernelcore size is larger
than totalpages, there is no ZONE_MOVABLE.  We should fill the zone with
both kernel memory and movable memory.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-skip-if-required_kernelcore-is-larger-than-totalpages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-skip-if-required_kernelcore-is-larger-than-totalpages
+++ a/mm/page_alloc.c
@@ -5675,8 +5675,11 @@ static void __init find_zone_movable_pfn
 		required_kernelcore = max(required_kernelcore, corepages);
 	}
 
-	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
-	if (!required_kernelcore)
+	/*
+	 * If kernelcore was not specified or kernelcore size is larger
+	 * than totalpages, there is no ZONE_MOVABLE.
+	 */
+	if (!required_kernelcore || required_kernelcore >= totalpages)
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
_

Patches currently in -mm which might be from qiuxishi@huawei.com are


