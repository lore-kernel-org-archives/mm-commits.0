From: akpm@linux-foundation.org
Subject: + fix-binfmt_miscc-avoid-potential-kernel-stack-overflow.patch added to -mm tree
Date: Mon, 18 Aug 2008 16:20:52 -0700
Message-ID: <200808182320.m7INKq8Y019064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbYHRXVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 19:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, kirill@shutemov.name, stable@kernel.org


The patch titled
     fix "binfmt_misc.c: avoid potential kernel stack overflow"
has been added to the -mm tree.  Its filename is
     fix-binfmt_miscc-avoid-potential-kernel-stack-overflow.patch

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
Subject: fix "binfmt_misc.c: avoid potential kernel stack overflow"
From: Pavel Emelyanov <xemul@openvz.org>

Fix a regression introduced by 3a2e7f47d71e1df86acc1dda6826890b6546a4e1
("binfmt_misc.c: avoid potential kernel stack overflow").

In the case of modularized binfmt, the appropriate binary handler gets
registered _before_ the script one and sets the misc_bang flag even too
early.

Thus when we launch a script the load_misc_binary sets this bang, then
returns error, since the binary is actually a script, then the
load_script_binary successfully loads the script, then it loads the misc
binary again, which exits with the -ENOEXEC error due to bang set.

Reported-and-tested-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_misc.c~fix-binfmt_miscc-avoid-potential-kernel-stack-overflow fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~fix-binfmt_miscc-avoid-potential-kernel-stack-overflow
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

