Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA493FE37C;
	Fri, 26 Jun 2026 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492649; cv=none; b=HdFA5khuIdqybbSYXriGgVoEirePBxrxXnjPmK7sDLdAcnsyQIKl6koC0Qm05qVGRGsX+VCfQIy8lueOiU9kEm2H8pIMJM6LVBMe7mNPGmNPEaYiJVQZIPzblIO6O+lkMN4JUz5cEcd6iBzydz2uiWsep6WFVgkytiR95h7Egsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492649; c=relaxed/simple;
	bh=B++2b+HZFi53LEA6K++93M5y9N7V+BQgGOoJjBhHbvI=;
	h=Date:To:From:Subject:Message-Id; b=TS8IL/9AB0MxtZxljaNeq8h8Rd2cUYhXDcX+XAf9lS0WYTepSEfWiEgRkzeiYkjvJDD29Slrzlxq/Lc2X8zcnf2EbmEDTdTgOZ49hYP5hUh72v1j7ZHZ8SjTyfFRARvIbb0bUWKTIpyC1a0JP3UZ3+8qf63kR6sK/0CF8H0SMJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rQ2ihM/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rQ2ihM/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B274F1F00A3A;
	Fri, 26 Jun 2026 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782492644;
	bh=8Cs7bMrGB8UWOF+SzDf0hzrnSN5Wx1Mu3hlKuFODmLI=;
	h=Date:To:From:Subject;
	b=rQ2ihM/q4XkL1rVjPAV65cdeTNPHqPSi15N1TN2JgEq6GyiU7cEecJhlaK6jIl7NZ
	 y63Fx0b/s4+Ka4/88Fe5uc4BiIoOCi/UGhzF0ttXh4cHSbP9kl3piZcceREQjeqyUG
	 mDrPZ/pomIcVv6PR96bXMVOeB6ZJQ6xXvOVAwswI=
Date: Fri, 26 Jun 2026 09:50:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,dianders@chromium.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch removed from -mm tree
Message-Id: <20260626165044.B274F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: use sys_info_with_filter() to avoid duplicate backtraces
has been removed from the -mm tree.  Its filename was
     watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch

This patch was dropped because an updated version will be issued

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

powerpc-watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
lib-string-fix-memchr_inv-for-large-ranges.patch

