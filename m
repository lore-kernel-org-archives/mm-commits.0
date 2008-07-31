From: akpm@linux-foundation.org
Subject: + x86-fdiv-bug-detection-fix.patch added to -mm tree
Date: Thu, 31 Jul 2008 14:50:04 -0700
Message-ID: <200807312150.m6VLo4gj014114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758822AbYGaVu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 17:50:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fdiv bug detection fix
has been added to the -mm tree.  Its filename is
     x86-fdiv-bug-detection-fix.patch

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
fbcon-fix-scrolling-after-logo-is-cleared.patch
drivers-video-fsl-diu-fbc-add-missing-of_node_put.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
x86-fdiv-bug-detection-fix.patch

