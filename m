From: akpm@linux-foundation.org
Subject: +
 mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2.patch added to -mm tree
Date: Thu, 12 May 2016 13:54:13 -0700
Message-ID: <5734ed75.znrhFArPP3v1viIw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbcELUyO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2016 16:54:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2
has been added to the -mm tree.  Its filename is
     mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2

Link: http://lkml.kernel.org/r/1463070742-18401-1-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: "Kirill A. Shutemov" <kirill@shutemov.name>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2
+++ a/mm/huge_memory.c
@@ -3248,8 +3248,12 @@ int page_trans_huge_mapcount(struct page
 	/* hugetlbfs shouldn't call it */
 	VM_BUG_ON_PAGE(PageHuge(page), page);
 
-	if (likely(!PageTransCompound(page)))
-		return atomic_read(&page->_mapcount) + 1;
+	if (likely(!PageTransCompound(page))) {
+		mapcount = atomic_read(&page->_mapcount) + 1;
+		if (total_mapcount)
+			*total_mapcount = mapcount;
+		return mapcount;
+	}
 
 	page = compound_head(page);
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults.patch
mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix.patch
mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2.patch
mm-thp-microoptimize-compound_mapcount.patch
mm-thp-split_huge_pmd_address-comment-improvement.patch

