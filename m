From: akpm@linux-foundation.org
Subject: [merged] hexagon-handle-pgtable_page_ctor-fail.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:08:10 -0800
Message-ID: <52867f2a.M8fuQA0bcdsD8ZHk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3KOUIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rkuo@codeaurora.org, kirill.shutemov@linux.intel.com

Subject: [merged] hexagon-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,rkuo@codeaurora.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:10 -0800


The patch titled
     Subject: hexagon: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     hexagon-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: hexagon: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/pgalloc.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/hexagon/include/asm/pgalloc.h~hexagon-handle-pgtable_page_ctor-fail arch/hexagon/include/asm/pgalloc.h
--- a/arch/hexagon/include/asm/pgalloc.h~hexagon-handle-pgtable_page_ctor-fail
+++ a/arch/hexagon/include/asm/pgalloc.h
@@ -65,10 +65,12 @@ static inline struct page *pte_alloc_one
 	struct page *pte;
 
 	pte = alloc_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
-
-	if (pte)
-		pgtable_page_ctor(pte);
