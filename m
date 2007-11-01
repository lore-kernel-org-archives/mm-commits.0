From: akpm@linux-foundation.org
Subject: + uml-correctly-strip-kernel-defines-from-userspace-cflags.patch added to -mm tree
Date: Thu, 01 Nov 2007 16:36:27 -0700
Message-ID: <200711012336.lA1NaRvP021427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754048AbXKAXgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 19:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, sam@ravnborg.org


The patch titled
     uml: correctly strip kernel defines from userspace CFLAGS
has been added to the -mm tree.  Its filename is
     uml-correctly-strip-kernel-defines-from-userspace-cflags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-correctly-strip-kernel-defines-from-userspace-cflags.patch
git-kvm.patch
arch-um-drivers-ubd_kernc-a-warning-fix.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
