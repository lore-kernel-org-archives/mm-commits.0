From: akpm@linux-foundation.org
Subject: [merged] ipcsem-fix-semctl-getncnt.patch removed from -mm tree
Date: Fri, 10 May 2013 12:14:59 -0700
Message-ID: <20130510191459.63E455A415D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:37985 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3EJTPA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 15:15:00 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so90212qab.2
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 12:14:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem: fix semctl(..., GETNCNT)
has been removed from the -mm tree.  Its filename was
     ipcsem-fix-semctl-getncnt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: ipc,sem: fix semctl(..., GETNCNT)

The semctl GETNCNT returns the number of semops waiting for the specified
semaphore to become nonzero.  After changeset 9f1bc2c ("ipc,sem: have only
one list in struct sem_queue"), the semops waiting on just one semaphore
are waiting on that semaphore's list.

In order to return the correct count, we have to walk that list too, in
addition to the sem_array's list for complex operations.

This is the semncnt equivalent of the previous patch.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN ipc/sem.c~ipcsem-fix-semctl-getncnt ipc/sem.c
--- a/ipc/sem.c~ipcsem-fix-semctl-getncnt
+++ a/ipc/sem.c
@@ -796,6 +796,13 @@ static int count_semncnt (struct sem_arr
 	struct sem_queue * q;
 
 	semncnt = 0;
+	list_for_each_entry(q, &sma->sem_base[semnum].sem_pending, list) {
+		struct sembuf * sops = q->sops;
+		BUG_ON(sops->sem_num != semnum);
+		if ((sops->sem_op < 0) && !(sops->sem_flg & IPC_NOWAIT))
+			semncnt++;
+	}
+
 	list_for_each_entry(q, &sma->sem_pending, list) {
 		struct sembuf * sops = q->sops;
 		int nsops = q->nsops;
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch
ipcsem-fix-semctl-getzcnt-fix.patch
ipcsem-fix-semctl-getncnt-fix.patch
mm-remove-free_area_cache.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

