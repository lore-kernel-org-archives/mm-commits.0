From: akpm@linux-foundation.org
Subject: +
 watchdog-introduce-the-hardlockup_detector_disable-function.patch added to
 -mm tree
Date: Mon, 23 Feb 2015 13:20:55 -0800
Message-ID: <54eb99b7.Kjs2cjqNYbBZBR03%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbbBWVU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:20:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: introduce the hardlockup_detector_disable() function
has been added to the -mm tree.  Its filename is
     watchdog-introduce-the-hardlockup_detector_disable-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-introduce-the-hardlockup_detector_disable-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-introduce-the-hardlockup_detector_disable-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: introduce the hardlockup_detector_disable() function

Have kvm_guest_init() use hardlockup_detector_disable() instead of
watchdog_enable_hardlockup_detector(false).

Remove the watchdog_hardlockup_detector_is_enabled() and the
watchdog_enable_hardlockup_detector() function which are no longer needed.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kvm.c |    2 +-
 include/linux/nmi.h   |    9 ++-------
 kernel/watchdog.c     |   21 ++-------------------
 3 files changed, 5 insertions(+), 27 deletions(-)

diff -puN arch/x86/kernel/kvm.c~watchdog-introduce-the-hardlockup_detector_disable-function arch/x86/kernel/kvm.c
--- a/arch/x86/kernel/kvm.c~watchdog-introduce-the-hardlockup_detector_disable-function
+++ a/arch/x86/kernel/kvm.c
@@ -513,7 +513,7 @@ void __init kvm_guest_init(void)
 	 * can get false positives too easily, for example if the host is
 	 * overcommitted.
 	 */
-	watchdog_enable_hardlockup_detector(false);
+	hardlockup_detector_disable();
 }
 
 static noinline uint32_t __kvm_cpuid_base(void)
diff -puN include/linux/nmi.h~watchdog-introduce-the-hardlockup_detector_disable-function include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-introduce-the-hardlockup_detector_disable-function
+++ a/include/linux/nmi.h
@@ -25,16 +25,11 @@ static inline void touch_nmi_watchdog(vo
 #endif
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR)
-extern void watchdog_enable_hardlockup_detector(bool val);
-extern bool watchdog_hardlockup_detector_is_enabled(void);
+extern void hardlockup_detector_disable(void);
 #else
-static inline void watchdog_enable_hardlockup_detector(bool val)
+static inline void hardlockup_detector_disable(void)
 {
 }
-static inline bool watchdog_hardlockup_detector_is_enabled(void)
-{
-	return true;
-}
 #endif
 
 /*
diff -puN kernel/watchdog.c~watchdog-introduce-the-hardlockup_detector_disable-function kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-introduce-the-hardlockup_detector_disable-function
+++ a/kernel/watchdog.c
@@ -83,8 +83,6 @@ static unsigned long soft_lockup_nmi_war
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static int hardlockup_panic =
 			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
-
-static bool hardlockup_detector_enabled = true;
 /*
  * We may not want to enable hard lockup detection by default in all cases,
  * for example when running the kernel as a guest on a hypervisor. In these
@@ -93,14 +91,9 @@ static bool hardlockup_detector_enabled
  * kernel command line parameters are parsed, because otherwise it is not
  * possible to override this in hardlockup_panic_setup().
  */
-void watchdog_enable_hardlockup_detector(bool val)
-{
-	hardlockup_detector_enabled = val;
-}
-
-bool watchdog_hardlockup_detector_is_enabled(void)
+void hardlockup_detector_disable(void)
 {
-	return hardlockup_detector_enabled;
+	watchdog_enabled &= ~NMI_WATCHDOG_ENABLED;
 }
 
 static int __init hardlockup_panic_setup(char *str)
@@ -524,15 +517,6 @@ static int watchdog_nmi_enable(unsigned
 	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
 		goto out;
 
-	/*
-	 * Some kernels need to default hard lockup detection to
-	 * 'disabled', for example a guest on a hypervisor.
-	 */
-	if (!watchdog_hardlockup_detector_is_enabled()) {
-		event = ERR_PTR(-ENOENT);
-		goto handle_err;
-	}
-
 	/* is it already setup and enabled? */
 	if (event && event->state > PERF_EVENT_STATE_OFF)
 		goto out;
@@ -547,7 +531,6 @@ static int watchdog_nmi_enable(unsigned
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
 
-handle_err:
 	/* save cpu0 error for future comparision */
 	if (cpu == 0 && IS_ERR(event))
 		cpu0_err = PTR_ERR(event);
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-new-definitions-and-variables-initialization.patch
watchdog-introduce-the-proc_watchdog_update-function.patch
watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch
watchdog-introduce-the-proc_watchdog_common-function.patch
watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch
watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch
watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
watchdog-clean-up-some-function-names-and-arguments.patch
watchdog-introduce-the-hardlockup_detector_disable-function.patch

