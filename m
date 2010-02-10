From: akpm@linux-foundation.org
Subject: + kernel-core-use-helpers-for-rlimits-fix.patch added to -mm tree
Date: Wed, 10 Feb 2010 12:10:59 -0800
Message-ID: <201002102010.o1AKAx08028708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701Ab0BJULm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Feb 2010 15:11:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, mingo@elte.hu


The patch titled
     kernel-core-use-helpers-for-rlimits-fix
has been added to the -mm tree.  Its filename is
     kernel-core-use-helpers-for-rlimits-fix.patch

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
@@ -827,6 +827,8 @@ void __cleanup_sighand(struct sighand_st
  */
 static void posix_cpu_timers_init_group(struct signal_struct *sig)
 {
+	unsigned long cpu_limit;
+
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
@@ -841,9 +843,9 @@ static void posix_cpu_timers_init_group(
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

linux-next.patch
gpu-drm-i915-fix-potential-null-dereference.patch
infiniband-use-rlimit-helpers.patch
mtd-chips-cfi-remove-unneeded-null-checks.patch
video-backlight-progear-fix-pci-device-refcounting.patch
mm-use-rlimit-helpers.patch
bootmem-avoid-dma32-zone-by-default.patch
fs-use-rlimit-helpers.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
kernel-core-use-helpers-for-rlimits-fix.patch
ipc-use-rlimit-helpers.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

