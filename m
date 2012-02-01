From: akpm@linux-foundation.org
Subject: + mm-compaction-make-compact_control-order-signed.patch added to -mm tree
Date: Wed, 01 Feb 2012 12:46:57 -0800
Message-ID: <20120201204657.B4197A0367@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:51656 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2BAUrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 15:47:00 -0500
Received: by werb13 with SMTP id b13so76727wer.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 12:46:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, aarcange@redhat.com, mel@csn.ul.ie, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm: compaction: make compact_control order signed
has been added to the -mm tree.  Its filename is
     mm-compaction-make-compact_control-order-signed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm: compaction: make compact_control order signed

"order" is -1 when compacting via /proc/sys/vm/compact_memory.  Making
it unsigned causes a bug in __compact_pgdat() when we test:

	if (cc->order < 0 || !compaction_deferred(zone, cc->order))
		compact_zone(zone, cc);

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-make-compact_control-order-signed mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-compact_control-order-signed
+++ a/mm/compaction.c
@@ -35,7 +35,7 @@ struct compact_control {
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
 
-	unsigned int order;		/* order a direct compactor needs */
+	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
 };
_
Subject: Subject: mm: compaction: make compact_control order signed

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
mm-compaction-make-compact_control-order-signed.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
sysctl-remove-an-unused-variable.patch
sysctl-fix-memset-parameters-in-setup_sysctl_set.patch

