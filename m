From: akpm@linux-foundation.org
Subject: - arch-um-os-linux-start_upc-various-improvements.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:51 -0700
Message-ID: <200804282154.m3SLspVf018046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935456AbYD1Vy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     arch/um/os-Linux/start_up.c: various improvements.
has been removed from the -mm tree.  Its filename was
     arch-um-os-linux-start_upc-various-improvements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

