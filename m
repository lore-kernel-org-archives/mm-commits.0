From: akpm@linux-foundation.org
Subject: + mm-exclude-hugetlb-pages-from-thp-page_mapped-logic.patch added to -mm tree
Date: Thu, 31 Mar 2016 16:07:47 -0700
Message-ID: <56fdadc3.XaV9ayk7qniiceII%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbcCaXHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 19:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.capper@arm.com, catalin.marinas@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mingo@kernel.org, stable@vger.kernel.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: exclude HugeTLB pages from THP page_mapped() logic
has been added to the -mm tree.  Its filename is
     mm-exclude-hugetlb-pages-from-thp-page_mapped-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-exclude-hugetlb-pages-from-thp-page_mapped-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-exclude-hugetlb-pages-from-thp-page_mapped-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steve Capper <steve.capper@arm.com>
Subject: mm: exclude HugeTLB pages from THP page_mapped() logic

HugeTLB pages cannot be split, so we use the compound_mapcount to track
rmaps.

Currently page_mapped() will check the compound_mapcount, but will also go
through the constituent pages of a THP compound page and query the
individual _mapcount's too.

Unfortunately, page_mapped() does not distinguish between HugeTLB and THP
compound pages and assumes that a compound page always needs to have
HPAGE_PMD_NR pages querying.

For most cases when dealing with HugeTLB this is just inefficient, but for
scenarios where the HugeTLB page size is less than the pmd block size
(e.g.  when using contiguous bit on ARM) this can lead to crashes.

This patch adjusts the page_mapped function such that we skip the
unnecessary THP reference checks for HugeTLB pages.

Fixes: e1534ae95004 ("mm: differentiate page_mapped() from page_mapcount() for compound pages")
Signed-off-by: Steve Capper <steve.capper@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>	[4.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mm.h~mm-exclude-hugetlb-pages-from-thp-page_mapped-logic include/linux/mm.h
--- a/include/linux/mm.h~mm-exclude-hugetlb-pages-from-thp-page_mapped-logic
+++ a/include/linux/mm.h
@@ -1031,6 +1031,8 @@ static inline bool page_mapped(struct pa
 	page = compound_head(page);
 	if (atomic_read(compound_mapcount_ptr(page)) >= 0)
 		return true;
+	if (PageHuge(page))
+		return false;
 	for (i = 0; i < hpage_nr_pages(page); i++) {
 		if (atomic_read(&page[i]._mapcount) >= 0)
 			return true;
_

Patches currently in -mm which might be from steve.capper@arm.com are

mm-exclude-hugetlb-pages-from-thp-page_mapped-logic.patch

