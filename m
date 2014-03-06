From: akpm@linux-foundation.org
Subject: +
 mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch added to -mm tree
Date: Thu, 06 Mar 2014 15:52:01 -0800
Message-ID: <53190a21.vyJCupEW7vLEzmxS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaCFXwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 18:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, b.zolnierkie@samsung.com, lauraa@codeaurora.org

Subject: + mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch added to -mm tree
To: lauraa@codeaurora.org,b.zolnierkie@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 15:52:01 -0800


The patch titled
     Subject: mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block
has been added to the -mm tree.  Its filename is
     mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block

We received several reports of bad page state when freeing CMA pages
previously allocated with alloc_contig_range:

<1>[ 1258.084111] BUG: Bad page state in process Binder_A  pfn:63202
<1>[ 1258.089763] page:d21130b0 count:0 mapcount:1 mapping:  (null) index:0x7dfbf
<1>[ 1258.096109] page flags: 0x40080068(uptodate|lru|active|swapbacked)

Based on the page state, it looks like the page was still in use.  The
page flags do not make sense for the use case though.  Further debugging
showed that despite alloc_contig_range returning success, at least one
page in the range still remained in the buddy allocator.

There is an issue with isolate_freepages_block.  In strict mode (which CMA
uses), if any pages in the range cannot be isolated,
isolate_freepages_block should return failure 0.  The current check keeps
track of the total number of isolated pages and compares against the size
of the range:

        if (strict && nr_strict_required > total_isolated)
                total_isolated = 0;

After taking the zone lock, if one of the pages in the range is not in the
buddy allocator, we continue through the loop and do not increment
total_isolated.  If we end up over isolating by more than one page (e.g. 
last since page needed is a higher order page), it is not possible to
detect that the page was skipped.  The fix is to bail out if the loop
immediately if we are in strict mode.  There's no benfit to continuing
anyway since we need all pages to be isolated.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block mm/compaction.c
--- a/mm/compaction.c~mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block
+++ a/mm/compaction.c
@@ -255,12 +255,21 @@ static unsigned long isolate_freepages_b
 		struct page *page = cursor;
 
 		nr_scanned++;
-		if (!pfn_valid_within(blockpfn))
-			continue;
+		if (!pfn_valid_within(blockpfn)) {
+			if (strict)
+				break;
+			else
+				continue;
+		}
+
 		if (!valid_page)
 			valid_page = page;
-		if (!PageBuddy(page))
-			continue;
+		if (!PageBuddy(page)) {
+			if (strict)
+				break;
+			else
+				continue;
+		}
 
 		/*
 		 * The zone lock must be held to isolate freepages.
@@ -288,8 +297,12 @@ static unsigned long isolate_freepages_b
 		}
 
 		/* Recheck this is a buddy page under lock */
-		if (!PageBuddy(page))
-			continue;
+		if (!PageBuddy(page)) {
+			if (strict)
+				break;
+			else
+				continue;
+		}
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

