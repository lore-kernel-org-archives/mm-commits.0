From: akpm@linux-foundation.org
Subject: [folded-merged] ipc-sem-optimize-perform_atomic_semop-fix.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 14:30:14 -0800
Message-ID: <5851c7f6.WM+QP/i+hPiFY3j6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933465AbcLNW30 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 17:29:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: ensure we left shift a ULL rather than a 32 bit integer
has been removed from the -mm tree.  Its filename was
     ipc-sem-optimize-perform_atomic_semop-fix.patch

This patch was dropped because it was folded into ipc-sem-optimize-perform_atomic_semop.patch

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: ipc/sem: ensure we left shift a ULL rather than a 32 bit integer

The left shift amount is sop->sem_num % 64, which is up to 63, so
ensure we are shifting a ULL rather than a 32 bit value.

CoverityScan CID#1372862 "Bad bit shift operation"

Fixes: 7c24530cb4e3c0ae ("ipc/sem: optimize perform_atomic_semop()")
Link: http://lkml.kernel.org/r/20161028181129.7311-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/sem.c~ipc-sem-optimize-perform_atomic_semop-fix ipc/sem.c
--- a/ipc/sem.c~ipc-sem-optimize-perform_atomic_semop-fix
+++ a/ipc/sem.c
@@ -1850,7 +1850,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 
 	max = 0;
 	for (sop = sops; sop < sops + nsops; sop++) {
-		unsigned long mask = 1 << ((sop->sem_num) % BITS_PER_LONG);
+		unsigned long mask = 1ULL << ((sop->sem_num) % BITS_PER_LONG);
 
 		if (sop->sem_num >= max)
 			max = sop->sem_num;
_

Patches currently in -mm which might be from colin.king@canonical.com are

ipc-sem-optimize-perform_atomic_semop.patch

