From: akpm@linux-foundation.org
Subject: + core_pattern-fix-up-a-few-miscellaneous-bugs.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:31:22 -0700
Message-ID: <200707290731.l6T7VMPd013808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757162AbXG2Hc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:32:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, jeremy@goop.org, martin.pitt@ubuntu.com, wwoods@redhat.com


The patch titled
     core_pattern: fix up a few miscellaneous bugs
has been added to the -mm tree.  Its filename is
     core_pattern-fix-up-a-few-miscellaneous-bugs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: core_pattern: fix up a few miscellaneous bugs
From: Neil Horman <nhorman@tuxdriver.com>

- Fixes call_usermodehelper_pipe to not wait for program exit on the user
  mode helper process.  Since this context fill the pipe.  The user mode
  helper, if it reads stdin, will block waiting for the pipe to have data on
  it, and we will wait forever for the usermodehelper to exit.  Changed this
  to wait only for a successful exec.

- Fixes do_coredump to detect a crash in the user mode helper process and
  abort the attempt to recursively dump core to another copy of the helper
  process, potentially ad-infinitum.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: <martin.pitt@ubuntu.com>
Cc: <wwoods@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |   14 +++++++++++++-
 kernel/kmod.c |    2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~core_pattern-fix-up-a-few-miscellaneous-bugs fs/exec.c
--- a/fs/exec.c~core_pattern-fix-up-a-few-miscellaneous-bugs
+++ a/fs/exec.c
@@ -1768,12 +1768,24 @@ int do_coredump(long signr, int exit_cod
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
+		if (!strcmp(delimit, current->comm))
+		{
+			printk(KERN_NOTICE "Recursive core dump detected, Aborting\n");
+			goto fail_unlock;
+		}
+
+		core_limit = RLIM_INFINITY;
+
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, helper_argv, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
diff -puN kernel/kmod.c~core_pattern-fix-up-a-few-miscellaneous-bugs kernel/kmod.c
--- a/kernel/kmod.c~core_pattern-fix-up-a-few-miscellaneous-bugs
+++ a/kernel/kmod.c
@@ -505,7 +505,7 @@ int call_usermodehelper_pipe(char *path,
 	if (ret < 0)
 		goto out;
 
-	return call_usermodehelper_exec(sub_info, 1);
+	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
 
   out:
 	call_usermodehelper_freeinfo(sub_info);
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
