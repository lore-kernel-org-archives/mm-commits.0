From: akpm@linux-foundation.org
Subject: [merged] sysvipc-cacheline-align-kern_ipc_perm.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:02:22 -0700
Message-ID: <20170509180222.2ojxFA1Of%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754514AbdEISCX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysv,ipc: cacheline align kern_ipc_perm
has been removed from the -mm tree.  Its filename was
     sysvipc-cacheline-align-kern_ipc_perm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: sysv,ipc: cacheline align kern_ipc_perm

Assign 'struct kern_ipc_perm' its own cacheline to avoid false sharing
with sysv ipc calls.  While the structure itself is rather read-mostly
throughout the lifespan of ipc, the spinlock causes most of the
invalidations.  One example is 31a7c4746e9 ("ipc/sem.c: cacheline align
the ipc spinlock for semaphores").  Therefore, extend this to all ipc.

The effect of cacheline alignment on sems can be seen in sembench, which
deals mostly with semtimedop wait/wakes is seen to improve raw throughput
(worker loops) between 8 to 12% on a 24-core x86 with over 4 threads.

Link: http://lkml.kernel.org/r/1486673582-6979-4-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |    7 +++----
 include/linux/sem.h |    3 +--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN include/linux/ipc.h~sysvipc-cacheline-align-kern_ipc_perm include/linux/ipc.h
--- a/include/linux/ipc.h~sysvipc-cacheline-align-kern_ipc_perm
+++ a/include/linux/ipc.h
@@ -8,8 +8,7 @@
 #define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */
 
 /* used by in-kernel data structures */
-struct kern_ipc_perm
-{
+struct kern_ipc_perm {
 	spinlock_t	lock;
 	bool		deleted;
 	int		id;
@@ -18,9 +17,9 @@ struct kern_ipc_perm
 	kgid_t		gid;
 	kuid_t		cuid;
 	kgid_t		cgid;
-	umode_t		mode; 
+	umode_t		mode;
 	unsigned long	seq;
 	void		*security;
-};
+} ____cacheline_aligned_in_smp;
 
 #endif /* _LINUX_IPC_H */
diff -puN include/linux/sem.h~sysvipc-cacheline-align-kern_ipc_perm include/linux/sem.h
--- a/include/linux/sem.h~sysvipc-cacheline-align-kern_ipc_perm
+++ a/include/linux/sem.h
@@ -10,8 +10,7 @@ struct task_struct;
 
 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
-	struct kern_ipc_perm	____cacheline_aligned_in_smp
-				sem_perm;	/* permissions .. see ipc.h */
+	struct kern_ipc_perm	sem_perm;	/* permissions .. see ipc.h */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
 	struct list_head	pending_alter;	/* pending operations */
_

Patches currently in -mm which might be from dave@stgolabs.net are


