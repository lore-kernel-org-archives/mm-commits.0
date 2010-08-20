From: akpm@linux-foundation.org
Subject: + vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch added to -mm tree
Date: Thu, 19 Aug 2010 17:37:28 -0700
Message-ID: <201008200037.o7K0bSco017871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168Ab0HTAiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 20:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, mel@csn.ul.ie


The patch titled
     vmstat: update zone stat threshold when onlining a cpu
has been added to the -mm tree.  Its filename is
     vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch

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
Subject: vmstat: update zone stat threshold when onlining a cpu
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

refresh_zone_stat_thresholds() calculates parameter based on the number of
online cpus.  It's called at cpu offlining but needs to be called at
onlining, too.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmstat.c~vmstat-update-zone-stat-threshold-when-onlining-a-cpu mm/vmstat.c
--- a/mm/vmstat.c~vmstat-update-zone-stat-threshold-when-onlining-a-cpu
+++ a/mm/vmstat.c
@@ -998,6 +998,7 @@ static int __cpuinit vmstat_cpuup_callba
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		refresh_zone_stat_thresholds();
 		start_cpu_timer(cpu);
 		node_set_state(cpu_to_node(cpu), N_CPU);
 		break;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

oom-fix-null-pointer-dereference.patch
oom-fix-tasklist_lock-leak.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch

