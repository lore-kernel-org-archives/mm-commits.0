From: akpm@linux-foundation.org
Subject: [merged] ipcshm-fix-shm_file-deletion-races.patch removed from
 -mm tree
Date: Fri, 22 Nov 2013 13:21:49 -0800
Message-ID: <528fcaed.ebO9bkSinHrN+B7b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab3KVVVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:21:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, davidlohr@hp.com, gthelen@google.com

Subject: [merged] ipcshm-fix-shm_file-deletion-races.patch removed from -mm tree
To: gthelen@google.com,davidlohr@hp.com,manfred@colorfullife.com,riel@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:21:49 -0800


The patch titled
     Subject: ipc,shm: fix shm_file deletion races
has been removed from the -mm tree.  Its filename was
     ipcshm-fix-shm_file-deletion-races.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: ipc,shm: fix shm_file deletion races

When IPC_RMID races with other shm operations there's potential for
use-after-free of the shm object's associated file (shm_file).

Here's the race before this patch:
  TASK 1                     TASK 2
  ------                     ------
  shm_rmid()
    ipc_lock_object()
                             shmctl()
                             shp = shm_obtain_object_check()

    shm_destroy()
      shum_unlock()
      fput(shp->shm_file)
                             ipc_lock_object()
                             shmem_lock(shp->shm_file)
                             <OOPS>

The oops is caused because shm_destroy() calls fput() after dropping the
ipc_lock.  fput() clears the file's f_inode, f_path.dentry, and
f_path.mnt, which causes various NULL pointer references in task 2.  I
reliably see the oops in task 2 if with shmlock, shmu

This patch fixes the races by:
1) set shm_file=NULL in shm_destroy() while holding ipc_object_lock().
2) modify at risk operations to check shm_file while holding
   ipc_object_lock().

Example workloads, which each trigger oops...

Workload 1:
  while true; do
    id=$(shmget 1 4096)
    shm_rmid $id &
    shmlock $id &
    wait
  done

  The oops stack shows accessing NULL f_inode due to racing fput:
    _raw_spin_lock
    shmem_lock
    SyS_shmctl

Workload 2:
  while true; do
    id=$(shmget 1 4096)
    shmat $id 4096 &
    shm_rmid $id &
    wait
  done

  The oops stack is similar to workload 1 due to NULL f_inode:
    touch_atime
    shmem_mmap
    shm_mmap
    mmap_region
    do_mmap_pgoff
    do_shmat
    SyS_shmat

Workload 3:
  while true; do
    id=$(shmget 1 4096)
    shmlock $id
    shm_rmid $id &
    shmunlock $id &
    wait
  done

  The oops stack shows second fput tripping on an NULL f_inode.  The
  first fput() completed via from shm_destroy(), but a racing thread did
  a get_file() and queued this fput():
    locks_remove_flock
    __fput
    ____fput
    task_work_run
    do_notify_resume
    int_signal

Fixes: c2c737a0461e ("ipc,shm: shorten critical region for shmat")
Fixes: 2caacaa82a51 ("ipc,shm: shorten critical region for shmctl")
Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>  # 3.10.17+ 3.11.6+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff -puN ipc/shm.c~ipcshm-fix-shm_file-deletion-races ipc/shm.c
--- a/ipc/shm.c~ipcshm-fix-shm_file-deletion-races
+++ a/ipc/shm.c
@@ -208,15 +208,18 @@ static void shm_open(struct vm_area_stru
  */
 static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
+	struct file *shm_file;
+
+	shm_file = shp->shm_file;
+	shp->shm_file = NULL;
 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	shm_rmid(ns, shp);
 	shm_unlock(shp);
-	if (!is_file_hugepages(shp->shm_file))
-		shmem_lock(shp->shm_file, 0, shp->mlock_user);
+	if (!is_file_hugepages(shm_file))
+		shmem_lock(shm_file, 0, shp->mlock_user);
 	else if (shp->mlock_user)
-		user_shm_unlock(file_inode(shp->shm_file)->i_size,
-						shp->mlock_user);
-	fput (shp->shm_file);
+		user_shm_unlock(file_inode(shm_file)->i_size, shp->mlock_user);
+	fput(shm_file);
 	ipc_rcu_putref(shp, shm_rcu_free);
 }
 
@@ -983,6 +986,13 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 		}
 
 		shm_file = shp->shm_file;
+
+		/* check if shm_destroy() is tearing down shp */
+		if (shm_file == NULL) {
+			err = -EIDRM;
+			goto out_unlock0;
+		}
+
 		if (is_file_hugepages(shm_file))
 			goto out_unlock0;
 
@@ -1101,6 +1111,14 @@ long do_shmat(int shmid, char __user *sh
 		goto out_unlock;
 
 	ipc_lock_object(&shp->shm_perm);
+
+	/* check if shm_destroy() is tearing down shp */
+	if (shp->shm_file == NULL) {
+		ipc_unlock_object(&shp->shm_perm);
+		err = -EIDRM;
+		goto out_unlock;
+	}
+
 	path = shp->shm_file->f_path;
 	path_get(&path);
 	shp->shm_nattch++;
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch

