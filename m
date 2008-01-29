From: akpm@linux-foundation.org
Subject: - xen-fix-section-usage-in-xen-heads-and-setupc.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:50:15 -0800
Message-ID: <200801290150.m0T1oF79027559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYA2B7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, chrisw@sous-sol.org, jeremy@xensource.com, mingo@elte.hu, tglx@linutronix.de, toralf.foerster@gmx.de, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     xen: fix section usage in xen-head.S and setup.c
has been removed from the -mm tree.  Its filename was
     xen-fix-section-usage-in-xen-heads-and-setupc.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: xen: fix section usage in xen-head.S and setup.c
=46rom: Sam Ravnborg <sam@ravnborg.org>

=46ailing to specify "ax" in the pushsection caused ld to generate an
additional section for .init.text appending a number.

A side effect of this was a section mismatch warning because modpost di=
d
not recognize a .init.text section named .init.text.1: WARNING:
vmlinux.o(.text.head+0x247): Section mismatch: reference to
=2Einit.text.1:start_kernel (between 'is386' and 'check_x87')

=46ix this by hardcoding the "ax" in the pushsection.  Thanks to Torlaf=
 for
reporting this.

Alan Modra provided the hint that made me able to locate the root cause=
 of
this warning.  And Mike Frysinger told me how to properly fix it using
__INIT/__FINIT.

=46ix following Section mismatch warning in addition:
WARNING: vmlinux.o(.text+0x14c8): Section mismatch: reference to .init.=
data:vsyscall_int80_start (between 'fiddle_vdso' and 'xen_setup_feature=
s')

fiddle_vdso was only used from a __init function - so declare it __init=
=2E

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Toralf F=F6rster <toralf.foerster@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/setup.c    |    2 +-
 arch/x86/xen/xen-head.S |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/x86/xen/setup.c~xen-fix-section-usage-in-xen-heads-and-s=
etupc arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c~xen-fix-section-usage-in-xen-heads-and-setup=
c
+++ a/arch/x86/xen/setup.c
@@ -60,7 +60,7 @@ static void xen_idle(void)
 /*
  * Set the bit indicating "nosegneg" library variants should be used.
  */
-static void fiddle_vdso(void)
+static void __init fiddle_vdso(void)
 {
 	extern const char vdso32_default_start;
 	u32 *mask =3D VDSO32_SYMBOL(&vdso32_default_start, NOTE_MASK);
diff -puN arch/x86/xen/xen-head.S~xen-fix-section-usage-in-xen-heads-an=
d-setupc arch/x86/xen/xen-head.S
--- a/arch/x86/xen/xen-head.S~xen-fix-section-usage-in-xen-heads-and-se=
tupc
+++ a/arch/x86/xen/xen-head.S
@@ -4,16 +4,18 @@
 #ifdef CONFIG_XEN
=20
 #include <linux/elfnote.h>
+#include <linux/init.h>
 #include <asm/boot.h>
 #include <xen/interface/elfnote.h>
=20
-.pushsection .init.text
+	__INIT
 ENTRY(startup_xen)
 	movl %esi,xen_start_info
 	cld
 	movl $(init_thread_union+THREAD_SIZE),%esp
 	jmp xen_start_kernel
-.popsection
+
+	__FINIT
=20
 .pushsection .bss.page_aligned
 	.align PAGE_SIZE_asm
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
sdio-fix-module-device-table-definition-for-m68k.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-net.patch
hamradio-fix-dmascc-section-mismatch.patch
git-x86.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
m68k-use-cc-cross-prefix.patch
cris-avoid-using-arch-links-in-kconfig.patch
uml-remove-topdir.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
tpm-infineon-section-mismatch.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
linux-kernel-markers-create-modpost-file.patch
linux-typesh-always-export-64bit-aligned-defines.patch
avoid-overflows-in-kernel-timec.patch
