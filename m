From: akpm@linux-foundation.org
Subject: + uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:07:55 -0800
Message-ID: <200711160007.lAG07tvn022955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765268AbXKPAH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:07:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@linux.intel.com, magotari@gmail.com


The patch titled
     uml-improve-detection-of-host-cmov-checkpatch-fixes-fix
has been added to the -mm tree.  Its filename is
     uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml-improve-detection-of-host-cmov-checkpatch-fixes-fix
From: Jeff Dike <jdike@linux.intel.com>

Cc: Jeff Dike <jdike@linux.intel.com>
Cc: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/common-offsets.h |    1 +
 arch/um/sys-i386/bugs.c          |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/um/include/common-offsets.h~uml-improve-detection-of-host-cmov-checkpatch-fixes-fix arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-improve-detection-of-host-cmov-checkpatch-fixes-fix
+++ a/arch/um/include/common-offsets.h
@@ -18,6 +18,7 @@ DEFINE_STR(UM_KERN_WARNING, KERN_WARNING
 DEFINE_STR(UM_KERN_NOTICE, KERN_NOTICE);
 DEFINE_STR(UM_KERN_INFO, KERN_INFO);
 DEFINE_STR(UM_KERN_DEBUG, KERN_DEBUG);
+DEFINE_STR(UM_KERN_CONT, KERN_CONT);
 
 DEFINE(UM_ELF_CLASS, ELF_CLASS);
 DEFINE(UM_ELFCLASS32, ELFCLASS32);
diff -puN arch/um/sys-i386/bugs.c~uml-improve-detection-of-host-cmov-checkpatch-fixes-fix arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-improve-detection-of-host-cmov-checkpatch-fixes-fix
+++ a/arch/um/sys-i386/bugs.c
@@ -39,9 +39,9 @@ static void test_for_host_cmov(void)
 	if (setjmp(cmov_test_return) == 0) {
 		unsigned long foo = 0;
 		__asm__ __volatile__("cmovz %0, %1" : "=r" (foo) : "0" (foo));
-		printk(KERN_CONT "Yes\n");
+		printk(UM_KERN_CONT "Yes\n");
 	} else
-		printk(KERN_CONT "No\n");
+		printk(UM_KERN_CONT "No\n");
 
 	sigaction(SIGILL, &old, &new);
 }
_

Patches currently in -mm which might be from jdike@linux.intel.com are

origin.patch
git-kvm.patch
uml-remove-xmm-checking-on-x86.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-fix-urls-in-kconfig-and-help-strings.patch
uml-improve-detection-of-host-cmov.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch
uml-remove-now-unused-code.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-const-and-other-tidying.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-gprof-needs-to-depend-on-frame_pointer.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-reconst-a-parameter.patch
