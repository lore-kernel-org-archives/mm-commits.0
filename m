From: akpm@linux-foundation.org
Subject: + i386-vdso_prelink-warning-fix.patch added to -mm tree
Date: Mon, 05 Mar 2007 22:36:06 -0800
Message-ID: <200703060637.l266bkL5014573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933962AbXCFGh5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 01:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, rusty@rustcorp.com.au


The patch titled
     i386: VDSO_PRELINK warning fix
has been added to the -mm tree.  Its filename is
     i386-vdso_prelink-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: VDSO_PRELINK warning fix
From: Andrew Morton <akpm@linux-foundation.org>

The lguest patche ssomehow managed to trigger this:

In file included from arch/i386/lguest/lguest.c:38:
include/asm/asm-offsets.h:67:1: warning: "VDSO_PRELINK" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:15,
                 from include/linux/device.h:21,
                 from include/linux/interrupt.h:15,
                 from arch/i386/lguest/lguest.c:27:
include/asm/elf.h:140:1: warning: this is the location of the previous definition

I assume that using the same identifier twice was a bad idea..

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c  |    2 +-
 arch/i386/kernel/vsyscall.lds.S |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/asm-offsets.c~i386-vdso_prelink-warning-fix arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~i386-vdso_prelink-warning-fix
+++ a/arch/i386/kernel/asm-offsets.c
@@ -101,7 +101,7 @@ void foo(void)
 		 sizeof(struct tss_struct));
 
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
-	DEFINE(VDSO_PRELINK, VDSO_PRELINK);
+	DEFINE(VDSO_PRELINK_asm, VDSO_PRELINK);
 
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
 
diff -puN arch/i386/kernel/vsyscall.lds.S~i386-vdso_prelink-warning-fix arch/i386/kernel/vsyscall.lds.S
--- a/arch/i386/kernel/vsyscall.lds.S~i386-vdso_prelink-warning-fix
+++ a/arch/i386/kernel/vsyscall.lds.S
@@ -7,7 +7,7 @@
 
 SECTIONS
 {
-  . = VDSO_PRELINK + SIZEOF_HEADERS;
+  . = VDSO_PRELINK_asm + SIZEOF_HEADERS;
 
   .hash           : { *(.hash) }		:text
   .gnu.hash       : { *(.gnu.hash) }
@@ -21,7 +21,7 @@ SECTIONS
      For the layouts to match, we need to skip more than enough
      space for the dynamic symbol table et al.  If this amount
      is insufficient, ld -shared will barf.  Just increase it here.  */
-  . = VDSO_PRELINK + 0x400;
+  . = VDSO_PRELINK_asm + 0x400;
 
   .text           : { *(.text) }		:text =0x90909090
   .note		  : { *(.note.*) }		:text :note
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-md-accel-fixup.patch
git-mmc-fix-99.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
i386-vdso_prelink-warning-fix.patch
