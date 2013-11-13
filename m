From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:39:34 -0800
Message-ID: <5283e386.Uu+gNUIA+mWj+ZJb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3KMUjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wuzhy@linux.vnet.ibm.com

Subject: [merged] mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch removed from -mm tree
To: wuzhy@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:34 -0800


The patch titled
     Subject: arch/x86/mm/init.c: fix incorrect function name in alloc_low_pages()
has been removed from the -mm tree.  Its filename was
     mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: arch/x86/mm/init.c: fix incorrect function name in alloc_low_pages()

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/init.c~mm-fix-the-incorrect-function-name-in-alloc_low_pages arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~mm-fix-the-incorrect-function-name-in-alloc_low_pages
+++ a/arch/x86/mm/init.c
@@ -53,12 +53,12 @@ __ref void *alloc_low_pages(unsigned int
 	if ((pgt_buf_end + num) > pgt_buf_top || !can_use_brk_pgt) {
 		unsigned long ret;
 		if (min_pfn_mapped >= max_pfn_mapped)
-			panic("alloc_low_page: ran out of memory");
+			panic("alloc_low_pages: ran out of memory");
 		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
 					max_pfn_mapped << PAGE_SHIFT,
 					PAGE_SIZE * num , PAGE_SIZE);
 		if (!ret)
-			panic("alloc_low_page: can not alloc memory");
+			panic("alloc_low_pages: can not alloc memory");
 		memblock_reserve(ret, PAGE_SIZE * num);
 		pfn = ret >> PAGE_SHIFT;
 	} else {
_

Patches currently in -mm which might be from wuzhy@linux.vnet.ibm.com are

origin.patch
linux-next.patch

