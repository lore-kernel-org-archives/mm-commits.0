From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:20:39 -0700
Message-ID: <543c17f7.D4nyWKsbbk6ZDQAk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbaJMSUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Li.Xiubo@freescale.com, arnd@arndb.de, mgorman@suse.de, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: fix warning of 'flags' may be used uninitialized
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -570,7 +570,7 @@ isolate_migratepages_block(struct compac
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 	struct lruvec *lruvec;
-	unsigned long flags;
+	unsigned long flags = 0;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 
_

Patches currently in -mm which might be from Li.Xiubo@freescale.com are

origin.patch
linux-next.patch

