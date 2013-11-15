From: akpm@linux-foundation.org
Subject: [merged] m32r-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:14 -0800
Message-ID: <52867f2e.xrz5WS4A503/eZ9v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3KOUIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, takata@linux-m32r.org, kirill.shutemov@linux.intel.com

Subject: [merged] m32r-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,takata@linux-m32r.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:14 -0800


The patch titled
     Subject: m32r: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     m32r-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: m32r: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/pgalloc.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/m32r/include/asm/pgalloc.h~m32r-handle-pgtable_page_ctor-fail arch/m32r/include/asm/pgalloc.h
--- a/arch/m32r/include/asm/pgalloc.h~m32r-handle-pgtable_page_ctor-fail
+++ a/arch/m32r/include/asm/pgalloc.h
@@ -45,7 +45,10 @@ static __inline__ pgtable_t pte_alloc_on
 
 	if (!pte)
 		return NULL;
-	pgtable_page_ctor(pte);
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

