From: akpm@linux-foundation.org
Subject: + ipcsem-fix-semctl-getncnt.patch added to -mm tree
Date: Thu, 09 May 2013 14:08:48 -0700
Message-ID: <20130509210848.B09C65A41D5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:56393 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3EIVIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 17:08:49 -0400
Received: by mail-ve0-f201.google.com with SMTP id cz11so71197veb.0
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 14:08:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com


The patch titled
     Subject: ipc,sem: fix semctl(..., GETNCNT)
has been added to the -mm tree.  Its filename is
     ipcsem-fix-semctl-getncnt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch
ipcsem-fix-semctl-getzcnt.patch
ipcsem-fix-semctl-getzcnt-fix.patch
ipcsem-fix-semctl-getncnt.patch
ipcsem-fix-semctl-getncnt-fix.patch
mm-remove-free_area_cache.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

