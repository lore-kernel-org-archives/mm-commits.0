From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-move-inode_lock-out-of-claim_swapfile.patch
 added to -mm tree
Date: Sun, 09 Feb 2020 20:16:48 -0800
Message-ID: <20200210041648.AoOi96Ibl%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgBJEQt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 23:16:49 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, darrick.wong@oracle.com, hch@infradead.org, mm-commits@vger.kernel.org, naohiro.aota@wdc.com


The patch titled
     Subject: mm/swapfile.c: move inode_lock out of claim_swapfile
has been added to the -mm tree.  Its filename is
     mm-swap-move-inode_lock-out-of-claim_swapfile.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-move-inode_lock-out-of-claim_swapfile.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-move-inode_lock-out-of-claim_swapfile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: mm/swapfile.c: move inode_lock out of claim_swapfile

claim_swapfile() currently keeps the inode locked when it is successful,
or the file is already swapfile (with -EBUSY).  And, on the other error
cases, it does not lock the inode.

This inconsistency of the lock state and return value is quite confusing
and actually causing a bad unlock balance as below in the "bad_swap"
section of __do_sys_swapon().

This commit fixes this issue by moving the inode_lock() and IS_SWAPFILE
check out of claim_swapfile().  The inode is unlocked in
"bad_swap_unlock_inode" section, so that the inode is ensured to be
unlocked at "bad_swap".  Thus, error handling codes after the locking now
jumps to "bad_swap_unlock_inode" instead of "bad_swap".

    =====================================
    WARNING: bad unlock balance detected!
    5.5.0-rc7+ #176 Not tainted
    -------------------------------------
    swapon/4294 is trying to release lock (&sb->s_type->i_mutex_key) at:
    [<ffffffff8173a6eb>] __do_sys_swapon+0x94b/0x3550
    but there are no more locks to release!

    other info that might help us debug this:
    no locks held by swapon/4294.

    stack backtrace:
    CPU: 5 PID: 4294 Comm: swapon Not tainted 5.5.0-rc7-BTRFS-ZNS+ #176
    Hardware name: ASUS All Series/H87-PRO, BIOS 2102 07/29/2014
    Call Trace:
     dump_stack+0xa1/0xea
     ? __do_sys_swapon+0x94b/0x3550
     print_unlock_imbalance_bug.cold+0x114/0x123
     ? __do_sys_swapon+0x94b/0x3550
     lock_release+0x562/0xed0
     ? kvfree+0x31/0x40
     ? lock_downgrade+0x770/0x770
     ? kvfree+0x31/0x40
     ? rcu_read_lock_sched_held+0xa1/0xd0
     ? rcu_read_lock_bh_held+0xb0/0xb0
     up_write+0x2d/0x490
     ? kfree+0x293/0x2f0
     __do_sys_swapon+0x94b/0x3550
     ? putname+0xb0/0xf0
     ? kmem_cache_free+0x2e7/0x370
     ? do_sys_open+0x184/0x3e0
     ? generic_max_swapfile_size+0x40/0x40
     ? do_syscall_64+0x27/0x4b0
     ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
     ? lockdep_hardirqs_on+0x38c/0x590
     __x64_sys_swapon+0x54/0x80
     do_syscall_64+0xa4/0x4b0
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7f15da0a0dc7

Link: http://lkml.kernel.org/r/20200206090132.154869-1-naohiro.aota@wdc.com
Fixes: 1638045c3677 ("mm: set S_SWAPFILE on blockdev swap devices")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/mm/swapfile.c~mm-swap-move-inode_lock-out-of-claim_swapfile
+++ a/mm/swapfile.c
@@ -2904,10 +2904,6 @@ static int claim_swapfile(struct swap_in
 		p->bdev = inode->i_sb->s_bdev;
 	}
 
-	inode_lock(inode);
-	if (IS_SWAPFILE(inode))
-		return -EBUSY;
-
 	return 0;
 }
 
@@ -3162,36 +3158,41 @@ SYSCALL_DEFINE2(swapon, const char __use
 	mapping = swap_file->f_mapping;
 	inode = mapping->host;
 
-	/* If S_ISREG(inode->i_mode) will do inode_lock(inode); */
 	error = claim_swapfile(p, inode);
 	if (unlikely(error))
 		goto bad_swap;
 
+	inode_lock(inode);
+	if (IS_SWAPFILE(inode)) {
+		error = -EBUSY;
+		goto bad_swap_unlock_inode;
+	}
+
 	/*
 	 * Read the swap header.
 	 */
 	if (!mapping->a_ops->readpage) {
 		error = -EINVAL;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 	page = read_mapping_page(mapping, 0, swap_file);
 	if (IS_ERR(page)) {
 		error = PTR_ERR(page);
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 	swap_header = kmap(page);
 
 	maxpages = read_swap_header(p, swap_header, inode);
 	if (unlikely(!maxpages)) {
 		error = -EINVAL;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 
 	/* OK, set up the swap map and apply the bad block list */
 	swap_map = vzalloc(maxpages);
 	if (!swap_map) {
 		error = -ENOMEM;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 
 	if (bdi_cap_stable_pages_required(inode_to_bdi(inode)))
@@ -3216,7 +3217,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 					GFP_KERNEL);
 		if (!cluster_info) {
 			error = -ENOMEM;
-			goto bad_swap;
+			goto bad_swap_unlock_inode;
 		}
 
 		for (ci = 0; ci < nr_cluster; ci++)
@@ -3225,7 +3226,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		p->percpu_cluster = alloc_percpu(struct percpu_cluster);
 		if (!p->percpu_cluster) {
 			error = -ENOMEM;
-			goto bad_swap;
+			goto bad_swap_unlock_inode;
 		}
 		for_each_possible_cpu(cpu) {
 			struct percpu_cluster *cluster;
@@ -3239,13 +3240,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = swap_cgroup_swapon(p->type, maxpages);
 	if (error)
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 
 	nr_extents = setup_swap_map_and_extents(p, swap_header, swap_map,
 		cluster_info, maxpages, &span);
 	if (unlikely(nr_extents < 0)) {
 		error = nr_extents;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 	/* frontswap enabled? set up bit-per-page map for frontswap */
 	if (IS_ENABLED(CONFIG_FRONTSWAP))
@@ -3285,7 +3286,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = init_swap_address_space(p->type, maxpages);
 	if (error)
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 
 	/*
 	 * Flush any pending IO and dirty mappings before we start using this
@@ -3295,7 +3296,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3320,6 +3321,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = 0;
 	goto out;
+bad_swap_unlock_inode:
+	inode_unlock(inode);
 bad_swap:
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
@@ -3327,6 +3330,7 @@ bad_swap:
 		set_blocksize(p->bdev, p->old_block_size);
 		blkdev_put(p->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
+	inode = NULL;
 	destroy_swap_extents(p);
 	swap_cgroup_swapoff(p->type);
 	spin_lock(&swap_lock);
@@ -3338,13 +3342,8 @@ bad_swap:
 	kvfree(frontswap_map);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
-	if (swap_file) {
-		if (inode) {
-			inode_unlock(inode);
-			inode = NULL;
-		}
+	if (swap_file)
 		filp_close(swap_file, NULL);
-	}
 out:
 	if (page && !IS_ERR(page)) {
 		kunmap(page);
_

Patches currently in -mm which might be from naohiro.aota@wdc.com are

mm-swap-move-inode_lock-out-of-claim_swapfile.patch
