From: akpm@linux-foundation.org
Subject: - uml-dont-use-glibc-asm-userh.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:13 -0700
Message-ID: <200710162038.l9GKcDUg015422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936122AbXJPVHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: don't use glibc asm/user.h
has been removed from the -mm tree.  Its filename was
     uml-dont-use-glibc-asm-userh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: don't use glibc asm/user.h
From: Jeff Dike <jdike@addtoit.com>

Stop including asm/user.h from libc - it seems to be disappearing from
distros.  It's replaced with sys/user.h which defines user_fpregs_struct and
user_fpxregs_struct instead of user_i387_struct and struct user_fxsr_struct on
i386.

As a bonus, on x86_64, I get to dump some stupid typedefs which were needed in
order to get asm/user.h to compile.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/user-offsets.c   |    6 +++---
 arch/um/sys-x86_64/user-offsets.c |    9 +--------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff -puN arch/um/sys-i386/user-offsets.c~uml-dont-use-glibc-asm-userh arch/um/sys-i386/user-offsets.c
--- a/arch/um/sys-i386/user-offsets.c~uml-dont-use-glibc-asm-userh
+++ a/arch/um/sys-i386/user-offsets.c
@@ -2,9 +2,9 @@
 #include <stddef.h>
 #include <signal.h>
 #include <sys/poll.h>
+#include <sys/user.h>
 #include <sys/mman.h>
 #include <asm/ptrace.h>
-#include <asm/user.h>
 
 #define DEFINE(sym, val) \
 	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -48,8 +48,8 @@ void foo(void)
 	OFFSET(HOST_SC_FP_ST, _fpstate, _st);
 	OFFSET(HOST_SC_FXSR_ENV, _fpstate, _fxsr_env);
 
-	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_i387_struct));
-	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fxsr_struct));
+	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
+	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fpxregs_struct));
 
 	DEFINE(HOST_IP, EIP);
 	DEFINE(HOST_SP, UESP);
diff -puN arch/um/sys-x86_64/user-offsets.c~uml-dont-use-glibc-asm-userh arch/um/sys-x86_64/user-offsets.c
--- a/arch/um/sys-x86_64/user-offsets.c~uml-dont-use-glibc-asm-userh
+++ a/arch/um/sys-x86_64/user-offsets.c
@@ -3,17 +3,10 @@
 #include <signal.h>
 #include <sys/poll.h>
 #include <sys/mman.h>
+#include <sys/user.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
 #include <asm/types.h>
-/* For some reason, x86_64 defines u64 and u32 only in <pci/types.h>, which I
- * refuse to include here, even though they're used throughout the headers.
- * These are used in asm/user.h, and that include can't be avoided because of
- * the sizeof(struct user_regs_struct) below.
- */
-typedef __u64 u64;
-typedef __u32 u32;
-#include <asm/user.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
