From: akpm@linux-foundation.org
Subject: [merged] mips-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:20 -0800
Message-ID: <52867f34.59pEN1C/hnpUjfZ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3KOUIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, kirill.shutemov@linux.intel.com

Subject: [merged] mips-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:20 -0800


The patch titled
     Subject: mips: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     mips-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mips: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgalloc.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/mips/include/asm/pgalloc.h~mips-handle-pgtable_page_ctor-fail arch/mips/include/asm/pgalloc.h
--- a/arch/mips/include/asm/pgalloc.h~mips-handle-pgtable_page_ctor-fail
+++ a/arch/mips/include/asm/pgalloc.h
@@ -80,9 +80,12 @@ static inline struct page *pte_alloc_one
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

