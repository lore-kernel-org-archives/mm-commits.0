From: akpm@linux-foundation.org
Subject: + mm-limit-boost_watermark-on-small-zones.patch added to
 -mm tree
Date: Mon, 04 May 2020 13:37:14 -0700
Message-ID: <20200504203714.NGTXlsFfU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgEDUhP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 May 2020 16:37:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henry.willard@oracle.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm: Limit boost_watermark on small zones.
has been added to the -mm tree.  Its filename is
     mm-limit-boost_watermark-on-small-zones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-limit-boost_watermark-on-small-zones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-limit-boost_watermark-on-small-zones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Henry Willard <henry.willard@oracle.com>
Subject: mm: Limit boost_watermark on small zones.

Commit 1c30844d2dfe ("mm: reclaim small amounts of memory when an external
fragmentation event occurs") adds a boost_watermark() function which
increases the min watermark in a zone by at least pageblock_nr_pages or
the number of pages in a page block. On Arm64, with 64K pages and 512M
huge pages, this is 8192 pages or 512M. It does this regardless of the
number of managed pages managed in the zone or the likelihood of success.
This can put the zone immediately under water in terms of allocating pages
from the zone, and can cause a small machine to fail immediately due to
OoM. Unlike set_recommended_min_free_kbytes(), which substantially
increases min_free_kbytes and is tied to THP, boost_watermark() can be
called even if THP is not active. The problem is most likely to appear
on architectures such as Arm64 where pageblock_nr_pages is very large.

It is desirable to run the kdump capture kernel in as small a space as
possible to avoid wasting memory. In some architectures, such as Arm64,
there are restrictions on where the capture kernel can run, and therefore,
the space available. A capture kernel running in 768M can fail due to OoM
immediately after boost_watermark() sets the min in zone DMA32, where
most of the memory is, to 512M. It fails even though there is over 500M of
free memory. With boost_watermark() suppressed, the capture kernel can run
successfully in 448M.

This patch limits boost_watermark() to boosting a zone's min watermark only
when there are enough pages that the boost will produce positive results.
In this case that is estimated to be four times as many pages as
pageblock_nr_pages.

Link: http://lkml.kernel.org/r/1588294148-6586-1-git-send-email-henry.willard@oracle.com
Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
Signed-off-by: Henry Willard <henry.willard@oracle.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/page_alloc.c~mm-limit-boost_watermark-on-small-zones
+++ a/mm/page_alloc.c
@@ -2401,6 +2401,14 @@ static inline void boost_watermark(struc
 
 	if (!watermark_boost_factor)
 		return;
+	/*
+	 * Don't bother in zones that are unlikely to produce results.
+	 * On small machines, including kdump capture kernels running
+	 * in a small area, boosting the watermark can cause an out of
+	 * memory situation immediately.
+	 */
+	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
+		return;
 
 	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
 			watermark_boost_factor, 10000);
_

Patches currently in -mm which might be from henry.willard@oracle.com are

mm-limit-boost_watermark-on-small-zones.patch
