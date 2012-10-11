From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-fix-bit-ranges-in-getclearset_pageblock_skip.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:00 -0700
Message-ID: <20121011205900.C4BAB1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54259 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2JKU7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:02 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so270416qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b.zolnierkie@samsung.com, kyungmin.park@samsung.com, mgorman@suse.de, minchan@kernel.org, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: fix bit ranges in {get,clear,set}_pageblock_skip()
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-bit-ranges-in-getclearset_pageblock_skip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: mm: compaction: fix bit ranges in {get,clear,set}_pageblock_skip()

{get,clear,set}_pageblock_skip() use incorrect bit ranges (please compare
to bit ranges used by {get,set}_pageblock_flags() used for migration
types) and can overwrite pageblock migratetype of the next pageblock in
the bitmap.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/pageblock-flags.h~mm-compaction-fix-bit-ranges-in-getclearset_pageblock_skip include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~mm-compaction-fix-bit-ranges-in-getclearset_pageblock_skip
+++ a/include/linux/pageblock-flags.h
@@ -71,13 +71,13 @@ void set_pageblock_flags_group(struct pa
 #ifdef CONFIG_COMPACTION
 #define get_pageblock_skip(page) \
 			get_pageblock_flags_group(page, PB_migrate_skip,     \
-							PB_migrate_skip + 1)
+							PB_migrate_skip)
 #define clear_pageblock_skip(page) \
 			set_pageblock_flags_group(page, 0, PB_migrate_skip,  \
-							PB_migrate_skip + 1)
+							PB_migrate_skip)
 #define set_pageblock_skip(page) \
 			set_pageblock_flags_group(page, 1, PB_migrate_skip,  \
-							PB_migrate_skip + 1)
+							PB_migrate_skip)
 #endif /* CONFIG_COMPACTION */
 
 #define get_pageblock_flags(page) \
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

origin.patch

