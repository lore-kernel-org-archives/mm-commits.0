From: akpm@linux-foundation.org
Subject: [merged]
 microblaze-add-missing-pgtable_page_ctor-dtor-calls.patch removed from -mm
 tree
Date: Fri, 15 Nov 2013 12:07:50 -0800
Message-ID: <52867f16.TLqT4hu4X2cT21Af%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3KOUHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, monstr@monstr.eu, kirill.shutemov@linux.intel.com

Subject: [merged] microblaze-add-missing-pgtable_page_ctor-dtor-calls.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,monstr@monstr.eu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:50 -0800


The patch titled
     Subject: microblaze: add missing pgtable_page_ctor/dtor calls
has been removed from the -mm tree.  Its filename was
     microblaze-add-missing-pgtable_page_ctor-dtor-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: microblaze: add missing pgtable_page_ctor/dtor calls

It will fix NR_PAGETABLE accounting.  It's also required if the arch is
going ever support split ptl.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/pgalloc.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN arch/microblaze/include/asm/pgalloc.h~microblaze-add-missing-pgtable_page_ctor-dtor-calls arch/microblaze/include/asm/pgalloc.h
--- a/arch/microblaze/include/asm/pgalloc.h~microblaze-add-missing-pgtable_page_ctor-dtor-calls
+++ a/arch/microblaze/include/asm/pgalloc.h
@@ -122,8 +122,13 @@ static inline struct page *pte_alloc_one
 #endif
 
 	ptepage = alloc_pages(flags, 0);
-	if (ptepage)
-		clear_highpage(ptepage);
+	if (!ptepage)
+		return NULL;
+	clear_highpage(ptepage);
+	if (!pgtable_page_ctor(ptepage)) {
+		__free_page(ptepage);
+		return NULL;
+	}
 	return ptepage;
 }
 
@@ -158,8 +163,9 @@ extern inline void pte_free_slow(struct
 	__free_page(ptepage);
 }
 
-extern inline void pte_free(struct mm_struct *mm, struct page *ptepage)
+static inline void pte_free(struct mm_struct *mm, struct page *ptepage)
 {
+	pgtable_page_dtor(ptepage);
 	__free_page(ptepage);
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

