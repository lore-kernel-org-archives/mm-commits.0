From: akpm@linux-foundation.org
Subject: - config_highpte-vs-sub-page-page-tables-avr32-fix.patch removed from -mm tree
Date: Fri, 01 Feb 2008 15:07:43 -0800
Message-ID: <200802012316.m11NGQ4U003690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761579AbYBAXQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 18:16:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bn@niasdigital.com, hskinnemoen@atmel.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix variable use in AVR32 pte_alloc_one
has been removed from the -mm tree.  Its filename was
     config_highpte-vs-sub-page-page-tables-avr32-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix variable use in AVR32 pte_alloc_one
From: Ben Nizette <bn@niasdigital.com>

Some parts of this function use 'page', some 'pte'.  As such, an AVR32 -mm
build fails with an undefined reference to 'page'.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-avr32/pgalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-avr32/pgalloc.h~config_highpte-vs-sub-page-page-tables-avr32-fix include/asm-avr32/pgalloc.h
--- a/include/asm-avr32/pgalloc.h~config_highpte-vs-sub-page-page-tables-avr32-fix
+++ a/include/asm-avr32/pgalloc.h
@@ -52,9 +52,9 @@ static inline struct page *pte_alloc_one
 	struct page *pte;
 
 	pte = alloc_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
-	if (!page)
+	if (!pte)
 		return NULL;
-	pgtable_page_ctor(page);
+	pgtable_page_ctor(pte);
 	return pte;
 }
 
_

Patches currently in -mm which might be from bn@niasdigital.com are

config_highpte-vs-sub-page-page-tables-avr32-fix.patch
