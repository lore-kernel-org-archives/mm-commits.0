From: akpm@linux-foundation.org
Subject: - uml-fix-gcc-ices-and-unresolved-externs.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:50:43 -0700
Message-ID: <200807112350.m6BNohlj010978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780AbYGKXvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, bhalevy@panasas.com, bunk@kernel.org, drepper@redhat.com, jdike@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     uml: fix gcc ICEs and unresolved externs
has been removed from the -mm tree.  Its filename was
     uml-fix-gcc-ices-and-unresolved-externs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix gcc ICEs and unresolved externs
From: Jeff Dike <jdike@addtoit.com>

There are various constraints on the use of unit-at-a-time:
        i386 uses no-unit-at-a-time for pre-4.0 (not 4.3)
        x86_64 uses unit-at-a-time always

Uli reported a crash on x86_64 with gcc 4.1.2 with unit-at-a-time, resulting
in commit c0a18111e571138747a98af18b3a2124df56a0d1

Ingo reported a gcc internal error with gcc 4.3 with no-unit-at-a-timem,
resulting in 22eecde2f9034764a3fd095eecfa3adfb8ec9a98

Benny Halevy <bhalevy@panasas.com> is seeing extern inlines not resolved with
gcc 4.3 with no-unit-at-a-time

This patch reintroduces unit-at-a-time for gcc >= 4.0, bringing back the
possibility of Uli's crash.  If that happens, we'll debug it.

I started seeing both the internal compiler errors and unresolved inlines on
Fedora 9.  This patch fixes both problems, without so far reintroducing the
crash reported by Uli.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Benny Halevy <bhalevy@panasas.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile        |    1 -
 arch/um/Makefile-i386   |    7 +++++++
 arch/um/Makefile-x86_64 |    3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff -puN arch/um/Makefile~uml-fix-gcc-ices-and-unresolved-externs arch/um/Makefile
--- a/arch/um/Makefile~uml-fix-gcc-ices-and-unresolved-externs
+++ a/arch/um/Makefile
@@ -77,7 +77,6 @@ include $(srctree)/$(ARCH_DIR)/Makefile-
 KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
 			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
-KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
 
 PHONY += linux
 
diff -puN arch/um/Makefile-i386~uml-fix-gcc-ices-and-unresolved-externs arch/um/Makefile-i386
--- a/arch/um/Makefile-i386~uml-fix-gcc-ices-and-unresolved-externs
+++ a/arch/um/Makefile-i386
@@ -32,4 +32,11 @@ cflags-y += $(call cc-option,-mpreferred
 # an unresolved reference.
 cflags-y += -ffreestanding
 
+# Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
+# a lot more stack due to the lack of sharing of stacklots.  Also, gcc
+# 4.3.0 needs -funit-at-a-time for extern inline functions.
+KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
+			echo $(call cc-option,-fno-unit-at-a-time); \
+			else echo $(call cc-option,-funit-at-a-time); fi ;)
+
 KBUILD_CFLAGS += $(cflags-y)
diff -puN arch/um/Makefile-x86_64~uml-fix-gcc-ices-and-unresolved-externs arch/um/Makefile-x86_64
--- a/arch/um/Makefile-x86_64~uml-fix-gcc-ices-and-unresolved-externs
+++ a/arch/um/Makefile-x86_64
@@ -21,3 +21,6 @@ HEADER_ARCH := x86
 
 LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib64
 LINK-y += -m64
+
+# Do unit-at-a-time unconditionally on x86_64, following the host
+KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch
hppfs-remove-hppfs_permission.patch
kernel-call-constructors-uml-fix-1.patch
kernel-call-constructors-uml-fix-2.patch

