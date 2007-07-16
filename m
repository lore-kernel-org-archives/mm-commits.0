From: akpm@linux-foundation.org
Subject: - use-boot-based-time-for-uptime-in-proc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:06 -0700
Message-ID: <200707162053.l6GKr6es001598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760600AbXGPVXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:23:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tjanouse@redhat.com, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use boot based time for uptime in /proc
has been removed from the -mm tree.  Its filename was
     use-boot-based-time-for-uptime-in-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use boot based time for uptime in /proc
From: Tomas Janousek <tjanouse@redhat.com>

Commit 411187fb05cd11676b0979d9fbf3291db69dbce2 caused uptime not to increase
during suspend.  This may cause confusion so I restore the old behaviour by
using the boot based time instead of monotonic for uptime.

Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    1 +
 kernel/timer.c      |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/proc/proc_misc.c~use-boot-based-time-for-uptime-in-proc fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~use-boot-based-time-for-uptime-in-proc
+++ a/fs/proc/proc_misc.c
@@ -105,6 +105,7 @@ static int uptime_read_proc(char *page, 
 	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
 
 	do_posix_clock_monotonic_gettime(&uptime);
+	monotonic_to_bootbased(&uptime);
 	cputime_to_timespec(idletime, &idle);
 	len = sprintf(page,"%lu.%02lu %lu.%02lu\n",
 			(unsigned long) uptime.tv_sec,
diff -puN kernel/timer.c~use-boot-based-time-for-uptime-in-proc kernel/timer.c
--- a/kernel/timer.c~use-boot-based-time-for-uptime-in-proc
+++ a/kernel/timer.c
@@ -1114,6 +1114,7 @@ int do_sysinfo(struct sysinfo *info)
 		getnstimeofday(&tp);
 		tp.tv_sec += wall_to_monotonic.tv_sec;
 		tp.tv_nsec += wall_to_monotonic.tv_nsec;
+		monotonic_to_bootbased(&tp);
 		if (tp.tv_nsec - NSEC_PER_SEC >= 0) {
 			tp.tv_nsec = tp.tv_nsec - NSEC_PER_SEC;
 			tp.tv_sec++;
_

Patches currently in -mm which might be from tjanouse@redhat.com are

origin.patch
