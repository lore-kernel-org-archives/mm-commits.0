From: akpm@linux-foundation.org
Subject: + uml-fix-config_static_link=y-build-failure-with-newer-glibc.patch added to -mm tree
Date: Mon, 27 Sep 2010 15:25:48 -0700
Message-ID: <201009272225.o8RMPmOi020313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760273Ab0I0W0q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 18:26:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, jdike@addtoit.com, viro@zeniv.linux.org.uk


The patch titled
     uml: fix CONFIG_STATIC_LINK=y build failure with newer glibc
has been added to the -mm tree.  Its filename is
     uml-fix-config_static_link=y-build-failure-with-newer-glibc.patch

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
Subject: uml: fix CONFIG_STATIC_LINK=y build failure with newer glibc
From: Roland McGrath <roland@redhat.com>

With glibc 2.11 or later that was built with --enable-multi-arch, the UML
link fails with undefined references to __rel_iplt_start and similar
symbols.  In recent binutils, the default linker script defines these
symbols (see ld --verbose).  Fix the UML linker scripts to match the new
defaults for these sections.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/dyn.lds.S |   14 ++++++++++++--
 arch/um/kernel/uml.lds.S |   17 +++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/dyn.lds.S~uml-fix-config_static_link=y-build-failure-with-newer-glibc arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~uml-fix-config_static_link=y-build-failure-with-newer-glibc
+++ a/arch/um/kernel/dyn.lds.S
@@ -50,8 +50,18 @@ SECTIONS
   .rela.got       : { *(.rela.got) }
   .rel.bss        : { *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*) }
   .rela.bss       : { *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*) }
-  .rel.plt        : { *(.rel.plt) }
-  .rela.plt       : { *(.rela.plt) }
+  .rel.plt : {
+	*(.rel.plt)
+	PROVIDE_HIDDEN(__rel_iplt_start = .);
+	*(.rel.iplt)
+	PROVIDE_HIDDEN(__rel_iplt_end = .);
+  }
+  .rela.plt : {
+	*(.rela.plt)
+	PROVIDE_HIDDEN(__rela_iplt_start = .);
+	*(.rela.iplt)
+	PROVIDE_HIDDEN(__rela_iplt_end = .);
+  }
   .init           : {
     KEEP (*(.init))
   } =0x90909090
diff -puN arch/um/kernel/uml.lds.S~uml-fix-config_static_link=y-build-failure-with-newer-glibc arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~uml-fix-config_static_link=y-build-failure-with-newer-glibc
+++ a/arch/um/kernel/uml.lds.S
@@ -43,6 +43,23 @@ SECTIONS
 	__syscall_stub_end = .;
   }
 
+  /*
+   * These are needed even in a static link, even if they wind up being empty.
+   * Newer glibc needs these __rel{,a}_iplt_{start,end} symbols.
+   */
+  .rel.plt : {
+	*(.rel.plt)
+	PROVIDE_HIDDEN(__rel_iplt_start = .);
+	*(.rel.iplt)
+	PROVIDE_HIDDEN(__rel_iplt_end = .);
+  }
+  .rela.plt : {
+	*(.rela.plt)
+	PROVIDE_HIDDEN(__rela_iplt_start = .);
+	*(.rela.iplt)
+	PROVIDE_HIDDEN(__rela_iplt_end = .);
+  }
+
   #include "asm/common.lds.S"
 
   init.data : { INIT_DATA }
_

Patches currently in -mm which might be from roland@redhat.com are

uml-fix-config_static_link=y-build-failure-with-newer-glibc.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
default-config_core_dump_default_elf_headers=y.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

