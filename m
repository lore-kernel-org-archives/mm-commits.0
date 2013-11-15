From: akpm@linux-foundation.org
Subject: [merged] parisc-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:22 -0800
Message-ID: <52867f36.gPqddyTcgI865OUX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3KOUIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jejb@parisc-linux.org, deller@gmx.de, kirill.shutemov@linux.intel.com

Subject: [merged] parisc-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,deller@gmx.de,jejb@parisc-linux.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:22 -0800


The patch titled
     Subject: parisc: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     parisc-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: parisc: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/pgalloc.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/parisc/include/asm/pgalloc.h~parisc-handle-pgtable_page_ctor-fail arch/parisc/include/asm/pgalloc.h
--- a/arch/parisc/include/asm/pgalloc.h~parisc-handle-pgtable_page_ctor-fail
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -121,8 +121,12 @@ static inline pgtable_t
 pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	struct page *page = alloc_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-	if (page)
-		pgtable_page_ctor(page);
+	if (!page)
+		return NULL;
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 	return page;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

