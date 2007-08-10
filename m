From: akpm@linux-foundation.org
Subject: - i386-vdso-install-unstripped-copies-on-disk-fix.patch removed from -mm tree
Date: Fri, 10 Aug 2007 14:54:41 -0700
Message-ID: <200708102154.l7ALsf4u011583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59677 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbXHJVzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Aug 2007 17:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     i386-vdso-install-unstripped-copies-on-disk fix
has been removed from the -mm tree.  Its filename was
     i386-vdso-install-unstripped-copies-on-disk-fix.patch

This patch was dropped because it was folded into i386-vdso-install-unstripped-copies-on-disk.patch

------------------------------------------------------
Subject: i386-vdso-install-unstripped-copies-on-disk fix
From: Roland McGrath <roland@redhat.com>

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/Makefile~i386-vdso-install-unstripped-copies-on-disk-fix arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~i386-vdso-install-unstripped-copies-on-disk-fix
+++ a/arch/i386/kernel/Makefile
@@ -65,12 +65,12 @@ export CPPFLAGS_vsyscall.lds += -P -C -U
 
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
@@ -81,7 +81,7 @@ vdsos := vdso-int80.so vdso-sysenter.so
 
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
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
x86_64-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
add-sys-module-name-notes.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
zap_other_threads-dont-optimize-thread_group_empty-case.patch
add-mmf_dump_elf_headers.patch
