From: akpm@linux-foundation.org
Subject: + mmvmscan-only-evict-file-pages-when-we-have-plenty.patch added to -mm tree
Date: Tue, 30 Oct 2012 11:56:33 -0700
Message-ID: <20121030185635.4671320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:37563 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2J3S4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 14:56:38 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so44146fae.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 11:56:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     Subject: mm,vmscan: only evict file pages when we have plenty
has been added to the -mm tree.  Its filename is
     mmvmscan-only-evict-file-pages-when-we-have-plenty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm,vmscan: only evict file pages when we have plenty

If we have more inactive file pages than active file pages, we skip
scanning the active file pages altogether, with the idea that we do not
want to evict the working set when there is plenty of streaming IO in the
cache.

However, the code forgot to also skip scanning anonymous pages in that
situation.  That leads to the curious situation of keeping the active file
pages protected from being paged out when there are lots of inactive file
pages, while still scanning and evicting anonymous pages.

This patch fixes that situation, by only evicting file pages when we have
plenty of them and most are inactive.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/vmscan.c~mmvmscan-only-evict-file-pages-when-we-have-plenty mm/vmscan.c
--- a/mm/vmscan.c~mmvmscan-only-evict-file-pages-when-we-have-plenty
+++ a/mm/vmscan.c
@@ -1686,6 +1686,15 @@ static void get_scan_count(struct lruvec
 			fraction[1] = 0;
 			denominator = 1;
 			goto out;
+		} else if (!inactive_file_is_low_global(zone)) {
+			/*
+			 * There is enough inactive page cache, do not
+			 * reclaim anything from the working set right now.
+			 */
+			fraction[0] = 0;
+			fraction[1] = 1;
+			denominator = 1;
+			goto out;
 		}
 	}
 
_

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

