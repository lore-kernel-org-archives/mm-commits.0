From: akpm@linux-foundation.org
Subject: - uml-fix-string-exporting-on-uml-i386.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:24:26 -0700
Message-ID: <200707242324.l6ONOQCI006272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756371AbXGXXYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:24:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix string exporting on UML/i386
has been removed from the -mm tree.  Its filename was
     uml-fix-string-exporting-on-uml-i386.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix string exporting on UML/i386
From: Jeff Dike <jdike@addtoit.com>

In 2.6.23-rc1, i386 fiddled its string support such that UML started getting
undefined references from modules.  The UML asm/string.h was including the
i386 string.h, which defined __HAVE_ARCH_STR*, but the corresponding
implementations weren't being pulled in.

This is fixed by adding arch/i386/lib/string.h to the list of host
architecture files to be pulled in to UML.

A complication is that the libc exports file assumed that the generic strlen
and strstr weren't in use (i.e.  __HAVE_ARCH_STR is defined), then they aren't
exported.  This is untrue for strlen, which is exported in either case, so
this logic is not needed.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/user_syms.c |    5 +----
 arch/um/sys-i386/Makefile    |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/um/os-Linux/user_syms.c~uml-fix-string-exporting-on-uml-i386 arch/um/os-Linux/user_syms.c
--- a/arch/um/os-Linux/user_syms.c~uml-fix-string-exporting-on-uml-i386
+++ a/arch/um/os-Linux/user_syms.c
@@ -19,10 +19,7 @@ extern void *memmove(void *, const void 
 extern void *memset(void *, int, size_t);
 extern int printf(const char *, ...);
 
-/* If they're not defined, the export is included in lib/string.c.*/
-#ifdef __HAVE_ARCH_STRLEN
-EXPORT_SYMBOL(strlen);
-#endif
+/* If it's not defined, the export is included in lib/string.c.*/
 #ifdef __HAVE_ARCH_STRSTR
 EXPORT_SYMBOL(strstr);
 #endif
diff -puN arch/um/sys-i386/Makefile~uml-fix-string-exporting-on-uml-i386 arch/um/sys-i386/Makefile
--- a/arch/um/sys-i386/Makefile~uml-fix-string-exporting-on-uml-i386
+++ a/arch/um/sys-i386/Makefile
@@ -4,7 +4,7 @@ obj-y = bug.o bugs.o checksum.o delay.o 
 
 obj-$(CONFIG_MODE_SKAS) += stub.o stub_segv.o
 
-subarch-obj-y = lib/bitops.o lib/semaphore.o
+subarch-obj-y = lib/bitops.o lib/semaphore.o lib/string.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
