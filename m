From: akpm@linux-foundation.org
Subject: [merged] uml-drivers-slip_userc-memory-leak-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:39 -0700
Message-ID: <201107260753.p6Q7rgKw003256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1GZHyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalivanov@gmail.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     uml: drivers/slip_user.c memory leak fix
has been removed from the -mm tree.  Its filename was
     uml-drivers-slip_userc-memory-leak-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
gcov-disable-constructors-for-uml.patch

