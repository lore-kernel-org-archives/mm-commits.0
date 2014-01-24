From: akpm@linux-foundation.org
Subject: [merged] mm-do_mincore-cleanup.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:13 -0800
Message-ID: <52e2b801.cmQ8agwKDwPznRDP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com, n-horiguchi@ah.jp.nec.com, minchan.kim@gmail.com, hannes@cmpxchg.org, wujianguo@huawei.com

Subject: [merged] mm-do_mincore-cleanup.patch removed from -mm tree
To: wujianguo@huawei.com,hannes@cmpxchg.org,minchan.kim@gmail.com,n-horiguchi@ah.jp.nec.com,qiuxishi@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:13 -0800


The patch titled
     Subject: mm: do_mincore() cleanup
has been removed from the -mm tree.  Its filename was
     mm-do_mincore-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm: do_mincore() cleanup

Two cleanups:
1. remove redundant codes for hugetlb pages.
2. end = pmd_addr_end(addr, end) restricts [addr, end) within PMD_SIZE,
   this may increase do_mincore() calls, remove it.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: qiuxishi <qiuxishi@huawei.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/mincore.c~mm-do_mincore-cleanup mm/mincore.c
--- a/mm/mincore.c~mm-do_mincore-cleanup
+++ a/mm/mincore.c
@@ -225,13 +225,6 @@ static long do_mincore(unsigned long add
 
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 
-	if (is_vm_hugetlb_page(vma)) {
-		mincore_hugetlb_page_range(vma, addr, end, vec);
-		return (end - addr) >> PAGE_SHIFT;
-	}
-
-	end = pmd_addr_end(addr, end);
