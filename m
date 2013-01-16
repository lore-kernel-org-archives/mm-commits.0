From: akpm@linux-foundation.org
Subject: + timer_list-split-timer_list_show_tickdevices.patch added to -mm tree
Date: Wed, 16 Jan 2013 14:12:49 -0800
Message-ID: <20130116221250.0BE745A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41089 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab3APWMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 17:12:51 -0500
Received: by mail-yh0-f74.google.com with SMTP id w68so229003yhw.1
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 14:12:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     Subject: timer_list: split timer_list_show_tickdevices()
has been added to the -mm tree.  Its filename is
     timer_list-split-timer_list_show_tickdevices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: timer_list: split timer_list_show_tickdevices()

Split timer_list_show_tickdevices() out the header and just pull the rest up
to timer_list_show.  Also tweak the location of the whitespace.  This is all
to prep for the fix.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN kernel/time/timer_list.c~timer_list-split-timer_list_show_tickdevices kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-split-timer_list_show_tickdevices
+++ a/kernel/time/timer_list.c
@@ -133,7 +133,6 @@ static void print_cpu(struct seq_file *m
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	SEQ_printf(m, "\n");
 	SEQ_printf(m, "cpu: %d\n", cpu);
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		SEQ_printf(m, " clock %d:\n", i);
@@ -187,6 +186,7 @@ static void print_cpu(struct seq_file *m
 
 #undef P
 #undef P_ns
+	SEQ_printf(m, "\n");
 }
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
@@ -195,7 +195,6 @@ print_tickdevice(struct seq_file *m, str
 {
 	struct clock_event_device *dev = td->evtdev;
 
-	SEQ_printf(m, "\n");
 	SEQ_printf(m, "Tick Device: mode:     %d\n", td->mode);
 	if (cpu < 0)
 		SEQ_printf(m, "Broadcast device\n");
@@ -230,12 +229,11 @@ print_tickdevice(struct seq_file *m, str
 	print_name_offset(m, dev->event_handler);
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, " retries:        %lu\n", dev->retries);
+	SEQ_printf(m, "\n");
 }
 
-static void timer_list_show_tickdevices(struct seq_file *m)
+static void timer_list_show_tickdevices_header(struct seq_file *m)
 {
-	int cpu;
-
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 	print_tickdevice(m, tick_get_broadcast_device(), -1);
 	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
@@ -246,12 +244,8 @@ static void timer_list_show_tickdevices(
 #endif
 	SEQ_printf(m, "\n");
 #endif
-	for_each_online_cpu(cpu)
-		print_tickdevice(m, tick_get_device(cpu), cpu);
 	SEQ_printf(m, "\n");
 }
-#else
-static void timer_list_show_tickdevices(struct seq_file *m) { }
 #endif
 
 static int timer_list_show(struct seq_file *m, void *v)
@@ -262,12 +256,16 @@ static int timer_list_show(struct seq_fi
 	SEQ_printf(m, "Timer List Version: v0.7\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+	SEQ_printf(m, "\n");
 
 	for_each_online_cpu(cpu)
 		print_cpu(m, cpu, now);
 
-	SEQ_printf(m, "\n");
-	timer_list_show_tickdevices(m);
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	timer_list_show_tickdevices_header(m);
+	for_each_online_cpu(cpu)
+		print_tickdevice(m, tick_get_device(cpu), cpu);
+#endif
 
 	return 0;
 }
_

Patches currently in -mm which might be from nzimmer@sgi.com are

timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch

