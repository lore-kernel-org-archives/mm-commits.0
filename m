From: akpm@linux-foundation.org
Subject: - proper-extern-for-late_time_init.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:22 -0700
Message-ID: <200804300540.m3U5eMvP028956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756163AbYD3Fld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     proper extern for late_time_init
has been removed from the -mm tree.  Its filename was
     proper-extern-for-late_time_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper extern for late_time_init
From: Adrian Bunk <bunk@kernel.org>

Add a proper extern for late_time_init in include/linux/init.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/pmc-sierra/yosemite/setup.c |    3 ---
 arch/ppc/platforms/sbc82xx.c          |    2 --
 arch/um/kernel/time.c                 |    3 +--
 arch/x86/kernel/time_32.c             |    1 -
 include/asm-x86/time.h                |    1 -
 include/linux/init.h                  |    2 ++
 6 files changed, 3 insertions(+), 9 deletions(-)

diff -puN arch/mips/pmc-sierra/yosemite/setup.c~proper-extern-for-late_time_init arch/mips/pmc-sierra/yosemite/setup.c
--- a/arch/mips/pmc-sierra/yosemite/setup.c~proper-extern-for-late_time_init
+++ a/arch/mips/pmc-sierra/yosemite/setup.c
@@ -143,9 +143,6 @@ void __init plat_time_init(void)
 mips_hpt_frequency = 33000000 * 3 * 5;
 }
 
-/* No other usable initialization hook than this ...  */
-extern void (*late_time_init)(void);
-
 unsigned long ocd_base;
 
 EXPORT_SYMBOL(ocd_base);
diff -puN arch/ppc/platforms/sbc82xx.c~proper-extern-for-late_time_init arch/ppc/platforms/sbc82xx.c
--- a/arch/ppc/platforms/sbc82xx.c~proper-extern-for-late_time_init
+++ a/arch/ppc/platforms/sbc82xx.c
@@ -30,8 +30,6 @@ static void (*callback_init_IRQ)(void);
 
 extern unsigned char __res[sizeof(bd_t)];
 
-extern void (*late_time_init)(void);
-
 #ifdef CONFIG_GEN_RTC
 TODC_ALLOC();
 
diff -puN arch/um/kernel/time.c~proper-extern-for-late_time_init arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~proper-extern-for-late_time_init
+++ a/arch/um/kernel/time.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/clockchips.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/threads.h>
@@ -109,8 +110,6 @@ static void __init setup_itimer(void)
 	clockevents_register_device(&itimer_clockevent);
 }
 
-extern void (*late_time_init)(void);
-
 void __init time_init(void)
 {
 	long long nsecs;
diff -puN arch/x86/kernel/time_32.c~proper-extern-for-late_time_init arch/x86/kernel/time_32.c
--- a/arch/x86/kernel/time_32.c~proper-extern-for-late_time_init
+++ a/arch/x86/kernel/time_32.c
@@ -115,7 +115,6 @@ irqreturn_t timer_interrupt(int irq, voi
 	return IRQ_HANDLED;
 }
 
-extern void (*late_time_init)(void);
 /* Duplicate of time_init() below, with hpet_enable part added */
 void __init hpet_time_init(void)
 {
diff -puN include/asm-x86/time.h~proper-extern-for-late_time_init include/asm-x86/time.h
--- a/include/asm-x86/time.h~proper-extern-for-late_time_init
+++ a/include/asm-x86/time.h
@@ -1,7 +1,6 @@
 #ifndef _ASMX86_TIME_H
 #define _ASMX86_TIME_H
 
-extern void (*late_time_init)(void);
 extern void hpet_time_init(void);
 
 #include <asm/mc146818rtc.h>
diff -puN include/linux/init.h~proper-extern-for-late_time_init include/linux/init.h
--- a/include/linux/init.h~proper-extern-for-late_time_init
+++ a/include/linux/init.h
@@ -147,6 +147,8 @@ extern unsigned int reset_devices;
 void setup_arch(char **);
 void prepare_namespace(void);
 
+extern void (*late_time_init)(void);
+
 #endif
   
 #ifndef MODULE
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

