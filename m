From: akpm@linux-foundation.org
Subject: + elfnote-mark-all-note-sections-shf_alloc.patch added to
 -mm tree
Date: Sat, 18 Apr 2020 13:19:55 -0700
Message-ID: <20200418201955.wltNE-2kB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbgDRUT4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Apr 2020 16:19:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilie.halip@gmail.com, jeremy@goop.org, maskray@google.com, mm-commits@vger.kernel.org, natechancellor@gmail.com, ndesaulniers@google.com, tglx@linutronix.de, vincenzo.frascino@arm.com


The patch titled
     Subject: elfnote: mark all .note sections SHF_ALLOC
has been added to the -mm tree.  Its filename is
     elfnote-mark-all-note-sections-shf_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/elfnote-mark-all-note-sections-shf_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/elfnote-mark-all-note-sections-shf_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: elfnote: mark all .note sections SHF_ALLOC

ELFNOTE_START allows callers to specify flags for .pushsection assembler
directives.  All callsites but ELF_NOTE use "a" for SHF_ALLOC.  For vdso's
that explicitly use ELF_NOTE_START and BUILD_SALT, the same section is
specified twice after preprocessing, once with "a" flag, once without. 
Example:

.pushsection .note.Linux, "a", @note ;
.pushsection .note.Linux, "", @note ;

While GNU as allows this ordering, it warns for the opposite ordering,
making these directives position dependent.  We'd prefer not to precisely
match this behavior in Clang's integrated assembler.  Instead, the non
__ASSEMBLY__ definition of ELF_NOTE uses
__attribute__((section(".note.Linux"))) which is created with SHF_ALLOC,
so let's make the __ASSEMBLY__ definition of ELF_NOTE consistent with C
and just always use "a" flag.

This allows Clang to assemble a working mainline (5.6) kernel via:
$ make CC=clang AS=clang

Link: https://github.com/ClangBuiltLinux/linux/issues/913
Link: http://lkml.kernel.org/r/20200325231250.99205-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Debugged-by: Ilie Halip <ilie.halip@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elfnote.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/elfnote.h~elfnote-mark-all-note-sections-shf_alloc
+++ a/include/linux/elfnote.h
@@ -54,7 +54,7 @@
 .popsection				;
 
 #define ELFNOTE(name, type, desc)		\
-	ELFNOTE_START(name, type, "")		\
+	ELFNOTE_START(name, type, "a")		\
 		desc			;	\
 	ELFNOTE_END
 
_

Patches currently in -mm which might be from ndesaulniers@google.com are

elfnote-mark-all-note-sections-shf_alloc.patch
