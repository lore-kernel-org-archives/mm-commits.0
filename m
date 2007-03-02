From: akpm@linux-foundation.org
Subject: + revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch added to -mm tree
Date: Thu, 01 Mar 2007 22:25:45 -0800
Message-ID: <200703020627.l226RJkN002246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45062 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422964AbXCBG2A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 01:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@muc.de, mingo@elte.hu, prarit@redhat.com, zwane@arm.linux.org.uk


The patch titled
     revert x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata
has been added to the -mm tree.  Its filename is
     revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata
From: Andrew Morton <akpm@linux-foundation.org>

Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <ak@muc.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Zwane Mwaikambo <zwane@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sysenter.c |    2 +-
 include/linux/init.h        |    7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff -puN arch/i386/kernel/sysenter.c~revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata
+++ a/arch/i386/kernel/sysenter.c
@@ -72,7 +72,7 @@ extern const char vsyscall_int80_start, 
 extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
 static struct page *syscall_pages[1];
 
-int __cpuinit sysenter_setup(void)
+int __init sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	syscall_pages[0] = virt_to_page(syscall_page);
diff -puN include/linux/init.h~revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata include/linux/init.h
--- a/include/linux/init.h~revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata
+++ a/include/linux/init.h
@@ -52,14 +52,9 @@
 #endif
 
 /* For assembly routines */
-#ifdef CONFIG_HOTPLUG_CPU
-#define __INIT		.section	".text","ax"
-#define __INITDATA	.section	".data","aw"
-#else
 #define __INIT		.section	".init.text","ax"
-#define __INITDATA	.section	".init.data","aw"
-#endif
 #define __FINIT		.previous
+#define __INITDATA	.section	".init.data","aw"
 
 #ifndef __ASSEMBLY__
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
