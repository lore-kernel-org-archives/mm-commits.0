From: akpm@linux-foundation.org
Subject: + core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:31:20 -0700
Message-ID: <200707290731.l6T7VKhg013805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbXG2HcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, jeremy@goop.org, martin.pitt@ubuntu.com, wwoods@redhat.com


The patch titled
     core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
has been added to the -mm tree.  Its filename is
     core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
From: Neil Horman <nhorman@tuxdriver.com>

A rewrite of my previous post for this enhancement.  It uses jeremy's
split_argv/free_argv library functions to translate core_pattern into an argv
array to be passed to the user mode helper process.  It also adds a
translation to format_corename such that the origional value of RLIMIT_CORE
can be passed to userspace as an argument.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: <martin.pitt@ubuntu.com>
Cc: <wwoods@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe fs/exec.c
--- a/fs/exec.c~core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe
+++ a/fs/exec.c
@@ -51,6 +51,7 @@
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
 #include <linux/signalfd.h>
+#include <linux/string.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1520,6 +1521,14 @@ static int format_corename(char *corenam
 					goto out;
 				out_ptr += rc;
 				break;
+			/* core limit size */
+			case 'c':
+				rc = snprintf(out_ptr, out_end - out_ptr,
+					      "%lu", current->signal->rlim[RLIMIT_CORE].rlim_cur);
+				if (rc > out_end - out_ptr)
+					goto out;
+				out_ptr += rc;
+				break;
 			default:
 				break;
 			}
@@ -1704,6 +1713,9 @@ int do_coredump(long signr, int exit_cod
 	int flag = 0;
 	int ispipe = 0;
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
+	char **helper_argv = NULL;
+	int helper_argc = 0;
+	char *delimit;
 
 	audit_core_dumps(signr);
 
@@ -1752,14 +1764,18 @@ int do_coredump(long signr, int exit_cod
 	 * at which point file size limits and permissions will be imposed
 	 * as it does with any other process
 	 */
-	if ((!ispipe) &&
-	   (core_limit < binfmt->min_coredump))
+	if ((!ispipe) && (core_limit < binfmt->min_coredump))
 		goto fail_unlock;
 
  	if (ispipe) {
 		core_limit = RLIM_INFINITY;
+		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
+		/* Terminate the string before the first option */
+		delimit = strchr(corename, ' ');
+		if (delimit)
+			*delimit = '\0';
 		/* SIGPIPE can happen, but it's just never processed */
- 		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
+ 		if(call_usermodehelper_pipe(corename+1, helper_argv, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
  			goto fail_unlock;
@@ -1794,6 +1810,9 @@ int do_coredump(long signr, int exit_cod
 close_fail:
 	filp_close(file, NULL);
 fail_unlock:
+	if (helper_argv)
+		argv_free(helper_argv);
+
 	current->fsuid = fsuid;
 	complete_all(&mm->core_done);
 fail:
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
