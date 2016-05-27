From: akpm@linux-foundation.org
Subject: [merged]
 ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable.patch removed
 from -mm tree
Date: Fri, 27 May 2016 11:44:54 -0700
Message-ID: <574895a6.HpaDQ0HXHW8kHPLq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0Soz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, dave@stgolabs.net, hughd@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc, shm: make shmem attach/detach wait for mmap_sem killable
has been removed from the -mm tree.  Its filename was
     ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: ipc, shm: make shmem attach/detach wait for mmap_sem killable

shmat and shmdt rely on mmap_sem for write.  If the waiting task gets
killed by the oom killer it would block oom_reaper from asynchronous
address space reclaim and reduce the chances of timely OOM resolving. 
Wait for the lock in the killable mode and return with EINTR if the task
got killed while waiting.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable ipc/shm.c
--- a/ipc/shm.c~ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable
+++ a/ipc/shm.c
@@ -1200,7 +1200,11 @@ long do_shmat(int shmid, char __user *sh
 	if (err)
 		goto out_fput;
 
-	down_write(&current->mm->mmap_sem);
+	if (down_write_killable(&current->mm->mmap_sem)) {
+		err = -EINTR;
+		goto out_fput;
+	}
+
 	if (addr && !(shmflg & SHM_REMAP)) {
 		err = -EINVAL;
 		if (addr + size < addr)
@@ -1271,7 +1275,8 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 	if (addr & ~PAGE_MASK)
 		return retval;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 
 	/*
 	 * This function tries to be smart and unmap shm segments that
_

Patches currently in -mm which might be from mhocko@suse.com are

oom_reaper-close-race-with-exiting-task.patch

