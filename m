From: akpm@linux-foundation.org
Subject: [merged] powerpc-handle-pgtable_page_ctor-fail.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:08:24 -0800
Message-ID: <52867f38.5qtT9fo0S0MPEqLV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3KOUIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulus@samba.org, benh@kernel.crashing.org, kirill.shutemov@linux.intel.com

Subject: [merged] powerpc-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,benh@kernel.crashing.org,paulus@samba.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:24 -0800


The patch titled
     Subject: powerpc: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     powerpc-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: powerpc: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgalloc-64.h |    5 ++++-
 arch/powerpc/mm/pgtable_32.c          |    5 ++++-
 arch/powerpc/mm/pgtable_64.c          |    7 ++++---
 3 files changed, 12 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/include/asm/pgalloc-64.h~powerpc-handle-pgtable_page_ctor-fail arch/powerpc/include/asm/pgalloc-64.h
--- a/arch/powerpc/include/asm/pgalloc-64.h~powerpc-handle-pgtable_page_ctor-fail
+++ a/arch/powerpc/include/asm/pgalloc-64.h
@@ -91,7 +91,10 @@ static inline pgtable_t pte_alloc_one(st
 	if (!pte)
 		return NULL;
 	page = virt_to_page(pte);
-	pgtable_page_ctor(page);
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 	return page;
 }
 
diff -puN arch/powerpc/mm/pgtable_32.c~powerpc-handle-pgtable_page_ctor-fail arch/powerpc/mm/pgtable_32.c
--- a/arch/powerpc/mm/pgtable_32.c~powerpc-handle-pgtable_page_ctor-fail
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -121,7 +121,10 @@ pgtable_t pte_alloc_one(struct mm_struct
 	ptepage = alloc_pages(flags, 0);
 	if (!ptepage)
 		return NULL;
-	pgtable_page_ctor(ptepage);
+	if (!pgtable_page_ctor(ptepage)) {
+		__free_page(ptepage);
+		return NULL;
+	}
 	return ptepage;
 }
 
diff -puN arch/powerpc/mm/pgtable_64.c~powerpc-handle-pgtable_page_ctor-fail arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~powerpc-handle-pgtable_page_ctor-fail
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -378,6 +378,10 @@ static pte_t *__alloc_for_cache(struct m
 				       __GFP_REPEAT | __GFP_ZERO);
 	if (!page)
 		return NULL;
+	if (!kernel && !pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 
 	ret = page_address(page);
 	spin_lock(&mm->page_table_lock);
@@ -392,9 +396,6 @@ static pte_t *__alloc_for_cache(struct m
 	}
 	spin_unlock(&mm->page_table_lock);
 
-	if (!kernel)
-		pgtable_page_ctor(page);
