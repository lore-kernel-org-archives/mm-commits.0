From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2.patch removed from -mm tree
Date: Thu, 12 May 2016 15:18:40 -0700
Message-ID: <57350140.FG45VtT23anxY/Kl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbcELWSm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2016 18:18:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2
has been removed from the -mm tree.  Its filename was
     mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2.patch

This patch was dropped because it was folded into mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults.patch

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
mm-thp-microoptimize-compound_mapcount.patch
mm-thp-split_huge_pmd_address-comment-improvement.patch

