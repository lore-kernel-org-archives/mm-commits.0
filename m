From: akpm@linux-foundation.org
Subject: + ipcshm-correct-error-return-value-in-shmctl-shm_unlock.patch
 added to -mm tree
Date: Wed, 20 Nov 2013 14:45:48 -0800
Message-ID: <528d3b9c.fqDDOT754w6CkQ9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3KTWpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:45:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, viro@zeniv.linux.org.uk, stable@vger.kernel.org, riel@redhat.com, davidlohr@hp.com, jesper.nilsson@axis.com

Subject: + ipcshm-correct-error-return-value-in-shmctl-shm_unlock.patch added to -mm tree
To: jesper.nilsson@axis.com,davidlohr@hp.com,riel@redhat.com,stable@vger.kernel.org,viro@zeniv.linux.org.uk,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:45:48 -0800


The patch titled
     Subject: ipc,shm: correct error return value in shmctl (SHM_UNLOCK)
has been added to the -mm tree.  Its filename is
     ipcshm-correct-error-return-value-in-shmctl-shm_unlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-correct-error-return-value-in-shmctl-shm_unlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-correct-error-return-value-in-shmctl-shm_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: ipc,shm: correct error return value in shmctl (SHM_UNLOCK)

2caacaa82a51b78 ("ipc,shm: shorten critical region for shmctl")
restructured the ipc shm to shorten critical region, but introduced a path
where the return value could be -EPERM, even if the operation actually was
performed.

Before the commit, the err return value was reset by the return value from
security_shm_shmctl() after the if (!ns_capable(...)) statement.

Now, we still exit the if statement with err set to -EPERM, and in the
case of SHM_UNLOCK, it is not reset at all, and used as the return value
from shmctl.

To fix this, we only set err when errors occur, leaving the fallthrough
case alone.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>	[3.12.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN ipc/shm.c~ipcshm-correct-error-return-value-in-shmctl-shm_unlock ipc/shm.c
--- a/ipc/shm.c~ipcshm-correct-error-return-value-in-shmctl-shm_unlock
+++ a/ipc/shm.c
@@ -977,12 +977,15 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 		ipc_lock_object(&shp->shm_perm);
 		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			kuid_t euid = current_euid();
-			err = -EPERM;
 			if (!uid_eq(euid, shp->shm_perm.uid) &&
-			    !uid_eq(euid, shp->shm_perm.cuid))
+			    !uid_eq(euid, shp->shm_perm.cuid)) {
+				err = -EPERM;
 				goto out_unlock0;
-			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK))
+			}
+			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK)) {
+				err = -EPERM;
 				goto out_unlock0;
+			}
 		}
 
 		shm_file = shp->shm_file;
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
ipcshm-correct-error-return-value-in-shmctl-shm_unlock.patch

