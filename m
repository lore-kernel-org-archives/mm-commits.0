From: akpm@linux-foundation.org
Subject: - nohz-no-softirq-pending-warnings-for-offline-cpus.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:02:26 -0800
Message-ID: <200812152002.mBFK2QIE030953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850AbYLOUDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     nohz: no softirq pending warnings for offline cpus
has been removed from the -mm tree.  Its filename was
     nohz-no-softirq-pending-warnings-for-offline-cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nohz: no softirq pending warnings for offline cpus
From: Heiko Carstens <heiko.carstens@de.ibm.com>

After a cpu was taken down during cpu hotplug (read: disabled for interrupts)
it still might have pending softirqs. However take_cpu_down makes sure
that the idle task will run next instead of ksoftirqd on the taken down cpu.
The idle task will call tick_nohz_stop_sched_tick which might warn about
pending softirqs just before the cpu kills itself completely.
However the pending softirqs on the dead cpu aren't a problem because they
will be moved to an online cpu during CPU_DEAD handling.

So make sure we warn only for online cpus.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~nohz-no-softirq-pending-warnings-for-offline-cpus kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~nohz-no-softirq-pending-warnings-for-offline-cpus
+++ a/kernel/time/tick-sched.c
@@ -247,7 +247,7 @@ void tick_nohz_stop_sched_tick(int inidl
 	if (need_resched())
 		goto end;
 
-	if (unlikely(local_softirq_pending())) {
+	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
 
 		if (ratelimit < 10) {
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
fix-similar-typos-to-successfull-v2.patch

