From: akpm@linux-foundation.org
Subject: + slab_panic-more-proc-posix-timers-shmem.patch added to -mm tree
Date: Wed, 18 Jul 2007 15:37:39 -0700
Message-ID: <200707182237.l6IMbd7l032585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbXGRWpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 18:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     SLAB_PANIC more (proc, posix-timers, shmem)
has been added to the -mm tree.  Its filename is
     slab_panic-more-proc-posix-timers-shmem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLAB_PANIC more (proc, posix-timers, shmem)
From: Alexey Dobriyan <adobriyan@sw.ru>

These aren't modular, so SLAB_PANIC is OK.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c       |    4 +---
 kernel/posix-timers.c |    3 ++-
 mm/shmem.c            |    4 +---
 3 files changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/proc/inode.c~slab_panic-more-proc-posix-timers-shmem fs/proc/inode.c
--- a/fs/proc/inode.c~slab_panic-more-proc-posix-timers-shmem
+++ a/fs/proc/inode.c
@@ -118,10 +118,8 @@ int __init proc_init_inodecache(void)
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
 					     sizeof(struct proc_inode),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_PANIC),
 					     init_once, NULL);
-	if (proc_inode_cachep == NULL)
-		return -ENOMEM;
 	return 0;
 }
 
diff -puN kernel/posix-timers.c~slab_panic-more-proc-posix-timers-shmem kernel/posix-timers.c
--- a/kernel/posix-timers.c~slab_panic-more-proc-posix-timers-shmem
+++ a/kernel/posix-timers.c
@@ -241,7 +241,8 @@ static __init int init_posix_timers(void
 	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
-					sizeof (struct k_itimer), 0, 0, NULL, NULL);
+					sizeof (struct k_itimer), 0, SLAB_PANIC,
+					NULL, NULL);
 	idr_init(&posix_timers_id);
 	return 0;
 }
diff -puN mm/shmem.c~slab_panic-more-proc-posix-timers-shmem mm/shmem.c
--- a/mm/shmem.c~slab_panic-more-proc-posix-timers-shmem
+++ a/mm/shmem.c
@@ -2365,9 +2365,7 @@ static int init_inodecache(void)
 {
 	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
 				sizeof(struct shmem_inode_info),
-				0, 0, init_once, NULL);
-	if (shmem_inode_cachep == NULL)
-		return -ENOMEM;
+				0, SLAB_PANIC, init_once, NULL);
 	return 0;
 }
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
isdn-sc-compile-breakage-re-check_reset.patch
git-dvb.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
slab_panic-more-proc-posix-timers-shmem.patch
