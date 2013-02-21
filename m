From: akpm@linux-foundation.org
Subject: [folded-merged] timer_list-convert-timer-list-to-be-a-proper-seq_file-v2.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:07:35 -0800
Message-ID: <20130221230735.E444031C1B7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50712 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3BUXHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:07:37 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so9647yhz.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:07:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2
has been removed from the -mm tree.  Its filename was
     timer_list-convert-timer-list-to-be-a-proper-seq_file-v2.patch

This patch was dropped because it was folded into timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

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
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch

