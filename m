From: akpm@linux-foundation.org
Subject: + kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch added to -mm tree
Date: Thu, 15 May 2008 16:06:31 -0700
Message-ID: <200805152306.m4FN6VLB015111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbYEOXHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, sam@ravnborg.org


The patch titled
     kbuild: remove final references to deprecated, unreferenced TOPDIR
has been added to the -mm tree.  Its filename is
     kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch

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
Subject: kbuild: remove final references to deprecated, unreferenced TOPDIR
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Now that the final references to the deprecated TOPDIR are gone, it seems
safe to remove its definition.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN Makefile~kbuild-remove-final-references-to-deprecated-unreferenced-topdir Makefile
--- a/Makefile~kbuild-remove-final-references-to-deprecated-unreferenced-topdir
+++ a/Makefile
@@ -148,15 +148,13 @@ _all: modules
 endif
 
 srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
-TOPDIR		:= $(srctree)
-# FIXME - TOPDIR is obsolete, use srctree/objtree
 objtree		:= $(CURDIR)
 src		:= $(srctree)
 obj		:= $(objtree)
 
 VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
 
-export srctree objtree VPATH TOPDIR
+export srctree objtree VPATH
 
 
 # SUBARCH tells the usermode build what the underlying arch is.  That is set
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
macintosh-replace-deprecated-__initcall-with-device_initcall.patch
kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch
zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch
spi-kconfig-simplifications.patch

