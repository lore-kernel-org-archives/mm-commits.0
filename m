From: akpm@linux-foundation.org
Subject: [merged] mn10300-add-missing-pgtable_page_ctor-dtor-calls.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:07:52 -0800
Message-ID: <52867f18.d2toDt5vRoekpmPV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3KOUHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yasutake.koichi@jp.panasonic.com, dhowells@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] mn10300-add-missing-pgtable_page_ctor-dtor-calls.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,dhowells@redhat.com,yasutake.koichi@jp.panasonic.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:52 -0800


The patch titled
     Subject: mn10300: add missing pgtable_page_ctor/dtor calls
has been removed from the -mm tree.  Its filename was
     mn10300-add-missing-pgtable_page_ctor-dtor-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mn10300: add missing pgtable_page_ctor/dtor calls

It will fix NR_PAGETABLE accounting.  It's also required if the arch is
going ever support split ptl.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/pgalloc.h |    1 +
 arch/mn10300/mm/pgtable.c          |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/mn10300/include/asm/pgalloc.h~mn10300-add-missing-pgtable_page_ctor-dtor-calls arch/mn10300/include/asm/pgalloc.h
--- a/arch/mn10300/include/asm/pgalloc.h~mn10300-add-missing-pgtable_page_ctor-dtor-calls
+++ a/arch/mn10300/include/asm/pgalloc.h
@@ -46,6 +46,7 @@ static inline void pte_free_kernel(struc
 
 static inline void pte_free(struct mm_struct *mm, struct page *pte)
 {
+	pgtable_page_dtor(pte);
 	__free_page(pte);
 }
 
diff -puN arch/mn10300/mm/pgtable.c~mn10300-add-missing-pgtable_page_ctor-dtor-calls arch/mn10300/mm/pgtable.c
--- a/arch/mn10300/mm/pgtable.c~mn10300-add-missing-pgtable_page_ctor-dtor-calls
+++ a/arch/mn10300/mm/pgtable.c
@@ -78,8 +78,13 @@ struct page *pte_alloc_one(struct mm_str
 #else
 	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
 #endif
-	if (pte)
-		clear_highpage(pte);
+	if (!pte)
+		return NULL;
+	clear_highpage(pte);
+	if (!pgtable_page_ctor(pte)) {
+		__free_page(pte);
+		return NULL;
+	}
 	return pte;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

