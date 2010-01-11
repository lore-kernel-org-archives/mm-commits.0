From: akpm@linux-foundation.org
Subject: + ipc-use-rlimit-helpers.patch added to -mm tree
Date: Mon, 11 Jan 2010 14:34:03 -0800
Message-ID: <201001112234.o0BMY3Oa032389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab0AKWef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 17:34:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz


The patch titled
     ipc: use rlimit helpers
has been added to the -mm tree.  Its filename is
     ipc-use-rlimit-helpers.patch

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
@@ -152,7 +152,7 @@ static struct inode *mqueue_get_inode(st
 			spin_lock(&mq_lock);
 			if (u->mq_bytes + mq_bytes < u->mq_bytes ||
 		 	    u->mq_bytes + mq_bytes >
-			    p->signal->rlim[RLIMIT_MSGQUEUE].rlim_cur) {
+			    task_rlimit(p, RLIMIT_MSGQUEUE)) {
 				spin_unlock(&mq_lock);
 				goto out_inode;
 			}
diff -puN ipc/shm.c~ipc-use-rlimit-helpers ipc/shm.c
--- a/ipc/shm.c~ipc-use-rlimit-helpers
+++ a/ipc/shm.c
@@ -761,8 +761,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
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
infiniband-use-rlimit-helpers.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch

