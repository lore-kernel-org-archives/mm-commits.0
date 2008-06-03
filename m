From: akpm@linux-foundation.org
Subject: - gcov-architecture-specific-compile-flag-adjustments-fix.patch removed from -mm tree
Date: Tue, 03 Jun 2008 15:51:21 -0700
Message-ID: <200806032251.m53MpLcj024007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753639AbYFCWwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oberparleiter@de.ibm.com, andi@firstfloor.org, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de, mm-commits@


The patch titled
     gcov: architecture specific compile flag adjustments fix
has been removed from the -mm tree.  Its filename was
     gcov-architecture-specific-compile-flag-adjustments-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: architecture specific compile flag adjustments fix
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Exclude code from profiling which is not linked to the main kernel or
which is running in a context not compatible with the assumptions made by
gcc's profiling code.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vdso32/Makefile |    1 +
 arch/powerpc/kernel/vdso64/Makefile |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/powerpc/kernel/vdso32/Makefile~gcov-architecture-specific-compile-flag-adjustments-fix arch/powerpc/kernel/vdso32/Makefile
--- a/arch/powerpc/kernel/vdso32/Makefile~gcov-architecture-specific-compile-flag-adjustments-fix
+++ a/arch/powerpc/kernel/vdso32/Makefile
@@ -17,6 +17,7 @@ EXTRA_CFLAGS := -shared -fno-common -fno
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso32.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO32__ -s
+GCOV := n
 
 obj-y += vdso32_wrapper.o
 extra-y += vdso32.lds
diff -puN arch/powerpc/kernel/vdso64/Makefile~gcov-architecture-specific-compile-flag-adjustments-fix arch/powerpc/kernel/vdso64/Makefile
--- a/arch/powerpc/kernel/vdso64/Makefile~gcov-architecture-specific-compile-flag-adjustments-fix
+++ a/arch/powerpc/kernel/vdso64/Makefile
@@ -11,6 +11,7 @@ EXTRA_CFLAGS := -shared -fno-common -fno
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO64__ -s
+GCOV := n
 
 obj-y += vdso64_wrapper.o
 extra-y += vdso64.lds
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

origin.patch
linux-next.patch
gcov-architecture-specific-compile-flag-adjustments-fix.patch

