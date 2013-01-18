From: akpm@linux-foundation.org
Subject: + sched-proc-sched_debug-fails-on-very-very-large-machines-v2.patch added to -mm tree
Date: Fri, 18 Jan 2013 13:46:25 -0800
Message-ID: <20130118214625.AB1EE5A41FB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:49090 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3ARVq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Jan 2013 16:46:27 -0500
Received: by mail-ob0-f201.google.com with SMTP id ef5so1028817obb.2
        for <mm-commits@vger.kernel.org>; Fri, 18 Jan 2013 13:46:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, davej@redhat.com, mingo@redhat.com, peterz@infradead.org


The patch titled
     Subject: sched-proc-sched_debug-fails-on-very-very-large-machines-v2
has been added to the -mm tree.  Its filename is
     sched-proc-sched_debug-fails-on-very-very-large-machines-v2.patch

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
Subject: sched-proc-sched_debug-fails-on-very-very-large-machines-v2

v2: Took suggetion for adding comments

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/debug.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/sched/debug.c~sched-proc-sched_debug-fails-on-very-very-large-machines-v2 kernel/sched/debug.c
--- a/kernel/sched/debug.c~sched-proc-sched_debug-fails-on-very-very-large-machines-v2
+++ a/kernel/sched/debug.c
@@ -413,6 +413,13 @@ void sysrq_sched_debug_show(void)
 
 }
 
+/*
+ * This itererator needs some explination.
+ * It returns 1 for the header position.
+ * This means 2 is cpu 0.
+ * In a hotplugged system some cpus, including cpu 0, may be missing so we have
+ * to use cpumask_* to iterate over the cpus.
+ */
 static void *sched_debug_start(struct seq_file *file, loff_t *offset)
 {
 	unsigned long n = *offset;
_

Patches currently in -mm which might be from nzimmer@sgi.com are

timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2.patch

