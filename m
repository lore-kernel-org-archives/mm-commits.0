From: akpm@linux-foundation.org
Subject: + mm-thp-use-list_first_entry_or_null.patch added to -mm tree
Date: Wed, 18 Nov 2015 14:03:23 -0800
Message-ID: <564cf5ab.O5t9OxkV+Zi/BZct%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbbKRWDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Nov 2015 17:03:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: use list_first_entry_or_null()
has been added to the -mm tree.  Its filename is
     mm-thp-use-list_first_entry_or_null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-use-list_first_entry_or_null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-use-list_first_entry_or_null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm, thp: use list_first_entry_or_null()

Simplify the code with list_first_entry_or_null().

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/pgtable-generic.c~mm-thp-use-list_first_entry_or_null mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-thp-use-list_first_entry_or_null
+++ a/mm/pgtable-generic.c
@@ -176,13 +176,10 @@ pgtable_t pgtable_trans_huge_withdraw(st
 
 	/* FIFO */
 	pgtable = pmd_huge_pte(mm, pmdp);
-	if (list_empty(&pgtable->lru))
-		pmd_huge_pte(mm, pmdp) = NULL;
-	else {
-		pmd_huge_pte(mm, pmdp) = list_entry(pgtable->lru.next,
-					      struct page, lru);
+	pmd_huge_pte(mm, pmdp) = list_first_entry_or_null(&pgtable->lru,
+							  struct page, lru);
+	if (pmd_huge_pte(mm, pmdp))
 		list_del(&pgtable->lru);
-	}
 	return pgtable;
 }
 #endif
_

Patches currently in -mm which might be from geliangtang@163.com are

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch

