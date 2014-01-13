From: akpm@linux-foundation.org
Subject: [alternative-merged]
 swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
 removed from -mm tree
Date: Mon, 13 Jan 2014 13:45:44 -0800
Message-ID: <52d45e88.gV43HMB3kEpubvG9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAMVpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 16:45:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang.kh@gmail.com, shli@fusionio.com, minchan@kernel.org, konrad.wilk@oracle.com, hughd@google.com, bob.liu@oracle.com, k.kozlowski@samsung.com

Subject: [alternative-merged] swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch removed from -mm tree
To: k.kozlowski@samsung.com,bob.liu@oracle.com,hughd@google.com,konrad.wilk@oracle.com,minchan@kernel.org,shli@fusionio.com,weijie.yang.kh@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 13:45:44 -0800


The patch titled
     Subject: swap: fix setting PAGE_SIZE blocksize during swapoff/swapon race
has been removed from the -mm tree.  Its filename was
     swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: swap: fix setting PAGE_SIZE blocksize during swapoff/swapon race

Fix race between swapoff and swapon resulting in setting blocksize of
PAGE_SIZE for block devices during swapoff.

The swapon modifies swap_info->old_block_size before acquiring
swapon_mutex.  It reads block_size of bdev, stores it under
swap_info->old_block_size and sets new block_size to PAGE_SIZE.

On the other hand the swapoff sets the device's block_size to
old_block_size after releasing swapon_mutex.

This patch locks the swapon_mutex much earlier during swapon. It also
releases the swapon_mutex later during swapoff.

The effect of race can be triggered by following scenario:
 - One block swap device with block size of 512
 - thread 1: Swapon is called, swap is activated,
   p->old_block_size = block_size(p->bdev); /512/
   block_size(p->bdev) = PAGE_SIZE;
   Thread ends.

 - thread 2: Swapoff is called and it goes just after releasing the
   swapon_mutex. The swap is now fully disabled except of setting the
   block size to old value. The p->bdev->block_size is still equal to
   PAGE_SIZE.

 - thread 3: New swapon is called. This swap is disabled so without
   acquiring the swapon_mutex:
   - p->old_block_size = block_size(p->bdev); /PAGE_SIZE (!!!)/
   - block_size(p->bdev) = PAGE_SIZE;
   Swap is activated and thread ends.

 - thread 2: resumes work and sets blocksize to old value:
   - set_blocksize(bdev, p->old_block_size)
   But now the p->old_block_size is equal to PAGE_SIZE.

The patch swap-fix-set_blocksize-race-during-swapon-swapoff does not fix
this particular issue.  It reduces the possibility of races as the swapon
must overwrite p->old_block_size before acquiring swapon_mutex in swapoff.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/swapfile.c~swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race mm/swapfile.c
--- a/mm/swapfile.c~swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race
+++ a/mm/swapfile.c
@@ -1927,7 +1927,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	spin_unlock(&swap_lock);
 	frontswap_invalidate_area(type);
 	frontswap_map_set(p, NULL);
-	mutex_unlock(&swapon_mutex);
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
 	vfree(swap_map);
@@ -1947,6 +1946,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 		mutex_unlock(&inode->i_mutex);
 	}
 	filp_close(swap_file, NULL);
+	mutex_unlock(&swapon_mutex);
 
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so that swapon
@@ -2413,37 +2413,38 @@ SYSCALL_DEFINE2(swapon, const char __use
 		}
 	}
 
+	mutex_lock(&swapon_mutex);
 	inode = mapping->host;
 	/* If S_ISREG(inode->i_mode) will do mutex_lock(&inode->i_mutex); */
 	error = claim_swapfile(p, inode);
 	if (unlikely(error))
-		goto bad_swap;
+		goto bad_swap_wmutex;
 
 	/*
 	 * Read the swap header.
 	 */
 	if (!mapping->a_ops->readpage) {
 		error = -EINVAL;
-		goto bad_swap;
+		goto bad_swap_wmutex;
 	}
 	page = read_mapping_page(mapping, 0, swap_file);
 	if (IS_ERR(page)) {
 		error = PTR_ERR(page);
-		goto bad_swap;
+		goto bad_swap_wmutex;
 	}
 	swap_header = kmap(page);
 
 	maxpages = read_swap_header(p, swap_header, inode);
 	if (unlikely(!maxpages)) {
 		error = -EINVAL;
-		goto bad_swap;
+		goto bad_swap_wmutex;
 	}
 
 	/* OK, set up the swap map and apply the bad block list */
 	swap_map = vzalloc(maxpages);
 	if (!swap_map) {
 		error = -ENOMEM;
-		goto bad_swap;
+		goto bad_swap_wmutex;
 	}
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 		p->flags |= SWP_SOLIDSTATE;
@@ -2473,13 +2474,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = swap_cgroup_swapon(p->type, maxpages);
 	if (error)
-		goto bad_swap;
+		goto bad_swap_wmutex;
 
 	nr_extents = setup_swap_map_and_extents(p, swap_header, swap_map,
 		cluster_info, maxpages, &span);
 	if (unlikely(nr_extents < 0)) {
 		error = nr_extents;
-		goto bad_swap;
+		goto bad_swap_wmutex;
 	}
 	/* frontswap enabled? set up bit-per-page map for frontswap */
 	if (frontswap_enabled)
@@ -2515,7 +2516,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 		}
 	}
 
-	mutex_lock(&swapon_mutex);
 	prio = -1;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio =
@@ -2540,6 +2540,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 		inode->i_flags |= S_SWAPFILE;
 	error = 0;
 	goto out;
+bad_swap_wmutex:
+	mutex_unlock(&swapon_mutex);
 bad_swap:
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

linux-next.patch

