From: akpm@linux-foundation.org
Subject: [merged] parisc-switch-to-using-asm-generic-for-seccomph.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:36 -0700
Message-ID: <55355184.ldc+9ZhN2JAX2S8q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbDTTOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: switch to using asm-generic for seccomp.h
has been removed from the -mm tree.  Its filename was
     parisc-switch-to-using-asm-generic-for-seccomph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: parisc: switch to using asm-generic for seccomp.h

Switch to using the newly created asm-generic/seccomp.h for the seccomp
strict mode syscall definitions. Definitions were identical.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/Kbuild    |    1 +
 arch/parisc/include/asm/seccomp.h |   16 ----------------
 2 files changed, 1 insertion(+), 16 deletions(-)

diff -puN arch/parisc/include/asm/Kbuild~parisc-switch-to-using-asm-generic-for-seccomph arch/parisc/include/asm/Kbuild
--- a/arch/parisc/include/asm/Kbuild~parisc-switch-to-using-asm-generic-for-seccomph
+++ a/arch/parisc/include/asm/Kbuild
@@ -20,6 +20,7 @@ generic-y += param.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += preempt.h
+generic-y += seccomp.h
 generic-y += segment.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff -puN arch/parisc/include/asm/seccomp.h~parisc-switch-to-using-asm-generic-for-seccomph /dev/null
--- a/arch/parisc/include/asm/seccomp.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _ASM_PARISC_SECCOMP_H
-#define _ASM_PARISC_SECCOMP_H
-
-#include <linux/unistd.h>
-
-#define __NR_seccomp_read __NR_read
-#define __NR_seccomp_write __NR_write
-#define __NR_seccomp_exit __NR_exit
-#define __NR_seccomp_sigreturn __NR_rt_sigreturn
-
-#define __NR_seccomp_read_32 __NR_read
-#define __NR_seccomp_write_32 __NR_write
-#define __NR_seccomp_exit_32 __NR_exit
-#define __NR_seccomp_sigreturn_32 __NR_rt_sigreturn
