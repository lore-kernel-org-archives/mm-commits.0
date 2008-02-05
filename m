From: akpm@linux-foundation.org
Subject: - uml-remove-topdir.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:36 -0800
Message-ID: <200802052238.m15McHOf012938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37976 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932369AbYBEWnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@linux.intel.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     uml: remove TOPDIR
has been removed from the -mm tree.  Its filename was
     uml-remove-topdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove TOPDIR
From: WANG Cong <xiyou.wangcong@gmail.com>

TOPDIR is obsolete, use srctree instead.  This patch removes TOPDIR from all
UML Makefiles.

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile         |    4 ++--
 arch/um/sys-ppc/Makefile |   22 +++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/um/Makefile~uml-remove-topdir arch/um/Makefile
--- a/arch/um/Makefile~uml-remove-topdir
+++ a/arch/um/Makefile
@@ -160,7 +160,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-um/$(basename $(notdir $@))-$(SUBARCH)$(suffix $@) $@
 else
-	$(Q)cd $(TOPDIR)/$(dir $@) ; \
+	$(Q)cd $(srctree)/$(dir $@) ; \
 	ln -sf $(basename $(notdir $@))-$(SUBARCH)$(suffix $@) $(notdir $@)
 endif
 
@@ -170,7 +170,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
+	$(Q)cd $(srctree)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
diff -puN arch/um/sys-ppc/Makefile~uml-remove-topdir arch/um/sys-ppc/Makefile
--- a/arch/um/sys-ppc/Makefile~uml-remove-topdir
+++ a/arch/um/sys-ppc/Makefile
@@ -6,7 +6,7 @@ OBJ = built-in.o
 OBJS = ptrace.o sigcontext.o semaphore.o checksum.o miscthings.o misc.o \
 	ptrace_user.o sysrq.o
 
-EXTRA_AFLAGS := -DCONFIG_PPC32 -I. -I$(TOPDIR)/arch/ppc/kernel
+EXTRA_AFLAGS := -DCONFIG_PPC32 -I. -I$(srctree)/arch/ppc/kernel
 
 all: $(OBJ)
 
@@ -22,25 +22,25 @@ sigcontext.o: sigcontext.c
 
 semaphore.c:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/kernel/$@ $@
+	ln -s $(srctree)/arch/ppc/kernel/$@ $@
 
 checksum.S:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/lib/$@ $@
+	ln -s $(srctree)/arch/ppc/lib/$@ $@
 
 mk_defs.c:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/kernel/$@ $@
+	ln -s $(srctree)/arch/ppc/kernel/$@ $@
 
 ppc_defs.head:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/kernel/$@ $@
+	ln -s $(srctree)/arch/ppc/kernel/$@ $@
 
 ppc_defs.h: mk_defs.c ppc_defs.head \
-		$(TOPDIR)/include/asm-ppc/mmu.h \
-		$(TOPDIR)/include/asm-ppc/processor.h \
-		$(TOPDIR)/include/asm-ppc/pgtable.h \
-		$(TOPDIR)/include/asm-ppc/ptrace.h
+		$(srctree)/include/asm-ppc/mmu.h \
+		$(srctree)/include/asm-ppc/processor.h \
+		$(srctree)/include/asm-ppc/pgtable.h \
+		$(srctree)/include/asm-ppc/ptrace.h
 #	$(CC) $(CFLAGS) -S mk_defs.c
 	cp ppc_defs.head ppc_defs.h
 # for bk, this way we can write to the file even if it's not checked out
@@ -56,13 +56,13 @@ ppc_defs.h: mk_defs.c ppc_defs.head \
 
 checksum.o: checksum.S
 	rm -f asm
-	ln -s $(TOPDIR)/include/asm-ppc asm
+	ln -s $(srctree)/include/asm-ppc asm
 	$(CC) $(EXTRA_AFLAGS) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 	rm -f asm
 
 misc.o: misc.S ppc_defs.h
 	rm -f asm
-	ln -s $(TOPDIR)/include/asm-ppc asm
+	ln -s $(srctree)/include/asm-ppc asm
 	$(CC) $(EXTRA_AFLAGS) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 	rm -f asm
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
