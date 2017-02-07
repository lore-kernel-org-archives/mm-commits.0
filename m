From: akpm@linux-foundation.org
Subject: + mm-fix-a-overflow-in-test_pages_in_a_zone-fix.patch added to
 -mm tree
Date: Tue, 07 Feb 2017 13:58:40 -0800
Message-ID: <589a4310.TuVKikTEyIVQdRjo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754304AbdBGV7e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2017 16:59:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, mgorman@techsingularity.net, vbabka@suse.cz, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-a-overflow-in-test_pages_in_a_zone-fix
has been added to the -mm tree.  Its filename is
     mm-fix-a-overflow-in-test_pages_in_a_zone-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-a-overflow-in-test_pages_in_a_zone-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-a-overflow-in-test_pages_in_a_zone-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: mm-fix-a-overflow-in-test_pages_in_a_zone-fix

remove assumption that end_pfn is aligned by MAX_ORDER_NR_PAGES

Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-fix-a-overflow-in-test_pages_in_a_zone-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-a-overflow-in-test_pages_in_a_zone-fix
+++ a/mm/memory_hotplug.c
@@ -1512,7 +1512,7 @@ int test_pages_in_a_zone(unsigned long s
 			while ((i < MAX_ORDER_NR_PAGES) &&
 				!pfn_valid_within(pfn + i))
 				i++;
-			if (i == MAX_ORDER_NR_PAGES)
+			if (i == MAX_ORDER_NR_PAGES || pfn + i >= end_pfn)
 				continue;
 			page = pfn_to_page(pfn + i);
 			if (zone && page_zone(page) != zone)
_

Patches currently in -mm which might be from toshi.kani@hpe.com are

mm-fix-a-overflow-in-test_pages_in_a_zone-fix.patch

