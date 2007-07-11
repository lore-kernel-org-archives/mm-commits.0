From: akpm@linux-foundation.org
Subject: + powerpc-vdso-install-unstripped-copies-on-disk.patch added to -mm tree
Date: Wed, 11 Jul 2007 14:02:27 -0700
Message-ID: <200707112102.l6BL2RZt016716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934019AbXGKVCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 17:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, benh@kernel.crashing.org, paulus@samba.org, sam@ravnborg.org


The patch titled
     powerpc vDSO: install unstripped copies on disk
has been added to the -mm tree.  Its filename is
     powerpc-vdso-install-unstripped-copies-on-disk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc vDSO: install unstripped copies on disk
From: Roland McGrath <roland@redhat.com>

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed in
$(MODLIB)/vdso/ by "make install".  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Makefile               |    5 ++++-
 arch/powerpc/kernel/vdso32/Makefile |   20 +++++++++++++++++---
 arch/powerpc/kernel/vdso64/Makefile |   19 ++++++++++++++++---
 3 files changed, 37 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/Makefile~powerpc-vdso-install-unstripped-copies-on-disk arch/powerpc/Makefile
--- a/arch/powerpc/Makefile~powerpc-vdso-install-unstripped-copies-on-disk
+++ a/arch/powerpc/Makefile
@@ -168,6 +168,10 @@ endef
 
 install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+ifeq ($(CONFIG_PPC64),y)
+	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso64 install
+endif
+	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso32 install
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
@@ -209,4 +213,3 @@ checkbin:
 	fi
 
 CLEAN_FILES += $(TOUT)
-
diff -puN arch/powerpc/kernel/vdso32/Makefile~powerpc-vdso-install-unstripped-copies-on-disk arch/powerpc/kernel/vdso32/Makefile
--- a/arch/powerpc/kernel/vdso32/Makefile~powerpc-vdso-install-unstripped-copies-on-disk
+++ a/arch/powerpc/kernel/vdso32/Makefile
@@ -9,11 +9,11 @@ ifeq ($(CONFIG_PPC32),y)
 CROSS32CC := $(CC)
 endif
 
-targets := $(obj-vdso32) vdso32.so
+targets := $(obj-vdso32) vdso32.so vdso32.so.dbg
 obj-vdso32 := $(addprefix $(obj)/, $(obj-vdso32))
 
 
-EXTRA_CFLAGS := -shared -s -fno-common -fno-builtin
+EXTRA_CFLAGS := -shared -fno-common -fno-builtin
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso32.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO32__ -s
@@ -26,9 +26,14 @@ CPPFLAGS_vdso32.lds += -P -C -Upowerpc
 $(obj)/vdso32_wrapper.o : $(obj)/vdso32.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso32.so: $(src)/vdso32.lds $(obj-vdso32)
+$(obj)/vdso32.so.dbg: $(src)/vdso32.lds $(obj-vdso32)
 	$(call if_changed,vdso32ld)
 
+# strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
 # assembly rules for the .S files
 $(obj-vdso32): %.o: %.S
 	$(call if_changed_dep,vdso32as)
@@ -39,3 +44,12 @@ quiet_cmd_vdso32ld = VDSO32L $@
 quiet_cmd_vdso32as = VDSO32A $@
       cmd_vdso32as = $(CROSS32CC) $(a_flags) -c -o $@ $<
 
+# install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $@.dbg $(MODLIB)/vdso/$@
+
+vdso32.so: $(obj)/vdso32.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+install: vdso32.so
diff -puN arch/powerpc/kernel/vdso64/Makefile~powerpc-vdso-install-unstripped-copies-on-disk arch/powerpc/kernel/vdso64/Makefile
--- a/arch/powerpc/kernel/vdso64/Makefile~powerpc-vdso-install-unstripped-copies-on-disk
+++ a/arch/powerpc/kernel/vdso64/Makefile
@@ -4,10 +4,10 @@ obj-vdso64 = sigtramp.o gettimeofday.o d
 
 # Build rules
 
-targets := $(obj-vdso64) vdso64.so
+targets := $(obj-vdso64) vdso64.so vdso64.so.dbg
 obj-vdso64 := $(addprefix $(obj)/, $(obj-vdso64))
 
-EXTRA_CFLAGS := -shared -s -fno-common -fno-builtin
+EXTRA_CFLAGS := -shared -fno-common -fno-builtin
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO64__ -s
@@ -20,9 +20,14 @@ CPPFLAGS_vdso64.lds += -P -C -U$(ARCH)
 $(obj)/vdso64_wrapper.o : $(obj)/vdso64.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso64.so: $(src)/vdso64.lds $(obj-vdso64)
+$(obj)/vdso64.so.dbg: $(src)/vdso64.lds $(obj-vdso64)
 	$(call if_changed,vdso64ld)
 
+# strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
 # assembly rules for the .S files
 $(obj-vdso64): %.o: %.S
 	$(call if_changed_dep,vdso64as)
@@ -33,4 +38,12 @@ quiet_cmd_vdso64ld = VDSO64L $@
 quiet_cmd_vdso64as = VDSO64A $@
       cmd_vdso64as = $(CC) $(a_flags) -c -o $@ $<
 
+# install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $@.dbg $(MODLIB)/vdso/$@
+
+vdso64.so: $(obj)/vdso64.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
 
+install: vdso64.so
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
i386-vdso-install-unstripped-copies-on-disk.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
pie-randomization.patch
pass-g-to-assembler-under-config_debug_info.patch
