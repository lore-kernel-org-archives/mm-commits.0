From: akpm@linux-foundation.org
Subject: [merged] ipc-use-rlimit-helpers.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:31 -0400
Message-ID: <201003150702.o2F724CR016835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935792Ab0COHCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ipc: use rlimit helpers
has been removed from the -mm tree.  Its filename was
     ipc-use-rlimit-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: use rlimit helpers
From: Jiri Slaby <jslaby@suse.cz>

Make sure compiler won't do weird things with limits.  E.g.  fetching them
twice may return 2 different values after writable limits are implemented.

I.e.  either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd ("resource: add helpers for
fetching rlimits") or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 ipc/shm.c    |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN ipc/mqueue.c~ipc-use-rlimit-helpers ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-use-rlimit-helpers
+++ a/ipc/mqueue.c
@@ -155,7 +155,7 @@ static struct inode *mqueue_get_inode(st
 			spin_lock(&mq_lock);
 			if (u->mq_bytes + mq_bytes < u->mq_bytes ||
 		 	    u->mq_bytes + mq_bytes >
-			    p->signal->rlim[RLIMIT_MSGQUEUE].rlim_cur) {
+			    task_rlimit(p, RLIMIT_MSGQUEUE)) {
 				spin_unlock(&mq_lock);
 				kfree(info->messages);
 				goto out_inode;
diff -puN ipc/shm.c~ipc-use-rlimit-helpers ipc/shm.c
--- a/ipc/shm.c~ipc-use-rlimit-helpers
+++ a/ipc/shm.c
@@ -764,8 +764,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 			if (euid != shp->shm_perm.uid &&
 			    euid != shp->shm_perm.cuid)
 				goto out_unlock;
-			if (cmd == SHM_LOCK &&
-			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
+			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK))
 				goto out_unlock;
 		}
 
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

