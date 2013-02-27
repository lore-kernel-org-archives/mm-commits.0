From: akpm@linux-foundation.org
Subject: + timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch added to -mm tree
Date: Wed, 27 Feb 2013 13:55:56 -0800
Message-ID: <20130227215557.50E8C5A40AC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39746 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3B0Vz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 16:55:58 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so120519ggi.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 13:55:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, sboyd@codeaurora.org, tglx@linutronix.de


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v3
has been added to the -mm tree.  Its filename is
     timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch

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
@@ -277,8 +277,8 @@ static int timer_list_show(struct seq_fi
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
@@ -286,6 +286,8 @@ static int timer_list_show(struct seq_fi
  * It returnes nr_cpu_ids + 1 for the second header position.
  * For cpu 0 it returns nr_cpu_ids + 2
  * The final possible cpu would be nr_cpu_ids + nr_cpu_ids + 2.
+ * It is also important to remember that cpumask_next returns >= nr_cpu_ids if
+ * no further cpus set.
  */
 static void *timer_list_start(struct seq_file *file, loff_t *offset)
 {
@@ -295,11 +297,9 @@ static void *timer_list_start(struct seq
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
@@ -310,10 +310,9 @@ static void *timer_list_start(struct seq
 
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

origin.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch
procfs-improve-scaling-in-proc.patch

