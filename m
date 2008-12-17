From: akpm@linux-foundation.org
Subject: + uml-get-rid-of-the-last-symlink-in-uml-build.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:52:27 -0800
Message-ID: <200812172252.mBHMqRFx026075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbYLQXJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 18:09:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, jdike@addtoit.com, sam@ravnborg.orgviro@ZenIV.linux.org.uk


The patch titled
     uml: get rid of the last symlink in uml build
has been added to the -mm tree.  Its filename is
     uml-get-rid-of-the-last-symlink-in-uml-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: get rid of the last symlink in uml build
From: Al Viro <viro@ZenIV.linux.org.uk>

We need to make asm-offsets.h contents visible for objects built with
userland headers.  Instead of creating a symlink, just have the file with
equivalent include (relative to location of header) created once.

That kills the last symlink used in arch/um builds.  Have fun...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN arch/um/Makefile~uml-get-rid-of-the-last-symlink-in-uml-build arch/um/Makefile
--- a/arch/um/Makefile~uml-get-rid-of-the-last-symlink-in-uml-build
+++ a/arch/um/Makefile
@@ -22,10 +22,11 @@ MODE_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)
 
 include $(srctree)/$(ARCH_DIR)/Makefile-skas
 
-ARCH_INCLUDE	:= -I$(srctree)/$(ARCH_DIR)/include/shared
+SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
+ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
 ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)/shared
 ifneq ($(KBUILD_SRC),)
-ARCH_INCLUDE	+= -I$(ARCH_DIR)/include/shared # for two generated files
+ARCH_INCLUDE	+= -I$(SHARED_HEADERS)
 endif
 KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
 
@@ -85,8 +86,8 @@ endef
 
 KBUILD_KCONFIG := arch/um/Kconfig.$(HEADER_ARCH)
 
-archprepare: $(ARCH_DIR)/include/shared/user_constants.h
-prepare: $(ARCH_DIR)/include/shared/kern_constants.h
+archprepare: $(SHARED_HEADERS)/user_constants.h
+prepare: $(SHARED_HEADERS)/kern_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
 LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib
@@ -119,17 +120,13 @@ endef
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
 CLEAN_FILES += linux x.i gmon.out \
-	$(ARCH_DIR)/include/shared/user_constants.h \
-	$(ARCH_DIR)/include/shared/kern_constants.h
+	$(SHARED_HEADERS)/user_constants.h \
+	$(SHARED_HEADERS)/kern_constants.h
 
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
 		-o -name '*.gcov' \) -type f -print | xargs rm -f
 
-$(objtree)/$(ARCH_DIR)/include/shared:
-	@echo '  MKDIR $@'
-	$(Q)mkdir -p $@
-
 # Generated files
 
 $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s: FORCE
@@ -148,11 +145,11 @@ define filechk_gen-asm-offsets
          echo ""; )
 endef
 
-$(ARCH_DIR)/include/shared/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
+$(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
 	$(call filechk,gen-asm-offsets)
 
-$(ARCH_DIR)/include/shared/kern_constants.h: $(objtree)/$(ARCH_DIR)/include/shared
-	@echo '  SYMLINK $@'
-	$(Q)ln -sf ../../../../include/asm/asm-offsets.h $@
+$(SHARED_HEADERS)/kern_constants.h:
+	$(Q)mkdir -p $(dir $@)
+	$(Q)echo '#include "../../../../include/asm/asm-offsets.h"' >$@
 
 export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
_

Patches currently in -mm which might be from viro@ZenIV.linux.org.uk are

linux-next.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
uml-get-rid-of-the-last-symlink-in-uml-build.patch

