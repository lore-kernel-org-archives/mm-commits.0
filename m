Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EC432D0EE;
	Thu, 25 Jun 2026 18:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782413050; cv=none; b=Snvv0LYteJKBZi0CabHdiVEgP0ljrTvD1q3WDOfcmFjuYdxzbeWJ+W5NBWpupy+I4GgHjP3D0oRcRvvRGP6+jCbXHEWta2xvFW88eShrHMh6/V5QFIeUj0ZQ9oIw+PWhFsPtI0XlCBHUQQ48dsbs8/aXJSv/b+VWSV4VYEI9zcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782413050; c=relaxed/simple;
	bh=n1du59NIY4XOSnycOSz6os8KLncB06yqyUpaODeQXG0=;
	h=Date:To:From:Subject:Message-Id; b=JUFiCS1yRJ37WyA/FslM+GqVJr03QbYCdvCYCyHZV0rC5Eh7hNrTIvQfggzIisas8en9oESVJQIoirVDSImbTNuAQ3n43ZtfDseXvHLgqyLnPNGQVEZR0puLWnZjnQbdVEhr1mImkHNw+ux0mEebuy+Z+/sR1ZZck3oj0ayE7Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NTncaflk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NTncaflk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D30E1F000E9;
	Thu, 25 Jun 2026 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782413048;
	bh=R3GquTMdnshInoARQtM3SEOql/kVGSbX+dy+DEtmjVU=;
	h=Date:To:From:Subject;
	b=NTncaflkE+9V7pukjVtYw357yN8m7umnjyhE6dabpVmXw4dLUWwYPeUNe1f4XD2wg
	 dcEvNiSbBlLsbttyIyhpMM9Dp6hjt4bi7QEeLPQXRWxG+bXv6bYGnwgu12qeEQBp0/
	 V3SrL9UmS49yRxSA13WRU7lxF2NpK+bVKyCxdGmg=
Date: Thu, 25 Jun 2026 11:44:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,dianders@chromium.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625184408.9D30E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/watchdog: use sys_info_with_filter() to avoid duplicate backtraces
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     powerpc-watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch

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
From: Bradley Morgan <include@grrlz.net>
Subject: powerpc/watchdog: use sys_info_with_filter() to avoid duplicate backtraces
Date: Thu, 25 Jun 2026 15:25:57 +0000

The powerpc watchdog prints all CPU backtraces itself.  When the watchdog
mask contains only SYS_INFO_ALL_BT, stripping that bit leaves zero and
sys_info(0) falls back to kernel_sys_info.

Use sys_info_with_filter() so an explicit all_bt mask does not request the
global default.

Link: https://lore.kernel.org/20260625152558.7450-4-include@grrlz.net
Fixes: a9af76a78760 ("watchdog: add sys_info sysctls to dump sys info on system lockup")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/watchdog.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/watchdog.c~powerpc-watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces
+++ a/arch/powerpc/kernel/watchdog.c
@@ -201,6 +201,7 @@ static bool set_cpu_stuck(int cpu)
 static void watchdog_smp_panic(int cpu)
 {
 	static cpumask_t wd_smp_cpus_ipi; // protected by reporting
+	unsigned long si_mask;
 	unsigned long flags;
 	u64 tb, last_reset;
 	int c;
@@ -236,8 +237,9 @@ static void watchdog_smp_panic(int cpu)
 	pr_emerg("CPU %d TB:%lld, last SMP heartbeat TB:%lld (%lldms ago)\n",
 		 cpu, tb, last_reset, tb_to_ns(tb - last_reset) / 1000000);
 
+	si_mask = READ_ONCE(hardlockup_si_mask);
 	if (sysctl_hardlockup_all_cpu_backtrace ||
-	    (hardlockup_si_mask & SYS_INFO_ALL_BT)) {
+	    (si_mask & SYS_INFO_ALL_BT)) {
 		trigger_allbutcpu_cpu_backtrace(cpu);
 		cpumask_clear(&wd_smp_cpus_ipi);
 	} else {
@@ -251,7 +253,7 @@ static void watchdog_smp_panic(int cpu)
 		}
 	}
 
-	sys_info(hardlockup_si_mask & ~SYS_INFO_ALL_BT);
+	sys_info_with_filter(si_mask, SYS_INFO_ALL_BT);
 	if (hardlockup_panic)
 		nmi_panic(NULL, "Hard LOCKUP");
 
@@ -371,6 +373,7 @@ static void watchdog_timer_interrupt(int
 
 DEFINE_INTERRUPT_HANDLER_NMI(soft_nmi_interrupt)
 {
+	unsigned long si_mask;
 	unsigned long flags;
 	int cpu = raw_smp_processor_id();
 	u64 tb;
@@ -418,11 +421,12 @@ DEFINE_INTERRUPT_HANDLER_NMI(soft_nmi_in
 
 		xchg(&__wd_nmi_output, 1); // see wd_lockup_ipi
 
+		si_mask = READ_ONCE(hardlockup_si_mask);
 		if (sysctl_hardlockup_all_cpu_backtrace ||
-		    (hardlockup_si_mask & SYS_INFO_ALL_BT))
+		    (si_mask & SYS_INFO_ALL_BT))
 			trigger_allbutcpu_cpu_backtrace(cpu);
 
-		sys_info(hardlockup_si_mask & ~SYS_INFO_ALL_BT);
+		sys_info_with_filter(si_mask, SYS_INFO_ALL_BT);
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
 
_

Patches currently in -mm which might be from include@grrlz.net are

sys_info-add-helper-for-callers-that-print-some-sys_info-on-their-own.patch
watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
powerpc-watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
lib-string-fix-memchr_inv-for-large-ranges.patch

