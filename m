From: akpm@linux-foundation.org
Subject: [merged] shmdt-use-i_size_read-instead-of-i_size.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:10:16 -0800
Message-ID: <548d0da8.ag33J8sZWAN9Gl6C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaLNEKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmdt: use i_size_read() instead of ->i_size
has been removed from the -mm tree.  Its filename was
     shmdt-use-i_size_read-instead-of-i_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: shmdt: use i_size_read() instead of ->i_size

Andrew Morton noted

	http://lkml.kernel.org/r/20141104142027.a7a0d010772d84560b445f59@linux-foundation.org

that the shmdt uses inode->i_size outside of i_mutex being held.
There is one more case in shm.c in shm_destroy().  This converts
both users over to use i_size_read().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~shmdt-use-i_size_read-instead-of-i_size ipc/shm.c
--- a/ipc/shm.c~shmdt-use-i_size_read-instead-of-i_size
+++ a/ipc/shm.c
@@ -219,7 +219,8 @@ static void shm_destroy(struct ipc_names
 	if (!is_file_hugepages(shm_file))
 		shmem_lock(shm_file, 0, shp->mlock_user);
 	else if (shp->mlock_user)
-		user_shm_unlock(file_inode(shm_file)->i_size, shp->mlock_user);
+		user_shm_unlock(i_size_read(file_inode(shm_file)),
+				shp->mlock_user);
 	fput(shm_file);
 	ipc_rcu_putref(shp, shm_rcu_free);
 }
@@ -1280,7 +1281,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 			 * in the range we are unmapping.
 			 */
 			file = vma->vm_file;
-			size = file_inode(file)->i_size;
+			size = i_size_read(file_inode(vma->vm_file));
 			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 			/*
 			 * We discovered the size of the shm segment, so
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

