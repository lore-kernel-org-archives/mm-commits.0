From: akpm@linux-foundation.org
Subject: + mm-fix-a-overflow-in-test_pages_in_a_zone.patch added to -mm
 tree
Date: Tue, 07 Feb 2017 13:58:38 -0800
Message-ID: <589a430e./Q2qmnt+0tE8Rmnz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754212AbdBGV7e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2017 16:59:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, mgorman@techsingularity.net, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: fix overflow in test_pages_in_a_zone()
has been added to the -mm tree.  Its filename is
     mm-fix-a-overflow-in-test_pages_in_a_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-a-overflow-in-test_pages_in_a_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-a-overflow-in-test_pages_in_a_zone.patch

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
Subject: mm/memory_hotplug.c: fix overflow in test_pages_in_a_zone()

When mainline introduced a96dfddbcc04 ("base/memory, hotplug: fix a kernel
oops in show_valid_zones()"), it obtained the valid start and end pfn from
the given pfn range.  The valid start pfn can fix the actual issue, but it
introduced another issue.  The valid end pfn will may exceed the given
end_pfn.

Although the incorrect overflow will not result in actual problem at
present, but I think it need to be fixed.

Fixes: a96dfddbcc04 ("base/memory, hotplug: fix a kernel oops in show_valid_zones()")
Link: http://lkml.kernel.org/r/1486467299-22648-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-fix-a-overflow-in-test_pages_in_a_zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-a-overflow-in-test_pages_in_a_zone
+++ a/mm/memory_hotplug.c
@@ -1526,7 +1526,7 @@ int test_pages_in_a_zone(unsigned long s
 
 	if (zone) {
 		*valid_start = start;
-		*valid_end = end;
+		*valid_end = min(end, end_pfn);
 		return 1;
 	} else {
 		return 0;
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch
mm-fix-a-overflow-in-test_pages_in_a_zone.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

