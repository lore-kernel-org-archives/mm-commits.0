From: akpm@linux-foundation.org
Subject: + mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch
 added to -mm tree
Date: Mon, 04 Nov 2013 13:41:55 -0800
Message-ID: <527814a3.TipM8Nct8u6INA64%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3KDVl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 16:41:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wuzhy@linux.vnet.ibm.com

Subject: + mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch added to -mm tree
To: wuzhy@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 13:41:55 -0800


The patch titled
     Subject: arch/x86/mm/init.c: fix incorrect function name in alloc_low_pages()
has been added to the -mm tree.  Its filename is
     mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch
mm-fix-the-comment-in-zlc_setup.patch
linux-next.patch

