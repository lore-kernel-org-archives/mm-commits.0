From: akpm@linux-foundation.org
Subject: + memcg-rework-usage-of-stats-by-soft-limit.patch added to -mm tree
Date: Mon, 04 Jan 2010 13:34:13 -0800
Message-ID: <201001042134.o04LYDbM019488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581Ab0ADVed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 16:34:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, davidel@xmailserver.org, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, vbuzov@embeddedalley.com, virtuoso@slind.org, xemul@openvz.org


The patch titled
     memcg: rework usage of stats by soft limit
has been added to the -mm tree.  Its filename is
     memcg-rework-usage-of-stats-by-soft-limit.patch

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
Subject: memcg: rework usage of stats by soft limit
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Instead of incrementing counter on each page in/out and comparing it with
constant, we set counter to constant, decrement counter on each page
in/out and compare it with zero.  We want to make comparing as fast as
possible.  On many RISC systems (probably not only RISC) comparing with
zero is more effective than comparing with a constant, since not every
constant can be immediate operand for compare instruction.

Also, I've renamed MEM_CGROUP_STAT_EVENTS to MEM_CGROUP_STAT_SOFTLIMIT,
since really it's not a generic counter.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: Vladislav Buzov <vbuzov@embeddedalley.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Alexander Shishkin <virtuoso@slind.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-rework-usage-of-stats-by-soft-limit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rework-usage-of-stats-by-soft-limit
+++ a/mm/memcontrol.c
@@ -71,8 +71,9 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
-	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
+	MEM_CGROUP_STAT_SOFTLIMIT, /* decrements on each page in/out.
+					used by soft limit implementation */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -86,10 +87,10 @@ struct mem_cgroup_stat {
 };
 
 static inline void
-__mem_cgroup_stat_reset_safe(struct mem_cgroup_stat_cpu *stat,
-				enum mem_cgroup_stat_index idx)
+__mem_cgroup_stat_set_safe(struct mem_cgroup_stat_cpu *stat,
+				enum mem_cgroup_stat_index idx, s64 val)
 {
-	stat->count[idx] = 0;
+	stat->count[idx] = val;
 }
 
 static inline s64
@@ -411,9 +412,10 @@ static bool mem_cgroup_soft_limit_check(
 
 	cpu = get_cpu();
 	cpustat = &mem->stat.cpustat[cpu];
-	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
-	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
-		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
+	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_SOFTLIMIT);
+	if (unlikely(val < 0)) {
+		__mem_cgroup_stat_set_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT,
+				SOFTLIMIT_EVENTS_THRESH);
 		ret = true;
 	}
 	put_cpu();
@@ -546,7 +548,7 @@ static void mem_cgroup_charge_statistics
 	else
 		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_EVENTS, 1);
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT, -1);
 	put_cpu();
 }
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch

