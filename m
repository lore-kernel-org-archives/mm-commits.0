From: akpm@linux-foundation.org
Subject: + mm-page_isolation-check-pfn-validity-before-access.patch added
 to -mm tree
Date: Tue, 11 Nov 2014 14:21:27 -0800
Message-ID: <54628be7.3XqgPHmJwnM0ftgR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaKKWVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Nov 2014 17:21:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_isolation: check pfn validity before access
has been added to the -mm tree.  Its filename is
     mm-page_isolation-check-pfn-validity-before-access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-check-pfn-validity-before-access.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-check-pfn-validity-before-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm: page_isolation: check pfn validity before access

In the undo path of start_isolate_page_range(), we need to check the pfn
validity before access its page, or it will trigger an addressing
exception if there is hole in the zone.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_isolation.c~mm-page_isolation-check-pfn-validity-before-access mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-check-pfn-validity-before-access
+++ a/mm/page_isolation.c
@@ -176,8 +176,11 @@ int start_isolate_page_range(unsigned lo
 undo:
 	for (pfn = start_pfn;
 	     pfn < undo_pfn;
-	     pfn += pageblock_nr_pages)
-		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
+	     pfn += pageblock_nr_pages) {
+		page = __first_valid_page(pfn, pageblock_nr_pages);
+		if (page)
+			unset_migratetype_isolate(page, migratetype);
+	}
 
 	return -EBUSY;
 }
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

zram-avoid-kunmap_atomic-a-null-pointer.patch
mm-page_isolation-check-pfn-validity-before-access.patch

