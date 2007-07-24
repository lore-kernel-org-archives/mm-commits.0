From: akpm@linux-foundation.org
Subject: + tiny-signalfd-cleanup.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:36:24 -0700
Message-ID: <200707240336.l6O3aONM026227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbXGXDgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org


The patch titled
     tiny signalfd cleanup
has been added to the -mm tree.  Its filename is
     tiny-signalfd-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tiny signalfd cleanup
From: Ulrich Drepper <drepper@redhat.com>

This is probably a leftover from a time when the return wasn't there yet.
Now the extra assignment is just irritating.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/signalfd.c~tiny-signalfd-cleanup fs/signalfd.c
--- a/fs/signalfd.c~tiny-signalfd-cleanup
+++ a/fs/signalfd.c
@@ -320,7 +320,7 @@ asmlinkage long sys_signalfd(int ufd, si
 
 	if (sizemask != sizeof(sigset_t) ||
 	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
-		return error = -EINVAL;
+		return -EINVAL;
 	sigdelsetmask(&sigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
 	signotset(&sigmask);
 
_

Patches currently in -mm which might be from drepper@redhat.com are

fallocate-syscall-interface-deficiency.patch
uml-fix-aio-compilation-bug.patch
tiny-signalfd-cleanup.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
