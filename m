From: akpm@linux-foundation.org
Subject: + mm-page_owner-align-with-pageblock_nr_pages.patch added to -mm
 tree
Date: Tue, 05 Dec 2017 16:58:30 -0800
Message-ID: <5a2740b6.m3GkeSf9sTyxzkQS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753999AbdLFA6b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 19:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: align with pageblock_nr_pages
has been added to the -mm tree.  Its filename is
     mm-page_owner-align-with-pageblock_nr_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-align-with-pageblock_nr_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-align-with-pageblock_nr_pages.patch

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
Subject: mm/page_owner: align with pageblock_nr_pages

Currently, init_pages_in_zone() walks the zone in pageblock_nr_pages
steps.  MAX_ORDER_NR_PAGES is possible to have holes when
CONFIG_HOLES_IN_ZONE is set.  it is likely to be different between
MAX_ORDER_NR_PAGES and pageblock_nr_pages.  if we skip the size of
MAX_ORDER_NR_PAGES, it will result in the second 2M memroy leak.

Meanwhile, the change will make the code consistent.  because the entire
function is based on the pageblock_nr_pages steps.

Link: http://lkml.kernel.org/r/1512395284-13588-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_owner.c~mm-page_owner-align-with-pageblock_nr_pages mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-align-with-pageblock_nr_pages
+++ a/mm/page_owner.c
@@ -544,7 +544,7 @@ static void init_pages_in_zone(pg_data_t
 	 */
 	for (; pfn < end_pfn; ) {
 		if (!pfn_valid(pfn)) {
-			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
+			pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 			continue;
 		}
 
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-page_owner-align-with-pageblock_nr_pages.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

