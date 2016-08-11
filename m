From: akpm@linux-foundation.org
Subject: [patch 2/7] proc, meminfo: use correct helpers for calculating
 LRU sizes in meminfo
Date: Thu, 11 Aug 2016 15:32:57 -0700
Message-ID: <57acfd19.EOcwOfbZz0sUFPsw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbcHKWc6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 18:32:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, david@fromorbit.com

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
