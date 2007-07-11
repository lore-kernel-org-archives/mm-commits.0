From: akpm@linux-foundation.org
Subject: + pass-g-to-assembler-under-config_debug_info.patch added to -mm tree
Date: Wed, 11 Jul 2007 14:10:28 -0700
Message-ID: <200707112110.l6BLASnZ017265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758253AbXGKVKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 17:10:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, sam@ravnborg.org


The patch titled
     Pass -g to assembler under CONFIG_DEBUG_INFO
has been added to the -mm tree.  Its filename is
     pass-g-to-assembler-under-config_debug_info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Pass -g to assembler under CONFIG_DEBUG_INFO
From: Roland McGrath <roland@redhat.com>

The assembler for a while now supports -g to generate source line info just
like the C compiler does.  Source-level assembly debugging sounds like an
oxymoron, but it is handy to be able to see the right source file and read
its comments rather than just the disassembly.  This patch enables -g for
assembly files when CONFIG_DEBUG_INFO=y and the assembler supports the option.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    1 +
 1 files changed, 1 insertion(+)

diff -puN Makefile~pass-g-to-assembler-under-config_debug_info Makefile
--- a/Makefile~pass-g-to-assembler-under-config_debug_info
+++ a/Makefile
@@ -498,6 +498,7 @@ endif
 
 ifdef CONFIG_DEBUG_INFO
 CFLAGS		+= -g
+AFLAGS		+= $(call as-option, -g)
 endif
 
 # Force gcc to behave correct even for buggy distributions
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
i386-vdso-install-unstripped-copies-on-disk.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
pie-randomization.patch
