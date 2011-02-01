From: akpm@linux-foundation.org
Subject: + memcg-fix-event-counting-breakage-by-recent-thp-update.patch added to -mm tree
Date: Mon, 31 Jan 2011 16:26:18 -0800
Message-ID: <201102010026.p110QIGj011065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297Ab1BAA0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Jan 2011 19:26:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hannes@cmpxchg.org, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix event counting breakage from recent THP update
has been added to the -mm tree.  Its filename is
     memcg-fix-event-counting-breakage-by-recent-thp-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix event counting breakage from recent THP update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changes in e401f1761 ("memcg: modify accounting function for supporting
THP better") adds nr_pages to support multiple page size in
memory_cgroup_charge_statistics.

But counting the number of event nees abs(nr_pages) for increasing
counters.  This patch fixes event counting.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-event-counting-breakage-by-recent-thp-update mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-event-counting-breakage-by-recent-thp-update
+++ a/mm/memcontrol.c
@@ -612,8 +612,10 @@ static void mem_cgroup_charge_statistics
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGIN_COUNT]);
-	else
+	else {
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGOUT_COUNT]);
+		nr_pages = -nr_pages; /* for event */
+	}
 
 	__this_cpu_add(mem->stat->count[MEM_CGROUP_EVENTS], nr_pages);
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memsw-handle-swapaccount-kernel-parameter-correctly.patch
memsw-deprecate-noswapaccount-kernel-parameter-and-schedule-it-for-removal.patch
memcg-prevent-endless-loop-when-charging-huge-pages.patch
memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group.patch
memcg-never-oom-when-charging-huge-pages.patch
memcg-fix-event-counting-breakage-by-recent-thp-update.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch

