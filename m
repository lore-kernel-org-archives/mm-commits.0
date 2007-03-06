From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-kconfig-menus-fix-2.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:33:31 -0800
Message-ID: <200703060133.l261XWlP007830@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45558 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933785AbXCFBdt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     sparse chokes on arch/i386/kernel/i8253.c
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-kconfig-menus-fix-2.patch

This patch was dropped because it was folded into linux-kernel-markers-kconfig-menus.patch

------------------------------------------------------
Subject: sparse chokes on arch/i386/kernel/i8253.c
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Here is a marker fix that puts the correct -i include/linux/marker.h in
the top level Makefile so sparse works correctly. The tricky part is to
keep the kernel compiling correctly with a kernel build directory

The fix applies on top the the Linux Kernel Markers for 2.6.20.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN Makefile~linux-kernel-markers-kconfig-menus-fix-2 Makefile
--- a/Makefile~linux-kernel-markers-kconfig-menus-fix-2
+++ a/Makefile
@@ -309,7 +309,8 @@ AFLAGS_KERNEL	=
 LINUXINCLUDE    := -Iinclude \
                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
 		   -include include/linux/autoconf.h \
-		   -include linux/marker.h
+		   -include \
+		   	$(if $(KBUILD_SRC),$(srctree)/)include/linux/marker.h
 
 CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-kconfig-menus-fix-3.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
linux-kernel-markers-kconfig-menus-fix-5.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-architecture-independant-code-flags.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-flags.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
linux-kernel-markers-i386-optimization-flags.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architures-fallback-flags.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
linux-kernel-markers-documentation-update-flags.patch
