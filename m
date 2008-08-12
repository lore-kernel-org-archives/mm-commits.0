From: akpm@linux-foundation.org
Subject: - x86-fdiv-bug-detection-fix.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:34:05 -0700
Message-ID: <200808122034.m7CKY5TG011924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbYHLUe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fdiv bug detection fix
has been removed from the -mm tree.  Its filename was
     x86-fdiv-bug-detection-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fdiv bug detection fix
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The fdiv detection code writes s32 integer into the
boot_cpu_data.fdiv_bug.

However, the boot_cpu_data.fdiv_bug is only char (s8) field so the
detection overwrites already set fields for other bugs, e.g.  the f00f bug
field.

Use local s32 variable to achieve result.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/bugs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/bugs.c~x86-fdiv-bug-detection-fix arch/x86/kernel/cpu/bugs.c
--- a/arch/x86/kernel/cpu/bugs.c~x86-fdiv-bug-detection-fix
+++ a/arch/x86/kernel/cpu/bugs.c
@@ -50,6 +50,8 @@ static double __initdata y = 3145727.0;
  */
 static void __init check_fpu(void)
 {
+	s32 fdiv_bug;
+
 	if (!boot_cpu_data.hard_math) {
 #ifndef CONFIG_MATH_EMULATION
 		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
@@ -74,8 +76,10 @@ static void __init check_fpu(void)
 		"fistpl %0\n\t"
 		"fwait\n\t"
 		"fninit"
-		: "=m" (*&boot_cpu_data.fdiv_bug)
+		: "=m" (*&fdiv_bug)
 		: "m" (*&x), "m" (*&y));
+
+	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
 		printk("Hmm, FPU with FDIV bug.\n");
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
matrox-maven-fix-a-broken-error-path.patch
matroxfb-i2c-structure-templates-clean-up.patch
matrox-maven-convert-to-a-new-style-i2c-driver.patch
atmel_lcdfb-set-ypanstep-to-1-and-enable-y-panning-on-at91.patch
atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size.patch
fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font.patch
linux-next.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch

