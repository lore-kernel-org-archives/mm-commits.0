From: akpm@linux-foundation.org
Subject: [merged] mm-thp-simplify-the-implementation-of-mk_huge_pmd.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:45:54 -0700
Message-ID: <57435df2.q+6iQk3jPRJ1eeXn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbcEWTpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:45:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: simplify the implementation of mk_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-thp-simplify-the-implementation-of-mk_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: mm: thp: simplify the implementation of mk_huge_pmd()

The implementation of mk_huge_pmd looks verbose, it could be just
simplified to one line code.

Signed-off-by: Yang Shi <yang.shi@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-simplify-the-implementation-of-mk_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-simplify-the-implementation-of-mk_huge_pmd
+++ a/mm/huge_memory.c
@@ -764,10 +764,7 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 
 static inline pmd_t mk_huge_pmd(struct page *page, pgprot_t prot)
 {
-	pmd_t entry;
-	entry = mk_pmd(page, prot);
-	entry = pmd_mkhuge(entry);
-	return entry;
+	return pmd_mkhuge(mk_pmd(page, prot));
 }
 
 static inline struct list_head *page_deferred_list(struct page *page)
_

Patches currently in -mm which might be from yang.shi@linaro.org are

mm-page_is_guard-return-false-when-page_ext-arrays-are-not-allocated-yet.patch
mm-move-page_ext_init-after-all-struct-pages-are-initialized-v2.patch

