From: akpm@linux-foundation.org
Subject: + ipc-resolve-shadow-warnings.patch added to -mm tree
Date: Thu, 11 Sep 2014 14:35:31 -0700
Message-ID: <541215a3.fJLkaZN4L8FfngzM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaIKVfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Sep 2014 17:35:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.d.rustad@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: resolve shadow warnings
has been added to the -mm tree.  Its filename is
     ipc-resolve-shadow-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-resolve-shadow-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-resolve-shadow-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Rustad <mark.d.rustad@intel.com>
Subject: ipc: resolve shadow warnings

Resolve some shadow warnings produced in W=2 builds by changing the name
of some parameters and local variables.  Change instances of "s64" because
that clashes with the well-known typedef.  Also change a local variable
with the name "up" because that clashes with the name of of the "up"
function for semaphores.  These are hazards so eliminate the hazards by
renaming them.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/compat.c |   92 ++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff -puN ipc/compat.c~ipc-resolve-shadow-warnings ipc/compat.c
--- a/ipc/compat.c~ipc-resolve-shadow-warnings
+++ a/ipc/compat.c
@@ -171,32 +171,32 @@ static inline int __put_compat_ipc64_per
 }
 
 static inline int __put_compat_ipc_perm(struct ipc64_perm *p,
-					struct compat_ipc_perm __user *up)
+					struct compat_ipc_perm __user *uip)
 {
 	int err;
 	__compat_uid_t u;
 	__compat_gid_t g;
 
-	err  = __put_user(p->key, &up->key);
+	err  = __put_user(p->key, &uip->key);
 	SET_UID(u, p->uid);
-	err |= __put_user(u, &up->uid);
+	err |= __put_user(u, &uip->uid);
 	SET_GID(g, p->gid);
-	err |= __put_user(g, &up->gid);
+	err |= __put_user(g, &uip->gid);
 	SET_UID(u, p->cuid);
-	err |= __put_user(u, &up->cuid);
+	err |= __put_user(u, &uip->cuid);
 	SET_GID(g, p->cgid);
-	err |= __put_user(g, &up->cgid);
-	err |= __put_user(p->mode, &up->mode);
-	err |= __put_user(p->seq, &up->seq);
+	err |= __put_user(g, &uip->cgid);
+	err |= __put_user(p->mode, &uip->mode);
+	err |= __put_user(p->seq, &uip->seq);
 	return err;
 }
 
-static inline int get_compat_semid64_ds(struct semid64_ds *s64,
+static inline int get_compat_semid64_ds(struct semid64_ds *sem64,
 					struct compat_semid64_ds __user *up64)
 {
 	if (!access_ok(VERIFY_READ, up64, sizeof(*up64)))
 		return -EFAULT;
-	return __get_compat_ipc64_perm(&s64->sem_perm, &up64->sem_perm);
+	return __get_compat_ipc64_perm(&sem64->sem_perm, &up64->sem_perm);
 }
 
 static inline int get_compat_semid_ds(struct semid64_ds *s,
@@ -207,17 +207,17 @@ static inline int get_compat_semid_ds(st
 	return __get_compat_ipc_perm(&s->sem_perm, &up->sem_perm);
 }
 
-static inline int put_compat_semid64_ds(struct semid64_ds *s64,
+static inline int put_compat_semid64_ds(struct semid64_ds *sem64,
 					struct compat_semid64_ds __user *up64)
 {
 	int err;
 
 	if (!access_ok(VERIFY_WRITE, up64, sizeof(*up64)))
 		return -EFAULT;
-	err  = __put_compat_ipc64_perm(&s64->sem_perm, &up64->sem_perm);
-	err |= __put_user(s64->sem_otime, &up64->sem_otime);
-	err |= __put_user(s64->sem_ctime, &up64->sem_ctime);
-	err |= __put_user(s64->sem_nsems, &up64->sem_nsems);
+	err  = __put_compat_ipc64_perm(&sem64->sem_perm, &up64->sem_perm);
+	err |= __put_user(sem64->sem_otime, &up64->sem_otime);
+	err |= __put_user(sem64->sem_ctime, &up64->sem_ctime);
+	err |= __put_user(sem64->sem_nsems, &up64->sem_nsems);
 	return err;
 }
 
@@ -239,11 +239,11 @@ static long do_compat_semctl(int first,
 {
 	unsigned long fourth;
 	int err, err2;
-	struct semid64_ds s64;
+	struct semid64_ds sem64;
 	struct semid64_ds __user *up64;
 	int version = compat_ipc_parse_version(&third);
 
-	memset(&s64, 0, sizeof(s64));
+	memset(&sem64, 0, sizeof(sem64));
 
 	if ((third & (~IPC_64)) == SETVAL)
 #ifdef __BIG_ENDIAN
@@ -269,29 +269,29 @@ static long do_compat_semctl(int first,
 
 	case IPC_STAT:
 	case SEM_STAT:
-		up64 = compat_alloc_user_space(sizeof(s64));
+		up64 = compat_alloc_user_space(sizeof(sem64));
 		fourth = (unsigned long)up64;
 		err = sys_semctl(first, second, third, fourth);
 		if (err < 0)
 			break;
-		if (copy_from_user(&s64, up64, sizeof(s64)))
+		if (copy_from_user(&sem64, up64, sizeof(sem64)))
 			err2 = -EFAULT;
 		else if (version == IPC_64)
-			err2 = put_compat_semid64_ds(&s64, compat_ptr(pad));
+			err2 = put_compat_semid64_ds(&sem64, compat_ptr(pad));
 		else
-			err2 = put_compat_semid_ds(&s64, compat_ptr(pad));
+			err2 = put_compat_semid_ds(&sem64, compat_ptr(pad));
 		if (err2)
 			err = -EFAULT;
 		break;
 
 	case IPC_SET:
 		if (version == IPC_64)
-			err = get_compat_semid64_ds(&s64, compat_ptr(pad));
+			err = get_compat_semid64_ds(&sem64, compat_ptr(pad));
 		else
-			err = get_compat_semid_ds(&s64, compat_ptr(pad));
+			err = get_compat_semid_ds(&sem64, compat_ptr(pad));
 
-		up64 = compat_alloc_user_space(sizeof(s64));
-		if (copy_to_user(up64, &s64, sizeof(s64)))
+		up64 = compat_alloc_user_space(sizeof(sem64));
+		if (copy_to_user(up64, &sem64, sizeof(sem64)))
 			err = -EFAULT;
 		if (err)
 			break;
@@ -561,12 +561,12 @@ COMPAT_SYSCALL_DEFINE3(shmat, int, shmid
 	return (long)ret;
 }
 
-static inline int get_compat_shmid64_ds(struct shmid64_ds *s64,
+static inline int get_compat_shmid64_ds(struct shmid64_ds *sem64,
 					struct compat_shmid64_ds __user *up64)
 {
 	if (!access_ok(VERIFY_READ, up64, sizeof(*up64)))
 		return -EFAULT;
-	return __get_compat_ipc64_perm(&s64->shm_perm, &up64->shm_perm);
+	return __get_compat_ipc64_perm(&sem64->shm_perm, &up64->shm_perm);
 }
 
 static inline int get_compat_shmid_ds(struct shmid64_ds *s,
@@ -577,21 +577,21 @@ static inline int get_compat_shmid_ds(st
 	return __get_compat_ipc_perm(&s->shm_perm, &up->shm_perm);
 }
 
-static inline int put_compat_shmid64_ds(struct shmid64_ds *s64,
+static inline int put_compat_shmid64_ds(struct shmid64_ds *sem64,
 					struct compat_shmid64_ds __user *up64)
 {
 	int err;
 
 	if (!access_ok(VERIFY_WRITE, up64, sizeof(*up64)))
 		return -EFAULT;
-	err  = __put_compat_ipc64_perm(&s64->shm_perm, &up64->shm_perm);
-	err |= __put_user(s64->shm_atime, &up64->shm_atime);
-	err |= __put_user(s64->shm_dtime, &up64->shm_dtime);
-	err |= __put_user(s64->shm_ctime, &up64->shm_ctime);
-	err |= __put_user(s64->shm_segsz, &up64->shm_segsz);
-	err |= __put_user(s64->shm_nattch, &up64->shm_nattch);
-	err |= __put_user(s64->shm_cpid, &up64->shm_cpid);
-	err |= __put_user(s64->shm_lpid, &up64->shm_lpid);
+	err  = __put_compat_ipc64_perm(&sem64->shm_perm, &up64->shm_perm);
+	err |= __put_user(sem64->shm_atime, &up64->shm_atime);
+	err |= __put_user(sem64->shm_dtime, &up64->shm_dtime);
+	err |= __put_user(sem64->shm_ctime, &up64->shm_ctime);
+	err |= __put_user(sem64->shm_segsz, &up64->shm_segsz);
+	err |= __put_user(sem64->shm_nattch, &up64->shm_nattch);
+	err |= __put_user(sem64->shm_cpid, &up64->shm_cpid);
+	err |= __put_user(sem64->shm_lpid, &up64->shm_lpid);
 	return err;
 }
 
@@ -668,12 +668,12 @@ static inline int put_compat_shm_info(st
 COMPAT_SYSCALL_DEFINE3(shmctl, int, first, int, second, void __user *, uptr)
 {
 	void __user *p;
-	struct shmid64_ds s64;
+	struct shmid64_ds sem64;
 	struct shminfo64 smi;
 	int err, err2;
 	int version = compat_ipc_parse_version(&second);
 
-	memset(&s64, 0, sizeof(s64));
+	memset(&sem64, 0, sizeof(sem64));
 
 	switch (second & (~IPC_64)) {
 	case IPC_RMID:
@@ -700,14 +700,14 @@ COMPAT_SYSCALL_DEFINE3(shmctl, int, firs
 
 	case IPC_SET:
 		if (version == IPC_64)
-			err = get_compat_shmid64_ds(&s64, uptr);
+			err = get_compat_shmid64_ds(&sem64, uptr);
 		else
-			err = get_compat_shmid_ds(&s64, uptr);
+			err = get_compat_shmid_ds(&sem64, uptr);
 
 		if (err)
 			break;
-		p = compat_alloc_user_space(sizeof(s64));
-		if (copy_to_user(p, &s64, sizeof(s64)))
+		p = compat_alloc_user_space(sizeof(sem64));
+		if (copy_to_user(p, &sem64, sizeof(sem64)))
 			err = -EFAULT;
 		else
 			err = sys_shmctl(first, second, p);
@@ -715,16 +715,16 @@ COMPAT_SYSCALL_DEFINE3(shmctl, int, firs
 
 	case IPC_STAT:
 	case SHM_STAT:
-		p = compat_alloc_user_space(sizeof(s64));
+		p = compat_alloc_user_space(sizeof(sem64));
 		err = sys_shmctl(first, second, p);
 		if (err < 0)
 			break;
-		if (copy_from_user(&s64, p, sizeof(s64)))
+		if (copy_from_user(&sem64, p, sizeof(sem64)))
 			err2 = -EFAULT;
 		else if (version == IPC_64)
-			err2 = put_compat_shmid64_ds(&s64, uptr);
+			err2 = put_compat_shmid64_ds(&sem64, uptr);
 		else
-			err2 = put_compat_shmid_ds(&s64, uptr);
+			err2 = put_compat_shmid_ds(&sem64, uptr);
 		if (err2)
 			err = -EFAULT;
 		break;
_

Patches currently in -mm which might be from mark.d.rustad@intel.com are

mm-use-min3-max3-macros-to-avoid-shadow-warnings.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
init-resolve-shadow-warnings.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
ipc-resolve-shadow-warnings.patch
linux-next.patch

