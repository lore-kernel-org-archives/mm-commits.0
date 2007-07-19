From: akpm@linux-foundation.org
Subject: + slow-down-printk-during-boot-fix-2.patch added to -mm tree
Date: Thu, 19 Jul 2007 00:57:42 -0700
Message-ID: <200707190757.l6J7vgiQ020977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763206AbXGSIYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 04:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@redhat.com, rdunlap@xenotime.net


The patch titled
     slow-down-printk-during-boot-fix-2
has been added to the -mm tree.  Its filename is
     slow-down-printk-during-boot-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slow-down-printk-during-boot-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

- the delay should be in vprintk(), not printk()

- cleanups

- This:

	long long = long * long;

  doesn't work: the rhs will still be 32-bit.  Need to make the expression
  64-bit somehow.

Cc: Dave Jones <davej@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff -puN kernel/printk.c~slow-down-printk-during-boot-fix-2 kernel/printk.c
--- a/kernel/printk.c~slow-down-printk-during-boot-fix-2
+++ a/kernel/printk.c
@@ -171,8 +171,11 @@ unsigned long long printk_delay_msec; /*
 
 static int __init boot_delay_setup(char *str)
 {
-	unsigned long lpj = preset_lpj ? preset_lpj : 1000000; /* some guess */
-	unsigned long long loops_per_msec = lpj / 1000 * HZ;
+	unsigned long lpj;
+	unsigned long long loops_per_msec;
+
+	lpj = preset_lpj ? preset_lpj : 1000000;	/* some guess */
+	loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
 
 	get_option(&str, &boot_delay);
 	if (boot_delay > 10 * 1000)
@@ -186,12 +189,17 @@ static int __init boot_delay_setup(char 
 }
 __setup("boot_delay=", boot_delay_setup);
 
-static void boot_delay_msec(int millisecs)
+static void boot_delay_msec(void)
 {
-	unsigned long long k = printk_delay_msec * millisecs;
+	unsigned long long k;
 	unsigned long timeout;
 
-	timeout = jiffies + msecs_to_jiffies(millisecs);
+	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
+		return;
+
+	k = (unsigned long long)printk_delay_msec * boot_delay;
+
+	timeout = jiffies + msecs_to_jiffies(boot_delay);
 	while (k) {
 		k--;
 		cpu_relax();
@@ -205,7 +213,10 @@ static void boot_delay_msec(int millisec
 		touch_nmi_watchdog();
 	}
 }
-
+#else
+static inline void boot_delay_msec(void)
+{
+}
 #endif
 
 /*
@@ -559,11 +570,6 @@ asmlinkage int printk(const char *fmt, .
 	r = vprintk(fmt, args);
 	va_end(args);
 
-#ifdef CONFIG_BOOT_PRINTK_DELAY
-	if (boot_delay && system_state == SYSTEM_BOOTING)
-		boot_delay_msec(boot_delay);
-#endif
-
 	return r;
 }
 
@@ -578,6 +584,8 @@ asmlinkage int vprintk(const char *fmt, 
 	static char printk_buf[1024];
 	static int log_level_unknown = 1;
 
+	boot_delay_msec();
+
 	preempt_disable();
 	if (unlikely(oops_in_progress) && printk_cpu == smp_processor_id())
 		/* If a crash is occurring during printk() on this CPU,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
kernel-sysctlc-finish-off-the-warning-comments.patch
afs-build-fix.patch
