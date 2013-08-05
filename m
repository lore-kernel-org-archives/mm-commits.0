From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ipcshm-shorten-critical-region-in-shmctl_down-fix.patch removed from -mm
 tree
Date: Mon, 05 Aug 2013 14:57:06 -0700
Message-ID: <52001fb2.0lSw2lzmXPoehdF1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3HEV5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 17:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, sasha.levin@oracle.com

Subject: [to-be-updated] ipcshm-shorten-critical-region-in-shmctl_down-fix.patch removed from -mm tree
To: sasha.levin@oracle.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 14:57:06 -0700


The patch titled
     Subject: ipc,shm: dont leave do_shmat with rcu lock held
has been removed from the -mm tree.  Its filename was
     ipcshm-shorten-critical-region-in-shmctl_down-fix.patch

This patch was dropped because an updated version will be merged

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
linux-next.patch

