From: akpm@linux-foundation.org
Subject: +
 mm-check_new_page_bad-directly-returns-in-__pg_hwpoison-case.patch added to -mm tree
Date: Wed, 18 May 2016 13:19:42 -0700
Message-ID: <573cce5e.UUNnWc3LTRF/tzk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbcERUTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2016 16:19:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check_new_page_bad() directly returns in __PG_HWPOISON case
has been added to the -mm tree.  Its filename is
     mm-check_new_page_bad-directly-returns-in-__pg_hwpoison-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-check_new_page_bad-directly-returns-in-__pg_hwpoison-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-check_new_page_bad-directly-returns-in-__pg_hwpoison-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: check_new_page_bad() directly returns in __PG_HWPOISON case

Currently we check page->flags twice for "HWPoisoned" case of
check_new_page_bad(), which can cause a race with unpoisoning.
This race unnecessarily taints kernel with "BUG: Bad page state".
check_new_page_bad() is the only caller of bad_page() which is interested
in __PG_HWPOISON, so let's move the hwpoison related code in bad_page()
to it.

Link: http://lkml.kernel.org/r/20160518100949.GA17299@hori1.linux.bs1.fc.nec.co.jp
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-check_new_page_bad-directly-returns-in-__pg_hwpoison-case mm/page_alloc.c
--- a/mm/page_alloc.c~mm-check_new_page_bad-directly-returns-in-__pg_hwpoison-case
+++ a/mm/page_alloc.c
@@ -522,12 +522,6 @@ static void bad_page(struct page *page,
 	static unsigned long nr_shown;
 	static unsigned long nr_unshown;
 
-	/* Don't complain about poisoned pages */
-	if (PageHWPoison(page)) {
-		page_mapcount_reset(page); /* remove PageBuddy */
-		return;
-	}
