From: akpm@linux-foundation.org
Subject: + ipcsem-fix-semctl-getzcnt.patch added to -mm tree
Date: Thu, 09 May 2013 14:00:46 -0700
Message-ID: <20130509210046.7458E31C145@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55012 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3EIVAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 17:00:47 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so334682vbe.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 14:00:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, koverstreet@google.com


The patch titled
     Subject: ipc,sem: fix semctl(..., GETZCNT)
has been added to the -mm tree.  Its filename is
     ipcsem-fix-semctl-getzcnt.patch

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
Subject: ipc,sem: fix semctl(..., GETZCNT)

The semctl GETZCNT returns the number of semops waiting for the specified
semaphore to become zero.  After changeset 9f1bc2c, the semops waiting on
just one semaphore are waiting on that semaphore's list.

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
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch
ipcsem-fix-semctl-getzcnt.patch
mm-remove-free_area_cache.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

