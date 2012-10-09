From: akpm@linux-foundation.org
Subject: + mm-compaction-fix-bit-ranges-in-getclearset_pageblock_skip.patch added to -mm tree
Date: Tue, 09 Oct 2012 12:03:25 -0700
Message-ID: <20121009190326.2323E5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:37060 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab2JITD2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 15:03:28 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so364483bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 12:03:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b.zolnierkie@samsung.com, kyungmin.park@samsung.com, mgorman@suse.de


The patch titled
     Subject: mm: compaction: fix bit ranges in {get,clear,set}_pageblock_skip()
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-bit-ranges-in-getclearset_pageblock_skip.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-compaction-fix-bit-ranges-in-getclearset_pageblock_skip.patch

