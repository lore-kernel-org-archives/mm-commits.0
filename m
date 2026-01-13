Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D08730C629
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280976; cv=none; b=Re09Tc3dmnG7l0+E+lL2yBTXNfMZBGCSzi2Abg3JWUSA0is8ImHp5t4Hfai+Om+mH/KVTWE/rxC+ehX2dZv9z1rGVysyR5BssI/4/584leIM4/iT6RPkjUfhl6rLQO/vwff2/jh35wcD4krCq5NZo77BJxJDGA8Ykebo0PUfpKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280976; c=relaxed/simple;
	bh=suAR4xzO414OSDTXVoYPxGWGTfG8i8pIxjlCO359O+E=;
	h=Date:To:From:Subject:Message-Id; b=OZOnpAUhYgBamLAHHesD7R9PPxJV+trVsLN7UM9kWQp4LGXR44YH6rc8BFJSMXQZkKtNH7etOMT1TFsPzHu3M+0tzfBPFQARsv96ACJ2zNi5Fz1Jwjb9MAgZMsJtrOn0fti9wLtlx6DYpx9l4M+ybVqH51RpxTF9cdgmlWsvphE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bfgF8/EU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bfgF8/EU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E8EC116C6;
	Tue, 13 Jan 2026 05:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280976;
	bh=suAR4xzO414OSDTXVoYPxGWGTfG8i8pIxjlCO359O+E=;
	h=Date:To:From:Subject:From;
	b=bfgF8/EUUiv+aVmBtxHEHxuqQufhiZbNFa+U3NHkuPG0KjrGWumUoJeHD/vvJGjUy
	 tvF4EcC3U2v/etGZOBUGQ9KIxx2Erf03aiy0RD71YyMv2rKnzfwYEQo5wyxabV1rTp
	 wf7wBNeASF7w3wM7ibDi40P/tk32WLTNfL4nOVNA=
Date: Mon, 12 Jan 2026 21:09:35 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,lkp@intel.com,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] powerpc-watchdog-add-support-for-hardlockup_sys_info-sysctl.patch removed from -mm tree
Message-Id: <20260113050935.E3E8EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/watchdog: add support for hardlockup_sys_info sysctl
has been removed from the -mm tree.  Its filename was
     powerpc-watchdog-add-support-for-hardlockup_sys_info-sysctl.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Petr Mladek <pmladek@suse.com>
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


