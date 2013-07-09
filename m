From: akpm@linux-foundation.org
Subject: [merged]
 ipc-semc-replace-shared-sem_otime-with-per-semaphore-value.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:21:58 -0700
Message-ID: <51dc9b16.oH42rAvu20+5uDhh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3GIXV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-semc-replace-shared-sem_otime-with-per-semaphore-value.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:58 -0700


The patch titled
     Subject: ipc/sem.c: replace shared sem_otime with per-semaphore value
has been removed from the -mm tree.  Its filename was
     ipc-semc-replace-shared-sem_otime-with-per-semaphore-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: replace shared sem_otime with per-semaphore value

sem_otime contains the time of the last semaphore operation that completed
successfully.  Every operation updates this value, thus access from
multiple cpus can cause thrashing.

Therefore the patch replaces the variable with a per-semaphore variable. 
The per-array sem_otime is only calculated when required.

No performance improvement on a single-socket i3 - only important
for larger systems.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    1 -
 ipc/sem.c           |   37 +++++++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff -puN include/linux/sem.h~ipc-semc-replace-shared-sem_otime-with-per-semaphore-value include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-replace-shared-sem_otime-with-per-semaphore-value
+++ a/include/linux/sem.h
@@ -12,7 +12,6 @@ struct task_struct;
 struct sem_array {
 	struct kern_ipc_perm	____cacheline_aligned_in_smp
 				sem_perm;	/* permissions .. see ipc.h */
-	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
 	struct list_head	pending_alter;	/* pending operations */
diff -puN ipc/sem.c~ipc-semc-replace-shared-sem_otime-with-per-semaphore-value ipc/sem.c
--- a/ipc/sem.c~ipc-semc-replace-shared-sem_otime-with-per-semaphore-value
+++ a/ipc/sem.c
@@ -99,6 +99,7 @@ struct sem {
 					/* that alter the semaphore */
 	struct list_head pending_const; /* pending single-sop operations */
 					/* that do not alter the semaphore*/
+	time_t	sem_otime;	/* candidate for sem_otime */
 } ____cacheline_aligned_in_smp;
 
 /* One queue for each sleeping process in the system. */
@@ -911,8 +912,14 @@ static void do_smart_update(struct sem_a
 			}
 		}
 	}
-	if (otime)
-		sma->sem_otime = get_seconds();
+	if (otime) {
+		if (sops == NULL) {
+			sma->sem_base[0].sem_otime = get_seconds();
+		} else {
+			sma->sem_base[sops[0].sem_num].sem_otime =
+								get_seconds();
+		}
+	}
 }
 
 
@@ -1058,6 +1065,21 @@ static unsigned long copy_semid_to_user(
 	}
 }
 
+static time_t get_semotime(struct sem_array *sma)
+{
+	int i;
+	time_t res;
+
+	res = sma->sem_base[0].sem_otime;
+	for (i = 1; i < sma->sem_nsems; i++) {
+		time_t to = sma->sem_base[i].sem_otime;
+
+		if (to > res)
+			res = to;
+	}
+	return res;
+}
+
 static int semctl_nolock(struct ipc_namespace *ns, int semid,
 			 int cmd, int version, void __user *p)
 {
@@ -1131,9 +1153,9 @@ static int semctl_nolock(struct ipc_name
 			goto out_unlock;
 
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
-		tbuf.sem_otime  = sma->sem_otime;
-		tbuf.sem_ctime  = sma->sem_ctime;
-		tbuf.sem_nsems  = sma->sem_nsems;
+		tbuf.sem_otime = get_semotime(sma);
+		tbuf.sem_ctime = sma->sem_ctime;
+		tbuf.sem_nsems = sma->sem_nsems;
 		rcu_read_unlock();
 		if (copy_semid_to_user(p, &tbuf, version))
 			return -EFAULT;
@@ -2025,6 +2047,9 @@ static int sysvipc_sem_proc_show(struct
 {
 	struct user_namespace *user_ns = seq_user_ns(s);
 	struct sem_array *sma = it;
+	time_t sem_otime;
+
+	sem_otime = get_semotime(sma);
 
 	return seq_printf(s,
 			  "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
@@ -2036,7 +2061,7 @@ static int sysvipc_sem_proc_show(struct
 			  from_kgid_munged(user_ns, sma->sem_perm.gid),
 			  from_kuid_munged(user_ns, sma->sem_perm.cuid),
 			  from_kgid_munged(user_ns, sma->sem_perm.cgid),
-			  sma->sem_otime,
+			  sem_otime,
 			  sma->sem_ctime);
 }
 #endif
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

