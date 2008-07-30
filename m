From: akpm@linux-foundation.org
Subject: - kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch removed from -mm tree
Date: Wed, 30 Jul 2008 13:08:16 -0700
Message-ID: <200807302008.m6UK8G6u014306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756170AbYG3UJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 16:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: remove final references to deprecated, unreferenced TOPDIR
has been removed from the -mm tree.  Its filename was
     kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch

This patch was dropped because it was nacked

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
kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch
m32r-remove-the-unused-nohighmem-option.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
uml-remove-the-dead-tty_log-code.patch

