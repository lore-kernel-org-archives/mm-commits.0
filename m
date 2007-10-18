From: akpm@linux-foundation.org
Subject: - core_pattern-fix-up-a-few-miscellaneous-bugs.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:29 -0700
Message-ID: <200710180654.l9I6sTh7030530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34165 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760353AbXJRHrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, jeremy@goop.org, martin.pitt@ubuntu.com, wwoods@redhat.com, mm-commits@vger.kernel.org


The patch titled
     core_pattern: fix up a few miscellaneous bugs
has been removed from the -mm tree.  Its filename was
     core_pattern-fix-up-a-few-miscellaneous-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: core_pattern: fix up a few miscellaneous bugs
From: Neil Horman <nhorman@tuxdriver.com>

Fix do_coredump to detect a crash in the user mode helper process and abort
the attempt to recursively dump core to another copy of the helper process,
potentially ad-infinitum.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: <martin.pitt@ubuntu.com>
Cc: <wwoods@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~core_pattern-fix-up-a-few-miscellaneous-bugs fs/exec.c
--- a/fs/exec.c~core_pattern-fix-up-a-few-miscellaneous-bugs
+++ a/fs/exec.c
@@ -1762,14 +1762,27 @@ int do_coredump(long signr, int exit_cod
 		goto fail_unlock;
 
  	if (ispipe) {
-		core_limit = RLIM_INFINITY;
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		/* Terminate the string before the first option */
 		delimit = strchr(corename, ' ');
 		if (delimit)
 			*delimit = '\0';
+		delimit = strrchr(helper_argv[0], '/');
+		if (delimit)
+			delimit++;
+		else
+			delimit = helper_argv[0];
+		if (!strcmp(delimit, current->comm)) {
+			printk(KERN_NOTICE "Recursive core dump detected, "
+					"aborting\n");
+			goto fail_unlock;
+		}
+
+		core_limit = RLIM_INFINITY;
+
 		/* SIGPIPE can happen, but it's just never processed */
- 		if(call_usermodehelper_pipe(corename+1, helper_argv, NULL, &file)) {
+ 		if (call_usermodehelper_pipe(corename+1, helper_argv, NULL,
+				&file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
  			goto fail_unlock;
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
