From: akpm@linux-foundation.org
Subject: - binfmt_misc-fix-false-enoexec-when-coupled-with-other-binary-handlers.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:25 -0700
Message-ID: <200808210349.m7L3nP8e015638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825AbYHUDtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, kirill@shutemov.name, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     binfmt_misc: fix false -ENOEXEC when coupled with other binary handlers
has been removed from the -mm tree.  Its filename was
     binfmt_misc-fix-false-enoexec-when-coupled-with-other-binary-handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmt_misc: fix false -ENOEXEC when coupled with other binary handlers
From: Pavel Emelyanov <xemul@openvz.org>

In case the binfmt_misc binary handler is registered *before* the e.g. 
script one (when for example being compiled as a module) the following
situation may occur:

1. user launches a script, whose interpreter is a misc binary;
2. the load_misc_binary sets the misc_bang and returns -ENOEVEC,
   since the binary is a script;
3. the load_script_binary loads one and calls for search_binary_hander
   to run the interpreter;
4. the load_misc_binary is called again, but refuses to load the
   binary due to misc_bang bit set.

The fix is to move the misc_bang setting lower - prior to the actual
call to the search_binary_handler.

Caused by the commit 3a2e7f47 (binfmt_misc.c: avoid potential kernel
stack overflow)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Tested-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-fix-false-enoexec-when-coupled-with-other-binary-handlers fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-fix-false-enoexec-when-coupled-with-other-binary-handlers
+++ a/fs/binfmt_misc.c
@@ -120,8 +120,6 @@ static int load_misc_binary(struct linux
 	if (bprm->misc_bang)
 		goto _ret;
 
-	bprm->misc_bang = 1;
-
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
@@ -199,6 +197,8 @@ static int load_misc_binary(struct linux
 	if (retval < 0)
 		goto _error;
 
+	bprm->misc_bang = 1;
+
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
 		goto _error;
_

Patches currently in -mm which might be from xemul@openvz.org are

memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

