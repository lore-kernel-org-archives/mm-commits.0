From: akpm@linux-foundation.org
Subject: + mm-walk-the-zone-in-pageblock_nr_pages-steps.patch added to -mm tree
Date: Tue, 26 Jul 2016 12:40:22 -0700
Message-ID: <5797bca6.DtHFEthd1VJpClts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbcGZTkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 15:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: walk the zone in pageblock_nr_pages steps
has been added to the -mm tree.  Its filename is
     mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

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
Subject: mm/vmstat.c: walk the zone in pageblock_nr_pages steps

when walking the zone, we can happens to the holes. we should not
align MAX_ORDER_NR_PAGES, so it can skip the normal memory.

In addition, pagetypeinfo_showmixedcount_print reflect fragmentization.
we hope to get more accurate data. therefore, I decide to fix it.

Link: http://lkml.kernel.org/r/1469502526-24486-2-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-walk-the-zone-in-pageblock_nr_pages-steps mm/vmstat.c
--- a/mm/vmstat.c~mm-walk-the-zone-in-pageblock_nr_pages-steps
+++ a/mm/vmstat.c
@@ -1277,7 +1277,7 @@ static void pagetypeinfo_showmixedcount_
 	 */
 	for (; pfn < end_pfn; ) {
 		if (!pfn_valid(pfn)) {
-			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
+			pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 			continue;
 		}
 
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-hugetlb-fix-race-when-migrate-pages.patch
mm-update-the-comment-in-__isolate_free_page.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
kexec-add-resriction-on-the-kexec_load.patch
kexec-add-resriction-on-the-kexec_load-update.patch

