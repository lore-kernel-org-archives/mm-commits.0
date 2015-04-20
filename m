From: akpm@linux-foundation.org
Subject: [merged] x86-switch-to-using-asm-generic-for-seccomph.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:43 -0700
Message-ID: <5535518b.cffyIDL6v6SzD5Sg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbDTTOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: switch to using asm-generic for seccomp.h
has been removed from the -mm tree.  Its filename was
     x86-switch-to-using-asm-generic-for-seccomph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: x86: switch to using asm-generic for seccomp.h

Switch to using the newly created asm-generic/seccomp.h for the seccomp
strict mode syscall definitions. The obsolete sigreturn syscall override
is retained in 32-bit mode, and the ia32 syscall overrides are used in
the compat case. Remaining definitions were identical.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/seccomp.h    |   21 ++++++++++++++++++---
 arch/x86/include/asm/seccomp_32.h |   11 -----------
 arch/x86/include/asm/seccomp_64.h |   17 -----------------
 3 files changed, 18 insertions(+), 31 deletions(-)

diff -puN arch/x86/include/asm/seccomp.h~x86-switch-to-using-asm-generic-for-seccomph arch/x86/include/asm/seccomp.h
--- a/arch/x86/include/asm/seccomp.h~x86-switch-to-using-asm-generic-for-seccomph
+++ a/arch/x86/include/asm/seccomp.h
@@ -1,5 +1,20 @@
+#ifndef _ASM_X86_SECCOMP_H
+#define _ASM_X86_SECCOMP_H
+
+#include <asm/unistd.h>
+
 #ifdef CONFIG_X86_32
-# include <asm/seccomp_32.h>
-#else
-# include <asm/seccomp_64.h>
+#define __NR_seccomp_sigreturn		__NR_sigreturn
 #endif
+
+#ifdef CONFIG_COMPAT
+#include <asm/ia32_unistd.h>
+#define __NR_seccomp_read_32		__NR_ia32_read
+#define __NR_seccomp_write_32		__NR_ia32_write
+#define __NR_seccomp_exit_32		__NR_ia32_exit
+#define __NR_seccomp_sigreturn_32	__NR_ia32_sigreturn
+#endif
+
+#include <asm-generic/seccomp.h>
+
+#endif /* _ASM_X86_SECCOMP_H */
diff -puN arch/x86/include/asm/seccomp_32.h~x86-switch-to-using-asm-generic-for-seccomph /dev/null
--- a/arch/x86/include/asm/seccomp_32.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _ASM_X86_SECCOMP_32_H
-#define _ASM_X86_SECCOMP_32_H
-
-#include <linux/unistd.h>
-
-#define __NR_seccomp_read __NR_read
-#define __NR_seccomp_write __NR_write
-#define __NR_seccomp_exit __NR_exit
-#define __NR_seccomp_sigreturn __NR_sigreturn
-
-#endif /* _ASM_X86_SECCOMP_32_H */
diff -puN arch/x86/include/asm/seccomp_64.h~x86-switch-to-using-asm-generic-for-seccomph /dev/null
--- a/arch/x86/include/asm/seccomp_64.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _ASM_X86_SECCOMP_64_H
-#define _ASM_X86_SECCOMP_64_H
-
-#include <linux/unistd.h>
-#include <asm/ia32_unistd.h>
-
-#define __NR_seccomp_read __NR_read
-#define __NR_seccomp_write __NR_write
-#define __NR_seccomp_exit __NR_exit
-#define __NR_seccomp_sigreturn __NR_rt_sigreturn
-
-#define __NR_seccomp_read_32 __NR_ia32_read
-#define __NR_seccomp_write_32 __NR_ia32_write
-#define __NR_seccomp_exit_32 __NR_ia32_exit
-#define __NR_seccomp_sigreturn_32 __NR_ia32_sigreturn
