From: akpm@linux-foundation.org
Subject: [merged] sh-handle-pgtable_page_ctor-fail.patch removed from -mm
 tree
Date: Fri, 15 Nov 2013 12:08:30 -0800
Message-ID: <52867f3e.MEPy7P4MTMfBYS9X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KOUIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lethal@linux-sh.org, kirill.shutemov@linux.intel.com

Subject: [merged] sh-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,lethal@linux-sh.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:30 -0800


The patch titled
     Subject: sh: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     sh-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: sh: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/pgalloc.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/sh/include/asm/pgalloc.h~sh-handle-pgtable_page_ctor-fail arch/sh/include/asm/pgalloc.h
--- a/arch/sh/include/asm/pgalloc.h~sh-handle-pgtable_page_ctor-fail
+++ a/arch/sh/include/asm/pgalloc.h
@@ -47,7 +47,10 @@ static inline pgtable_t pte_alloc_one(st
 	if (!pg)
 		return NULL;
 	page = virt_to_page(pg);
-	pgtable_page_ctor(page);
+	if (!pgtable_page_ctor(page)) {
+		quicklist_free(QUICK_PT, NULL, pg);
+		return NULL;
+	}
 	return page;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

