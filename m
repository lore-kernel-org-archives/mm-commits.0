From: akpm@linux-foundation.org
Subject: [to-be-updated] dup2-fix-return-value-with-oldfd-==-newfd-and-invalid-fd.patch removed from -mm tree
Date: Mon, 11 May 2009 12:31:31 -0700
Message-ID: <200905111931.n4BJVWYe024362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbZEKTfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 15:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, jdluhos@novell.com, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     dup2: fix return value with oldfd == newfd and invalid fd
has been removed from the -mm tree.  Its filename was
     dup2-fix-return-value-with-oldfd-==-newfd-and-invalid-fd.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dup2: fix return value with oldfd == newfd and invalid fd
From: Jeff Mahoney <jeffm@suse.com>

Fix a regression introduced with 6c5d0512a091480c9f981162227fdb1c9d70e555
("get rid of corner case in dup3() entirely").

The return value of dup2 when oldfd == newfd and the fd isn't valid is not
getting properly sign extended.  We end up with 4294967287 instead of
-EBADF.

I've reproduced this on SLE11 (2.6.27.21), openSUSE Factory (2.6.29-rc5),
and Ubuntu 9.04 (2.6.28).

This patch uses a signed int for the error value so it is properly extended.

Reported-by: Jiri Dluhos <jdluhos@novell.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fcntl.c~dup2-fix-return-value-with-oldfd-==-newfd-and-invalid-fd fs/fcntl.c
--- a/fs/fcntl.c~dup2-fix-return-value-with-oldfd-==-newfd-and-invalid-fd
+++ a/fs/fcntl.c
@@ -115,13 +115,14 @@ out_unlock:
 
 SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
 {
+	int ret = oldfd;
 	if (unlikely(newfd == oldfd)) { /* corner case */
 		struct files_struct *files = current->files;
 		rcu_read_lock();
 		if (!fcheck_files(files, oldfd))
-			oldfd = -EBADF;
+			ret = -EBADF;
 		rcu_read_unlock();
-		return oldfd;
+		return ret;
 	}
 	return sys_dup3(oldfd, newfd, 0);
 }
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
dup2-fix-return-value-with-oldfd-==-newfd-and-invalid-fd.patch

