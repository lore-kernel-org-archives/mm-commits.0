From: akpm@linux-foundation.org
Subject: + mm-thp-simplify-the-implementation-of-mk_huge_pmd.patch added
 to -mm tree
Date: Thu, 21 Apr 2016 16:38:32 -0700
Message-ID: <57196478.WmB18OWN+1azB/RE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbcDUXid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 19:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: simplify the implementation of mk_huge_pmd()
has been added to the -mm tree.  Its filename is
     mm-thp-simplify-the-implementation-of-mk_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-simplify-the-implementation-of-mk_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-simplify-the-implementation-of-mk_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: mm: thp: simplify the implementation of mk_huge_pmd()

The implementation of mk_huge_pmd looks verbose, it could be just simplified
to one line code.

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

mm-thp-correct-split_huge_pages-file-permission.patch
mm-thp-simplify-the-implementation-of-mk_huge_pmd.patch

