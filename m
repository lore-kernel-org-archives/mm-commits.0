From: akpm@linux-foundation.org
Subject: + proper-extern-for-late_time_init.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:36:43 -0800
Message-ID: <200803030836.m238ahmQ007071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbYCCIiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:38:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     proper extern for late_time_init
has been added to the -mm tree.  Its filename is
     proper-extern-for-late_time_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -148,6 +148,8 @@ extern int initmem_now_dynamic;
 void setup_arch(char **);
 void prepare_namespace(void);
 
+extern void (*late_time_init)(void);
+
 #endif
   
 #ifndef MODULE
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
ipwireless-fix-potential-tty-==-null-dereference.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch

