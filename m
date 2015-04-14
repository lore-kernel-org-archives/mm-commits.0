From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism-fix.patch
 removed from -mm tree
Date: Tue, 14 Apr 2015 15:11:15 -0700
Message-ID: <552d9083.Ql3gw4TER3U/gnyc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbbDNWLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: update documentation for kernel params and sysctl
has been removed from the -mm tree.  Its filename was
     watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism-fix.patch

This patch was dropped because it was folded into watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: watchdog: update documentation for kernel params and sysctl

The nmi_watchdog and softlockup documentation was outdated and didn't
describe the effect of the current patchset correctly.  Update it so
others can understand how the knobs work and more importantly what to
expect when turning them.

[dzickus@redhat.com: wrote changelog]
Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 +-
 Documentation/sysctl/kernel.txt     |   64 +++++++++++++++++++++-----
 2 files changed, 58 insertions(+), 12 deletions(-)

diff -puN Documentation/kernel-parameters.txt~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism-fix Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism-fix
+++ a/Documentation/kernel-parameters.txt
@@ -2235,8 +2235,9 @@ bytes respectively. Such letter suffixes
 
 	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
 			Format: [panic,][nopanic,][num]
-			Valid num: 0
+			Valid num: 0 or 1
 			0 - turn nmi_watchdog off
+			1 - turn nmi_watchdog on
 			When panic is specified, panic when an NMI watchdog
 			timeout occurs (or 'nopanic' to override the opposite
 			default).
@@ -2463,7 +2464,8 @@ bytes respectively. Such letter suffixes
 
 	nousb		[USB] Disable the USB subsystem
 
-	nowatchdog	[KNL] Disable the lockup detector (NMI watchdog).
+	nowatchdog	[KNL] Disable both lockup detectors, i.e.
+                        soft-lockup and NMI watchdog (hard-lockup).
 
 	nowb		[ARM]
 
diff -puN Documentation/sysctl/kernel.txt~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism-fix Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism-fix
+++ a/Documentation/sysctl/kernel.txt
@@ -77,12 +77,14 @@ show up in /proc/sys/kernel:
 - shmmax                      [ sysv ipc ]
 - shmmni
 - softlockup_all_cpu_backtrace
+- soft_watchdog
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
 - sysctl_writes_strict
 - tainted
 - threads-max
 - unknown_nmi_panic
+- watchdog
 - watchdog_thresh
 - version
 
@@ -417,16 +419,23 @@ successful IPC object allocation.
 
 nmi_watchdog:
 
-Enables/Disables the NMI watchdog on x86 systems. When the value is
-non-zero the NMI watchdog is enabled and will continuously test all
-online cpus to determine whether or not they are still functioning
-properly. Currently, passing "nmi_watchdog=" parameter at boot time is
-required for this function to work.
-
-If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel
-parameter), the NMI watchdog shares registers with oprofile. By
-disabling the NMI watchdog, oprofile may have more registers to
-utilize.
+This parameter can be used to control the NMI watchdog
+(i.e. the hard lockup detector) on x86 systems.
+
+   0 - disable the hard lockup detector
+   1 - enable the hard lockup detector
+
+The hard lockup detector monitors each CPU for its ability to respond to
+timer interrupts. The mechanism utilizes CPU performance counter registers
+that are programmed to generate Non-Maskable Interrupts (NMIs) periodically
+while a CPU is busy. Hence, the alternative name 'NMI watchdog'.
+
+The NMI watchdog is disabled by default if the kernel is running as a guest
+in a KVM virtual machine. This default can be overridden by adding
+
+   nmi_watchdog=1
+
+to the guest kernel command line (see Documentation/kernel-parameters.txt).
 
 ==============================================================
 
@@ -816,6 +825,22 @@ NMI.
 
 ==============================================================
 
+soft_watchdog
+
+This parameter can be used to control the soft lockup detector.
+
+   0 - disable the soft lockup detector
+   1 - enable the soft lockup detector
+
+The soft lockup detector monitors CPUs for threads that are hogging the CPUs
+without rescheduling voluntarily, and thus prevent the 'watchdog/N' threads
+from running. The mechanism depends on the CPUs ability to respond to timer
+interrupts which are needed for the 'watchdog/N' threads to be woken up by
+the watchdog timer function, otherwise the NMI watchdog - if enabled - can
+detect a hard lockup condition.
+
+==============================================================
+
 tainted:
 
 Non-zero if the kernel has been tainted.  Numeric values, which
@@ -858,6 +883,25 @@ example.  If a system hangs up, try pres
 
 ==============================================================
 
+watchdog:
+
+This parameter can be used to disable or enable the soft lockup detector
+_and_ the NMI watchdog (i.e. the hard lockup detector) at the same time.
+
+   0 - disable both lockup detectors
+   1 - enable both lockup detectors
+
+The soft lockup detector and the NMI watchdog can also be disabled or
+enabled individually, using the soft_watchdog and nmi_watchdog parameters.
+If the watchdog parameter is read, for example by executing
+
+   cat /proc/sys/kernel/watchdog
+
+the output of this command (0 or 1) shows the logical OR of soft_watchdog
+and nmi_watchdog.
+
+==============================================================
+
 watchdog_thresh:
 
 This value can be used to control the frequency of hrtimer and NMI
_

Patches currently in -mm which might be from dzickus@redhat.com are

watchdog-new-definitions-and-variables-initialization.patch
watchdog-introduce-the-proc_watchdog_update-function.patch
watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch
watchdog-introduce-the-proc_watchdog_common-function.patch
watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch
watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch
watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
watchdog-clean-up-some-function-names-and-arguments.patch
watchdog-introduce-the-hardlockup_detector_disable-function.patch

