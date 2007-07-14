From: akpm@linux-foundation.org
Subject: + i386-vdso-install-unstripped-copies-on-disk-fix.patch added to -mm tree
Date: Fri, 13 Jul 2007 17:04:11 -0700
Message-ID: <200707140004.l6E04B6S030401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756535AbXGNAEh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 20:04:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, sam@ravnborg.org


The patch titled
     i386-vdso-install-unstripped-copies-on-disk fix
has been added to the -mm tree.  Its filename is
     i386-vdso-install-unstripped-copies-on-disk-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386-vdso-install-unstripped-copies-on-disk fix
From: Roland McGrath <roland@redhat.com>

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/Makefile~i386-vdso-install-unstripped-copies-on-disk-fix arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~i386-vdso-install-unstripped-copies-on-disk-fix
+++ a/arch/i386/kernel/Makefile
@@ -67,12 +67,12 @@ export CPPFLAGS_vsyscall.lds += -P -C -U
 
 vsyscall-flags = -shared -Wl,-soname=linux-gate.so.1 \
 		 $(call ld-option, -Wl$(comma)--hash-style=sysv)
-SYSCFLAGS_vsyscall-sysenter.so	= $(vsyscall-flags)
-SYSCFLAGS_vsyscall-int80.so	= $(vsyscall-flags)
+SYSCFLAGS_vsyscall-sysenter.so.dbg	= $(vsyscall-flags)
+SYSCFLAGS_vsyscall-int80.so.dbg		= $(vsyscall-flags)
 
 $(obj)/vsyscall-int80.so.dbg $(obj)/vsyscall-sysenter.so.dbg: \
 $(obj)/vsyscall-%.so.dbg: $(src)/vsyscall.lds \
-			  $(obj)/vsyscall-%.o $(obj)/vsyscall-note.o FORCE
+				  $(obj)/vsyscall-%.o $(obj)/vsyscall-note.o FORCE
 	$(call if_changed,syscall)
 
 $(obj)/%.so: OBJCOPYFLAGS := -S
@@ -83,7 +83,7 @@ vdsos := vdso-int80.so vdso-sysenter.so
 
 quiet_cmd_vdso_install = INSTALL $@
       cmd_vdso_install = cp $(@:vdso-%.so=$(obj)/vsyscall-%.so.dbg) \
-			    $(MODLIB)/vdso/$@
+				    $(MODLIB)/vdso/$@
 
 $(vdsos):
 	@mkdir -p $(MODLIB)/vdso
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
avoid-open_max-in-scm_max_fd.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
pie-randomization.patch
remove-open_max.patch
remove-child_max.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
x86_64-put-allocated-elf-notes-in-read-only-data-segment.patch
alpha-put-allocated-elf-notes-in-read-only-data-segment.patch
powerpc-put-allocated-elf-notes-in-read-only-data-segment.patch
s390-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
use-build-id-ld-option.patch
