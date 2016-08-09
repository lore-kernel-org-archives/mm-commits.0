From: akpm@linux-foundation.org
Subject: +
 proc-meminfo-use-correct-helpers-for-calculating-lru-sizes-in-meminfo.patch added to -mm tree
Date: Tue, 09 Aug 2016 16:30:14 -0700
Message-ID: <57aa6786.e3PnMb6bU6z99dWY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbcHIXaP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 19:30:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc, meminfo: use correct helpers for calculating LRU sizes in meminfo
has been added to the -mm tree.  Its filename is
     proc-meminfo-use-correct-helpers-for-calculating-lru-sizes-in-meminfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-meminfo-use-correct-helpers-for-calculating-lru-sizes-in-meminfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-meminfo-use-correct-helpers-for-calculating-lru-sizes-in-meminfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: proc, meminfo: use correct helpers for calculating LRU sizes in meminfo

meminfo_proc_show() and si_mem_available() are using the wrong helpers for
calculating the size of the LRUs.  The user-visible impact is that there
appears to be an abnormally high number of unevictable pages.

Link: http://lkml.kernel.org/r/20160805105805.GR2799@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    2 +-
 mm/page_alloc.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/meminfo.c~proc-meminfo-use-correct-helpers-for-calculating-lru-sizes-in-meminfo fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~proc-meminfo-use-correct-helpers-for-calculating-lru-sizes-in-meminfo
+++ a/fs/proc/meminfo.c
@@ -46,7 +46,7 @@ static int meminfo_proc_show(struct seq_
 		cached = 0;
 
 	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
-		pages[lru] = global_page_state(NR_LRU_BASE + lru);
+		pages[lru] = global_node_page_state(NR_LRU_BASE + lru);
 
 	available = si_mem_available();
 
diff -puN mm/page_alloc.c~proc-meminfo-use-correct-helpers-for-calculating-lru-sizes-in-meminfo mm/page_alloc.c
--- a/mm/page_alloc.c~proc-meminfo-use-correct-helpers-for-calculating-lru-sizes-in-meminfo
+++ a/mm/page_alloc.c
@@ -4060,7 +4060,7 @@ long si_mem_available(void)
 	int lru;
 
 	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
-		pages[lru] = global_page_state(NR_LRU_BASE + lru);
+		pages[lru] = global_node_page_state(NR_LRU_BASE + lru);
 
 	for_each_zone(zone)
 		wmark_low += zone->watermark[WMARK_LOW];
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

proc-meminfo-use-correct-helpers-for-calculating-lru-sizes-in-meminfo.patch

