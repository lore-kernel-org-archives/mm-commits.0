From: akpm@linux-foundation.org
Subject: [merged] cris-fix-potential-null-pointer-dereference.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:07:42 -0800
Message-ID: <52867f0e.ssZ+/gyvqPMnoQdV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3KOUHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, jesper.nilsson@axis.com, kirill.shutemov@linux.intel.com

Subject: [merged] cris-fix-potential-null-pointer-dereference.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,jesper.nilsson@axis.com,starvik@axis.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:42 -0800


The patch titled
     Subject: cris: fix potential NULL-pointer dereference
has been removed from the -mm tree.  Its filename was
     cris-fix-potential-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: cris: fix potential NULL-pointer dereference

Add missing check for memory allocation fail.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mikael Starvik <starvik@axis.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/pgalloc.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/cris/include/asm/pgalloc.h~cris-fix-potential-null-pointer-dereference arch/cris/include/asm/pgalloc.h
--- a/arch/cris/include/asm/pgalloc.h~cris-fix-potential-null-pointer-dereference
+++ a/arch/cris/include/asm/pgalloc.h
@@ -32,6 +32,8 @@ static inline pgtable_t pte_alloc_one(st
 {
 	struct page *pte;
 	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+	if (!pte)
+		return NULL;
 	pgtable_page_ctor(pte);
 	return pte;
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

