From: akpm@linux-foundation.org
Subject: + gcov-architecture-specific-compile-flag-adjustments-powerpc-fix.patch added to -mm tree
Date: Thu, 12 Jun 2008 02:16:31 -0700
Message-ID: <200806120916.m5C9GVFh011654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbYFLJSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 05:18:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com


The patch titled
     gcov: architecture specific compile flag adjustments powerpc fix
has been added to the -mm tree.  Its filename is
     gcov-architecture-specific-compile-flag-adjustments-powerpc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: architecture specific compile flag adjustments powerpc fix
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Fix for gcov patch fallout:

powerpc allmodconfig fails with

Error: External symbol '__gcov_init' referenced from prom_init.c
Error: External symbol '__gcov_merge_add' referenced from prom_init.c

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/kernel/Makefile~gcov-architecture-specific-compile-flag-adjustments-powerpc-fix arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~gcov-architecture-specific-compile-flag-adjustments-powerpc-fix
+++ a/arch/powerpc/kernel/Makefile
@@ -11,6 +11,7 @@ ifeq ($(CONFIG_PPC32),y)
 CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
+GCOV_prom_init.o := n
 
 ifdef CONFIG_FTRACE
 # Do not trace early boot code
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

origin.patch
linux-next.patch
s390-cio-use-memory_read_from_buffer.patch
kernel-call-constructors.patch
kernel-call-constructors-uml-fix-1.patch
kernel-call-constructors-uml-fix-2.patch
kernel-introduce-gcc_version_lower-macro.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-create-links-to-gcda-files-in-build-directory.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-fix.patch

