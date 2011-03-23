From: akpm@linux-foundation.org
Subject: [merged] kernel-watchdogc-allow-hardlockup-to-panic-by-default.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:13 -0700
Message-ID: <201103232042.p2NKgnQW028802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933435Ab1CWUnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, a.p.zijlstra@chello.nl, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel/watchdog.c: allow hardlockup to panic by default
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-allow-hardlockup-to-panic-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/watchdog.c: allow hardlockup to panic by default
From: Don Zickus <dzickus@redhat.com>

When a cpu is considered stuck, instead of limping along and just printing
a warning, it is sometimes preferred to just panic, let kdump capture the
vmcore and reboot.  This gets the machine back into a stable state quickly
while saving the info that got it into a stuck state to begin with.

Add a Kconfig option to allow users to set the hardlockup to panic
by default.  Also add in a 'nmi_watchdog=nopanic' to override this.

[akpm@linux-foundation.org: fix strncmp length]
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
+	else if (!strncmp(str, "nopanic", 7))
+		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
 		watchdog_enabled = 0;
 	return 1;
diff -puN lib/Kconfig.debug~kernel-watchdogc-allow-hardlockup-to-panic-by-default lib/Kconfig.debug
--- a/lib/Kconfig.debug~kernel-watchdogc-allow-hardlockup-to-panic-by-default
+++ a/lib/Kconfig.debug
@@ -171,6 +171,23 @@ config HARDLOCKUP_DETECTOR
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

