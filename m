From: akpm@linux-foundation.org
Subject: + ipcshm-shorten-critical-region-for-shmctl.patch added to -mm
 tree
Date: Tue, 16 Jul 2013 15:51:49 -0700
Message-ID: <51e5ce85.D6V6SC2gTnY2rHGB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657Ab3GPWvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 18:51:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipcshm-shorten-critical-region-for-shmctl.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 15:51:49 -0700


The patch titled
     Subject: ipc,shm: shorten critical region for shmctl
has been added to the -mm tree.  Its filename is
     ipcshm-shorten-critical-region-for-shmctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-shorten-critical-region-for-shmctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-shorten-critical-region-for-shmctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,shm: shorten critical region for shmctl

With the *_INFO, *_STAT, IPC_RMID and IPC_SET commands already optimized,
deal with the remaining SHM_LOCK and SHM_UNLOCK commands.  Take the
shm_perm lock after doing the initial auditing and security checks.  The
rest of the logic remains unchanged.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff -puN ipc/shm.c~ipcshm-shorten-critical-region-for-shmctl ipc/shm.c
--- a/ipc/shm.c~ipcshm-shorten-critical-region-for-shmctl
+++ a/ipc/shm.c
@@ -940,10 +940,8 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 	int err, version;
 	struct ipc_namespace *ns;
 
-	if (cmd < 0 || shmid < 0) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (cmd < 0 || shmid < 0)
+		return -EINVAL;
 
 	version = ipc_parse_version(&cmd);
 	ns = current->nsproxy->ipc_ns;
@@ -954,36 +952,40 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 	case SHM_STAT:
 	case IPC_STAT:
 		return shmctl_nolock(ns, shmid, cmd, version, buf);
+	case IPC_RMID:
+	case IPC_SET:
+		return shmctl_down(ns, shmid, cmd, buf, version);
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
 		struct file *shm_file;
 
-		shp = shm_lock_check(ns, shmid);
+		rcu_read_lock();
+		shp = shm_obtain_object_check(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
-			goto out;
+			goto out_unlock1;
 		}
 
 		audit_ipc_obj(&(shp->shm_perm));
+		err = security_shm_shmctl(shp, cmd);
+		if (err)
+			goto out_unlock1;
 
+		ipc_lock_object(&shp->shm_perm);
 		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			kuid_t euid = current_euid();
 			err = -EPERM;
 			if (!uid_eq(euid, shp->shm_perm.uid) &&
 			    !uid_eq(euid, shp->shm_perm.cuid))
-				goto out_unlock;
+				goto out_unlock0;
 			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK))
-				goto out_unlock;
+				goto out_unlock0;
 		}
 
-		err = security_shm_shmctl(shp, cmd);
-		if (err)
-			goto out_unlock;
-
 		shm_file = shp->shm_file;
 		if (is_file_hugepages(shm_file))
-			goto out_unlock;
+			goto out_unlock0;
 
 		if (cmd == SHM_LOCK) {
 			struct user_struct *user = current_user();
@@ -992,32 +994,31 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 				shp->shm_perm.mode |= SHM_LOCKED;
 				shp->mlock_user = user;
 			}
-			goto out_unlock;
+			goto out_unlock0;
 		}
 
 		/* SHM_UNLOCK */
 		if (!(shp->shm_perm.mode & SHM_LOCKED))
-			goto out_unlock;
+			goto out_unlock0;
 		shmem_lock(shm_file, 0, shp->mlock_user);
 		shp->shm_perm.mode &= ~SHM_LOCKED;
 		shp->mlock_user = NULL;
 		get_file(shm_file);
-		shm_unlock(shp);
+		ipc_unlock_object(&shp->shm_perm);
+		rcu_read_unlock();
 		shmem_unlock_mapping(shm_file->f_mapping);
+
 		fput(shm_file);
-		goto out;
-	}
-	case IPC_RMID:
-	case IPC_SET:
-		err = shmctl_down(ns, shmid, cmd, buf, version);
 		return err;
+	}
 	default:
 		return -EINVAL;
 	}
 
-out_unlock:
-	shm_unlock(shp);
-out:
+out_unlock0:
+	ipc_unlock_object(&shp->shm_perm);
+out_unlock1:
+	rcu_read_unlock();
 	return err;
 }
 
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcshm-shorten-critical-region-in-shmctl_down.patch
ipc-drop-ipcctl_pre_down.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-introduce-shmctl_nolock.patch
ipcshm-make-shmctl_nolock-lockless.patch
ipcshm-shorten-critical-region-for-shmctl.patch
ipcshm-cleanup-do_shmat-pasta.patch
ipcshm-shorten-critical-region-for-shmat.patch
ipc-rename-ids-rw_mutex.patch
ipcmsg-drop-msg_unlock.patch
ipc-document-general-ipc-locking-scheme.patch

