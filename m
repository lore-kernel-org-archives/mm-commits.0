From: akpm@linux-foundation.org
Subject: [merged] ipcsem-fix-semctl-getzcnt.patch removed from -mm tree
Date: Fri, 10 May 2013 12:14:57 -0700
Message-ID: <20130510191457.6803031C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:45146 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3EJTO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 15:14:58 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so426258yho.0
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 12:14:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem: fix semctl(..., GETZCNT)
has been removed from the -mm tree.  Its filename was
     ipcsem-fix-semctl-getzcnt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: ipc,sem: fix semctl(..., GETZCNT)

The semctl GETZCNT returns the number of semops waiting for the specified
semaphore to become zero.  After changeset 9f1bc2c ("ipc,sem: have only
one list in struct sem_queue") , the semops waiting on just one semaphore
are waiting on that semaphore's list.

In order to return the correct count, we have to walk that list too, in
addition to the sem_array's list for complex operations.

This bug broke dbench; it works again with this patch applied.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Kent Overstreet <koverstreet@google.com>
Tested-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN ipc/sem.c~ipcsem-fix-semctl-getzcnt ipc/sem.c
--- a/ipc/sem.c~ipcsem-fix-semctl-getzcnt
+++ a/ipc/sem.c
@@ -815,6 +815,13 @@ static int count_semzcnt (struct sem_arr
 	struct sem_queue * q;
 
 	semzcnt = 0;
+	list_for_each_entry(q, &sma->sem_base[semnum].sem_pending, list) {
+		struct sembuf * sops = q->sops;
+		BUG_ON(sops->sem_num != semnum);
+		if ((sops->sem_op == 0) && !(sops->sem_flg & IPC_NOWAIT))
+			semzcnt++;
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

