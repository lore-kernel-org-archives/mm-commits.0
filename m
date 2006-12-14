From: akpm@osdl.org
Subject: - optimize-calc_load.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:18:08 -0800
Message-ID: <200612140618.kBE6I7gf002326@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52766 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbWLNGSc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:18:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     Optimize calc_load()
has been removed from the -mm tree.  Its filename was
     optimize-calc_load.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Optimize calc_load()
From: Eric Dumazet <dada1@cosmosbay.com>

calc_load() is called by timer interrupt to update avenrun[].  It currently
calls nr_active() at each timer tick (HZ per second), while the update of
avenrun[] is done only once every 5 seconds.  (LOAD_FREQ=5 Hz)

nr_active() is quite expensive on SMP machines, since it has to sum up
nr_running and nr_uninterruptible of all online CPUS, bringing foreign
dirty cache lines.

This patch is an optimization of calc_load() so that nr_active() is called
only if we need it.

The use of unlikely() is welcome since the condition is true only once every
5*HZ time.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/timer.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN kernel/timer.c~optimize-calc_load kernel/timer.c
--- a/kernel/timer.c~optimize-calc_load
+++ a/kernel/timer.c
@@ -1146,11 +1146,15 @@ static inline void calc_load(unsigned lo
 	unsigned long active_tasks; /* fixed-point */
 	static int count = LOAD_FREQ;
 
-	active_tasks = count_active_tasks();
-	for (count -= ticks; count < 0; count += LOAD_FREQ) {
-		CALC_LOAD(avenrun[0], EXP_1, active_tasks);
-		CALC_LOAD(avenrun[1], EXP_5, active_tasks);
-		CALC_LOAD(avenrun[2], EXP_15, active_tasks);
+	count -= ticks;
+	if (unlikely(count < 0)) {
+		active_tasks = count_active_tasks();
+		do {
+			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
+			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
+			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
+			count += LOAD_FREQ;
+		} while (count < 0);
 	}
 }
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
get-rid-of-arch_have_xtime_lock.patch
introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch

