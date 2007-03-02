From: akpm@linux-foundation.org
Subject: + vmi-paravirt-drop-udelay-op.patch added to -mm tree
Date: Thu, 01 Mar 2007 19:37:22 -0800
Message-ID: <200703020337.l223bMOW031346@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39690 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422805AbXCBDhY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 22:37:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com


The patch titled
     vmi: paravirt drop udelay op
has been added to the -mm tree.  Its filename is
     vmi-paravirt-drop-udelay-op.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmi: paravirt drop udelay op
From: Zachary Amsden <zach@vmware.com>

Not respecting udelay causes problems with any virtual hardware that is passed
through to real hardware.  This can be noticed by any device that interacts
with the real world in real time - like AP startup, which takes real time.  Or
keyboard LEDs, which should blink in real-time.  Or floppy drives, but only
when passed through to a real floppy controller on OSes which can't
sufficiently buffer the floppy commands to emulate a zero latency floppy.  Or
IDE drives, when connecting to a physical CDROM.

This was mostly a hack to get the kernel to boot faster, but it introduced a
number of misvirtualization bugs, and Alan and Pavel argued pretty strongly
against it.  We were the only client, and now want to clean up this cruft.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    1 -
 arch/i386/kernel/smpboot.c  |    5 -----
 arch/i386/kernel/vmi.c      |    8 +-------
 include/asm-i386/delay.h    |    8 --------
 include/asm-i386/paravirt.h |    1 -
 5 files changed, 1 insertion(+), 22 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~vmi-paravirt-drop-udelay-op arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~vmi-paravirt-drop-udelay-op
+++ a/arch/i386/kernel/paravirt.c
@@ -538,7 +538,6 @@ struct paravirt_ops paravirt_ops = {
 
 	.set_iopl_mask = native_set_iopl_mask,
 	.io_delay = native_io_delay,
-	.const_udelay = __const_udelay,
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	.apic_write = native_apic_write,
diff -puN arch/i386/kernel/smpboot.c~vmi-paravirt-drop-udelay-op arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~vmi-paravirt-drop-udelay-op
+++ a/arch/i386/kernel/smpboot.c
@@ -33,11 +33,6 @@
  *		Dave Jones	:	Report invalid combinations of Athlon CPUs.
 *		Rusty Russell	:	Hacked into shape for new "hotplug" boot process. */
 
-
-/* SMP boot always wants to use real time delay to allow sufficient time for
- * the APs to come online */
-#define USE_REAL_TIME_DELAY
-
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff -puN arch/i386/kernel/vmi.c~vmi-paravirt-drop-udelay-op arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-paravirt-drop-udelay-op
+++ a/arch/i386/kernel/vmi.c
@@ -48,7 +48,6 @@ typedef u64 __attribute__((regparm(2))) 
 
 static struct vrom_header *vmi_rom;
 static int license_gplok;
-static int disable_nodelay;
 static int disable_pge;
 static int disable_pse;
 static int disable_sep;
@@ -801,9 +800,6 @@ static inline int __init activate_vmi(vo
 
 	para_fill(set_iopl_mask, SetIOPLMask);
 	paravirt_ops.io_delay = (void *)vmi_nop;
-	if (!disable_nodelay) {
-		paravirt_ops.const_udelay = (void *)vmi_nop;
-	}
 
 	para_fill(set_lazy_mode, SetLazyMode);
 
@@ -947,9 +943,7 @@ static int __init parse_vmi(char *arg)
 	if (!arg)
 		return -EINVAL;
 
-	if (!strcmp(arg, "disable_nodelay"))
-		disable_nodelay = 1;
-	else if (!strcmp(arg, "disable_pge")) {
+	if (!strcmp(arg, "disable_pge")) {
 		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 		disable_pge = 1;
 	} else if (!strcmp(arg, "disable_pse")) {
diff -puN include/asm-i386/delay.h~vmi-paravirt-drop-udelay-op include/asm-i386/delay.h
--- a/include/asm-i386/delay.h~vmi-paravirt-drop-udelay-op
+++ a/include/asm-i386/delay.h
@@ -16,13 +16,6 @@ extern void __ndelay(unsigned long nsecs
 extern void __const_udelay(unsigned long usecs);
 extern void __delay(unsigned long loops);
 
-#if defined(CONFIG_PARAVIRT) && !defined(USE_REAL_TIME_DELAY)
-#define udelay(n) paravirt_ops.const_udelay((n) * 0x10c7ul)
-
-#define ndelay(n) paravirt_ops.const_udelay((n) * 5ul)
-
-#else /* !PARAVIRT || USE_REAL_TIME_DELAY */
-
 /* 0x10c7 is 2**32 / 1000000 (rounded up) */
 #define udelay(n) (__builtin_constant_p(n) ? \
 	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
@@ -32,7 +25,6 @@ extern void __delay(unsigned long loops)
 #define ndelay(n) (__builtin_constant_p(n) ? \
 	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
 	__ndelay(n))
-#endif
 
 void use_tsc_delay(void);
 
diff -puN include/asm-i386/paravirt.h~vmi-paravirt-drop-udelay-op include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~vmi-paravirt-drop-udelay-op
+++ a/include/asm-i386/paravirt.h
@@ -117,7 +117,6 @@ struct paravirt_ops
 	void (*set_iopl_mask)(unsigned mask);
 
 	void (*io_delay)(void);
-	void (*const_udelay)(unsigned long loops);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	void (*apic_write)(unsigned long reg, unsigned long v);
_

Patches currently in -mm which might be from zach@vmware.com are

vmi-timer-fixes-round-two.patch
vmi-sched-clock-paravirt-op-fix.patch
vmi-cpu-cycles-fix.patch
vmi-fix-highpte.patch
vmi-paravirt-drop-udelay-op.patch
vmi-pit-override.patch
vmi-fix-nohz-compile.patch
vmi-apic-ops.patch
vmi-smp-fixes.patch
make-struct-vmi_ops-static.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
