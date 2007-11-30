From: akpm@linux-foundation.org
Subject: + fix-__const_udelay-declaration-and-definition-mismatches.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:19:20 -0800
Message-ID: <200711300019.lAU0JK1v014674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933895AbXK3AUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:20:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, hskinnemoen@atmel.com, jdike@linux.intel.com, lethal@linux-sh.org, mingo@elte.hu, takata@linux-m32r.org, tglx@linutronix.de


The patch titled
     Fix __const_udelay declaration and definition mismatches
has been added to the -mm tree.  Its filename is
     fix-__const_udelay-declaration-and-definition-mismatches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix __const_udelay declaration and definition mismatches
From: Jeff Dike <jdike@addtoit.com>

The declaration and implementation of __const_udelay use different
names for the parameter on a number of architectures:

include/asm-avr32/delay.h:15:extern void __const_udelay(unsigned long usecs);
arch/avr32/lib/delay.c:39:inline void __const_udelay(unsigned long xloops)

include/asm-sh/delay.h:15:extern void __const_udelay(unsigned long usecs);
arch/sh/lib/delay.c:22:inline void __const_udelay(unsigned long xloops)

include/asm-m32r/delay.h:15:extern void __const_udelay(unsigned long usecs);
arch/m32r/lib/delay.c:58:void __const_udelay(unsigned long xloops)

include/asm-x86/delay.h:16:extern void __const_udelay(unsigned long usecs);
arch/x86/lib/delay_32.c:82:inline void __const_udelay(unsigned long xloops)
arch/x86/lib/delay_64.c:46:inline void __const_udelay(unsigned long xloops)

The units of the parameter isn't usecs, so that name is definitely
wrong.  It's also not exactly loops, so I suppose xloops is an OK
name.

This patch changes these names from usecs to xloops.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-avr32/delay.h |    2 +-
 include/asm-m32r/delay.h  |    2 +-
 include/asm-sh/delay.h    |    2 +-
 include/asm-x86/delay.h   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-avr32/delay.h~fix-__const_udelay-declaration-and-definition-mismatches include/asm-avr32/delay.h
--- a/include/asm-avr32/delay.h~fix-__const_udelay-declaration-and-definition-mismatches
+++ a/include/asm-avr32/delay.h
@@ -12,7 +12,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 #define udelay(n) (__builtin_constant_p(n) ? \
diff -puN include/asm-m32r/delay.h~fix-__const_udelay-declaration-and-definition-mismatches include/asm-m32r/delay.h
--- a/include/asm-m32r/delay.h~fix-__const_udelay-declaration-and-definition-mismatches
+++ a/include/asm-m32r/delay.h
@@ -12,7 +12,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 #define udelay(n) (__builtin_constant_p(n) ? \
diff -puN include/asm-sh/delay.h~fix-__const_udelay-declaration-and-definition-mismatches include/asm-sh/delay.h
--- a/include/asm-sh/delay.h~fix-__const_udelay-declaration-and-definition-mismatches
+++ a/include/asm-sh/delay.h
@@ -12,7 +12,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 #ifdef CONFIG_SUPERH32
diff -puN include/asm-x86/delay.h~fix-__const_udelay-declaration-and-definition-mismatches include/asm-x86/delay.h
--- a/include/asm-x86/delay.h~fix-__const_udelay-declaration-and-definition-mismatches
+++ a/include/asm-x86/delay.h
@@ -13,7 +13,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 /* 0x10c7 is 2**32 / 1000000 (rounded up) */
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-no_hz-busy-loop.patch
leak-in-do_ubd_request.patch
uml-keep-uml-kconfig-in-sync-with-x86.patch
uml-after_sleep_interval-should-return-something.patch
uml-work-around-host-tcsetattr-bug.patch
git-kvm.patch
uml-add-asm-um-asmh.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
