From: akpm@linux-foundation.org
Subject: + binfmt_misc-fix-false-enoexec-when-coupled-with-other-binary-handlers.patch added to -mm tree
Date: Tue, 19 Aug 2008 10:16:48 -0700
Message-ID: <200808191716.m7JHGm2L028549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbYHSRRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 13:17:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, kirill@shutemov.name, stable@kernel.org


The patch titled
     binfmt_misc: fix false -ENOEXEC when coupled with other binary handlers
has been added to the -mm tree.  Its filename is
     binfmt_misc-fix-false-enoexec-when-coupled-with-other-binary-handlers.patch

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

binfmt_misc-fix-false-enoexec-when-coupled-with-other-binary-handlers.patch
fix-binfmt_miscc-avoid-potential-kernel-stack-overflow.patch
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

