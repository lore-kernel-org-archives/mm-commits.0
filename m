From: akpm@linux-foundation.org
Subject: - uml-correctly-strip-kernel-defines-from-userspace-cflags.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:17 -0800
Message-ID: <200711060552.lA65qH05007279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986AbXKFF5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:57:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     uml: correctly strip kernel defines from userspace CFLAGS
has been removed from the -mm tree.  Its filename was
     uml-correctly-strip-kernel-defines-from-userspace-cflags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: correctly strip kernel defines from userspace CFLAGS
From: Jeff Dike <jdike@addtoit.com>

KERNEL_DEFINES needs whitespace trimmed, otherwise the whitespace crunching
done by make fools the patsubst which is used to remove KERNEL_DEFINES from
USER_CFLAGS.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/um/Makefile~uml-correctly-strip-kernel-defines-from-userspace-cflags arch/um/Makefile
--- a/arch/um/Makefile~uml-correctly-strip-kernel-defines-from-userspace-cflags
+++ a/arch/um/Makefile
@@ -70,9 +70,12 @@ include $(srctree)/$(ARCH_DIR)/Makefile-
 # in KBUILD_CFLAGS.  Otherwise, it would cause ld to complain about the two different
 # errnos.
 # These apply to kernelspace only.
+#
+# strip leading and trailing whitespace to make the USER_CFLAGS removal of these
+# defines more robust
 
-KERNEL_DEFINES = -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
-	-Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES)
+KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
+			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
 KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
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
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
