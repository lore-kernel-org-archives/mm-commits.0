From: akpm@linux-foundation.org
Subject: + uml-drivers-slip_userc-memory-leak-fix.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:55:11 -0700
Message-ID: <201107222255.p6MMtBwJ020028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab1GVWzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitalivanov@gmail.com, richard@nod.at


The patch titled
     uml: drivers/slip_user.c memory leak fix
has been added to the -mm tree.  Its filename is
     uml-drivers-slip_userc-memory-leak-fix.patch

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
Subject: uml: drivers/slip_user.c memory leak fix
From: Vitaliy Ivanov <vitalivanov@gmail.com>

Do not free memory when you failed to allocate it.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/slip_user.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/um/drivers/slip_user.c~uml-drivers-slip_userc-memory-leak-fix arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-drivers-slip_userc-memory-leak-fix
+++ a/arch/um/drivers/slip_user.c
@@ -102,7 +102,7 @@ static int slip_tramp(char **argv, int f
 		       "buffer\n");
 		os_kill_process(pid, 1);
 		err = -ENOMEM;
-		goto out_free;
+		goto out_close;
 	}
 
 	close(fds[1]);
@@ -112,7 +112,6 @@ static int slip_tramp(char **argv, int f
 	err = helper_wait(pid);
 	close(fds[0]);
 
-out_free:
 	kfree(output);
 	return err;
 
_

Patches currently in -mm which might be from vitalivanov@gmail.com are

linux-next.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
uml-drivers-net_userc-memory-leak-fix.patch
uml-cow_userc-warning-corrections.patch
uml-helperc-warning-corrections.patch
uml-drivers-slip_userc-memory-leak-fix.patch
uml-free-resources.patch
gcov-disable-constructors-for-uml.patch

