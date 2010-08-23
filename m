From: akpm@linux-foundation.org
Subject: + lockup_detector-remove-unnecessary-panic_notifier.patch added to -mm tree
Date: Mon, 23 Aug 2010 16:38:25 -0700
Message-ID: <201008232338.o7NNcPec021375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397Ab0HWXjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 19:39:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, dzickus@redhat.com, mingo@elte.hu


The patch titled
     lockup_detector: remove unnecessary panic_notifier
has been added to the -mm tree.  Its filename is
     lockup_detector-remove-unnecessary-panic_notifier.patch

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
Subject: lockup_detector: remove unnecessary panic_notifier
From: Akinobu Mita <akinobu.mita@gmail.com>

The panic notifer in lockup_detector just set did_panic to 1.  But
did_panic is not used anywhere so we can just remove it.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN kernel/watchdog.c~lockup_detector-remove-unnecessary-panic_notifier kernel/watchdog.c
--- a/kernel/watchdog.c~lockup_detector-remove-unnecessary-panic_notifier
+++ a/kernel/watchdog.c
@@ -43,7 +43,6 @@ static DEFINE_PER_CPU(unsigned long, hrt
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
 
-static int __read_mostly did_panic;
 static int __initdata no_watchdog;
 
 
@@ -180,18 +179,6 @@ static int is_softlockup(unsigned long t
 	return 0;
 }
 
-static int
-watchdog_panic(struct notifier_block *this, unsigned long event, void *ptr)
-{
-	did_panic = 1;
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block panic_block = {
-	.notifier_call = watchdog_panic,
-};
-
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
@@ -564,8 +551,6 @@ static int __init spawn_watchdog_task(vo
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
