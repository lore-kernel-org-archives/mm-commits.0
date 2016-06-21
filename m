From: akpm@linux-foundation.org
Subject: + procfs-avoid-32-bit-time_t-in-proc-stat.patch added to -mm tree
Date: Tue, 21 Jun 2016 16:24:16 -0700
Message-ID: <5769cca0.EsJky25rkdyHkx0P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbcFUXYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 19:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: avoid 32-bit time_t in /proc/*/stat
has been added to the -mm tree.  Its filename is
     procfs-avoid-32-bit-time_t-in-proc-stat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-avoid-32-bit-time_t-in-proc-stat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-avoid-32-bit-time_t-in-proc-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: procfs: avoid 32-bit time_t in /proc/*/stat

/proc/stat shows (among lots of other things) the current boottime (i.e. 
number of seconds since boot).  While a 32-bit number is sufficient for
this particular case, we want to get rid of the 'struct timespec' suffers
from a 32-bit overflow in 2038.

This changes the code to use a struct timespec64, which is known to
be safe in all cases.

Link: http://lkml.kernel.org/r/20160617201247.2292101-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/proc/stat.c~procfs-avoid-32-bit-time_t-in-proc-stat fs/proc/stat.c
--- a/fs/proc/stat.c~procfs-avoid-32-bit-time_t-in-proc-stat
+++ a/fs/proc/stat.c
@@ -80,19 +80,17 @@ static u64 get_iowait_time(int cpu)
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
-	unsigned long jif;
 	u64 user, nice, system, idle, iowait, irq, softirq, steal;
 	u64 guest, guest_nice;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
-	struct timespec boottime;
+	struct timespec64 boottime;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = 0;
 	guest = guest_nice = 0;
-	getboottime(&boottime);
-	jif = boottime.tv_sec;
+	getboottime64(&boottime);
 
 	for_each_possible_cpu(i) {
 		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
@@ -163,12 +161,12 @@ static int show_stat(struct seq_file *p,
 
 	seq_printf(p,
 		"\nctxt %llu\n"
-		"btime %lu\n"
+		"btime %llu\n"
 		"processes %lu\n"
 		"procs_running %lu\n"
 		"procs_blocked %lu\n",
 		nr_context_switches(),
-		(unsigned long)jif,
+		(unsigned long long)boottime.tv_sec,
 		total_forks,
 		nr_running(),
 		nr_iowait());
_

Patches currently in -mm which might be from arnd@arndb.de are

procfs-avoid-32-bit-time_t-in-proc-stat.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch

