From: akpm@linux-foundation.org
Subject: + gcov-architecture-specific-compile-flag-adjustments-fix.patch added to -mm tree
Date: Wed, 28 May 2008 16:17:52 -0700
Message-ID: <200805282317.m4SNHqT2005367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbYE1XUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 19:20:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com, andi@firstfloor.org, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de


The patch titled
     gcov: architecture specific compile flag adjustments fix
has been added to the -mm tree.  Its filename is
     gcov-architecture-specific-compile-flag-adjustments-fix.patch

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

linux-next.patch
kernel-call-constructors.patch
kernel-introduce-gcc_version_lower-macro.patch
kbuild-delay-object-file-renaming-during-module-versioning.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
kbuild-make-source-and-include-paths-absolute.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-fix.patch

