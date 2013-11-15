From: akpm@linux-foundation.org
Subject: [merged] arm-handle-pgtable_page_ctor-fail.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:08:00 -0800
Message-ID: <52867f20.KL/Froe8BdDW3hS2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3KOUIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@arm.linux.org.uk, kirill.shutemov@linux.intel.com

Subject: [merged] arm-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,linux@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:00 -0800


The patch titled
     Subject: arm: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     arm-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: arm: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgalloc.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/arm/include/asm/pgalloc.h~arm-handle-pgtable_page_ctor-fail arch/arm/include/asm/pgalloc.h
--- a/arch/arm/include/asm/pgalloc.h~arm-handle-pgtable_page_ctor-fail
+++ a/arch/arm/include/asm/pgalloc.h
@@ -102,12 +102,14 @@ pte_alloc_one(struct mm_struct *mm, unsi
 #else
 	pte = alloc_pages(PGALLOC_GFP, 0);
 #endif
-	if (pte) {
-		if (!PageHighMem(pte))
-			clean_pte_table(page_address(pte));
-		pgtable_page_ctor(pte);
+	if (!pte)
+		return NULL;
+	if (!PageHighMem(pte))
+		clean_pte_table(page_address(pte));
+	if (!pgtable_page_ctor(pte)) {
+		__free_page(pte);
+		return NULL;
 	}
