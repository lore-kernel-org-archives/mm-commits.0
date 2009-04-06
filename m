From: akpm@linux-foundation.org
Subject: [merged] mm-align-vmstat_works-timer.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:29 -0700
Message-ID: <200904061932.n36JWTFL010731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755770AbZDFTeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, mm-commits@vger.kernel.org


The patch titled
     mm: align vmstat_work's timer
has been removed from the -mm tree.  Its filename was
     mm-align-vmstat_works-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: align vmstat_work's timer
From: Anton Blanchard <anton@samba.org>

Even though vmstat_work is marked deferrable, there are still benefits to
aligning it.  For certain applications we want to keep OS jitter as low as
possible and aligning timers and work so they occur together can reduce
their overall impact.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmstat.c~mm-align-vmstat_works-timer mm/vmstat.c
--- a/mm/vmstat.c~mm-align-vmstat_works-timer
+++ a/mm/vmstat.c
@@ -891,7 +891,7 @@ static void vmstat_update(struct work_st
 {
 	refresh_cpu_vm_stats(smp_processor_id());
 	schedule_delayed_work(&__get_cpu_var(vmstat_work),
-		sysctl_stat_interval);
+		round_jiffies_relative(sysctl_stat_interval));
 }
 
 static void __cpuinit start_cpu_timer(int cpu)
@@ -899,7 +899,8 @@ static void __cpuinit start_cpu_timer(in
 	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
 
 	INIT_DELAYED_WORK_DEFERRABLE(vmstat_work, vmstat_update);
-	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
+	schedule_delayed_work_on(cpu, vmstat_work,
+				 __round_jiffies_relative(HZ, cpu));
 }
 
 /*
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
sunrpc-align-cache_clean-works-timer.patch

