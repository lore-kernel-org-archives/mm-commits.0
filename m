From: akpm@linux-foundation.org
Subject: + revert-optimize-and-simplify-get_cycles_sync.patch added to -mm tree
Date: Tue, 06 Mar 2007 16:29:14 -0800
Message-ID: <200703070029.l270TEFx014056@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030766AbXCGA3e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 19:29:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, joerg.roedel@amd.com


The patch titled
     revert optimize-and-simplify-get_cycles_sync
has been added to the -mm tree.  Its filename is
     revert-optimize-and-simplify-get_cycles_sync.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert optimize-and-simplify-get_cycles_sync
From: Andrew Morton <akpm@linux-foundation.org>

unbreak everyone's builds.

Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/cpufeature.h |    1 -
 include/asm-i386/tsc.h        |   21 ++++++++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff -puN include/asm-i386/cpufeature.h~revert-optimize-and-simplify-get_cycles_sync include/asm-i386/cpufeature.h
--- a/include/asm-i386/cpufeature.h~revert-optimize-and-simplify-get_cycles_sync
+++ a/include/asm-i386/cpufeature.h
@@ -49,7 +49,6 @@
 #define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
 #define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
-#define X86_FEATURE_RDTSCP      (1*32+27) /* RDTSCP */
 #define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
 #define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
 #define X86_FEATURE_3DNOW	(1*32+31) /* 3DNow! */
diff -puN include/asm-i386/tsc.h~revert-optimize-and-simplify-get_cycles_sync include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~revert-optimize-and-simplify-get_cycles_sync
+++ a/include/asm-i386/tsc.h
@@ -34,15 +34,22 @@ static inline cycles_t get_cycles(void)
 /* Like get_cycles, but make sure the CPU is synchronized. */
 static __always_inline cycles_t get_cycles_sync(void)
 {
-	unsigned int a, d;
+	unsigned long long ret;
+#ifdef X86_FEATURE_SYNC_RDTSC
+	unsigned eax;
 
-	alternative_io_two("cpuid\nrdtsc",
-			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
-			   "rdtscp", X86_FEATURE_RDTSCP,
-			   ASM_OUTPUT2("=a" (a), "=d" (d)),
-			   "0" (1) : "ecx", "memory");
+	/*
+	 * Don't do an additional sync on CPUs where we know
+	 * RDTSC is already synchronous:
+	 */
+	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
+			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
+#else
+	sync_core();
+#endif
+	rdtscll(ret);
 
-	return ((unsigned long long)a) | (((unsigned long long)d)<<32);
+	return ret;
 }
 
 extern void tsc_init(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-build-with-config_no_idle_hz=n.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
gfs2-build-fix.patch
git-input.patch
git-md-accel-fixup.patch
git-mmc-fix-99.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume.patch
sis900-warning-fixes.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
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
revert-optimize-and-simplify-get_cycles_sync.patch
