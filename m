From: akpm@linux-foundation.org
Subject: + uml-fix-symlink-loops.patch added to -mm tree
Date: Fri, 09 Nov 2007 12:48:27 -0800
Message-ID: <200711092048.lA9KmRee031262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbXKIUst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 15:48:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, sam@ravnborg.org


The patch titled
     uml: fix symlink loops
has been added to the -mm tree.  Its filename is
     uml-fix-symlink-loops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix symlink loops
From: Jeff Dike <jdike@addtoit.com>

symlinks to directories in the non-O= case were lacking -n, which meant
that, when the link already existed, a new link pointing at itself was
created in the target directory.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/Makefile~uml-fix-symlink-loops arch/um/Makefile
--- a/arch/um/Makefile~uml-fix-symlink-loops
+++ a/arch/um/Makefile
@@ -168,7 +168,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-	$(Q)cd $(TOPDIR)/include/asm-um && ln -sf ../asm-$(HEADER_ARCH) arch
+	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(SUBARCH) arch
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
@@ -180,7 +180,7 @@ $(ARCH_DIR)/include/sysdep: $(objtree)/$
 ifneq ($(KBUILD_SRC),)
 	$(Q)ln -fsn $(srctree)/$(ARCH_DIR)/include/sysdep-$(SUBARCH) $(ARCH_DIR)/include/sysdep
 else
-	$(Q)cd $(ARCH_DIR)/include && ln -sf sysdep-$(SUBARCH) sysdep
+	$(Q)cd $(ARCH_DIR)/include && ln -fsn sysdep-$(SUBARCH) sysdep
 endif
 
 $(ARCH_DIR)/os:
@@ -188,7 +188,7 @@ $(ARCH_DIR)/os:
 ifneq ($(KBUILD_SRC),)
 	$(Q)ln -fsn $(srctree)/$(ARCH_DIR)/os-$(OS) $(ARCH_DIR)/os
 else
-	$(Q)cd $(ARCH_DIR) && ln -sf os-$(OS) os
+	$(Q)cd $(ARCH_DIR) && ln -fsn os-$(OS) os
 endif
 
 # Generated files
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-symlink-loops.patch
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
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
