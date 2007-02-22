From: akpm@linux-foundation.org
Subject: + fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran.patch added to -mm tree
Date: Wed, 21 Feb 2007 19:50:41 -0800
Message-ID: <200702220350.l1M3ofJu003695@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36003 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774AbXBVDuv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 22:50:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     Fix posix-cpu-timer breakage caused by stale p->last_ran value
has been added to the -mm tree.  Its filename is
     fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix posix-cpu-timer breakage caused by stale p->last_ran value
From: Thomas Gleixner <tglx@linutronix.de>

Problem description at:
http://bugzilla.kernel.org/show_bug.cgi?id=8048

Commit b18ec80396834497933d77b81ec0918519f4e2a7
    [PATCH] sched: improve migration accuracy
optimized the scheduler time calculations, but broke posix-cpu-timers.

The problem is that the p->last_ran value is not updated after a context
switch.  So a subsequent call to current_sched_time() calculates with a
stale p->last_ran value, i.e.  accounts the full time, which the task was
scheduled away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran kernel/sched.c
--- a/kernel/sched.c~fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran
+++ a/kernel/sched.c
@@ -3566,7 +3566,7 @@ switch_tasks:
 
 	sched_info_switch(prev, next);
 	if (likely(prev != next)) {
-		next->timestamp = now;
+		next->timestamp = next->last_ran = now;
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
_

Patches currently in -mm which might be from tglx@linutronix.de are

fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran.patch
git-block.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v2.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
