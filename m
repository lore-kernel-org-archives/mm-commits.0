From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-microcode_corec-do-not-warn_oncpu-=-0-during-resume.patch added to -mm tree
Date: Tue, 08 Feb 2011 14:04:37 -0800
Message-ID: <201102082204.p18M4bqc028043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586Ab1BHWE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 17:04:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian.campbell@citrix.com, anton@redhat.com, dmitry.adamushko@gmail.com, hugh@veritas.com, jeremy@goop.org, mingo@elte.hu


The patch titled
     arch/x86/kernel/microcode_core.c: do not WARN_ON(cpu != 0) during resume
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-microcode_corec-do-not-warn_oncpu-=-0-during-resume.patch

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
Subject: arch/x86/kernel/microcode_core.c: do not WARN_ON(cpu != 0) during resume
From: Ian Campbell <ian.campbell@citrix.com>

871b72dd "x86: microcode: use smp_call_function_single instead of
set_cpus_allowed, cleanup of synchronization logic" included:

 static int mc_sysdev_resume(struct sys_device *dev)
 {
[...]
+       /*
+        * All non-bootup cpus are still disabled,
+        * so only CPU 0 will apply ucode here.
+        *
+        * Moreover, there can be no concurrent
+        * updates from any other places at this point.
+        */
+       WARN_ON(cpu != 0);

However suspend/resume under Xen doesn't need to hot unplug all the CPUs,
so we don't; the hypervisor can manage the context save/restore for all
CPUs.

It would be unnecessary to load microcode.ko in a Xen domU but if it does
occur (e.g.  because a distro installs the tools by default) we would like
to avoid the warning on resume.

Since the real constraint here is that we are running on the CPU for which
we would like to load microcode (which in all practical circumstances is
CPU0) just check for that and return if we are resuming a different CPU.

There is no danger of concurrent updates, even if we ignore the fact that
all but one CPUs are unplugged on native, because sysdev_resume() is
single threaded.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Anton Arapov <anton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/microcode_core.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/x86/kernel/microcode_core.c~arch-x86-kernel-microcode_corec-do-not-warn_oncpu-=-0-during-resume arch/x86/kernel/microcode_core.c
--- a/arch/x86/kernel/microcode_core.c~arch-x86-kernel-microcode_corec-do-not-warn_oncpu-=-0-during-resume
+++ a/arch/x86/kernel/microcode_core.c
@@ -441,18 +441,9 @@ static int mc_sysdev_resume(struct sys_d
 	int cpu = dev->id;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	if (!cpu_online(cpu))
+	if (cpu != smp_processor_id())
 		return 0;
 
-	/*
-	 * All non-bootup cpus are still disabled,
-	 * so only CPU 0 will apply ucode here.
-	 *
-	 * Moreover, there can be no concurrent
-	 * updates from any other places at this point.
-	 */
-	WARN_ON(cpu != 0);
