From: akpm@linux-foundation.org
Subject: + config_highpte-vs-sub-page-page-tables-avr32-fix.patch added to -mm tree
Date: Wed, 23 Jan 2008 23:58:51 -0800
Message-ID: <200801240758.m0O7wiIG016912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948AbYAXH7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jan 2008 02:59:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bn@niasdigital.com, hskinnemoen@atmel.com, schwidefsky@de.ibm.com


The patch titled
     fix variable use in AVR32 pte_alloc_one
has been added to the -mm tree.  Its filename is
     config_highpte-vs-sub-page-page-tables-avr32-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
