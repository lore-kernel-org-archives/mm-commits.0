Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C83132D0EE;
	Thu, 25 Jun 2026 18:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782413048; cv=none; b=sExNgxeRjsLmaEIJh/vtk8p1OdULMpJd/05jUztt/UGHVVyDTRpAQDnqQCIm4Zl2yAXHnw/9KiHg+B6IY/p3PanD3C/mMTi9idOF7wOAWGD6rZS05qJHfTdRmQZvarKnA+EHfzYjJVetYud4x4pCgMJcgND7KvHt8UnOSzu1KjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782413048; c=relaxed/simple;
	bh=F2uxKDdtJnWKy4kV5XnJdI06LPPwqPGWBUVBpr01Yyc=;
	h=Date:To:From:Subject:Message-Id; b=lB0m2gNf4UoxhdNjQYiebpiWY1AfCTEFWC2Ztka/S16v9iVzhbUkwW1vunupSgEEqzNcVFQ55nW3ABYGPsLwqazZRXasYfvd+XGwy4WT2soAS/uN/o/ILSA5o6d0QrFS9gvkToflxewi1GUo47ZgJ/KMCWHAhlQ0czeqMvf6XZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S21NH9UY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S21NH9UY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979F51F000E9;
	Thu, 25 Jun 2026 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782413046;
	bh=Or07ehHupwO+bng52SQuFjf0hv15bPXloBBOZyo0X6E=;
	h=Date:To:From:Subject;
	b=S21NH9UYl0miJXaPanwJxwZWs/q6c2TLn6Xzkh6AZG+/8xDtfg2kdIo0YEJ1v+qa5
	 X+6KVh4f29iSDwqZWum99rza20COuLbIdgqbPILQ8rV0R9OJqxJZk8LTUiQnrADgiG
	 VzFiLm68PdwkyKjahKA5XskTWq4hrHJkCuxFJVw0=
Date: Thu, 25 Jun 2026 11:44:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,dianders@chromium.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625184406.979F51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: use sys_info_with_filter() to avoid duplicate backtraces
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch

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
Subject: watchdog: use sys_info_with_filter() to avoid duplicate backtraces
Date: Thu, 25 Jun 2026 15:25:56 +0000

The watchdog prints all CPU backtraces itself.  When the watchdog mask
contains only SYS_INFO_ALL_BT, stripping that bit leaves zero and
sys_info(0) falls back to kernel_sys_info.

Use sys_info_with_filter() so an explicit all_bt mask does not request the
global default.

Link: https://lore.kernel.org/20260625152558.7450-3-include@grrlz.net
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

 kernel/watchdog.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/watchdog.c~watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces
+++ a/kernel/watchdog.c
@@ -208,6 +208,7 @@ void watchdog_hardlockup_check(unsigned
 {
 	int hardlockup_all_cpu_backtrace;
 	unsigned int this_cpu;
+	unsigned long si_mask;
 	unsigned long flags;
 
 	if (per_cpu(watchdog_hardlockup_touched, cpu)) {
@@ -216,7 +217,8 @@ void watchdog_hardlockup_check(unsigned
 		return;
 	}
 
-	hardlockup_all_cpu_backtrace = (hardlockup_si_mask & SYS_INFO_ALL_BT) ?
+	si_mask = READ_ONCE(hardlockup_si_mask);
+	hardlockup_all_cpu_backtrace = (si_mask & SYS_INFO_ALL_BT) ?
 					1 : sysctl_hardlockup_all_cpu_backtrace;
 	/*
 	 * Check for a hardlockup by making sure the CPU's timer
@@ -286,7 +288,7 @@ void watchdog_hardlockup_check(unsigned
 			clear_bit_unlock(0, &hard_lockup_nmi_warn);
 	}
 
-	sys_info(hardlockup_si_mask & ~SYS_INFO_ALL_BT);
+	sys_info_with_filter(si_mask, SYS_INFO_ALL_BT);
 	if (hardlockup_panic)
 		nmi_panic(regs, "Hard LOCKUP");
 
@@ -798,6 +800,7 @@ static enum hrtimer_restart watchdog_tim
 	struct pt_regs *regs = get_irq_regs();
 	int softlockup_all_cpu_backtrace;
 	int duration, thresh_count;
+	unsigned long si_mask;
 	unsigned long flags;
 
 	if (!watchdog_enabled)
@@ -809,7 +812,8 @@ static enum hrtimer_restart watchdog_tim
 	if (panic_in_progress())
 		return HRTIMER_NORESTART;
 
-	softlockup_all_cpu_backtrace = (softlockup_si_mask & SYS_INFO_ALL_BT) ?
+	si_mask = READ_ONCE(softlockup_si_mask);
+	softlockup_all_cpu_backtrace = (si_mask & SYS_INFO_ALL_BT) ?
 					1 : sysctl_softlockup_all_cpu_backtrace;
 
 	watchdog_hardlockup_kick();
@@ -900,7 +904,7 @@ static enum hrtimer_restart watchdog_tim
 		}
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
-		sys_info(softlockup_si_mask & ~SYS_INFO_ALL_BT);
+		sys_info_with_filter(si_mask, SYS_INFO_ALL_BT);
 		thresh_count = duration / get_softlockup_thresh();
 
 		if (softlockup_panic && thresh_count >= softlockup_panic)
_

Patches currently in -mm which might be from include@grrlz.net are

sys_info-add-helper-for-callers-that-print-some-sys_info-on-their-own.patch
watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
powerpc-watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
lib-string-fix-memchr_inv-for-large-ranges.patch

