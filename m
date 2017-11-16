From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 15 Nov 2017 17:29:42 -0800
Message-ID: <20171115172942.cfd98c4d66d9f4be53961cfd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37986 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932495AbdKPB3o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- a few misc bits

- ocfs2 updates

- almost all of MM

131 patches, based on c9b012e5f4a1d01dfa8abc6318211a67ba7d5db2:

Subject: bloat-o-meter: provide 3 different arguments for data, function and All
Subject: m32r: fix endianness constraints
Subject: ocfs2: remove unused declaration ocfs2_publish_get_mount_state()
Subject: ocfs2: no need flush workqueue before destroying it
Subject: ocfs2: cleanup unused func declaration and assignment
Subject: ocfs2: fix cluster hang after a node dies
Subject: ocfs2: clean up some unused function declarations
Subject: ocfs2: should wait dio before inode lock in ocfs2_setattr()
Subject: ocfs2: ip_alloc_sem should be taken in ocfs2_get_block()
Subject: ocfs2: subsystem.su_mutex is required while accessing the item->ci_parent
Subject: ocfs2/dlm: get mle inuse only when it is initialized
Subject: ocfs2: remove unneeded goto in ocfs2_reserve_cluster_bitmap_bits()
Subject: tools: slabinfo: add "-U" option to show unreclaimable slabs only
Subject: mm: slabinfo: remove CONFIG_SLABINFO
Subject: mm: oom: show unreclaimable slab info when unreclaimable slabs > user memory
Subject: mm/slob.c: remove an unnecessary check for __GFP_ZERO
Subject: mm/slab.c: only set __GFP_RECLAIMABLE once
Subject: slab, slub, slob: add slab_flags_t
Subject: slab, slub, slob: convert slab_flags_t to 32-bit
Subject: slub: fix sysfs duplicate filename creation when slub_debug=O
Subject: include/linux/slab.h: add kmalloc_array_node() and kcalloc_node()
Subject: block/blk-mq.c: use kmalloc_array_node()
Subject: drivers/infiniband/hw/qib/qib_init.c: use kmalloc_array_node()
Subject: drivers/infiniband/sw/rdmavt/qp.c: use kmalloc_array_node()
Subject: mm/mempool.c: use kmalloc_array_node()
Subject: net/rds/ib_fmr.c: use kmalloc_array_node()
Subject: mm: update comments for struct page.mapping
Subject: zram: set BDI_CAP_STABLE_WRITES once
Subject: bdi: introduce BDI_CAP_SYNCHRONOUS_IO
Subject: mm, swap: introduce SWP_SYNCHRONOUS_IO
Subject: mm, swap: skip swapcache for swapin of synchronous device
Subject: mm: swap: SWP_SYNCHRONOUS_IO: skip swapcache only if swapped page has no other reference
Subject: mm, swap: fix false error message in __swp_swapcount()
Subject: mm/page-writeback.c: remove unused parameter from balance_dirty_pages()
Subject: mm: drop migrate type checks from has_unmovable_pages
Subject: mm: distinguish CMA and MOVABLE isolation in has_unmovable_pages()
Subject: mm, page_alloc: fail has_unmovable_pages when seeing reserved pages
Subject: mm, memory_hotplug: do not fail offlining too early
Subject: mm, memory_hotplug: remove timeout from __offline_memory
Subject: mm/memblock.c: make the index explicit argument of for_each_memblock_type
Subject: mm/page-writeback.c: print a warning if the vm dirtiness settings are illogical
Subject: zram: add zstd to the supported algorithms list
Subject: zram: remove zlib from the list of recommended algorithms
Subject: fs/hugetlbfs/inode.c: remove redundant -ENIVAL return from hugetlbfs_setattr()
Subject: mm/hmm: constify hmm_devmem_page_get_drvdata() parameter
Subject: zsmalloc: calling zs_map_object() from irq is a bug
Subject: mm/mmu_notifier: avoid double notification when it is useless
Subject: mm/mmu_notifier: avoid call to invalidate_range() in range_end()
Subject: mm: remove unused pgdat->inactive_ratio
Subject: mm/swap_slots.c: fix race conditions in swap_slots cache init
Subject: mm, arch: remove empty_bad_page*
Subject: mm/cma.c: change pr_info to pr_err for cma_alloc fail log
Subject: mm/page_owner.c: reduce page_owner structure size
Subject: mm: implement find_get_pages_range_tag()
Subject: btrfs: use pagevec_lookup_range_tag()
Subject: ceph: use pagevec_lookup_range_tag()
Subject: ext4: use pagevec_lookup_range_tag()
Subject: f2fs: use pagevec_lookup_range_tag()
Subject: f2fs: simplify page iteration loops
Subject: f2fs: use find_get_pages_tag() for looking up single page
Subject: gfs2: use pagevec_lookup_range_tag()
Subject: nilfs2: use pagevec_lookup_range_tag()
Subject: mm: use pagevec_lookup_range_tag() in __filemap_fdatawait_range()
Subject: mm: use pagevec_lookup_range_tag() in write_cache_pages()
Subject: mm: add variant of pagevec_lookup_range_tag() taking number of pages
Subject: ceph: use pagevec_lookup_range_nr_tag()
Subject: mm: remove nr_pages argument from pagevec_lookup_{,range}_tag()
Subject: afs: use find_get_pages_range_tag()
Subject: cifs: use find_get_pages_range_tag()
Subject: kmemleak: change /sys/kernel/debug/kmemleak permissions from 0444 to 0644
Subject: mm: account pud page tables
Subject: mm: introduce wrappers to access mm->nr_ptes
Subject: mm: consolidate page table accounting
Subject: fs, mm: account filp cache to kmemcg
Subject: mm/rmap.c: remove redundant variable cend
Subject: kmemcheck: remove annotations
Subject: kmemcheck: stop using GFP_NOTRACK and SLAB_NOTRACK
Subject: kmemcheck: remove whats left of NOTRACK flags
Subject: kmemcheck: rip it out
Subject: mm/swap_state.c: declare a few variables as __read_mostly
Subject: mm: deferred_init_memmap improvements
Subject: x86/mm: set fields in deferred pages
Subject: sparc64/mm: set fields in deferred pages
Subject: sparc64: simplify vmemmap_populate
Subject: mm: define memblock_virt_alloc_try_nid_raw
Subject: mm: zero reserved and unavailable struct pages
Subject: x86/mm/kasan: don't use vmemmap_populate() to initialize shadow
Subject: arm64/mm/kasan: don't use vmemmap_populate() to initialize shadow
Subject: mm: stop zeroing memory during allocation in vmemmap
Subject: sparc64: optimize struct page zeroing
Subject: mm/page_alloc: make sure __rmqueue() etc are always inline
Subject: userfaultfd: use mmgrab instead of open-coded increment of mm_count
Subject: mm, soft_offline: improve hugepage soft offlining error log
Subject: mm/page-writeback.c: convert timers to use timer_setup()
Subject: drivers/block/zram/zram_drv.c: make zram_page_end_io() static
Subject: mm: speed up cancel_dirty_page() for clean pages
Subject: mm: refactor truncate_complete_page()
Subject: mm: factor out page cache page freeing into a separate function
Subject: mm: move accounting updates before page_cache_tree_delete()
Subject: mm: move clearing of page->mapping to page_cache_tree_delete()
Subject: mm: factor out checks and accounting from __delete_from_page_cache()
Subject: mm: batch radix tree operations when truncating pages
Subject: mm, page_alloc: enable/disable IRQs once when freeing a list of pages
Subject: mm, truncate: do not check mapping for every page being truncated
Subject: mm, truncate: remove all exceptional entries from pagevec under one lock
Subject: mm: only drain per-cpu pagevecs once per pagevec usage
Subject: mm, pagevec: remove cold parameter for pagevecs
Subject: mm: remove cold parameter for release_pages
Subject: mm: remove cold parameter from free_hot_cold_page*
Subject: mm: remove __GFP_COLD
Subject: mm, page_alloc: simplify list handling in rmqueue_bulk()
Subject: mm, pagevec: rename pagevec drained field
Subject: Unify migrate_pages and move_pages access checks
Subject: shmem: convert shmem_init_inodecache() to void
Subject: mm, sysctl: make NUMA stats configurable
Subject: mm: mlock: remove lru_add_drain_all()
Subject: mm, page_alloc: fix potential false positive in __zone_watermark_ok
Subject: fs: fuse: account fuse_inode slab memory as reclaimable
Subject: mm: don't warn about allocations which stall for too long
Subject: mm/page_alloc.c: broken deferred calculation
Subject: mm/shmem.c: mark expected switch fall-through
Subject: mm/list_lru.c: mark expected switch fall-through
Subject: mm/hmm: remove redundant variable align_end
Subject: mm, sparse: do not swamp log with huge vmemmap allocation failures
Subject: mm: do not rely on preempt_count in print_vma_addr
Subject: writeback: remove unused function parameter
Subject: mm/page_ext.c: check if page_ext is not prepared
Subject: mm,oom_reaper: remove pointless kthread_run() error check
Subject: mm: simplify nodemask printing
Subject: mm: make alloc_node_mem_map a void call if we don't have CONFIG_FLAT_NODE_MEM_MAP
Subject: memory hotplug: fix comments when adding section



