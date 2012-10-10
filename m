From: akpm@linux-foundation.org
Subject: + nohz-fix-idle-ticks-in-cpu-summary-line-of-proc-stat.patch added to -mm tree
Date: Wed, 10 Oct 2012 13:58:55 -0700
Message-ID: <20121010205856.2A38E5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:36044 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2JJU67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 16:58:59 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so69080fae.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 13:58:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, schwidefsky@de.ibm.com, srivatsa.bhat@linux.vnet.ibm.com, stable@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: nohz: fix idle ticks in cpu summary line of /proc/stat
has been added to the -mm tree.  Its filename is
     nohz-fix-idle-ticks-in-cpu-summary-line-of-proc-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: nohz: fix idle ticks in cpu summary line of /proc/stat

Commit 09a1d34f8535ecf9 ("nohz: Make idle/iowait counter update
conditional") introduced a bug in regard to cpu hotplug.  The effect is
that the number of idle ticks in the cpu summary line in /proc/stat is
still counting ticks for offline cpus.

Reproduction is easy, just start a workload that keeps all cpus busy,
switch off one or more cpus and then watch the idle field in top.  On a
dual-core with one cpu 100% busy and one offline cpu you will get
something like this:

%Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,
%0.0 st

The problem is that an offline cpu still has ts->idle_active == 1.  To fix
this we should make sure that the cpu is online when calling
get_cpu_idle_time_us and get_cpu_iowait_time_us.

[srivatsa.bhat@linux.vnet.ibm.com: rebased to current mainline]
Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/proc/stat.c~nohz-fix-idle-ticks-in-cpu-summary-line-of-proc-stat fs/proc/stat.c
--- a/fs/proc/stat.c~nohz-fix-idle-ticks-in-cpu-summary-line-of-proc-stat
+++ a/fs/proc/stat.c
@@ -45,10 +45,13 @@ static cputime64_t get_iowait_time(int c
 
 static u64 get_idle_time(int cpu)
 {
-	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
+	u64 idle, idle_time = -1ULL;
+
+	if (cpu_online(cpu))
+		idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL)
-		/* !NO_HZ so we can rely on cpustat.idle */
+		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
 	else
 		idle = usecs_to_cputime64(idle_time);
@@ -58,10 +61,13 @@ static u64 get_idle_time(int cpu)
 
 static u64 get_iowait_time(int cpu)
 {
-	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+	u64 iowait, iowait_time = -1ULL;
+
+	if (cpu_online(cpu))
+		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
 
 	if (iowait_time == -1ULL)
-		/* !NO_HZ so we can rely on cpustat.iowait */
+		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
 		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	else
 		iowait = usecs_to_cputime64(iowait_time);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
nohz-fix-idle-ticks-in-cpu-summary-line-of-proc-stat.patch
mm-memblock-reduce-overhead-in-binary-search.patch

