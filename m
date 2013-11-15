From: akpm@linux-foundation.org
Subject: [merged] xtensa-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:42 -0800
Message-ID: <52867f4a.sLXMLi4DepU/sR3j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KOUIm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jcmvbkbc@gmail.com, chris@zankel.net, kirill.shutemov@linux.intel.com

Subject: [merged] xtensa-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,chris@zankel.net,jcmvbkbc@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:42 -0800


The patch titled
     Subject: xtensa: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     xtensa-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: xtensa: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/pgalloc.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/xtensa/include/asm/pgalloc.h~xtensa-handle-pgtable_page_ctor-fail arch/xtensa/include/asm/pgalloc.h
--- a/arch/xtensa/include/asm/pgalloc.h~xtensa-handle-pgtable_page_ctor-fail
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -58,7 +58,10 @@ static inline pgtable_t pte_alloc_one(st
 	if (!pte)
 		return NULL;
 	page = virt_to_page(pte);
-	pgtable_page_ctor(page);
+	if (!pgtable_page_ctor(page)) {
+		kmem_cache_free(pgtable_cache, pte);
+		return NULL;
+	}
 	return page;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

