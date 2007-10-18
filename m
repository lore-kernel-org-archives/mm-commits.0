From: akpm@linux-foundation.org
Subject: - core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:27 -0700
Message-ID: <200710180654.l9I6sRR2030525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761659AbXJRHrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, jeremy@goop.org, martin.pitt@ubuntu.com, wwoods@redhat.com, mm-commits@vger.kernel.org


The patch titled
     core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
has been removed from the -mm tree.  Its filename was
     core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -29,6 +29,7 @@
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
+#include <linux/string.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
@@ -1514,6 +1515,14 @@ static int format_corename(char *corenam
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
@@ -1698,6 +1707,9 @@ int do_coredump(long signr, int exit_cod
 	int flag = 0;
 	int ispipe = 0;
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
+	char **helper_argv = NULL;
+	int helper_argc = 0;
+	char *delimit;
 
 	audit_core_dumps(signr);
 
@@ -1746,14 +1758,18 @@ int do_coredump(long signr, int exit_cod
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
@@ -1788,6 +1804,9 @@ int do_coredump(long signr, int exit_cod
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

origin.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
