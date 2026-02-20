Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198FD264617
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 21:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771622447; cv=none; b=X1ZnotBqi/bix4pV4a7FOzmbuvhZjxihWbqK3+lcsSwZjfyFo+3GTzllXVtQtDE8dGHsg20usUr0lCok/bgUKWJxqMmHyY+A7RS/staoCx29JmT56i2BFXYpT/V/2LC4hYdKUPoCbssRsDqgZ1TlE5+e7dVdGMs63sXd0wvBYZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771622447; c=relaxed/simple;
	bh=Zg6aDj7f5h72p5W+Ls0H5kAmnxE7RQgYnAytAhYpVnI=;
	h=Date:To:From:Subject:Message-Id; b=sJj0YYsDVKq+7aZo651c3BWyYIBcXhcc2vgIvBhEA4SKKFfqM+ZP6rkul7gfjfEqCiyrfAiyxrZEF4/9RUtFeH5AlpSFI0EZuIvWzjiIWngzDiir7Mw2KFVpSF0thLaIQfrZCc1HHOBAb84+Fe7hgICfeQ/SczHbONILavb6G5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZzfODIBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZzfODIBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E663C116C6;
	Fri, 20 Feb 2026 21:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771622446;
	bh=Zg6aDj7f5h72p5W+Ls0H5kAmnxE7RQgYnAytAhYpVnI=;
	h=Date:To:From:Subject:From;
	b=ZzfODIBRqVoGQ1trtabHKp+h96aw13XYx0B5USOCYNLFOVtTF3WL4CKx/DLFsdqFe
	 4gOg+5ai5J/zmJgBOBywcy0Pr1PwZQWSAGb5Jg5UmWmzWFdU4fkDpLmVfszNMIY3Qq
	 9EBCYEya9G22mzouUyHjNYZYM6ce+bH5kLLhQe48=
Date: Fri, 20 Feb 2026 13:20:45 -0800
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,mrungta@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-always-update-saved-interrupts-during-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260220212046.7E663C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/hardlockup: always update saved interrupts during check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-always-update-saved-interrupts-during-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-always-update-saved-interrupts-during-check.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Mayank Rungta <mrungta@google.com>
Subject: watchdog/hardlockup: always update saved interrupts during check
Date: Thu, 12 Feb 2026 14:12:10 -0700

Patch series "watchdog/hardlockup: Improvements to hardlockup".

This series addresses limitations in the hardlockup detector
implementations and updates the documentation to reflect actual behavior
and recent changes.

The changes are structured as follows:

Hardlockup Detection Improvements (Patches 1 & 3)
=================================================
The hardlockup detector logic relies on updating saved interrupt counts to
determine if the CPU is making progress.

Patch 1 ensures that the saved interrupt count is updated unconditionally
before checking the "touched" flag.  This prevents stale comparisons which
can delay detection.  This is a logic fix that ensures the detector
remains accurate even when the watchdog is frequently touched.

Patch 3 improves the Buddy detector's timeliness.  The current checking
interval (every 3rd sample) causes high variability in detection time (up
to 24s).  This patch changes the Buddy detector to check at every hrtimer
interval (4s) with a missed-interrupt threshold of 3, narrowing the
detection window to a consistent 8-12 second range.

Documentation Updates (Patches 2 & 4)
=====================================
The current documentation does not fully capture the variable nature of
detection latency or the details of the Buddy system.

Patch 2 removes the strict "10 seconds" definition of a hardlockup, which
was misleading given the periodic nature of the detector.  It adds a
"Detection Overhead" section to the admin guide, using "Best Case" and
"Worst Case" scenarios to illustrate that detection time can vary
significantly (e.g., ~6s to ~20s).

Patch 4 adds a dedicated section for the Buddy detector, which was
previously undocumented.  It details the mechanism, the new timing logic,
and known limitations.


This patch (of 4):

Currently, arch_touch_nmi_watchdog() causes an early return that skips
updating hrtimer_interrupts_saved.  This leads to stale comparisons and
delayed lockup detection.

Update the saved interrupt count before checking the touched flag to
ensure detection timeliness.

Link: https://lkml.kernel.org/r/20260212-hardlockup-watchdog-fixes-v1-0-745f1dce04c3@google.com
Link: https://lkml.kernel.org/r/20260212-hardlockup-watchdog-fixes-v1-1-745f1dce04c3@google.com
Signed-off-by: Mayank Rungta <mrungta@google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephane Erainan <eranian@google.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/kernel/watchdog.c~watchdog-hardlockup-always-update-saved-interrupts-during-check
+++ a/kernel/watchdog.c
@@ -186,7 +186,21 @@ static void watchdog_hardlockup_kick(voi
 
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
 {
+	bool is_hl;
 	int hardlockup_all_cpu_backtrace;
+	/*
+	 * Check for a hardlockup by making sure the CPU's timer
+	 * interrupt is incrementing. The timer interrupt should have
+	 * fired multiple times before we overflow'd. If it hasn't
+	 * then this is a good indication the cpu is stuck
+	 *
+	 * Purposely check this _before_ checking watchdog_hardlockup_touched
+	 * so we make sure we still update the saved value of the interrupts.
+	 * Without that we'll take an extra round through this function before
+	 * we can detect a lockup.
+	 */
+
+	is_hl = is_hardlockup(cpu);
 
 	if (per_cpu(watchdog_hardlockup_touched, cpu)) {
 		per_cpu(watchdog_hardlockup_touched, cpu) = false;
@@ -195,13 +209,8 @@ void watchdog_hardlockup_check(unsigned
 
 	hardlockup_all_cpu_backtrace = (hardlockup_si_mask & SYS_INFO_ALL_BT) ?
 					1 : sysctl_hardlockup_all_cpu_backtrace;
-	/*
-	 * Check for a hardlockup by making sure the CPU's timer
-	 * interrupt is incrementing. The timer interrupt should have
-	 * fired multiple times before we overflow'd. If it hasn't
-	 * then this is a good indication the cpu is stuck
-	 */
-	if (is_hardlockup(cpu)) {
+
+	if (is_hl) {
 		unsigned int this_cpu = smp_processor_id();
 		unsigned long flags;
 
_

Patches currently in -mm which might be from mrungta@google.com are

watchdog-hardlockup-always-update-saved-interrupts-during-check.patch
doc-watchdog-clarify-hardlockup-detection-timing.patch
watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch
doc-watchdog-document-buddy-detector.patch

