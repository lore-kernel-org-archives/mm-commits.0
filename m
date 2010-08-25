From: akpm@linux-foundation.org
Subject: + procfs-fix-proc-softirqs-formatting.patch added to -mm tree
Date: Wed, 25 Aug 2010 16:00:24 -0700
Message-ID: <201008252300.o7PN0O8n020761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490Ab0HYXAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 19:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@gnu.org, kobayashi.kk@ncos.nec.co.jp


The patch titled
     procfs: fix /proc/softirqs formatting
has been added to the -mm tree.  Its filename is
     procfs-fix-proc-softirqs-formatting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: fix /proc/softirqs formatting
From: Davidlohr Bueso <dave@gnu.org>

The length of the BLOCK_IPOLL string is making i's value be printed too
far to the right.  This patch fixes this and makes the output a bit
neater.

Currently:
                CPU0
      HI:          0
   TIMER:     599792
  NET_TX:          2
  NET_RX:          6
   BLOCK:      80807
BLOCK_IOPOLL:          0
 TASKLET:      20012
   SCHED:          0
 HRTIMER:         63
     RCU:     619279

With patch:
                    CPU0
          HI:          0
       TIMER:     585582
      NET_TX:          2
      NET_RX:          6
       BLOCK:      80320
BLOCK_IOPOLL:          0
     TASKLET:      19287
       SCHED:          0
     HRTIMER:         62
         RCU:     604441

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Acked-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/softirqs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/softirqs.c~procfs-fix-proc-softirqs-formatting fs/proc/softirqs.c
--- a/fs/proc/softirqs.c~procfs-fix-proc-softirqs-formatting
+++ a/fs/proc/softirqs.c
@@ -10,13 +10,13 @@ static int show_softirqs(struct seq_file
 {
 	int i, j;
 
-	seq_printf(p, "                ");
+	seq_printf(p, "                    ");
 	for_each_possible_cpu(i)
 		seq_printf(p, "CPU%-8d", i);
 	seq_printf(p, "\n");
 
 	for (i = 0; i < NR_SOFTIRQS; i++) {
-		seq_printf(p, "%8s:", softirq_to_name[i]);
+		seq_printf(p, "%12s:", softirq_to_name[i]);
 		for_each_possible_cpu(j)
 			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
 		seq_printf(p, "\n");
_

Patches currently in -mm which might be from dave@gnu.org are

procfs-fix-proc-softirqs-formatting.patch

