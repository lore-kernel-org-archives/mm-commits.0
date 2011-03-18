From: akpm@linux-foundation.org
Subject: + kernel-watchdogc-allow-hardlockup-to-panic-by-default.patch added to -mm tree
Date: Thu, 17 Mar 2011 18:54:56 -0700
Message-ID: <201103180157.p2I1vUe4024015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076Ab1CRB5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Mar 2011 21:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dzickus@redhat.com, a.p.zijlstra@chello.nl, xiyou.wangcong@gmail.com


The patch titled
     kernel/watchdog.c: allow hardlockup to panic by default
has been added to the -mm tree.  Its filename is
     kernel-watchdogc-allow-hardlockup-to-panic-by-default.patch

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
Subject: kernel/watchdog.c: allow hardlockup to panic by default
From: Don Zickus <dzickus@redhat.com>

Add a Kconfig option to allow users to set the hardlockup to panic
by default.  Also add in a 'nmi_watchdog=nopanic' to override this.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++--
 kernel/watchdog.c                   |    5 ++++-
 lib/Kconfig.debug                   |   17 +++++++++++++++++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~kernel-watchdogc-allow-hardlockup-to-panic-by-default Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kernel-watchdogc-allow-hardlockup-to-panic-by-default
+++ a/Documentation/kernel-parameters.txt
@@ -1597,11 +1597,12 @@ bytes respectively. Such letter suffixes
 			Format: [state][,regs][,debounce][,die]
 
 	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
-			Format: [panic,][num]
+			Format: [panic,][nopanic,][num]
 			Valid num: 0
 			0 - turn nmi_watchdog off
 			When panic is specified, panic when an NMI watchdog
-			timeout occurs.
+			timeout occurs (or 'nopanic' to override the opposite
+			default).
 			This is useful when you use a panic=... timeout and
 			need the box quickly up again.
 
diff -puN kernel/watchdog.c~kernel-watchdogc-allow-hardlockup-to-panic-by-default kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-allow-hardlockup-to-panic-by-default
+++ a/kernel/watchdog.c
@@ -48,12 +48,15 @@ static DEFINE_PER_CPU(struct perf_event 
  * Should we panic when a soft-lockup or hard-lockup occurs:
  */
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
-static int hardlockup_panic;
+static int hardlockup_panic =
+			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
 
 static int __init hardlockup_panic_setup(char *str)
 {
 	if (!strncmp(str, "panic", 5))
 		hardlockup_panic = 1;
+	else if (!strncmp(str, "nopanic", 5))
+		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
 		watchdog_enabled = 0;
 	return 1;
diff -puN lib/Kconfig.debug~kernel-watchdogc-allow-hardlockup-to-panic-by-default lib/Kconfig.debug
--- a/lib/Kconfig.debug~kernel-watchdogc-allow-hardlockup-to-panic-by-default
+++ a/lib/Kconfig.debug
@@ -176,6 +176,23 @@ config HARDLOCKUP_DETECTOR
 	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
 		 !ARCH_HAS_NMI_WATCHDOG
 
+config BOOTPARAM_HARDLOCKUP_PANIC
+	bool "Panic (Reboot) On Hard Lockups"
+	depends on LOCKUP_DETECTOR
+	help
+	  Say Y here to enable the kernel to panic on "hard lockups",
+	  which are bugs that cause the kernel to loop in kernel
+	  mode with interrupts disabled for more than 60 seconds.
+
+	  Say N if unsure.
+
+config BOOTPARAM_HARDLOCKUP_PANIC_VALUE
+	int
+	depends on LOCKUP_DETECTOR
+	range 0 1
+	default 0 if !BOOTPARAM_HARDLOCKUP_PANIC
+	default 1 if BOOTPARAM_HARDLOCKUP_PANIC
+
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
 	depends on LOCKUP_DETECTOR
_

Patches currently in -mm which might be from dzickus@redhat.com are

origin.patch
linux-next.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default.patch
kernel-watchdogc-always-return-notify_ok-during-cpu-up-down-events.patch

