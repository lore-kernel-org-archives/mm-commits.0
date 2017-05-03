From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 3 May 2017 14:50:52 -0700
Message-ID: <20170503145052.f8abc1d1874c3b0705b242b6@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751447AbdECVux (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- a few misc things

- most of MM

- KASAN updates

102 patches, based on 46f0537b1ecf672052007c97f102a7e6bf0791e4:

Subject: lib/dma-debug.c: make locking work for RT
Subject: scripts/spelling.txt: add several more common spelling mistakes
Subject: blackfin: bf609: let clk_disable() return immediately if clk is NULL
Subject: fs/ocfs2/cluster: use setup_timer
Subject: ocfs2: o2hb: revert hb threshold to keep compatible
Subject: fs/ocfs2/cluster: use offset_in_page() macro
Subject: slab: avoid IPIs when creating kmem caches
Subject: mm: fix 100% CPU kswapd busyloop on unreclaimable nodes
Subject: mm: fix check for reclaimable pages in PF_MEMALLOC reclaim throttling
Subject: mm: remove seemingly spurious reclaimability check from laptop_mode gating
Subject: mm: remove unnecessary reclaimability check from NUMA balancing target
Subject: mm: don't avoid high-priority reclaim on unreclaimable nodes
Subject: mm: don't avoid high-priority reclaim on memcg limit reclaim
Subject: mm: delete NR_PAGES_SCANNED and pgdat_reclaimable()
Subject: Revert "mm, vmscan: account for skipped pages as a partial scan"
Subject: mm: remove unnecessary back-off function when retrying page reclaim
Subject: mm/page-writeback.c: use setup_deferrable_timer
Subject: mm: delete unnecessary TTU_* flags
Subject: mm: don't assume anonymous pages have SwapBacked flag
Subject: mm: move MADV_FREE pages into LRU_INACTIVE_FILE list
Subject: mm: reclaim MADV_FREE pages
Subject: mm: fix lazyfree BUG_ON check in try_to_unmap_one()
Subject: mm: enable MADV_FREE for swapless system
Subject: proc: show MADV_FREE pages info in smaps
Subject: mm: memcontrol: provide shmem statistics
Subject: mm, swap: Fix a race in free_swap_and_cache()
Subject: mm: use is_migrate_highatomic() to simplify the code
Subject: mm: use is_migrate_isolate_page() to simplify the code
Subject: mm, vmstat: print non-populated zones in zoneinfo
Subject: mm, vmstat: suppress pcp stats for unpopulated zones in zoneinfo
Subject: lockdep: teach lockdep about memalloc_noio_save
Subject: lockdep: allow to disable reclaim lockup detection
Subject: xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS
Subject: mm: introduce memalloc_nofs_{save,restore} API
Subject: xfs: use memalloc_nofs_{save,restore} instead of memalloc_noio*
Subject: jbd2: mark the transaction context with the scope GFP_NOFS context
Subject: jbd2: make the whole kjournald2 kthread NOFS safe
Subject: mm: tighten up the fault path a little
Subject: mm: remove rodata_test_data export, add pr_fmt
Subject: mm: do not use double negation for testing page flags
Subject: mm, vmscan: fix zone balance check in prepare_kswapd_sleep
Subject: mm, vmscan: only clear pgdat congested/dirty/writeback state when balanced
Subject: mm, vmscan: prevent kswapd sleeping prematurely due to mismatched classzone_idx
Subject: mm: page_alloc: __GFP_NOWARN shouldn't suppress stall warnings
Subject: mm/sparse: refine usemap_size() a little
Subject: mm/compaction: ignore block suitable after check large free page
Subject: mm/vmscan: more restrictive condition for retry in do_try_to_free_pages
Subject: mm: remove unncessary ret in page_referenced
Subject: mm: remove SWAP_DIRTY in ttu
Subject: mm: remove SWAP_MLOCK check for SWAP_SUCCESS in ttu
Subject: mm: make try_to_munlock() return void
Subject: mm: remove SWAP_MLOCK in ttu
Subject: mm: remove SWAP_AGAIN in ttu
Subject: mm: make ttu's return boolean
Subject: mm: make rmap_walk() return void
Subject: mm: make rmap_one boolean function
Subject: mm: remove SWAP_[SUCCESS|AGAIN|FAIL]
Subject: mm, swap: fix comment in __read_swap_cache_async
Subject: mm, swap: improve readability via make spin_lock/unlock balanced
Subject: mm, swap: avoid lock swap_avail_lock when held cluster lock
Subject: mm: enable page poisoning early at boot
Subject: include/linux/migrate.h: add arg names to prototype
Subject: mm/swap_slots.c: add warning if swap slots cache failed to initialize
Subject: mm: fix spelling error
Subject: userfaultfd: selftest: combine all cases into a single executable
Subject: oom: improve oom disable handling
Subject: mm/mmap: replace SHM_HUGE_MASK with MAP_HUGE_MASK inside mmap_pgoff
Subject: mm: vmscan: fix IO/refault regression in cache workingset transition
Subject: mm: memcontrol: clean up memory.events counting function
Subject: mm: memcontrol: re-use global VM event enum
Subject: mm: memcontrol: re-use node VM page state enum
Subject: mm: memcontrol: use node page state naming scheme for memcg
Subject: mm, swap: remove unused function prototype
Subject: Documentation: vm, add hugetlbfs reservation overview
Subject: mm/madvise.c: clean up MADV_SOFT_OFFLINE and MADV_HWPOISON
Subject: mm/madvise: move up the behavior parameter validation
Subject: mm/memory-failure.c: add page flag description in error paths
Subject: mm, page_alloc: remove debug_guardpage_minorder() test in warn_alloc()
Subject: zram: handle multiple pages attached bio's bvec
Subject: zram: partial IO refactoring
Subject: zram: use zram_slot_lock instead of raw bit_spin_lock op
Subject: zram: remove zram_meta structure
Subject: zram: introduce zram data accessor
Subject: zram: use zram_free_page instead of open-coded
Subject: zram: reduce load operation in page_same_filled
Subject: fs: fix data invalidation in the cleancache during direct IO
Subject: fs/block_dev: always invalidate cleancache in invalidate_bdev()
Subject: mm/truncate: bail out early from invalidate_inode_pages2_range() if mapping is empty
Subject: mm/truncate: avoid pointless cleancache_invalidate_inode() calls.
Subject: mm/gup.c: fix access_ok() argument type
Subject: mm/swapfile.c: fix swap space leak in error path of swap_free_entries()
Subject: mm: hwpoison: call shake_page() unconditionally
Subject: mm: hwpoison: call shake_page() after try_to_unmap() for mlocked page
Subject: kasan: introduce helper functions for determining bug type
Subject: kasan: unify report headers
Subject: kasan: change allocation and freeing stack traces headers
Subject: kasan: simplify address description logic
Subject: kasan: change report header
Subject: kasan: improve slab object description
Subject: kasan: print page description after stacks
Subject: kasan: improve double-free report format
Subject: kasan: separate report parts by empty lines

