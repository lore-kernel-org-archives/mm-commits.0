From: akpm@linux-foundation.org
Subject: - ipc-semc-remove-unused-entries-from-struct-sem_queue.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:54 -0700
Message-ID: <200807252300.m6PN0sJx003638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755376AbYGYXHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, Nadia.Derbey@bull.net, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc/sem.c: remove unused entries from struct sem_queue
has been removed from the -mm tree.  Its filename was
     ipc-semc-remove-unused-entries-from-struct-sem_queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/sem.c: remove unused entries from struct sem_queue
From: Manfred Spraul <manfred@colorfullife.com>

sem_queue.sma and sem_queue.id were never used, the attached patch removes
them.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    2 --
 ipc/sem.c           |    2 --
 2 files changed, 4 deletions(-)

diff -puN include/linux/sem.h~ipc-semc-remove-unused-entries-from-struct-sem_queue include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-remove-unused-entries-from-struct-sem_queue
+++ a/include/linux/sem.h
@@ -107,8 +107,6 @@ struct sem_queue {
 	struct sem_undo *	undo;	 /* undo structure */
 	int    			pid;	 /* process id of requesting process */
 	int    			status;	 /* completion status of operation */
-	struct sem_array *	sma;	 /* semaphore array for operations */
-	int			id;	 /* internal sem id */
 	struct sembuf *		sops;	 /* array of pending operations */
 	int			nsops;	 /* number of operations */
 	int			alter;   /* does the operation alter the array? */
diff -puN ipc/sem.c~ipc-semc-remove-unused-entries-from-struct-sem_queue ipc/sem.c
--- a/ipc/sem.c~ipc-semc-remove-unused-entries-from-struct-sem_queue
+++ a/ipc/sem.c
@@ -1160,12 +1160,10 @@ asmlinkage long sys_semtimedop(int semid
 	 * task into the pending queue and go to sleep.
 	 */
 		
-	queue.sma = sma;
 	queue.sops = sops;
 	queue.nsops = nsops;
 	queue.undo = un;
 	queue.pid = task_tgid_vnr(current);
-	queue.id = semid;
 	queue.alter = alter;
 	if (alter)
 		append_to_queue(sma ,&queue);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

