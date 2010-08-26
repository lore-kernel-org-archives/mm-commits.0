From: akpm@linux-foundation.org
Subject: + lockup-detector-sync-touch__watchdog-back-to-old-semantics.patch added to -mm tree
Date: Thu, 26 Aug 2010 14:34:50 -0700
Message-ID: <201008262134.o7QLYodm015796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab0HZVfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Aug 2010 17:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dzickus@redhat.com, fweisbec@gmail.com, len.brown@intel.com, maximlevitsky@gmail.com, mingo@elte.hu, peterz@infradead.org, sergey.senozhatsky@gmail.com, yong.zhang0@gmail.com


The patch titled
     lockup detector: sync touch_*_watchdog back to old semantics
has been added to the -mm tree.  Its filename is
     lockup-detector-sync-touch__watchdog-back-to-old-semantics.patch

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
Subject: lockup detector: sync touch_*_watchdog back to old semantics
From: Don Zickus <dzickus@redhat.com>

During my rewrite, the semantics of touch_nmi_watchdog and
touch_softlockup_watchdog changed enough to break some drivers (mostly
over preemptable regions).

This change brings those touch_*_watchdog functions back in line to how
they used to work.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN kernel/watchdog.c~lockup-detector-sync-touch__watchdog-back-to-old-semantics kernel/watchdog.c
--- a/kernel/watchdog.c~lockup-detector-sync-touch__watchdog-back-to-old-semantics
+++ a/kernel/watchdog.c
@@ -122,7 +122,7 @@ static void __touch_watchdog(void)
 
 void touch_softlockup_watchdog(void)
 {
-	__get_cpu_var(watchdog_touch_ts) = 0;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -142,7 +142,14 @@ void touch_all_softlockup_watchdogs(void
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	__get_cpu_var(watchdog_nmi_touch) = true;
+	if (watchdog_enabled) {
+		unsigned cpu;
+
+		for_each_present_cpu(cpu) {
+			if (per_cpu(watchdog_nmi_touch, cpu) != true)
+				per_cpu(watchdog_nmi_touch, cpu) = true;
+		}
+	}
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
@@ -433,6 +440,9 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
+	/* if any cpu succeeds, watchdog is considered enabled for the system */
+	watchdog_enabled = 1;
+
 	return 0;
 }
 
@@ -455,9 +465,6 @@ static void watchdog_disable(int cpu)
 		per_cpu(softlockup_watchdog, cpu) = NULL;
 		kthread_stop(p);
 	}
