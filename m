From: akpm@linux-foundation.org
Subject: [merged] mm-fix-potential-data-race-in-sys_swapon.patch removed
 from -mm tree
Date: Mon, 24 Aug 2015 11:41:34 -0700
Message-ID: <55db655e.XTdwqaUcB8S3Ntcu%akpm__48451.4551972554$1440441714$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbbHXSlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 14:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cesarb@cesarb.net, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, jason.low2@hp.com, kcc@google.com, mhocko@suse.cz, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix potential data race in SyS_swapon
has been removed from the -mm tree.  Its filename was
     mm-fix-potential-data-race-in-sys_swapon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix potential data race in SyS_swapon

While running KernelThreadSanitizer (ktsan) on upstream kernel with
trinity, we got a few reports from SyS_swapon, here is one of them:

Read of size 8 by thread T307 (K7621):
 [<     inlined    >] SyS_swapon+0x3c0/0x1850 SYSC_swapon mm/swapfile.c:2395
 [<ffffffff812242c0>] SyS_swapon+0x3c0/0x1850 mm/swapfile.c:2345
 [<ffffffff81e97c8a>] ia32_do_call+0x1b/0x25

Looks like the swap_lock should be taken when iterating through the
swap_info array on lines 2392 - 2401: q->swap_file may be reset to NULL by
another thread before it is dereferenced for f_mapping.

But why is that iteration needed at all?  Doesn't the claim_swapfile()
which follows do all that is needed to check for a duplicate entry -
FMODE_EXCL on a bdev, testing IS_SWAPFILE under i_mutex on a regfile?

Well, not quite: bd_may_claim() allows the same "holder" to claim the bdev
again, so we do need to use a different holder than "sys_swapon"; and we
should not replace appropriate -EBUSY by inappropriate -EINVAL.

Index i was reused in a cpu loop further down: renamed cpu there.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff -puN mm/swapfile.c~mm-fix-potential-data-race-in-sys_swapon mm/swapfile.c
--- a/mm/swapfile.c~mm-fix-potential-data-race-in-sys_swapon
+++ a/mm/swapfile.c
@@ -2185,11 +2185,10 @@ static int claim_swapfile(struct swap_in
 	if (S_ISBLK(inode->i_mode)) {
 		p->bdev = bdgrab(I_BDEV(inode));
 		error = blkdev_get(p->bdev,
-				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-				   sys_swapon);
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL, p);
 		if (error < 0) {
 			p->bdev = NULL;
-			return -EINVAL;
+			return error;
 		}
 		p->old_block_size = block_size(p->bdev);
 		error = set_blocksize(p->bdev, PAGE_SIZE);
@@ -2390,7 +2389,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	struct filename *name;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
-	int i;
 	int prio;
 	int error;
 	union swap_header *swap_header;
@@ -2430,19 +2428,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	p->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
-
-	for (i = 0; i < nr_swapfiles; i++) {
-		struct swap_info_struct *q = swap_info[i];
-
-		if (q == p || !q->swap_file)
-			continue;
-		if (mapping == q->swap_file->f_mapping) {
-			error = -EBUSY;
-			goto bad_swap;
-		}
-	}
-
 	inode = mapping->host;
+
 	/* If S_ISREG(inode->i_mode) will do mutex_lock(&inode->i_mutex); */
 	error = claim_swapfile(p, inode);
 	if (unlikely(error))
@@ -2475,6 +2462,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 	}
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
+		int cpu;
+
 		p->flags |= SWP_SOLIDSTATE;
 		/*
 		 * select a random position to start with to help wear leveling
@@ -2493,9 +2482,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 			error = -ENOMEM;
 			goto bad_swap;
 		}
-		for_each_possible_cpu(i) {
+		for_each_possible_cpu(cpu) {
 			struct percpu_cluster *cluster;
-			cluster = per_cpu_ptr(p->percpu_cluster, i);
+			cluster = per_cpu_ptr(p->percpu_cluster, cpu);
 			cluster_set_null(&cluster->index);
 		}
 	}
_

Patches currently in -mm which might be from hughd@google.com are

mm-vmscan-unlock-page-while-waiting-on-writeback.patch

