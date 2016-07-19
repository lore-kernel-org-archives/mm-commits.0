From: akpm@linux-foundation.org
Subject: + mm-page_owner-align-with-pageblock_nr-pages.patch added to -mm
 tree
Date: Tue, 19 Jul 2016 12:08:30 -0700
Message-ID: <578e7aae.YqKq+z5DSrpTUvhb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbcGSTIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 15:08:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: align with pageblock_nr pages
has been added to the -mm tree.  Its filename is
     mm-page_owner-align-with-pageblock_nr-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-align-with-pageblock_nr-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-align-with-pageblock_nr-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/page_owner: align with pageblock_nr pages

When pfn_valid(pfn) return false, pfn should be align with
pageblock_nr_pages other than MAX_ORDER_NR_PAGES in init_pages_in_zone,
because the skipped 2M may be valid pfn, as a result, early allocated
count will not be accurate.

Link: http://lkml.kernel.org/r/1468938136-24228-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_owner.c~mm-page_owner-align-with-pageblock_nr-pages mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-align-with-pageblock_nr-pages
+++ a/mm/page_owner.c
@@ -417,7 +417,7 @@ static void init_pages_in_zone(pg_data_t
 	 */
 	for (; pfn < end_pfn; ) {
 		if (!pfn_valid(pfn)) {
-			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
+			pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 			continue;
 		}
 
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-update-the-comment-in-__isolate_free_page.patch
mm-page_owner-align-with-pageblock_nr-pages.patch

