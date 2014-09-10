From: akpm@linux-foundation.org
Subject: +
 mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch added to -mm tree
Date: Wed, 10 Sep 2014 13:25:30 -0700
Message-ID: <5410b3ba.reqZQZl0AmzdtpXQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaIJUZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 16:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Li.Xiubo@freescale.com, arnd@arndb.de, mgorman@suse.de, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: fix warning of 'flags' may be used uninitialized
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiubo Li <Li.Xiubo@freescale.com>
Subject: mm/compaction.c: fix warning of 'flags' may be used uninitialized

C      mm/compaction.o
mm/compaction.c: In function isolate_freepages_block:
mm/compaction.c:364:37: warning: flags may be used uninitialized in this function [-Wmaybe-uninitialized]
       && compact_unlock_should_abort(&cc->zone->lock, flags,
                                     ^

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-fix-warning-of-flags-may-be-used-uninitialized mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-warning-of-flags-may-be-used-uninitialized
+++ a/mm/compaction.c
@@ -344,7 +344,7 @@ static unsigned long isolate_freepages_b
 {
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor, *valid_page = NULL;
-	unsigned long flags;
+	unsigned long flags = 0;
 	bool locked = false;
 	unsigned long blockpfn = *start_pfn;
 
@@ -573,7 +573,7 @@ isolate_migratepages_block(struct compac
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 	struct lruvec *lruvec;
-	unsigned long flags;
+	unsigned long flags = 0;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 
_

Patches currently in -mm which might be from Li.Xiubo@freescale.com are

mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch
linux-next.patch

