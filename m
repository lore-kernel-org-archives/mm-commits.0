From: akpm@linux-foundation.org
Subject: + i386-vdso-install-unstripped-copies-on-disk.patch added to -mm tree
Date: Wed, 11 Jul 2007 14:03:51 -0700
Message-ID: <200707112103.l6BL3p5X016823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933562AbXGKVEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 17:04:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, sam@ravnborg.org


The patch titled
     i386 vDSO: install unstripped copies on disk
has been added to the -mm tree.  Its filename is
     i386-vdso-install-unstripped-copies-on-disk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 vDSO: install unstripped copies on disk
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

 arch/i386/Makefile        |    1 +
 arch/i386/kernel/Makefile |   27 ++++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff -puN arch/i386/Makefile~i386-vdso-install-unstripped-copies-on-disk arch/i386/Makefile
--- a/arch/i386/Makefile~i386-vdso-install-unstripped-copies-on-disk
+++ a/arch/i386/Makefile
@@ -142,6 +142,7 @@ fdimage fdimage144 fdimage288 isoimage: 
 
 install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+	$(Q)$(MAKE) $(build)=arch/i386/kernel $@
 
 archclean:
 	$(Q)$(MAKE) $(clean)=arch/i386/boot
diff -puN arch/i386/kernel/Makefile~i386-vdso-install-unstripped-copies-on-disk arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~i386-vdso-install-unstripped-copies-on-disk
+++ a/arch/i386/kernel/Makefile
@@ -54,7 +54,8 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 # We must build both images before we can assemble it.
 # Note: kbuild does not track this dependency due to usage of .incbin
 $(obj)/vsyscall.o: $(obj)/vsyscall-int80.so $(obj)/vsyscall-sysenter.so
-targets += $(foreach F,int80 sysenter,vsyscall-$F.o vsyscall-$F.so)
+targets += $(foreach F,$(addprefix vsyscall-,int80 sysenter),\
+		     $F.o $F.so $F.so.dbg)
 targets += vsyscall-note.o vsyscall.lds
 
 # The DSO images are built using a special linker script.
@@ -64,16 +65,32 @@ quiet_cmd_syscall = SYSCALL $@
 
 export CPPFLAGS_vsyscall.lds += -P -C -U$(ARCH)
 
-vsyscall-flags = -shared -s -Wl,-soname=linux-gate.so.1 \
+vsyscall-flags = -shared -Wl,-soname=linux-gate.so.1 \
 		 $(call ld-option, -Wl$(comma)--hash-style=sysv)
 SYSCFLAGS_vsyscall-sysenter.so	= $(vsyscall-flags)
 SYSCFLAGS_vsyscall-int80.so	= $(vsyscall-flags)
 
-$(obj)/vsyscall-int80.so $(obj)/vsyscall-sysenter.so: \
-$(obj)/vsyscall-%.so: $(src)/vsyscall.lds \
-		      $(obj)/vsyscall-%.o $(obj)/vsyscall-note.o FORCE
+$(obj)/vsyscall-int80.so.dbg $(obj)/vsyscall-sysenter.so.dbg: \
+$(obj)/vsyscall-%.so.dbg: $(src)/vsyscall.lds \
+			  $(obj)/vsyscall-%.o $(obj)/vsyscall-note.o FORCE
 	$(call if_changed,syscall)
 
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+vdsos := vdso-int80.so vdso-sysenter.so
+
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(@:vdso-%.so=$(obj)/vsyscall-%.so.dbg) \
+			    $(MODLIB)/vdso/$@
+
+$(vdsos):
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+install: $(vdsos)
+
 # We also create a special relocatable object that should mirror the symbol
 # table and layout of the linked DSO.  With ld -R we can then refer to
 # these symbols in the kernel code rather than hand-coded addresses.
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
