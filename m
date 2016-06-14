From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 14 Jun 2016 11:36:26 -0700
Message-ID: <57604eaa.Jz0U2oaQtvs2stzr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbcFNSg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 14:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-lib.c                  |   15 ---------------
 fs/btrfs/tests/extent-io-tests.c |    6 ------
 kernel/locking/qspinlock.c       |    3 ---
 net/sched/cls_u32.c              |    9 ---------
 4 files changed, 33 deletions(-)

diff -puN block/blk-lib.c~linux-next-git-rejects block/blk-lib.c
--- a/block/blk-lib.c~linux-next-git-rejects
+++ a/block/blk-lib.c
@@ -169,15 +169,8 @@ int blkdev_issue_write_same(struct block
 		}
 	}
 
-<<<<<<< HEAD
-	if (bio) {
-		ret = submit_bio_wait(REQ_WRITE | REQ_WRITE_SAME, bio);
-		bio_put(bio);
-	}
-=======
 	if (bio)
 		ret = submit_bio_wait(bio);
->>>>>>> linux-next/akpm-base
 	return ret != -EOPNOTSUPP ? ret : 0;
 }
 EXPORT_SYMBOL(blkdev_issue_write_same);
@@ -217,16 +210,8 @@ static int __blkdev_issue_zeroout(struct
 		}
 	}
 
-<<<<<<< HEAD
-	if (bio) {
-		ret = submit_bio_wait(WRITE, bio);
-		bio_put(bio);
-		return ret;
-	}
-=======
 	if (bio)
 		return submit_bio_wait(bio);
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
diff -puN fs/btrfs/tests/extent-io-tests.c~linux-next-git-rejects fs/btrfs/tests/extent-io-tests.c
--- a/fs/btrfs/tests/extent-io-tests.c~linux-next-git-rejects
+++ a/fs/btrfs/tests/extent-io-tests.c
@@ -376,15 +376,9 @@ static int test_eb_bitmaps(u32 sectorsiz
 	test_msg("Running extent buffer bitmap tests\n");
 
 	/*
-<<<<<<< HEAD
-	 * In ppc64, sectorsize can be 64K, thus 4 * 64K will be larger than
-	 * BTRFS_MAX_METADATA_BLOCKSIZE.
-	 */
-=======
 	* In ppc64, sectorsize can be 64K, thus 4 * 64K will be
 	* larger than BTRFS_MAX_METADATA_BLOCKSIZE.
 	*/
->>>>>>> linux-next/akpm-base
 	len = (sectorsize < BTRFS_MAX_METADATA_BLOCKSIZE)
 		? sectorsize * 4 : sectorsize;
 
diff -puN kernel/locking/qspinlock.c~linux-next-git-rejects kernel/locking/qspinlock.c
--- a/kernel/locking/qspinlock.c~linux-next-git-rejects
+++ a/kernel/locking/qspinlock.c
@@ -268,8 +268,6 @@ static __always_inline u32  __pv_wait_he
 #endif
 
 /*
-<<<<<<< HEAD
-=======
  * Various notes on spin_is_locked() and spin_unlock_wait(), which are
  * 'interesting' functions:
  *
@@ -327,7 +325,6 @@ static __always_inline u32  __pv_wait_he
  */
 
 /*
->>>>>>> linux-next/akpm-base
  * queued_spin_lock_slowpath() can (load-)ACQUIRE the lock before
  * issuing an _unordered_ store to set _Q_LOCKED_VAL.
  *
diff -puN net/sched/cls_u32.c~linux-next-git-rejects net/sched/cls_u32.c
--- a/net/sched/cls_u32.c~linux-next-git-rejects
+++ a/net/sched/cls_u32.c
@@ -508,19 +508,10 @@ static int u32_replace_hw_knode(struct t
 	offload.type = TC_SETUP_CLSU32;
 	offload.cls_u32 = &u32_offload;
 
-<<<<<<< HEAD
-	if (!tc_should_offload(dev, tp, flags))
-		return tc_skip_sw(flags) ? -EINVAL : 0;
-
-	offload.cls_u32->command = TC_CLSU32_REPLACE_KNODE;
-	offload.cls_u32->knode.handle = n->handle;
-	offload.cls_u32->knode.fshift = n->fshift;
-=======
 	if (tc_should_offload(dev, tp, flags)) {
 		offload.cls_u32->command = TC_CLSU32_REPLACE_KNODE;
 		offload.cls_u32->knode.handle = n->handle;
 		offload.cls_u32->knode.fshift = n->fshift;
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_CLS_U32_MARK
 	offload.cls_u32->knode.val = n->val;
 	offload.cls_u32->knode.mask = n->mask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

