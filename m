From: akpm@linux-foundation.org
Subject: - slow-down-printk-during-boot.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:29:31 -0700
Message-ID: <200710162029.l9GKTVii014322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935901AbXJPUaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, bunk@stusta.de, davej@redhat.com, heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slow down printk during boot
has been removed from the -mm tree.  Its filename was
     slow-down-printk-during-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slow down printk during boot
From: Randy Dunlap <rdunlap@xenotime.net>

Optionally add a boot delay after each kernel printk() call, crudely
measured in milliseconds, with a maximum delay of 10 seconds per printk.

Enable CONFIG_BOOT_PRINTK_DELAY=y and then add (e.g.):
"lpj=loops_per_jiffy boot_delay=100"
to the kernel command line.

It has been useful in cases like "during boot, my machine just reboots or the
screen goes black" by slowing down printk, (and adding initcall_debug), we can
usually see the last thing that happened before the lights went out which is
usually a valuable clue.

[akpm@linux-foundation.org: not all architectures implement CONFIG_HZ]
[akpm@linux-foundation.org: fix lots of stuff]
[bunk@stusta.de: kernel/printk.c: make 2 variables static]
[heiko.carstens@de.ibm.com: fix slow down printk on boot compile error]
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 ++
 include/linux/jiffies.h             |    2 
 init/calibrate.c                    |    2 
 kernel/printk.c                     |   59 ++++++++++++++++++++++++++
 lib/Kconfig.debug                   |   18 +++++++
 5 files changed, 85 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~slow-down-printk-during-boot Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~slow-down-printk-during-boot
+++ a/Documentation/kernel-parameters.txt
@@ -349,6 +349,11 @@ and is between 256 and 4096 characters. 
 	blkmtd_bs=
 	blkmtd_count=
 
+	boot_delay=	Milliseconds to delay each printk during boot.
+			Values larger than 10 seconds (10000) are changed to
+			no delay (0).
+			Format: integer
+
 	bttv.card=	[HW,V4L] bttv (bt848 + bt878 based grabber cards)
 	bttv.radio=	Most important insmod options are available as
 			kernel args too.
diff -puN include/linux/jiffies.h~slow-down-printk-during-boot include/linux/jiffies.h
--- a/include/linux/jiffies.h~slow-down-printk-during-boot
+++ a/include/linux/jiffies.h
@@ -148,6 +148,8 @@ static inline u64 get_jiffies_64(void)
  */
 #define MAX_JIFFY_OFFSET ((LONG_MAX >> 1)-1)
 
+extern unsigned long preset_lpj;
+
 /*
  * We want to do realistic conversions of time so we need to use the same
  * values the update wall clock code uses as the jiffies size.  This value
diff -puN init/calibrate.c~slow-down-printk-during-boot init/calibrate.c
--- a/init/calibrate.c~slow-down-printk-during-boot
+++ a/init/calibrate.c
@@ -10,7 +10,7 @@
 
 #include <asm/timex.h>
 
-static unsigned long preset_lpj;
+unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
 {
 	preset_lpj = simple_strtoul(str,NULL,0);
diff -puN kernel/printk.c~slow-down-printk-during-boot kernel/printk.c
--- a/kernel/printk.c~slow-down-printk-during-boot
+++ a/kernel/printk.c
@@ -22,6 +22,8 @@
 #include <linux/tty_driver.h>
 #include <linux/console.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/nmi.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/interrupt.h>			/* For in_interrupt() */
@@ -162,6 +164,61 @@ out:
 
 __setup("log_buf_len=", log_buf_len_setup);
 
+#ifdef CONFIG_BOOT_PRINTK_DELAY
+
+static unsigned int boot_delay; /* msecs delay after each printk during bootup */
+static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
+
+static int __init boot_delay_setup(char *str)
+{
+	unsigned long lpj;
+	unsigned long long loops_per_msec;
+
+	lpj = preset_lpj ? preset_lpj : 1000000;	/* some guess */
+	loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
+
+	get_option(&str, &boot_delay);
+	if (boot_delay > 10 * 1000)
+		boot_delay = 0;
+
+	printk_delay_msec = loops_per_msec;
+	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
+		"HZ: %d, printk_delay_msec: %llu\n",
+		boot_delay, preset_lpj, lpj, HZ, printk_delay_msec);
+	return 1;
+}
+__setup("boot_delay=", boot_delay_setup);
+
+static void boot_delay_msec(void)
+{
+	unsigned long long k;
+	unsigned long timeout;
+
+	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
+		return;
+
+	k = (unsigned long long)printk_delay_msec * boot_delay;
+
+	timeout = jiffies + msecs_to_jiffies(boot_delay);
+	while (k) {
+		k--;
+		cpu_relax();
+		/*
+		 * use (volatile) jiffies to prevent
+		 * compiler reduction; loop termination via jiffies
+		 * is secondary and may or may not happen.
+		 */
+		if (time_after(jiffies, timeout))
+			break;
+		touch_nmi_watchdog();
+	}
+}
+#else
+static inline void boot_delay_msec(void)
+{
+}
+#endif
+
 /*
  * Commands to do_syslog:
  *
@@ -527,6 +584,8 @@ asmlinkage int vprintk(const char *fmt, 
 	static char printk_buf[1024];
 	static int log_level_unknown = 1;
 
+	boot_delay_msec();
+
 	preempt_disable();
 	if (unlikely(oops_in_progress) && printk_cpu == smp_processor_id())
 		/* If a crash is occurring during printk() on this CPU,
diff -puN lib/Kconfig.debug~slow-down-printk-during-boot lib/Kconfig.debug
--- a/lib/Kconfig.debug~slow-down-printk-during-boot
+++ a/lib/Kconfig.debug
@@ -413,6 +413,24 @@ config FORCED_INLINING
 	  become the default in the future, until then this option is there to
 	  test gcc for this.
 
+config BOOT_PRINTK_DELAY
+	bool "Delay each boot printk message by N milliseconds"
+	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
+	help
+	  This build option allows you to read kernel boot messages
+	  by inserting a short delay after each one.  The delay is
+	  specified in milliseconds on the kernel command line,
+	  using "boot_delay=N".
+
+	  It is likely that you would also need to use "lpj=M" to preset
+	  the "loops per jiffie" value.
+	  See a previous boot log for the "lpj" value to use for your
+	  system, and then set "lpj=M" before setting "boot_delay=N".
+	  NOTE:  Using this option may adversely affect SMP systems.
+	  I.e., processors other than the first one may not boot up.
+	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
+	  what it believes to be lockup conditions.
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
ufs-implement-show_options.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
add-recommended-section-ids-to-deviceiobooktmpl.patch
fix-make-htmldocs-build-break.patch
add-section-ids-to-documentation-docbook-filesystemstmpl.patch
