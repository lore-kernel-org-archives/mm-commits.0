From: akpm@linux-foundation.org
Subject: [folded] proc-export-statistics-for-softirq-to-proc-update.patch removed from -mm tree
Date: Wed, 17 Jun 2009 13:05:03 -0700
Message-ID: <200906172005.n5HK53r8019994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbZFQUF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 16:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kobayashi.kk@ncos.nec.co.jp, adobriyan@gmail.com, dada1@cosmosbay.com, h-shimamoto@ct.jp.nec.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     proc-export-statistics-for-softirq-to-proc-update
has been removed from the -mm tree.  Its filename was
     proc-export-statistics-for-softirq-to-proc-update.patch

This patch was dropped because it was folded into proc-export-statistics-for-softirq-to-proc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-export-statistics-for-softirq-to-proc-update
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

Regarding /proc/softirq,
Ingo pointed out the difference from /proc/interrupts style.
# Thank you!
So, I inserted colon between softirq name and its statistics.

Here is update patch.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/softirqs.c |   15 +--------------
 fs/proc/stat.c     |    4 +---
 2 files changed, 2 insertions(+), 17 deletions(-)

diff -puN fs/proc/softirqs.c~proc-export-statistics-for-softirq-to-proc-update fs/proc/softirqs.c
--- a/fs/proc/softirqs.c~proc-export-statistics-for-softirq-to-proc-update
+++ a/fs/proc/softirqs.c
@@ -3,19 +3,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
-static const char *desc_array[] = {
-	"HI",
-	"TIMER",
-	"NET_TX",
-	"NET_RX",
-	"BLOCK",
-	"TASKLET",
-	"SCHED",
-#ifdef CONFIG_HIGH_RES_TIMERS
-	"HRTIMER",
-#endif
-	"RCU"};
-
 /*
  * /proc/softirqs  ... display the number of softirqs
  */
@@ -29,7 +16,7 @@ static int show_softirqs(struct seq_file
 	seq_printf(p, "\n");
 
 	for (i = 0; i < NR_SOFTIRQS; i++) {
-		seq_printf(p, "%-9s", desc_array[i]);
+		seq_printf(p, "%8s:", softirq_to_name[i]);
 		for_each_possible_cpu(j)
 			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
 		seq_printf(p, "\n");
diff -puN fs/proc/stat.c~proc-export-statistics-for-softirq-to-proc-update fs/proc/stat.c
--- a/fs/proc/stat.c~proc-export-statistics-for-softirq-to-proc-update
+++ a/fs/proc/stat.c
@@ -62,7 +62,6 @@ static int show_stat(struct seq_file *p,
 			per_softirq_sums[j] += softirq_stat;
 			sum_softirq += softirq_stat;
 		}
