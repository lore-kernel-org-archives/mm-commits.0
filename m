From: akpm@linux-foundation.org
Subject: [merged] arm64-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:02 -0800
Message-ID: <52867f22.6Q4how4EWwPvYcFI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3KOUIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com, kirill.shutemov@linux.intel.com

Subject: [merged] arm64-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,catalin.marinas@arm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:02 -0800


The patch titled
     Subject: arm64: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     arm64-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: arm64: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgalloc.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/arm64/include/asm/pgalloc.h~arm64-handle-pgtable_page_ctor-fail arch/arm64/include/asm/pgalloc.h
--- a/arch/arm64/include/asm/pgalloc.h~arm64-handle-pgtable_page_ctor-fail
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -63,9 +63,12 @@ pte_alloc_one(struct mm_struct *mm, unsi
 	struct page *pte;
 
 	pte = alloc_pages(PGALLOC_GFP, 0);
-	if (pte)
-		pgtable_page_ctor(pte);
