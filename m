From: akpm@linux-foundation.org
Subject: [merged] alpha-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:07:56 -0800
Message-ID: <52867f1c.qqJWySg9iWOxwlNH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3KOUH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rth@twiddle.net, mattst88@gmail.com, ink@jurassic.park.msu.ru, kirill.shutemov@linux.intel.com

Subject: [merged] alpha-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,ink@jurassic.park.msu.ru,mattst88@gmail.com,rth@twiddle.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:56 -0800


The patch titled
     Subject: alpha: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     alpha-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: alpha: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgalloc.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/alpha/include/asm/pgalloc.h~alpha-handle-pgtable_page_ctor-fail arch/alpha/include/asm/pgalloc.h
--- a/arch/alpha/include/asm/pgalloc.h~alpha-handle-pgtable_page_ctor-fail
+++ a/arch/alpha/include/asm/pgalloc.h
@@ -72,7 +72,10 @@ pte_alloc_one(struct mm_struct *mm, unsi
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
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

