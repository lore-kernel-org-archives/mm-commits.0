From: akpm@linux-foundation.org
Subject: [folded-merged]
 mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch removed from
 -mm tree
Date: Wed, 11 Feb 2015 15:18:01 -0800
Message-ID: <54dbe329.RVniVsnOt22Sja6u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbbBKXSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, hannes@cmpxchg.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mincore: remove unneeded variable 'err'
has been removed from the -mm tree.  Its filename was
     mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch

This patch was dropped because it was folded into mincore-apply-page-table-walker-on-do_mincore.patch

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: mincore: remove unneeded variable 'err'

mincore_hugetlb() returns always '0'

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix-fix mm/mincore.c
--- a/mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix-fix
+++ a/mm/mincore.c
@@ -22,7 +22,6 @@
 static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
-	int err = 0;
 #ifdef CONFIG_HUGETLB_PAGE
 	unsigned char present;
 	unsigned char *vec = walk->private;
@@ -38,7 +37,7 @@ static int mincore_hugetlb(pte_t *pte, u
 #else
 	BUG();
 #endif
-	return err;
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

origin.patch
mincore-apply-page-table-walker-on-do_mincore.patch

