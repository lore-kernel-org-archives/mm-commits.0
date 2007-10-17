From: akpm@linux-foundation.org
Subject: + x86-use-relative-symlink-for-bzimage.patch added to -mm tree
Date: Wed, 17 Oct 2007 13:38:07 -0700
Message-ID: <200710172038.l9HKc7B8007296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755314AbXJQUii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 16:38:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: use relative symlink for bzImage
has been added to the -mm tree.  Its filename is
     x86-use-relative-symlink-for-bzimage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: use relative symlink for bzImage
From: Sam Ravnborg <sam@ravnborg.org>

Use relative symlinks so we can refer bzImage from different tree
structures aka via NFS.

Moved the creation of directory + symlink after a successful build of the
boot parts.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Makefile   |    4 ++--
 arch/x86_64/Makefile |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/Makefile~x86-use-relative-symlink-for-bzimage arch/i386/Makefile
--- a/arch/i386/Makefile~x86-use-relative-symlink-for-bzimage
+++ a/arch/i386/Makefile
@@ -131,9 +131,9 @@ all: bzImage
 zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
 
 zImage bzImage: vmlinux
-	$(Q)mkdir -p $(objtree)/arch/i386/boot
-	$(Q)ln -fsn $(objtree)/arch/x86/boot/bzImage $(objtree)/arch/i386/boot/bzImage
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
+	$(Q)mkdir -p $(objtree)/arch/i386/boot
+	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/i386/boot/bzImage
 
 compressed: zImage
 
diff -puN arch/x86_64/Makefile~x86-use-relative-symlink-for-bzimage arch/x86_64/Makefile
--- a/arch/x86_64/Makefile~x86-use-relative-symlink-for-bzimage
+++ a/arch/x86_64/Makefile
@@ -97,9 +97,9 @@ BOOTIMAGE                     := arch/x8
 KBUILD_IMAGE                  := $(BOOTIMAGE)
 
 bzImage: vmlinux
-	$(Q)mkdir -p $(objtree)/arch/x86_64/boot
-	$(Q)ln -fsn $(objtree)/arch/x86/boot/bzImage $(objtree)/arch/x86_64/boot/bzImage
 	$(Q)$(MAKE) $(build)=$(boot) $(BOOTIMAGE)
+	$(Q)mkdir -p $(objtree)/arch/x86_64/boot
+	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/x86_64/boot/bzImage
 
 bzlilo: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) zlilo
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
x86-use-relative-symlink-for-bzimage.patch
documentation-make-headers_installtxt.patch
modpost-problem-when-symbols-move-from-one-module-to-another.patch
