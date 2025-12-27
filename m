Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035AD2472BA
	for <mm-commits@vger.kernel.org>; Thu,  1 Jan 2026 02:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767233506; cv=none; b=UEq1LTcH892xhgzTCWKoQa+bbiLF8R8EBQIRLekJP87hqFediUh+1wZp8t7H6fUK93CPyQo54dGyx9InsPKTRbvjZ7kPyhbSD+t68UUC2YCn2V4gTktQljJ3e/FUQ7plJiRTIm0Y9UvF6QwBmj1mEPmdbNh/Z33hacQmPQf235c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767233506; c=relaxed/simple;
	bh=bDP52Oie9mG+MZJGM9DQtMWLAJNj2RYr+OHuX4ObLOo=;
	h=Date:To:From:Subject:Message-Id; b=tWzivYXa3NpSpv3cx9UMxAhdguxpI4Ppvea92o63Zo2I89v9pEcwNI57qEpFPyZBClC/PQ/8MWnXYW3XtpAmORsiR4hk5koKatIc844aZlZSZcL2QeXtG0cHSbjVLeR4IqOlNTFVndsUWuFRQVz3UbntjT0sUnaT13p4o9YVD2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OCvEFycy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OCvEFycy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832B5C113D0;
	Thu,  1 Jan 2026 02:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767233505;
	bh=bDP52Oie9mG+MZJGM9DQtMWLAJNj2RYr+OHuX4ObLOo=;
	h=Date:To:From:Subject:From;
	b=OCvEFycyvGbB8sahrlC1TDI7kJxh/mn0hDLdz7gmKlPcjaApEu6Y1vjabgcQujZaW
	 IIZiUA7WQyHhkk5nMzN1ABShMpo1i0vAFJ/XUJbF4t1StlrrG9EflBw3UWTBeYskvS
	 S+NtWl52XF1vILOiNwpax4bZ4Z8uPZG1FW/F0vEU=
Date: Wed, 31 Dec 2025 18:11:44 +9900
To: mm-commits@vger.kernel.org,pmladek@suse.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,lkp@intel.com,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-watchdog-add-support-for-hardlockup_sys_info-sysctl.patch added to mm-hotfixes-unstable branch
Message-Id: <20260101021145.832B5C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/watchdog: add support for hardlockup_sys_info sysctl
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     powerpc-watchdog-add-support-for-hardlockup_sys_info-sysctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-watchdog-add-support-for-hardlockup_sys_info-sysctl.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: powerpc/watchdog: add support for hardlockup_sys_info sysctl
Date: Wed, 31 Dec 2025 16:03:09 +0800

Commit a9af76a78760 ("watchdog: add sys_info sysctls to dump sys info on
system lockup") adds 'hardlock_sys_info' systcl knob for general kernel
watchdog to control what kinds of system debug info to be dumped on
hardlockup.

Add similar support in powerpc watchdog code to make the sysctl knob more
general, which also fixes a compiling warning in general watchdog code
reported by 0day bot.

Link: https://lkml.kernel.org/r/20251231080309.39642-1-feng.tang@linux.alibaba.com
Fixes: a9af76a78760 ("watchdog: add sys_info sysctls to dump sys info on system lockup")
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512030920.NFKtekA7-lkp@intel.com/
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/watchdog.c |   15 ++++++++++-----
 include/linux/nmi.h            |    1 +
 kernel/watchdog.c              |    2 +-
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kernel/watchdog.c~powerpc-watchdog-add-support-for-hardlockup_sys_info-sysctl
+++ a/arch/powerpc/kernel/watchdog.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/processor.h>
 #include <linux/smp.h>
+#include <linux/sys_info.h>
 
 #include <asm/interrupt.h>
 #include <asm/paca.h>
@@ -235,7 +236,11 @@ static void watchdog_smp_panic(int cpu)
 	pr_emerg("CPU %d TB:%lld, last SMP heartbeat TB:%lld (%lldms ago)\n",
 		 cpu, tb, last_reset, tb_to_ns(tb - last_reset) / 1000000);
 
-	if (!sysctl_hardlockup_all_cpu_backtrace) {
+	if (sysctl_hardlockup_all_cpu_backtrace ||
+	    (hardlockup_si_mask & SYS_INFO_ALL_BT)) {
+		trigger_allbutcpu_cpu_backtrace(cpu);
+		cpumask_clear(&wd_smp_cpus_ipi);
+	} else {
 		/*
 		 * Try to trigger the stuck CPUs, unless we are going to
 		 * get a backtrace on all of them anyway.
@@ -244,11 +249,9 @@ static void watchdog_smp_panic(int cpu)
 			smp_send_nmi_ipi(c, wd_lockup_ipi, 1000000);
 			__cpumask_clear_cpu(c, &wd_smp_cpus_ipi);
 		}
-	} else {
-		trigger_allbutcpu_cpu_backtrace(cpu);
-		cpumask_clear(&wd_smp_cpus_ipi);
 	}
 
+	sys_info(hardlockup_si_mask & ~SYS_INFO_ALL_BT);
 	if (hardlockup_panic)
 		nmi_panic(NULL, "Hard LOCKUP");
 
@@ -415,9 +418,11 @@ DEFINE_INTERRUPT_HANDLER_NMI(soft_nmi_in
 
 		xchg(&__wd_nmi_output, 1); // see wd_lockup_ipi
 
-		if (sysctl_hardlockup_all_cpu_backtrace)
+		if (sysctl_hardlockup_all_cpu_backtrace ||
+		    (hardlockup_si_mask & SYS_INFO_ALL_BT))
 			trigger_allbutcpu_cpu_backtrace(cpu);
 
+		sys_info(hardlockup_si_mask & ~SYS_INFO_ALL_BT);
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
 
--- a/include/linux/nmi.h~powerpc-watchdog-add-support-for-hardlockup_sys_info-sysctl
+++ a/include/linux/nmi.h
@@ -83,6 +83,7 @@ static inline void reset_hung_task_detec
 #if defined(CONFIG_HARDLOCKUP_DETECTOR)
 extern void hardlockup_detector_disable(void);
 extern unsigned int hardlockup_panic;
+extern unsigned long hardlockup_si_mask;
 #else
 static inline void hardlockup_detector_disable(void) {}
 #endif
--- a/kernel/watchdog.c~powerpc-watchdog-add-support-for-hardlockup_sys_info-sysctl
+++ a/kernel/watchdog.c
@@ -71,7 +71,7 @@ unsigned int __read_mostly hardlockup_pa
  * hard lockup is detected, it could be task, memory, lock etc.
  * Refer include/linux/sys_info.h for detailed bit definition.
  */
-static unsigned long hardlockup_si_mask;
+unsigned long hardlockup_si_mask;
 
 #ifdef CONFIG_SYSFS
 
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

powerpc-watchdog-add-support-for-hardlockup_sys_info-sysctl.patch

