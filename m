From: akpm@linux-foundation.org
Subject: + arch-um-os-linux-sys-i386-task_sizec-improve-a-bit.patch added to -mm tree
Date: Mon, 14 Apr 2008 23:43:28 -0700
Message-ID: <200804150643.m3F6hSbT015287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbYDOGnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 02:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org


The patch titled
     arch/um/os-Linux/sys-i386/task_size.c: improve a bit
has been added to the -mm tree.  Its filename is
     arch-um-os-linux-sys-i386-task_sizec-improve-a-bit.patch

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
Subject: arch/um/os-Linux/sys-i386/task_size.c: improve a bit
From: WANG Cong <xiyou.wangcong@gmail.com>

Improve this code a bit: check sigaction's return value and remove a useless
fflush().

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sys-i386/task_size.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/um/os-Linux/sys-i386/task_size.c~arch-um-os-linux-sys-i386-task_sizec-improve-a-bit arch/um/os-Linux/sys-i386/task_size.c
--- a/arch/um/os-Linux/sys-i386/task_size.c~arch-um-os-linux-sys-i386-task_sizec-improve-a-bit
+++ a/arch/um/os-Linux/sys-i386/task_size.c
@@ -88,7 +88,10 @@ unsigned long os_get_task_size(void)
 	sa.sa_handler = segfault;
 	sigemptyset(&sa.sa_mask);
 	sa.sa_flags = SA_NODEFER;
-	sigaction(SIGSEGV, &sa, &old);
+	if (sigaction(SIGSEGV, &sa, &old)) {
+		perror("os_get_task_size");
+		exit(1);
+	}
 
 	if (!page_ok(bottom)) {
 		fprintf(stderr, "Address 0x%x no good?\n",
@@ -110,11 +113,12 @@ unsigned long os_get_task_size(void)
 
 out:
 	/* Restore the old SIGSEGV handling */
-	sigaction(SIGSEGV, &old, NULL);
-
+	if (sigaction(SIGSEGV, &old, NULL)) {
+		perror("os_get_task_size");
+		exit(1);
+	}
 	top <<= UM_KERN_PAGE_SHIFT;
 	printf("0x%x\n", top);
-	fflush(stdout);
 
 	return top;
 }
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

uml-compile-error-fix.patch
git-hrt.patch
arch-um-kernel-um_archc-some-small-improvements.patch
arch-um-os-linux-start_upc-various-improvements.patch
uml-make-a-function-static.patch
uml-remove-a-useless-function.patch
uml-make-three-functions-static.patch
uml-make-several-things-static.patch
uml-clean-up-arch-um-drivers-ubd_kernc.patch
arch-um-os-linux-sys-i386-task_sizec-improve-a-bit.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

