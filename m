From: akpm@linux-foundation.org
Subject: + arch-um-os-linux-start_upc-various-improvements.patch added to -mm tree
Date: Tue, 01 Apr 2008 13:43:37 -0700
Message-ID: <200804012043.m31KhbYD012347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296AbYDAUn5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 16:43:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org


The patch titled
     arch/um/os-Linux/start_up.c: various improvements.
has been added to the -mm tree.  Its filename is
     arch-um-os-linux-start_upc-various-improvements.patch

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
Subject: arch/um/os-Linux/start_up.c: various improvements.
From: WANG Cong <xiyou.wangcong@gmail.com>

 - lets ptrace_child become void
 - adds checking for the return value of change_sig
 - moves errors info into stderr instead of stdout.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/um/os-Linux/start_up.c~arch-um-os-linux-start_upc-various-improvements arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~arch-um-os-linux-start_upc-various-improvements
+++ a/arch/um/os-Linux/start_up.c
@@ -25,15 +25,15 @@
 #include "registers.h"
 #include "skas_ptrace.h"
 
-static int ptrace_child(void)
+static void ptrace_child(void)
 {
 	int ret;
 	/* Calling os_getpid because some libcs cached getpid incorrectly */
 	int pid = os_getpid(), ppid = getppid();
 	int sc_result;
 
-	change_sig(SIGWINCH, 0);
-	if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
+	if (change_sig(SIGWINCH, 0) < 0 ||
+	    ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
 		perror("ptrace");
 		kill(pid, SIGKILL);
 	}
@@ -75,9 +75,8 @@ static void fatal(char *fmt, ...)
 	va_list list;
 
 	va_start(list, fmt);
-	vprintf(fmt, list);
+	vfprintf(stderr, fmt, list);
 	va_end(list);
-	fflush(stdout);
 
 	exit(1);
 }
@@ -87,9 +86,8 @@ static void non_fatal(char *fmt, ...)
 	va_list list;
 
 	va_start(list, fmt);
-	vprintf(fmt, list);
+	vfprintf(stderr, fmt, list);
 	va_end(list);
-	fflush(stdout);
 }
 
 static int start_ptraced_child(void)
@@ -495,7 +493,7 @@ int __init parse_iomem(char *str, int *a
 	driver = str;
 	file = strchr(str,',');
 	if (file == NULL) {
-		printf("parse_iomem : failed to parse iomem\n");
+		fprintf(stderr, "parse_iomem : failed to parse iomem\n");
 		goto out;
 	}
 	*file = '\0';
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-hrt.patch
arch-um-kernel-um_archc-some-small-improvements.patch
arch-um-os-linux-start_upc-various-improvements.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

