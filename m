From: akpm@linux-foundation.org
Subject: [merged] mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:06 -0700
Message-ID: <20120322201906.57FB7A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:36713 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759480Ab2CVUTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:13 -0400
Received: by faaa19 with SMTP id a19so143739faa.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, counters: fold __sync_task_rss_stat() into sync_mm_rss()
has been removed from the -mm tree.  Its filename was
     mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, counters: fold __sync_task_rss_stat() into sync_mm_rss()

There's no difference between sync_mm_rss() and __sync_task_rss_stat(),
so fold the latter into the former.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/memory.c~mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss mm/memory.c
--- a/mm/memory.c~mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss
+++ a/mm/memory.c
@@ -125,7 +125,7 @@ core_initcall(init_zero_pfn);
 
 #if defined(SPLIT_RSS_COUNTING)
 
-static void __sync_task_rss_stat(struct mm_struct *mm)
+void sync_mm_rss(struct mm_struct *mm)
 {
 	int i;
 
@@ -157,12 +157,7 @@ static void check_sync_rss_stat(struct t
 	if (unlikely(task != current))
 		return;
 	if (unlikely(task->rss_stat.events++ > TASK_RSS_EVENTS_THRESH))
-		__sync_task_rss_stat(task->mm);
-}
