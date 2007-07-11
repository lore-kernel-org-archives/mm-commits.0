From: akpm@linux-foundation.org
Subject: + x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch added to -mm tree
Date: Wed, 11 Jul 2007 14:03:58 -0700
Message-ID: <200707112103.l6BL3wi5016829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39718 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934035AbXGKVEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 17:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, sam@ravnborg.org


The patch titled
     x86_64 ia32 vDSO: install unstripped copies on disk
has been added to the -mm tree.  Its filename is
     x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 ia32 vDSO: install unstripped copies on disk
From: Roland McGrath <roland@redhat.com>

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed in
$(MODLIB)/vdso/ by "make install".  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Makefile      |    3 +++
 arch/x86_64/ia32/Makefile |   25 +++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/Makefile~x86_64-ia32-vdso-install-unstripped-copies-on-disk arch/x86_64/Makefile
--- a/arch/x86_64/Makefile~x86_64-ia32-vdso-install-unstripped-copies-on-disk
+++ a/arch/x86_64/Makefile
@@ -110,6 +110,9 @@ fdimage fdimage144 fdimage288 isoimage: 
 
 install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
+ifeq ($(CONFIG_IA32_EMULATION),y)
+	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
+endif
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
diff -puN arch/x86_64/ia32/Makefile~x86_64-ia32-vdso-install-unstripped-copies-on-disk arch/x86_64/ia32/Makefile
--- a/arch/x86_64/ia32/Makefile~x86_64-ia32-vdso-install-unstripped-copies-on-disk
+++ a/arch/x86_64/ia32/Makefile
@@ -18,18 +18,35 @@ $(obj)/syscall32_syscall.o: \
 	$(foreach F,sysenter syscall,$(obj)/vsyscall-$F.so)
 
 # Teach kbuild about targets
-targets := $(foreach F,sysenter syscall,vsyscall-$F.o vsyscall-$F.so)
+targets := $(foreach F,$(addprefix vsyscall-,sysenter syscall),\
+		     $F.o $F.so $F.so.dbg)
 
 # The DSO images are built using a special linker script
 quiet_cmd_syscall = SYSCALL $@
-      cmd_syscall = $(CC) -m32 -nostdlib -shared -s \
+      cmd_syscall = $(CC) -m32 -nostdlib -shared \
 			  $(call ld-option, -Wl$(comma)--hash-style=sysv) \
 			   -Wl,-soname=linux-gate.so.1 -o $@ \
 			   -Wl,-T,$(filter-out FORCE,$^)
 
-$(obj)/vsyscall-sysenter.so $(obj)/vsyscall-syscall.so: \
-$(obj)/vsyscall-%.so: $(src)/vsyscall.lds $(obj)/vsyscall-%.o FORCE
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+$(obj)/vsyscall-sysenter.so.dbg $(obj)/vsyscall-syscall.so.dbg: \
+$(obj)/vsyscall-%.so.dbg: $(src)/vsyscall.lds $(obj)/vsyscall-%.o FORCE
 	$(call if_changed,syscall)
 
 AFLAGS_vsyscall-sysenter.o = -m32 -Wa,-32
 AFLAGS_vsyscall-syscall.o = -m32 -Wa,-32
+
+vdsos := vdso32-sysenter.so vdso32-syscall.so
+
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(@:vdso32-%.so=$(obj)/vsyscall-%.so.dbg) \
+			    $(MODLIB)/vdso/$@
+
+$(vdsos):
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+install: $(vdsos)
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
