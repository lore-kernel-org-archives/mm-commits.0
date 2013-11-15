From: akpm@linux-foundation.org
Subject: [merged] score-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:28 -0800
Message-ID: <52867f3c.fm0ixxEIefhcbEnp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3KOUI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liqin.chen@sunplusct.com, lennox.wu@gmail.com, kirill.shutemov@linux.intel.com

Subject: [merged] score-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,lennox.wu@gmail.com,liqin.chen@sunplusct.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:28 -0800


The patch titled
     Subject: score: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     score-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: score: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/include/asm/pgalloc.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/score/include/asm/pgalloc.h~score-handle-pgtable_page_ctor-fail arch/score/include/asm/pgalloc.h
--- a/arch/score/include/asm/pgalloc.h~score-handle-pgtable_page_ctor-fail
+++ a/arch/score/include/asm/pgalloc.h
@@ -54,9 +54,12 @@ static inline struct page *pte_alloc_one
 	struct page *pte;
 
 	pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
-	if (pte) {
-		clear_highpage(pte);
-		pgtable_page_ctor(pte);
+	if (!pte)
+		return NULL;
+	clear_highpage(pte);
+	if (!pgtable_page_ctor(pte)) {
+		__free_page(pte);
+		return NULL;
 	}
 	return pte;
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

