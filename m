From: akpm@linux-foundation.org
Subject: [merged] uml-improve-error-messages.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:28 -0700
Message-ID: <200904011839.n31IdSuV008671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933645AbZDASqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: improve error messages
has been removed from the -mm tree.  Its filename was
     uml-improve-error-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: improve error messages
From: WANG Cong <xiyou.wangcong@gmail.com>

These error messages are from check_sysemu(), not check_ptrace().

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/um/os-Linux/start_up.c~uml-improve-error-messages arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-improve-error-messages
+++ a/arch/um/os-Linux/start_up.c
@@ -244,7 +244,7 @@ static void __init check_sysemu(void)
 
 	if ((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
-		fatal_perror("check_ptrace: PTRACE_OLDSETOPTIONS failed");
+		fatal_perror("check_sysemu: PTRACE_OLDSETOPTIONS failed");
 
 	while (1) {
 		count++;
@@ -252,12 +252,12 @@ static void __init check_sysemu(void)
 			goto fail;
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
 		if (n < 0)
-			fatal_perror("check_ptrace : wait failed");
+			fatal_perror("check_sysemu: wait failed");
 
 		if (WIFSTOPPED(status) &&
 		    (WSTOPSIG(status) == (SIGTRAP|0x80))) {
 			if (!count) {
-				non_fatal("check_ptrace : SYSEMU_SINGLESTEP "
+				non_fatal("check_sysemu: SYSEMU_SINGLESTEP "
 					  "doesn't singlestep");
 				goto fail;
 			}
@@ -271,7 +271,7 @@ static void __init check_sysemu(void)
 		else if (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGTRAP))
 			count++;
 		else {
-			non_fatal("check_ptrace : expected SIGTRAP or "
+			non_fatal("check_sysemu: expected SIGTRAP or "
 				  "(SIGTRAP | 0x80), got status = %d\n",
 				  status);
 			goto fail;
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch

