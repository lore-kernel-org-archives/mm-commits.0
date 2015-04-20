From: akpm@linux-foundation.org
Subject: [merged] powerpc-switch-to-using-asm-generic-for-seccomph.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:38 -0700
Message-ID: <55355186.dY0gSuoLu5fhuvvi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbDTTOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: switch to using asm-generic for seccomp.h
has been removed from the -mm tree.  Its filename was
     powerpc-switch-to-using-asm-generic-for-seccomph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: powerpc: switch to using asm-generic for seccomp.h

Switch to using the newly created asm-generic/seccomp.h for the seccomp
strict mode syscall definitions.  The obsolete sigreturn in COMPAT mode is
retained as an override.  Remaining definitions are identical, though they
incorrectly appeared in uapi, which has been corrected.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/seccomp.h      |   10 ++++++++++
 arch/powerpc/include/uapi/asm/Kbuild    |    1 -
 arch/powerpc/include/uapi/asm/seccomp.h |   16 ----------------
 3 files changed, 10 insertions(+), 17 deletions(-)

diff -puN /dev/null arch/powerpc/include/asm/seccomp.h
--- /dev/null
+++ a/arch/powerpc/include/asm/seccomp.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_POWERPC_SECCOMP_H
+#define _ASM_POWERPC_SECCOMP_H
+
+#include <linux/unistd.h>
+
+#define __NR_seccomp_sigreturn_32 __NR_sigreturn
+
+#include <asm-generic/seccomp.h>
+
+#endif	/* _ASM_POWERPC_SECCOMP_H */
diff -puN arch/powerpc/include/uapi/asm/Kbuild~powerpc-switch-to-using-asm-generic-for-seccomph arch/powerpc/include/uapi/asm/Kbuild
--- a/arch/powerpc/include/uapi/asm/Kbuild~powerpc-switch-to-using-asm-generic-for-seccomph
+++ a/arch/powerpc/include/uapi/asm/Kbuild
@@ -25,7 +25,6 @@ header-y += posix_types.h
 header-y += ps3fb.h
 header-y += ptrace.h
 header-y += resource.h
-header-y += seccomp.h
 header-y += sembuf.h
 header-y += setup.h
 header-y += shmbuf.h
diff -puN arch/powerpc/include/uapi/asm/seccomp.h~powerpc-switch-to-using-asm-generic-for-seccomph /dev/null
--- a/arch/powerpc/include/uapi/asm/seccomp.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _ASM_POWERPC_SECCOMP_H
-#define _ASM_POWERPC_SECCOMP_H
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
-#define __NR_seccomp_sigreturn_32 __NR_sigreturn
