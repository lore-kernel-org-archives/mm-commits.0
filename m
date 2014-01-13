From: akpm@linux-foundation.org
Subject: + mm-do_mincore-cleanup.patch added to -mm tree
Date: Mon, 13 Jan 2014 14:07:38 -0800
Message-ID: <52d463aa.crveZx1lXsc37b8O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaAMWHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 17:07:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com, n-horiguchi@ah.jp.nec.com, minchan.kim@gmail.com, hannes@cmpxchg.org, wujianguo@huawei.com

Subject: + mm-do_mincore-cleanup.patch added to -mm tree
To: wujianguo@huawei.com,hannes@cmpxchg.org,minchan.kim@gmail.com,n-horiguchi@ah.jp.nec.com,qiuxishi@huawei.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 14:07:38 -0800


The patch titled
     Subject: mm: do_mincore() cleanup
has been added to the -mm tree.  Its filename is
     mm-do_mincore-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do_mincore-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do_mincore-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm: do_mincore() cleanup

Two cleanups:
1. remove redundant codes for hugetlb pages.
2. end = pmd_addr_end(addr, end) restricts [addr, end) within PMD_SIZE,
   this may increase do_mincore() calls, remove it.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
