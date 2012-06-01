From: akpm@linux-foundation.org
Subject: [merged] procfs-use-more-apprioriate-types-when-dumping-proc-n-stat.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:58 -0700
Message-ID: <20120601193358.592F0A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:32783 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090Ab2FATd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:59 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so140395wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@medozas.de, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: use more apprioriate types when dumping /proc/N/stat
has been removed from the -mm tree.  Its filename was
     procfs-use-more-apprioriate-types-when-dumping-proc-n-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -370,7 +370,7 @@ static int do_task_stat(struct seq_file 
 			struct pid *pid, struct task_struct *task, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
-	long priority, nice;
+	int priority, nice;
 	int tty_pgrp = -1, tty_nr = 0;
 	sigset_t sigign, sigcatch;
 	char state;
@@ -492,7 +492,7 @@ static int do_task_stat(struct seq_file 
 	seq_put_decimal_ull(m, ' ', 0);
 	seq_put_decimal_ull(m, ' ', start_time);
 	seq_put_decimal_ull(m, ' ', vsize);
-	seq_put_decimal_ll(m, ' ', mm ? get_mm_rss(mm) : 0);
+	seq_put_decimal_ull(m, ' ', mm ? get_mm_rss(mm) : 0);
 	seq_put_decimal_ull(m, ' ', rsslim);
 	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->start_code : 1) : 0);
 	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->end_code : 1) : 0);
_

Patches currently in -mm which might be from jengelh@medozas.de are

origin.patch

