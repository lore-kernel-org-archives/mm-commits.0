From: akpm@linux-foundation.org
Subject: + kernel-fix-bug_on-checks-for-cpu-notifier-callbacks-direct-call.patch added to -mm tree
Date: Wed, 02 Jun 2010 13:09:31 -0700
Message-ID: <201006022009.o52K9Vl0014332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933084Ab0FBUJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 16:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     kernel/: fix BUG_ON checks for cpu notifier callbacks direct call
has been added to the -mm tree.  Its filename is
     kernel-fix-bug_on-checks-for-cpu-notifier-callbacks-direct-call.patch

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
Subject: kernel/: fix BUG_ON checks for cpu notifier callbacks direct call
From: Akinobu Mita <akinobu.mita@gmail.com>

The commit 80b5184cc537718122e036afe7e62d202b70d077 ("kernel/: convert cpu
notifier to return encapsulate errno value") changed the return value of
cpu notifier callbacks.

Those callbacks don't return NOTIFY_BAD on failures anymore.  But there
are a few callbacks which are called directly at init time and checking
the return value.

I forgot to change BUG_ON checking by the direct callers in the commit.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |    2 +-
 kernel/timer.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/softirq.c~kernel-fix-bug_on-checks-for-cpu-notifier-callbacks-direct-call kernel/softirq.c
--- a/kernel/softirq.c~kernel-fix-bug_on-checks-for-cpu-notifier-callbacks-direct-call
+++ a/kernel/softirq.c
@@ -850,7 +850,7 @@ static __init int spawn_ksoftirqd(void)
 	void *cpu = (void *)(long)smp_processor_id();
 	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 
-	BUG_ON(err == NOTIFY_BAD);
+	BUG_ON(err != NOTIFY_OK);
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 	return 0;
diff -puN kernel/timer.c~kernel-fix-bug_on-checks-for-cpu-notifier-callbacks-direct-call kernel/timer.c
--- a/kernel/timer.c~kernel-fix-bug_on-checks-for-cpu-notifier-callbacks-direct-call
+++ a/kernel/timer.c
@@ -1716,7 +1716,7 @@ void __init init_timers(void)
 
 	init_timer_stats();
 
-	BUG_ON(err == NOTIFY_BAD);
+	BUG_ON(err != NOTIFY_OK);
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
kernel-fix-bug_on-checks-for-cpu-notifier-callbacks-direct-call.patch

