From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch removed from
 -mm tree
Date: Mon, 27 Jan 2014 16:55:24 -0800
Message-ID: <52e6fffc.Kpzw4FclOdO0Igke%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbaA1AzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 19:55:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pmladek@suse.cz, manfred@colorfullife.com, jkosina@suse.cz, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,jkosina@suse.cz,manfred@colorfullife.com,pmladek@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 16:55:24 -0800


The patch titled
     Subject: ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix
has been removed from the -mm tree.  Its filename was
     ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch

This patch was dropped because it was folded into ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix

restore lessened scope of local `undo'

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix ipc/sem.c
--- a/ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix
+++ a/ipc/sem.c
@@ -599,7 +599,7 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 			     int nsops, struct sem_undo *un, int pid)
 {
-	int result, undo, sem_op;
+	int result, sem_op;
 	struct sembuf *sop;
 	struct sem * curr;
 
@@ -618,7 +618,7 @@ static int perform_atomic_semop(struct s
 			goto out_of_range;
 
 		if (sop->sem_flg & SEM_UNDO) {
-			undo = un->semadj[sop->sem_num] - sem_op;
+			int undo = un->semadj[sop->sem_num] - sem_op;
 			/* Exceeding the undo range is an error. */
 			if (undo < (-SEMAEM - 1) || undo > SEMAEM)
 				goto out_of_range;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch

