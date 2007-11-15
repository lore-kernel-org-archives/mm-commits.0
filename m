From: akpm@linux-foundation.org
Subject: + config_highpte-vs-sub-page-page-tables-fix-2.patch added to -mm tree
Date: Thu, 15 Nov 2007 15:17:16 -0800
Message-ID: <200711152317.lAFNHGof020988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756455AbXKOXR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 18:17:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, benh@kernel.crashing.org, schwidefsky@de.ibm.com


The patch titled
     parisc: balance parenthesis in pte_free_kernel()
has been added to the -mm tree.  Its filename is
     config_highpte-vs-sub-page-page-tables-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parisc: balance parenthesis in pte_free_kernel()
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Another parenthesis fix.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-parisc/pgalloc.h~config_highpte-vs-sub-page-page-tables-fix-2 include/asm-parisc/pgalloc.h
--- a/include/asm-parisc/pgalloc.h~config_highpte-vs-sub-page-page-tables-fix-2
+++ a/include/asm-parisc/pgalloc.h
@@ -141,7 +141,7 @@ static inline void pte_free_kernel(struc
 static inline void pte_free_kernel(struct mm_struct *mm, struct page *pte)
 {
 	pgtable_page_dtor(pte);
-	pte_free_kernel(page_address((pte));
+	pte_free_kernel(page_address(pte));
 }
 
 #define check_pgt_cache()	do { } while (0)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-mmc.patch
config_highpte-vs-sub-page-page-tables-fix-2.patch
reiser4.patch
