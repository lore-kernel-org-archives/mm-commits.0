From: akpm@linux-foundation.org
Subject: - git-mips-fixup.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:45:31 -0800
Message-ID: <200702282345.l1SNjV3H030804@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbXB1Xpe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:45:34 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1SNjVhB000769
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2007 15:45:32 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-mips-fixup
has been removed from the -mm tree.  Its filename was
     git-mips-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-mips-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig          |   32 --------------------------------
 arch/mips/kernel/linux32.c |    3 ---
 arch/mips/kernel/signal.c  |    6 ------
 3 files changed, 41 deletions(-)

diff -puN arch/mips/Kconfig~git-mips-fixup arch/mips/Kconfig
--- a/arch/mips/Kconfig~git-mips-fixup
+++ a/arch/mips/Kconfig
@@ -2076,43 +2076,11 @@ config BINFMT_ELF32
 	bool
 	default y if MIPS32_O32 || MIPS32_N32
 
-<<<<<<< HEAD/arch/mips/Kconfig
 endmenu
 
 menu "Power management options"
 
 source "kernel/power/Kconfig"
-=======
-config PM
-	bool "Power Management support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SOC_AU1X00
-
-config APM
-        tristate "Advanced Power Management Emulation"
-	depends on PM
-        ---help---
-	  APM is a BIOS specification for saving power using several different
-	  techniques. This is mostly useful for battery powered systems with
-	  APM compliant BIOSes. If you say Y here, the system time will be
-	  reset after a RESUME operation, the /proc/apm device will provide
-	  battery status information, and user-space programs will receive
-	  notification of APM "events" (e.g. battery status change).
-
-	  In order to use APM, you will need supporting software. For location
-	  and more information, read <file:Documentation/pm.txt> and the
-	  Battery Powered Linux mini-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  This driver does not spin down disk drives (see the hdparm(8)
-	  manpage ("man 8 hdparm") for that), and it doesn't turn off
-	  VESA-compliant "green" monitors.
-
-	  Generally, if you don't have a battery in your machine, there isn't
-	  much point in using this driver and you should say N. If you get
-	  random kernel OOPSes or reboots that don't seem to be related to
-	  anything, try disabling/enabling this option (or disabling/enabling
-	  APM in your BIOS).
->>>>>>> /arch/mips/Kconfig
 
 endmenu
 
diff -puN arch/mips/kernel/linux32.c~git-mips-fixup arch/mips/kernel/linux32.c
--- a/arch/mips/kernel/linux32.c~git-mips-fixup
+++ a/arch/mips/kernel/linux32.c
@@ -194,8 +194,6 @@ sysn32_waitid(int which, compat_pid_t pi
 	return ret;
 }
 
-<<<<<<< HEAD/arch/mips/kernel/linux32.c
-=======
 struct sysinfo32 {
 	s32 uptime;
 	u32 loads[3];
@@ -240,7 +238,6 @@ asmlinkage int sys32_sysinfo(struct sysi
 	return ret;
 }
 
->>>>>>> /arch/mips/kernel/linux32.c
 #define RLIM_INFINITY32	0x7fffffff
 #define RESOURCE32(x) ((x > RLIM_INFINITY32) ? RLIM_INFINITY32 : x)
 
diff -puN arch/mips/kernel/signal.c~git-mips-fixup arch/mips/kernel/signal.c
--- a/arch/mips/kernel/signal.c~git-mips-fixup
+++ a/arch/mips/kernel/signal.c
@@ -434,14 +434,8 @@ int setup_frame(struct k_sigaction * ka,
 
 	DEBUGP("SIG deliver (%s:%d): sp=0x%p pc=0x%lx ra=0x%lx\n",
 	       current->comm, current->pid,
-<<<<<<< HEAD/arch/mips/kernel/signal.c
-	       frame, regs->cp0_epc, regs->regs[31]);
-	return 0;
-=======
 	       frame, regs->cp0_epc, frame->regs[31]);
-#endif
 	return 0;
->>>>>>> /arch/mips/kernel/signal.c
 
 give_sigsegv:
 	force_sigsegv(signr, current);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
git-md-accel-vs-md.patch
git-mips-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
