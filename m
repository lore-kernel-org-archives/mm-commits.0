From: akpm@linux-foundation.org
Subject: + arch-um-kernel-um_archc-some-small-improvements.patch added to -mm tree
Date: Fri, 15 Feb 2008 12:36:57 -0800
Message-ID: <200802152036.m1FKavPH022616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809AbYBOUhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 15:37:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com


The patch titled
     arch/um/kernel/um_arch.c: some small improvements
has been added to the -mm tree.  Its filename is
     arch-um-kernel-um_archc-some-small-improvements.patch

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
Subject: arch/um/kernel/um_arch.c: some small improvements
From: WANG Cong <xiyou.wangcong@gmail.com>

Make some small improvements for arch/um/kernel/um_arch.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/um_arch.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/um/kernel/um_arch.c~arch-um-kernel-um_archc-some-small-improvements arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~arch-um-kernel-um_archc-some-small-improvements
+++ a/arch/um/kernel/um_arch.c
@@ -115,7 +115,7 @@ static int have_root __initdata = 0;
 /* Set in uml_mem_setup and modified in linux_main */
 long long physmem_size = 32 * 1024 * 1024;
 
-static char *usage_string =
+static const char *usage_string =
 "User Mode Linux v%s\n"
 "	available at http://user-mode-linux.sourceforge.net/\n\n";
 
@@ -202,7 +202,7 @@ static void __init uml_checksetup(char *
 
 	p = &__uml_setup_start;
 	while (p < &__uml_setup_end) {
-		int n;
+		size_t n;
 
 		n = strlen(p->str);
 		if (!strncmp(line, p->str, n) && p->setup_func(line + n, add))
@@ -258,7 +258,8 @@ int __init linux_main(int argc, char **a
 {
 	unsigned long avail, diff;
 	unsigned long virtmem_size, max_physmem;
-	unsigned int i, add;
+	unsigned int i;
+	int add;
 	char * mode;
 
 	for (i = 1; i < argc; i++) {
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

uml-fix-initrd-printk.patch
arch-um-kernel-memc-fix-a-shadowed-variable.patch
arch-um-kernel-um_archc-some-small-improvements.patch
fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
