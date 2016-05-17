From: akpm@linux-foundation.org
Subject: +
 mm-bad_page-checks-bad_flags-instead-of-page-flags-for-hwpoison-page.patch
 added to -mm tree
Date: Tue, 17 May 2016 16:17:33 -0700
Message-ID: <573ba68d.vbV+OQel5nhHfNO6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbcEQXRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2016 19:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bad_page() checks bad_flags instead of page->flags for hwpoison page
has been added to the -mm tree.  Its filename is
     mm-bad_page-checks-bad_flags-instead-of-page-flags-for-hwpoison-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bad_page-checks-bad_flags-instead-of-page-flags-for-hwpoison-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bad_page-checks-bad_flags-instead-of-page-flags-for-hwpoison-page.patch

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
Subject: mm: bad_page() checks bad_flags instead of page->flags for hwpoison page

There's a race window between checking page->flags and unpoisoning, which
taints kernel with "BUG: Bad page state".  That's overkill.  It's safer to
use bad_flags to detect hwpoisoned page.

Link: http://lkml.kernel.org/r/1463470975-29972-1-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-bad_page-checks-bad_flags-instead-of-page-flags-for-hwpoison-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-bad_page-checks-bad_flags-instead-of-page-flags-for-hwpoison-page
+++ a/mm/page_alloc.c
@@ -522,8 +522,8 @@ static void bad_page(struct page *page,
 	static unsigned long nr_shown;
 	static unsigned long nr_unshown;
 
-	/* Don't complain about poisoned pages */
-	if (PageHWPoison(page)) {
+	/* Don't complain about hwpoisoned pages */
+	if (bad_flags == __PG_HWPOISON) {
 		page_mapcount_reset(page); /* remove PageBuddy */
 		return;
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-bad_page-checks-bad_flags-instead-of-page-flags-for-hwpoison-page.patch

