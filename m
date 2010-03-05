From: akpm@linux-foundation.org
Subject: [folded] kernel-core-use-helpers-for-rlimits-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:21:55 -0800
Message-ID: <201003052121.o25LLtuJ028353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755377Ab0CEVWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:22:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel-core-use-helpers-for-rlimits-fix
has been removed from the -mm tree.  Its filename was
     kernel-core-use-helpers-for-rlimits-fix.patch

This patch was dropped because it was folded into kernel-core-use-helpers-for-rlimits.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-core-use-helpers-for-rlimits-fix
From: Jiri Slaby <jslaby@suse.cz>

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/fork.c~kernel-core-use-helpers-for-rlimits-fix kernel/fork.c
--- a/kernel/fork.c~kernel-core-use-helpers-for-rlimits-fix
+++ a/kernel/fork.c
@@ -828,6 +828,8 @@ void __cleanup_sighand(struct sighand_st
  */
 static void posix_cpu_timers_init_group(struct signal_struct *sig)
 {
+	unsigned long cpu_limit;
+
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
@@ -842,9 +844,9 @@ static void posix_cpu_timers_init_group(
 	sig->cputime_expires.virt_exp = cputime_zero;
 	sig->cputime_expires.sched_exp = 0;
 
-	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
-		sig->cputime_expires.prof_exp =
-			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
+	if (cpu_limit != RLIM_INFINITY) {
+		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
 		sig->cputimer.running = 1;
 	}
 
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
kernel-core-use-helpers-for-rlimits-fix.patch

