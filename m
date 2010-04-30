From: akpm@linux-foundation.org
Subject: + ipc-semc-cacheline-align-the-ipc-spinlock-for-semaphores.patch added to -mm tree
Date: Fri, 30 Apr 2010 14:22:12 -0700
Message-ID: <201004302122.o3ULMCWb014207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759616Ab0D3VWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 17:22:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, chris.mason@oracle.com, jens.axboe@oracle.com, npiggin@suse.de, zach.brown@oracle.com


The patch titled
     [PATCH] ipc/sem.c: cacheline align the ipc spinlock for semaphores
has been added to the -mm tree.  Its filename is
     ipc-semc-cacheline-align-the-ipc-spinlock-for-semaphores.patch

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
Subject: [PATCH] ipc/sem.c: cacheline align the ipc spinlock for semaphores
From: Manfred Spraul <manfred@colorfullife.com>

This patch cacheline aligns the spinlock for sysv semaphores: Without the
patch, the spinlock and sem_otime [written by every semop that modified
the array] and sem_base [read in the hot path of try_atomic_semop()] can
be in the same cacheline.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/sem.h~ipc-semc-cacheline-align-the-ipc-spinlock-for-semaphores include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-cacheline-align-the-ipc-spinlock-for-semaphores
+++ a/include/linux/sem.h
@@ -79,6 +79,7 @@ struct  seminfo {
 #ifdef __KERNEL__
 #include <asm/atomic.h>
 #include <linux/rcupdate.h>
+#include <linux/cache.h>
 
 struct task_struct;
 
@@ -91,7 +92,8 @@ struct sem {
 
 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
-	struct kern_ipc_perm	sem_perm;	/* permissions .. see ipc.h */
+	struct kern_ipc_perm	____cacheline_aligned_in_smp
+				sem_perm;	/* permissions .. see ipc.h */
 	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-optimize-update_queue-for-bulk-wakeup-calls.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-cacheline-align-the-ipc-spinlock-for-semaphores.patch
slab-leaks3-default-y.patch

