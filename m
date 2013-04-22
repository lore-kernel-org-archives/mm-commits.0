From: akpm@linux-foundation.org
Subject: [merged] timer_list-split-timer_list_show_tickdevices.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:07:04 -0700
Message-ID: <20130422200704.7DAE631C19E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:38249 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3DVUHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:07:05 -0400
Received: by mail-ye0-f202.google.com with SMTP id l8so733137yen.3
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:07:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list: split timer_list_show_tickdevices()
has been removed from the -mm tree.  Its filename was
     timer_list-split-timer_list_show_tickdevices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/time/timer_list.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

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
@@ -246,12 +244,7 @@ static void timer_list_show_tickdevices(
 #endif
 	SEQ_printf(m, "\n");
 #endif
-	for_each_online_cpu(cpu)
-		print_tickdevice(m, tick_get_device(cpu), cpu);
-	SEQ_printf(m, "\n");
 }
-#else
-static void timer_list_show_tickdevices(struct seq_file *m) { }
 #endif
 
 static int timer_list_show(struct seq_file *m, void *v)
@@ -262,12 +255,16 @@ static int timer_list_show(struct seq_fi
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

linux-next.patch

