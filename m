From: akpm@linux-foundation.org
Subject: + thp-increase-split_huge_page-success-rate-fix.patch added to
 -mm tree
Date: Tue, 29 Dec 2015 13:05:57 -0800
Message-ID: <5682f5b5.bET7Dfp7ZwsNaDyc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbbL2VF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 16:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-increase-split_huge_page-success-rate-fix
has been added to the -mm tree.  Its filename is
     thp-increase-split_huge_page-success-rate-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-increase-split_huge_page-success-rate-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-increase-split_huge_page-success-rate-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: thp-increase-split_huge_page-success-rate-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-increase-split_huge_page-success-rate-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-increase-split_huge_page-success-rate-fix
+++ a/mm/huge_memory.c
@@ -3260,6 +3260,7 @@ int split_huge_page_to_list(struct page
 	struct page *head = compound_head(page);
 	struct anon_vma *anon_vma;
 	int count, mapcount, ret;
+	bool mlocked;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(page), page);
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
@@ -3290,11 +3291,13 @@ int split_huge_page_to_list(struct page
 		goto out_unlock;
 	}
 
+	mlocked = PageMlocked(page);
 	freeze_page(anon_vma, head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
 	/* Make sure the page is not on per-CPU pagevec as it takes pin */
-	lru_add_drain();
+	if (mlocked)
+		lru_add_drain();
 
 	/* Prevent deferred_split_scan() touching ->_count */
 	spin_lock(&split_queue_lock);
_

Patches currently in -mm which might be from kirill@shutemov.name are

futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch
thp-reintroduce-split_huge_page-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch
thp-increase-split_huge_page-success-rate-fix.patch
mm-add-page_check_address_transhuge-helper-fix-fix.patch

