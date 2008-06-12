From: akpm@linux-foundation.org
Subject: + kernel-call-constructors-uml-fix-1.patch added to -mm tree
Date: Wed, 11 Jun 2008 17:23:17 -0700
Message-ID: <200806120023.m5C0NIRf025217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYFLAYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 20:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com, jdike@addtoit.com, miklos@szeredi.hu, sam@ravnborg.org


The patch titled
     kernel-call-constructors-uml-fix-1
has been added to the -mm tree.  Its filename is
     kernel-call-constructors-uml-fix-1.patch

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
Subject: kernel-call-constructors-uml-fix-1
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Fix for linker error on UML:

/usr/lib64/gcc/x86_64-suse-linux/4.2.1/../../../../x86_64-suse-linux/bin/ld:arch/um/kernel/vmlinux.lds:267: syntax error

The error is triggered by the use of SORT(CONSTRUCTORS) in the UML
linker script which conflicts with the kernel-call-constructors patch.
Here is what the ld info page says about sorting constructors:

     If you are using the GNU C++ support for initialization priority,
     which provides some control over the order in which global
     constructors are run, you must sort the constructors at link time
     to ensure that they are executed in the correct order.

As there's no C++ code inside the kernel it should be safe to remove
the SORT construct.

Found-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/dyn.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/dyn.lds.S~kernel-call-constructors-uml-fix-1 arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~kernel-call-constructors-uml-fix-1
+++ a/arch/um/kernel/dyn.lds.S
@@ -102,7 +102,7 @@ SECTIONS
     *(.data.init_irqstack)
     DATA_DATA
     *(.data.* .gnu.linkonce.d.*)
-    SORT(CONSTRUCTORS)
+    CONSTRUCTORS
   }
   .data1          : { *(.data1) }
   .tdata	  : { *(.tdata .tdata.* .gnu.linkonce.td.*) }
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

