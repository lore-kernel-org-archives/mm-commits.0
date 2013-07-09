From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:19:33 -0700
Message-ID: <51dc9a85.f8DG2cNswuRX4DsO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3GIXTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, hannes@cmpxchg.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,hannes@cmpxchg.org,mel@csn.ul.ie,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:33 -0700


The patch titled
     Subject: mm/vmalloc.c: remove unused purge_fragmented_blocks_thiscpu
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/vmalloc.c: remove unused purge_fragmented_blocks_thiscpu

This function is nowhere used now, so remove it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu
+++ a/mm/vmalloc.c
@@ -891,11 +891,6 @@ static void purge_fragmented_blocks(int
 	}
 }
 
-static void purge_fragmented_blocks_thiscpu(void)
-{
-	purge_fragmented_blocks(smp_processor_id());
-}
