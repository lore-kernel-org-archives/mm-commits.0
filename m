From: akpm@linux-foundation.org
Subject: + mm-compaction-check-lock-contention-first-before-taking-lock.patch added to -mm tree
Date: Tue, 11 Sep 2012 16:43:39 -0700
Message-ID: <20120911234339.A14C71E0066@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60576 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2IKXnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 19:43:40 -0400
Received: by qafl39 with SMTP id l39so135562qaf.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 16:43:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, mgorman@suse.de, minchan@kernel.org, shli@fusionio.com


The patch titled
     Subject: mm: compaction: check lock contention first before taking lock
has been added to the -mm tree.  Its filename is
     mm-compaction-check-lock-contention-first-before-taking-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm: compaction: check lock contention first before taking lock

isolate_migratepages_range will take zone->lru_lock first and check if the
lock is contented, if yes, it will release the lock.  This isn't
efficient.  If the lock is truly contented, a lock/unlock pair will
increase the lock contention.  We'd better check if the lock is contended
first.  compact_trylock_irqsave perfectly meets the requirement.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-check-lock-contention-first-before-taking-lock mm/compaction.c
--- a/mm/compaction.c~mm-compaction-check-lock-contention-first-before-taking-lock
+++ a/mm/compaction.c
@@ -349,8 +349,9 @@ isolate_migratepages_range(struct zone *
 
 	/* Time to isolate some pages for migration */
 	cond_resched();
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	locked = true;
+	locked = compact_trylock_irqsave(&zone->lru_lock, &flags, cc);
+	if (!locked)
+		return 0;
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
 
_

Patches currently in -mm which might be from shli@kernel.org are

linux-next.patch
readahead-fault-retry-breaks-mmap-file-read-random-detection.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch

