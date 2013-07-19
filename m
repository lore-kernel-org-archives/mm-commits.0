From: akpm@linux-foundation.org
Subject: + ipcshm-shorten-critical-region-in-shmctl_down-fix.patch added
 to -mm tree
Date: Fri, 19 Jul 2013 12:31:45 -0700
Message-ID: <51e99421.OwqB6mj1BNd1Ut7o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3GSTbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, sasha.levin@oracle.com

Subject: + ipcshm-shorten-critical-region-in-shmctl_down-fix.patch added to -mm tree
To: sasha.levin@oracle.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:31:45 -0700


The patch titled
     Subject: ipc,shm: dont leave do_shmat with rcu lock held
has been added to the -mm tree.  Its filename is
     ipcshm-shorten-critical-region-in-shmctl_down-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-shorten-critical-region-in-shmctl_down-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-shorten-critical-region-in-shmctl_down-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: ipc,shm: dont leave do_shmat with rcu lock held

Commit "ipc,shm: shorten critical region for shmat" had an issue that allowed
us to exit do_shmat() without releasing the rcu lock that was taken previously
in the function.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/shm.c~ipcshm-shorten-critical-region-in-shmctl_down-fix ipc/shm.c
--- a/ipc/shm.c~ipcshm-shorten-critical-region-in-shmctl_down-fix
+++ a/ipc/shm.c
@@ -1062,7 +1062,7 @@ long do_shmat(int shmid, char __user *sh
 	shp = shm_lock_check(ns, shmid);
 	if (IS_ERR(shp)) {
 		err = PTR_ERR(shp);
-		goto out;
+		goto out_unlock;
 	}
 
 	err = -EACCES;
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
ipcshm-shorten-critical-region-in-shmctl_down-fix.patch
linux-next.patch

