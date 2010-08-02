From: akpm@linux-foundation.org
Subject: + afs-destroy-work-queue-on-init-failure.patch added to -mm tree
Date: Mon, 02 Aug 2010 16:06:43 -0700
Message-ID: <201008022306.o72N6hl0016912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810Ab0HBXGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Aug 2010 19:06:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, dhowells@redhat.com


The patch titled
     afs: destroy work queue on init failure
has been added to the -mm tree.  Its filename is
     afs-destroy-work-queue-on-init-failure.patch

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
Subject: afs: destroy work queue on init failure
From: Dan Carpenter <error27@gmail.com>

We can clean up the work queue on this error path.  This function is
called from afs_init().

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/rxrpc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/afs/rxrpc.c~afs-destroy-work-queue-on-init-failure fs/afs/rxrpc.c
--- a/fs/afs/rxrpc.c~afs-destroy-work-queue-on-init-failure
+++ a/fs/afs/rxrpc.c
@@ -100,6 +100,7 @@ int afs_open_socket(void)
 	ret = kernel_bind(socket, (struct sockaddr *) &srx, sizeof(srx));
 	if (ret < 0) {
 		sock_release(socket);
+		destroy_workqueue(afs_async_calls);
 		_leave(" = %d [bind]", ret);
 		return ret;
 	}
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
mtd-sst25l-check-for-null-consistently.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
autofs4-remove-unneeded-null-check-in-try_to_fill_dentry.patch
cgroups-save-space-for-the-terminator.patch
afs-destroy-work-queue-on-init-failure.patch
kexec-return-efault-on-copy_to_user-failures.patch

