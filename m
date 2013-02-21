From: akpm@linux-foundation.org
Subject: [folded-merged] timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:07:41 -0800
Message-ID: <20130221230741.E96E65A424D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:62996 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3BUXHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:07:43 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so9517yen.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:07:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, johnstul@us.ibm.com, nzimmer@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix
has been removed from the -mm tree.  Its filename was
     timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch

This patch was dropped because it was folded into timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix

kernel/time/timer_list.c: In function 'timer_list_show':
kernel/time/timer_list.c:262: warning: cast to pointer from integer of different size
kernel/time/timer_list.c:267: warning: cast to pointer from integer of different size
kernel/time/timer_list.c: In function 'timer_list_start':
kernel/time/timer_list.c:297: warning: cast to pointer from integer of different size

This code is revolting :(

Cc: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix
+++ a/kernel/time/timer_list.c
@@ -259,12 +259,12 @@ static int timer_list_show(struct seq_fi
 			   HRTIMER_MAX_CLOCK_BASES);
 		SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 		SEQ_printf(m, "\n");
-	} else if (v < (void *)(nr_cpu_ids + 2)) {
+	} else if (v < (void *)(unsigned long)(nr_cpu_ids + 2)) {
 		cpu = (unsigned long)(v - 2);
 		print_cpu(m, cpu, now);
 	}
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-	else if (v == (void *)nr_cpu_ids + 2) {
+	else if (v == (void *)(unsigned long)nr_cpu_ids + 2) {
 		timer_list_show_tickdevices_header(m);
 	} else {
 		cpu = (unsigned long)(v - 3 - nr_cpu_ids);
@@ -306,7 +306,7 @@ static void *timer_list_start(struct seq
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 	if (n == nr_cpu_ids + 1)
-		return (void *) (nr_cpu_ids + 2);
+		return (void *)(unsigned long)(nr_cpu_ids + 2);
 
 	if (n < nr_cpu_ids * 2 + 2) {
 		n -= (nr_cpu_ids + 2);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

