From: akpm@linux-foundation.org
Subject: + use-ldflags_module-only-for-ko-links.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:28:25 -0700
Message-ID: <200707232128.l6NLSPgI012750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761674AbXGWV3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:29:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, bunk@stusta.de, davem@davemloft.net, michal.k.k.piotrowski@gmail.com, sam@ravnborg.org


The patch titled
     Use LDFLAGS_MODULE only for .ko links
has been added to the -mm tree.  Its filename is
     use-ldflags_module-only-for-ko-links.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use LDFLAGS_MODULE only for .ko links
From: Roland McGrath <roland@redhat.com>

Sam Ravnborg pointed out that Documentation/kbuild/makefiles.txt already
says this is what it's for.  This patch makes the reality live up to the
documentation.  This fixes the problem of LDFLAGS_BUILD_ID getting into too
many places.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: "Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: David Miller <davem@davemloft.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                 |    2 +-
 scripts/Makefile.build   |    2 +-
 scripts/Makefile.modpost |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Makefile~use-ldflags_module-only-for-ko-links Makefile
--- a/Makefile~use-ldflags_module-only-for-ko-links
+++ a/Makefile
@@ -299,7 +299,7 @@ CHECKFLAGS     := -D__linux__ -Dlinux -D
 MODFLAGS	= -DMODULE
 CFLAGS_MODULE   = $(MODFLAGS)
 AFLAGS_MODULE   = $(MODFLAGS)
-LDFLAGS_MODULE  = -r
+LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 
diff -puN scripts/Makefile.build~use-ldflags_module-only-for-ko-links scripts/Makefile.build
--- a/scripts/Makefile.build~use-ldflags_module-only-for-ko-links
+++ a/scripts/Makefile.build
@@ -315,7 +315,7 @@ quiet_cmd_link_multi-y = LD      $@
 cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps)
 
 quiet_cmd_link_multi-m = LD [M]  $@
-cmd_link_multi-m = $(LD) $(ld_flags) $(LDFLAGS_MODULE) -o $@ $(link_multi_deps)
+cmd_link_multi-m = $(cmd_link_multi-y)
 
 # We would rather have a list of rules like
 # 	foo.o: $(foo-objs)
diff -puN scripts/Makefile.modpost~use-ldflags_module-only-for-ko-links scripts/Makefile.modpost
--- a/scripts/Makefile.modpost~use-ldflags_module-only-for-ko-links
+++ a/scripts/Makefile.modpost
@@ -97,7 +97,7 @@ targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
 quiet_cmd_ld_ko_o = LD [M]  $@
-      cmd_ld_ko_o = $(LD) $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
+      cmd_ld_ko_o = $(LD) -r $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
 			  $(filter-out FORCE,$^)
 
 $(modules): %.ko :%.o %.mod.o FORCE
_

Patches currently in -mm which might be from roland@redhat.com are

use-ldflags_module-only-for-ko-links.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
