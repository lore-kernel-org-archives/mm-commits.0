From: akpm@linux-foundation.org
Subject: - xen-disable-vdso-nosegneg-on-native-boot.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:41:44 -0700
Message-ID: <200707201941.l6KJfino012967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763586AbXGTTmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen: disable vdso "nosegneg" on native boot
has been removed from the -mm tree.  Its filename was
     xen-disable-vdso-nosegneg-on-native-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xen: disable vdso "nosegneg" on native boot
From: Roland McGrath <roland@redhat.com>

One of the nice ideas behind paravirt is that CONFIG_XEN=y can be included
in a standard configuration and be no worse for native booting than as a
Xen guest.  The glibc feature that supports the vDSO "nosegneg" note is
designed specifically to make this easy.  You just have to flip one bit at
boot time.  This patch makes Xen flip the bit, so a CONFIG_XEN=y kernel on
bare hardware does not make glibc use the less-optimized library builds.

Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/compressed/relocs.c |    1 +
 arch/i386/kernel/vsyscall-note.S   |   15 +++++++++------
 arch/i386/xen/setup.c              |   15 +++++++++++++++
 arch/i386/xen/vdso.h               |    4 ++++
 4 files changed, 29 insertions(+), 6 deletions(-)

diff -puN arch/i386/boot/compressed/relocs.c~xen-disable-vdso-nosegneg-on-native-boot arch/i386/boot/compressed/relocs.c
--- a/arch/i386/boot/compressed/relocs.c~xen-disable-vdso-nosegneg-on-native-boot
+++ a/arch/i386/boot/compressed/relocs.c
@@ -31,6 +31,7 @@ static const char* safe_abs_relocs[] = {
 		"__kernel_rt_sigreturn",
 		"__kernel_sigreturn",
 		"SYSENTER_RETURN",
+		"VDSO_NOTE_MASK",
 		"xen_irq_disable_direct_reloc",
 		"xen_save_fl_direct_reloc",
 };
diff -puN arch/i386/kernel/vsyscall-note.S~xen-disable-vdso-nosegneg-on-native-boot arch/i386/kernel/vsyscall-note.S
--- a/arch/i386/kernel/vsyscall-note.S~xen-disable-vdso-nosegneg-on-native-boot
+++ a/arch/i386/kernel/vsyscall-note.S
@@ -14,7 +14,6 @@ ELFNOTE_START(Linux, 0, "a")
 ELFNOTE_END
 
 #ifdef CONFIG_XEN
-
 /*
  * Add a special note telling glibc's dynamic linker a fake hardware
  * flavor that it will use to choose the search path for libraries in the
@@ -28,15 +27,19 @@ ELFNOTE_END
  * It should contain:
  *	hwcap 1 nosegneg
  * to match the mapping of bit to name that we give here.
+ *
+ * At runtime, the fake hardware feature will be considered to be present
+ * if its bit is set in the mask word.  So, we start with the mask 0, and
+ * at boot time we set VDSO_NOTE_NONEGSEG_BIT if running under Xen.
  */
 
-/* Bit used for the pseudo-hwcap for non-negative segments.  We use
-   bit 1 to avoid bugs in some versions of glibc when bit 0 is
-   used; the choice is otherwise arbitrary. */
-#define VDSO_NOTE_NONEGSEG_BIT	1
+#include "../xen/vdso.h"	/* Defines VDSO_NOTE_NONEGSEG_BIT.  */
 
+	.globl VDSO_NOTE_MASK
 ELFNOTE_START(GNU, 2, "a")
-	.long 1, 1<<VDSO_NOTE_NONEGSEG_BIT		/* ncaps, mask */
+	.long 1			/* ncaps */
+VDSO_NOTE_MASK:
+	.long 0			/* mask */
 	.byte VDSO_NOTE_NONEGSEG_BIT; .asciz "nosegneg"	/* bit, name */
 ELFNOTE_END
 #endif
diff -puN arch/i386/xen/setup.c~xen-disable-vdso-nosegneg-on-native-boot arch/i386/xen/setup.c
--- a/arch/i386/xen/setup.c~xen-disable-vdso-nosegneg-on-native-boot
+++ a/arch/i386/xen/setup.c
@@ -19,6 +19,7 @@
 #include <xen/features.h>
 
 #include "xen-ops.h"
+#include "vdso.h"
 
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
@@ -55,6 +56,18 @@ static void xen_idle(void)
 	}
 }
 
+/*
+ * Set the bit indicating "nosegneg" library variants should be used.
+ */
+static void fiddle_vdso(void)
+{
+	extern u32 VDSO_NOTE_MASK; /* See ../kernel/vsyscall-note.S.  */
+	extern char vsyscall_int80_start;
+	u32 *mask = (u32 *) ((unsigned long) &VDSO_NOTE_MASK - VDSO_PRELINK +
+			     &vsyscall_int80_start);
+	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
+}
+
 void __init xen_arch_setup(void)
 {
 	struct physdev_set_iopl set_iopl;
@@ -93,4 +106,6 @@ void __init xen_arch_setup(void)
 #endif
 
 	paravirt_disable_iospace();
+
+	fiddle_vdso();
 }
diff -puN /dev/null arch/i386/xen/vdso.h
--- /dev/null
+++ a/arch/i386/xen/vdso.h
@@ -0,0 +1,4 @@
+/* Bit used for the pseudo-hwcap for non-negative segments.  We use
+   bit 1 to avoid bugs in some versions of glibc when bit 0 is
+   used; the choice is otherwise arbitrary. */
+#define VDSO_NOTE_NONEGSEG_BIT	1
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
binfmt_elf-clean-up-the-pie-randomization-code.patch
