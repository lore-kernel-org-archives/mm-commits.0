From: akpm@linux-foundation.org
Subject: + procfs-use-more-apprioriate-types-when-dumping-proc-n-stat.patch added to -mm tree
Date: Thu, 19 Apr 2012 13:12:24 -0700
Message-ID: <20120419201224.63F72A0333@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:38982 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2DSUM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 16:12:26 -0400
Received: by lbol12 with SMTP id l12so241972lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 13:12:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@medozas.de


The patch titled
     Subject: procfs: use more apprioriate types when dumping /proc/N/stat
has been added to the -mm tree.  Its filename is
     procfs-use-more-apprioriate-types-when-dumping-proc-n-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Engelhardt <jengelh@medozas.de>
Subject: procfs: use more apprioriate types when dumping /proc/N/stat

- use int fpr priority and nice, since task_nice()/task_prio() return that

- field 24: get_mm_rss() returns unsigned long

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/array.c~procfs-use-more-apprioriate-types-when-dumping-proc-n-stat fs/proc/array.c
--- a/fs/proc/array.c~procfs-use-more-apprioriate-types-when-dumping-proc-n-stat
+++ a/fs/proc/array.c
@@ -361,7 +361,7 @@ static int do_task_stat(struct seq_file 
 			struct pid *pid, struct task_struct *task, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
-	long priority, nice;
+	int priority, nice;
 	int tty_pgrp = -1, tty_nr = 0;
 	sigset_t sigign, sigcatch;
 	char state;
@@ -483,7 +483,7 @@ static int do_task_stat(struct seq_file 
 	seq_put_decimal_ull(m, ' ', 0);
 	seq_put_decimal_ull(m, ' ', start_time);
 	seq_put_decimal_ull(m, ' ', vsize);
-	seq_put_decimal_ll(m, ' ', mm ? get_mm_rss(mm) : 0);
+	seq_put_decimal_ull(m, ' ', mm ? get_mm_rss(mm) : 0);
 	seq_put_decimal_ull(m, ' ', rsslim);
 	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->start_code : 1) : 0);
 	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->end_code : 1) : 0);
_
Subject: Subject: procfs: use more apprioriate types when dumping /proc/N/stat

Patches currently in -mm which might be from jengelh@medozas.de are

procfs-use-more-apprioriate-types-when-dumping-proc-n-stat.patch

