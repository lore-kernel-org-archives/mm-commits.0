From: akpm@linux-foundation.org
Subject: + nohz-no-softirq-pending-warnings-for-offline-cpus.patch added to -mm tree
Date: Thu, 11 Dec 2008 19:14:02 -0800
Message-ID: <200812120314.mBC3E2MW030012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757632AbYLLDSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 22:18:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     nohz: no softirq pending warnings for offline cpus
has been added to the -mm tree.  Its filename is
     nohz-no-softirq-pending-warnings-for-offline-cpus.patch

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
nohz-no-softirq-pending-warnings-for-offline-cpus.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
fix-similar-typos-to-successfull-v2.patch

