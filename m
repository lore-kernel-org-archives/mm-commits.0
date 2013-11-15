From: akpm@linux-foundation.org
Subject: [merged] s390-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:26 -0800
Message-ID: <52867f3a.XqVefE+uE8fVtEse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3KOUI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com

Subject: [merged] s390-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,heiko.carstens@de.ibm.com,schwidefsky@de.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:26 -0800


The patch titled
     Subject: s390: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     s390-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: s390: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN arch/s390/mm/pgtable.c~s390-handle-pgtable_page_ctor-fail arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~s390-handle-pgtable_page_ctor-fail
+++ a/arch/s390/mm/pgtable.c
@@ -772,7 +772,11 @@ static inline unsigned long *page_table_
 		__free_page(page);
 		return NULL;
 	}
-	pgtable_page_ctor(page);
+	if (!pgtable_page_ctor(page)) {
+		kfree(mp);
+		__free_page(page);
+		return NULL;
+	}
 	mp->vmaddr = vmaddr & PMD_MASK;
 	INIT_LIST_HEAD(&mp->mapper);
 	page->index = (unsigned long) mp;
@@ -902,7 +906,10 @@ unsigned long *page_table_alloc(struct m
 		page = alloc_page(GFP_KERNEL|__GFP_REPEAT);
 		if (!page)
 			return NULL;
-		pgtable_page_ctor(page);
+		if (!pgtable_page_ctor(page)) {
+			__free_page(page);
+			return NULL;
+		}
 		atomic_set(&page->_mapcount, 1);
 		table = (unsigned long *) page_to_phys(page);
 		clear_table(table, _PAGE_INVALID, PAGE_SIZE);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

