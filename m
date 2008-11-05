From: akpm@linux-foundation.org
Subject: + ipc-clean-up-ipc-shmc.patch added to -mm tree
Date: Tue, 04 Nov 2008 16:40:51 -0800
Message-ID: <200811050040.mA50epug027585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922AbYKEAl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 19:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangcong@zeuux.org, Nadia.Derbey@bull.net, peifferp@gmail.com


The patch titled
     ipc: clean up ipc/shm.c
has been added to the -mm tree.  Its filename is
     ipc-clean-up-ipc-shmc.patch

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
Subject: ipc: clean up ipc/shm.c
From: WANG Cong <wangcong@zeuux.org>

Use the macro shm_ids().

Remove useless check for a userspace pointer, because copy_to_user()
will check it.

Some style cleanups.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN ipc/shm.c~ipc-clean-up-ipc-shmc ipc/shm.c
--- a/ipc/shm.c~ipc-clean-up-ipc-shmc
+++ a/ipc/shm.c
@@ -75,7 +75,7 @@ void shm_init_ns(struct ipc_namespace *n
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
 	ns->shm_tot = 0;
-	ipc_init_ids(&ns->ids[IPC_SHM_IDS]);
+	ipc_init_ids(&shm_ids(ns));
 }
 
 /*
@@ -644,7 +644,7 @@ asmlinkage long sys_shmctl(int shmid, in
 		if (err)
 			return err;
 
-		memset(&shminfo,0,sizeof(shminfo));
+		memset(&shminfo, 0, sizeof(shminfo));
 		shminfo.shmmni = shminfo.shmseg = ns->shm_ctlmni;
 		shminfo.shmmax = ns->shm_ctlmax;
 		shminfo.shmall = ns->shm_ctlall;
@@ -669,7 +669,7 @@ asmlinkage long sys_shmctl(int shmid, in
 		if (err)
 			return err;
 
-		memset(&shm_info,0,sizeof(shm_info));
+		memset(&shm_info, 0, sizeof(shm_info));
 		down_read(&shm_ids(ns).rw_mutex);
 		shm_info.used_ids = shm_ids(ns).in_use;
 		shm_get_stat (ns, &shm_info.shm_rss, &shm_info.shm_swp);
@@ -678,7 +678,7 @@ asmlinkage long sys_shmctl(int shmid, in
 		shm_info.swap_successes = 0;
 		err = ipc_get_maxid(&shm_ids(ns));
 		up_read(&shm_ids(ns).rw_mutex);
-		if(copy_to_user (buf, &shm_info, sizeof(shm_info))) {
+		if (copy_to_user(buf, &shm_info, sizeof(shm_info))) {
 			err = -EFAULT;
 			goto out;
 		}
@@ -692,11 +692,6 @@ asmlinkage long sys_shmctl(int shmid, in
 		struct shmid64_ds tbuf;
 		int result;
 
-		if (!buf) {
-			err = -EFAULT;
-			goto out;
-		}
