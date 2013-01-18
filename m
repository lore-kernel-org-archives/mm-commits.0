From: akpm@linux-foundation.org
Subject: + timer_list-convert-timer-list-to-be-a-proper-seq_file-v2.patch added to -mm tree
Date: Fri, 18 Jan 2013 13:50:59 -0800
Message-ID: <20130118215100.2BEA85A41FB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:60161 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ARVvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Jan 2013 16:51:01 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so479945vba.4
        for <mm-commits@vger.kernel.org>; Fri, 18 Jan 2013 13:51:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2
has been added to the -mm tree.  Its filename is
     timer_list-convert-timer-list-to-be-a-proper-seq_file-v2.patch

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
Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2

v2: Added comments on the iteration.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-v2 kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-v2
+++ a/kernel/time/timer_list.c
@@ -274,6 +274,19 @@ static int timer_list_show(struct seq_fi
 	return 0;
 }
 
+/*
+ * This itererator really needs some explination since it is offset and has
+ * two passes one of which is controlled by a config option.
+ * In a hotplugged system some cpus, including cpu 0, may be missing so we have
+ * to use cpumask_* to iterate over the cpus.
+ * For the first pass:
+ * It returns 1 for the header position.
+ * For cpu 0 it returns 2 and the final possible cpu would be nr_cpu_ids + 1.
+ * On the second pass:
+ * It returnes nr_cpu_ids + 1 for the second header position.
+ * For cpu 0 it returns nr_cpu_ids + 2
+ * The final possible cpu would be nr_cpu_ids + nr_cpu_ids + 2.
+ */
 static void *timer_list_start(struct seq_file *file, loff_t *offset)
 {
 	unsigned long n = *offset;
_

Patches currently in -mm which might be from nzimmer@sgi.com are

timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch

