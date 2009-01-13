From: akpm@linux-foundation.org
Subject: + proc-export-statistics-for-softirq-to-proc-fix.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:22:50 -0800
Message-ID: <200901132222.n0DMMoRu026594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104AbZAMWXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:23:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com, dada1@cosmosbay.com, h-shimamoto@ct.jp.nec.com, kobayashi.kk@ncos.nec.co.jp, mingo@elte.hu


The patch titled
     proc: remove redundunt for_each_possible_cpu() loop
has been added to the -mm tree.  Its filename is
     proc-export-statistics-for-softirq-to-proc-fix.patch

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
Subject: proc: remove redundunt for_each_possible_cpu() loop
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Distros will set NR_CPUS to very large number and at that time
for_each_possible_cpu() is a bit costly.

Therefore, To remove unnecessary twice loop is better.

Note. we can remove softirq's redundunt loop, but we can't remove irq's.
because NR_SOFTIRQS ~= 10, NR_IRQS ~= 4000 (in x86 case).

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/proc/stat.c~proc-export-statistics-for-softirq-to-proc-fix fs/proc/stat.c
--- a/fs/proc/stat.c~proc-export-statistics-for-softirq-to-proc-fix
+++ a/fs/proc/stat.c
@@ -27,6 +27,7 @@ static int show_stat(struct seq_file *p,
 	cputime64_t guest;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
+	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
 	unsigned int per_irq_sum;
 
@@ -51,8 +52,12 @@ static int show_stat(struct seq_file *p,
 		}
 		sum += arch_irq_stat_cpu(i);
 
-		for (j = 0; j < NR_SOFTIRQS; j++)
-			sum_softirq += kstat_softirqs_cpu(j, i);
+		for (j = 0; j < NR_SOFTIRQS; j++) {
+			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
+
+			per_softirq_sums[j] += softirq_stat;
+			sum_softirq += softirq_stat;
+		}
 
 	}
 	sum += arch_irq_stat();
@@ -118,12 +123,7 @@ static int show_stat(struct seq_file *p,
 	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
 
 	for (i = 0; i < NR_SOFTIRQS; i++) {
-		per_irq_sum = 0;
-
-		for_each_possible_cpu(j)
-			per_irq_sum += kstat_softirqs_cpu(i, j);
