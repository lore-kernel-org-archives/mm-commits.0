From: akpm@linux-foundation.org
Subject: + exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:55:01 -0700
Message-ID: <200907212355.n6LNt2te017413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZGUXzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, earl_chew@agilent.com, oleg@tv-sign.ru


The patch titled
     exec: make do_coredump() more resilient to recursive crashes
has been added to the -mm tree.  Its filename is
     exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: make do_coredump() more resilient to recursive crashes
From: Neil Horman <nhorman@tuxdriver.com>

Change how we detect recursive dumps.

Currently we have a mechanism by which we try to compare pathnames of the
crashing process to the core_pattern path.  This is broken for a dozen
reasons, and just doesn't work in any sort of robust way.

I'm replacing it with the use of a 0 RLIMIT_CORE value.  Since helper apps
set RLIMIT_CORE to zero, we don't write out core files for any process
with that particular limit set.  It the core_pattern is a pipe, any
non-zero limit is translated to RLIM_INFINITY.

This allows complete dumps to be captured, but prevents infinite recursion
in the event that the core_pattern process itself crashes.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Earl Chew <earl_chew@agilent.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff -puN fs/exec.c~exec-make-do_coredump-more-resilient-to-recursive-crashes-v9 fs/exec.c
--- a/fs/exec.c~exec-make-do_coredump-more-resilient-to-recursive-crashes-v9
+++ a/fs/exec.c
@@ -1788,38 +1788,37 @@ void do_coredump(long signr, int exit_co
  	lock_kernel();
 	ispipe = format_corename(corename, signr);
 	unlock_kernel();
-	/*
-	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
-	 * to a pipe.  Since we're not writing directly to the filesystem
-	 * RLIMIT_CORE doesn't really apply, as no actual core file will be
-	 * created unless the pipe reader choses to write out the core file
-	 * at which point file size limits and permissions will be imposed
-	 * as it does with any other process
-	 */
+
 	if ((!ispipe) && (core_limit < binfmt->min_coredump))
 		goto fail_unlock;
 
  	if (ispipe) {
+		if (core_limit == 0) {
+			 /*
+			  * Normally core limits are irrelevant to pipes, since
+			  * we're not writing to the file system, but we use
+			  * core_limit of 0 here as a speacial value. Any
+			  * non-zero limit gets set to RLIM_INFINITY below, but
+			  * a limit of 0 skips the dump.  This is a consistent
+			  * way to catch recursive crashes.  We can still crash
+			  * if the core_pattern binary sets RLIM_CORE =  !0
+			  * but it runs as root, and can do lots of stupid things
+			  * Note that we use task_tgid_vnr here to grab the pid of the
+			  * process group leader.  That way we get the right pid if a thread
+			  * in a multi-threaded core_pattern process dies.
+			  */
+			printk(KERN_WARNING "Process %d(%s) has RLIMIT_CORE set to 0\n",
+			       task_tgid_vnr(current), current->comm);
+			printk(KERN_WARNING "Aborting core\n");
+			goto fail_unlock;
+		}
+
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
 			goto fail_unlock;
 		}
-		/* Terminate the string before the first option */
-		delimit = strchr(corename, ' ');
-		if (delimit)
-			*delimit = '\0';
-		delimit = strrchr(helper_argv[0], '/');
-		if (delimit)
-			delimit++;
-		else
-			delimit = helper_argv[0];
-		if (!strcmp(delimit, current->comm)) {
-			printk(KERN_NOTICE "Recursive core dump detected, "
-					"aborting\n");
-			goto fail_unlock;
-		}
 
 		core_limit = RLIM_INFINITY;
 
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
kmod-fix-race-in-usermodehelper-code.patch
proc-fix-reported-unit-for-rlimit_cpu.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch

