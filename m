From: akpm@linux-foundation.org
Subject: - tiny-signalfd-cleanup.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:04 -0700
Message-ID: <200707290611.l6T6B4E9010959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756383AbXG2GLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     tiny signalfd cleanup
has been removed from the -mm tree.  Its filename was
     tiny-signalfd-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
