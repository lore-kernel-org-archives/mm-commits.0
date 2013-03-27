From: akpm@linux-foundation.org
Subject: [folded-merged] timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch removed from -mm tree
Date: Wed, 27 Mar 2013 12:06:39 -0700
Message-ID: <20130327190640.351665A4206@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47567 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3C0TGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 15:06:43 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so860530vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 12:06:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, sboyd@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v3
has been removed from the -mm tree.  Its filename was
     timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch

This patch was dropped because it was folded into timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v3

v3: Corrected the case where max_cpus != nr_cpu_ids by exiting early.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-v3 kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-v3
+++ a/kernel/time/timer_list.c
@@ -276,8 +276,8 @@ static int timer_list_show(struct seq_fi
 /*
  * This itererator really needs some explanation since it is offset and has
  * two passes, one of which is controlled by a config option.
- * In a hotplugged system some cpus, including cpu 0, may be missing so we have
- * to use cpumask_* to iterate over the cpus.
+ * In a hotpluggable systems some cpus, including cpu 0 and the last cpu, may
+ * be missing so we have to use cpumask_* to iterate over the cpus.
  * For the first pass:
  * It returns 1 for the header position.
  * For cpu 0 it returns 2 and the final possible cpu would be nr_cpu_ids + 1.
@@ -285,6 +285,8 @@ static int timer_list_show(struct seq_fi
  * It returnes nr_cpu_ids + 1 for the second header position.
  * For cpu 0 it returns nr_cpu_ids + 2
  * The final possible cpu would be nr_cpu_ids + nr_cpu_ids + 2.
+ * It is also important to remember that cpumask_next returns >= nr_cpu_ids if
+ * no further cpus set.
  */
 static void *timer_list_start(struct seq_file *file, loff_t *offset)
 {
@@ -294,11 +296,9 @@ static void *timer_list_start(struct seq
 		return (void *) 1;
 
 	if (n < nr_cpu_ids + 1) {
-		n--;
-		if (n > 0)
-			n = cpumask_next(n - 1, cpu_online_mask);
-		else
-			n = cpumask_first(cpu_online_mask);
+		n = cpumask_next(n - 2, cpu_online_mask);
+		if (n >= nr_cpu_ids)
+			n = nr_cpu_ids;
 		*offset = n + 1;
 		return (void *)(unsigned long)(n + 2);
 	}
@@ -309,10 +309,9 @@ static void *timer_list_start(struct seq
 
 	if (n < nr_cpu_ids * 2 + 2) {
 		n -= (nr_cpu_ids + 2);
-		if (n > 0)
-			n = cpumask_next(n - 1, cpu_online_mask);
-		else
-			n = cpumask_first(cpu_online_mask);
+		n = cpumask_next(n - 1, cpu_online_mask);
+		if (n >= nr_cpu_ids)
+			return NULL;
 		*offset = n + 2 + nr_cpu_ids;
 		return (void *)(unsigned long)(n + 3 + nr_cpu_ids);
 	}
_

Patches currently in -mm which might be from nzimmer@sgi.com are

linux-next.patch
sound-convert-snd_info_register-to-use-proc_create_data.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-split-timer_list_show_tickdevices-v4.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
procfs-improve-scaling-in-proc.patch
procfs-improve-scaling-in-proc-v5.patch

