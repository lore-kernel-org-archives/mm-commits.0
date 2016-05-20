From: akpm@linux-foundation.org
Subject: [patch 022/162] mm: thp: simplify the implementation of
 mk_huge_pmd()
Date: Fri, 20 May 2016 16:57:30 -0700
Message-ID: <573fa46a.fE5wWFuK/Sq0AB8/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcETX5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yang.shi@linaro.org

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
