From: akpm@linux-foundation.org
Subject: + ipc-sem-optimize-perform_atomic_semop-fix.patch added to -mm
 tree
Date: Fri, 28 Oct 2016 15:05:35 -0700
Message-ID: <5813cbaf.467EnrOVDTnhAWKi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56180 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943059AbcJ1WFl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 18:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: ensure we left shift a ULL rather than a 32 bit integer
has been added to the -mm tree.  Its filename is
     ipc-sem-optimize-perform_atomic_semop-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-optimize-perform_atomic_semop-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-optimize-perform_atomic_semop-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-sem-optimize-perform_atomic_semop-fix.patch

