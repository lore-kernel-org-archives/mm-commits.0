From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 6 Sep 2017 16:17:27 -0700
Message-ID: <20170906161727.4ab1449f7acb1d9c67243de1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbdIFXR3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:17:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- various misc bits

- DAX updates

- OCFS2

- most of MM

119 patches, based on e7d0c41ecc2e372a81741a30894f556afec24315:

Subject: metag/numa: remove the unused parent_node() macro
Subject: mm: add vm_insert_mixed_mkwrite()
Subject: dax: relocate some dax functions
Subject: dax: use common 4k zero page for dax mmap reads
Subject: dax: remove DAX code from page_cache_tree_insert()
Subject: dax: move all DAX radix tree defs to fs/dax.c
Subject: dax: explain how read(2)/write(2) addresses are validated
Subject: dax: use PG_PMD_COLOUR instead of open coding
Subject: dax: initialize variable pfn before using it
Subject: modpost: simplify sec_name()
Subject: ocfs2: make ocfs2_set_acl() static
Subject: ocfs2: clean up some dead code
Subject: slub: tidy up initialization ordering
Subject: mm: add SLUB free list pointer obfuscation
Subject: mm/slub.c: add a naive detection of double free or corruption
Subject: mm: track actual nr_scanned during shrink_slab()
Subject: drm/i915: wire up shrinkctl->nr_scanned
Subject: mm/memory_hotplug: just build zonelist for newly added node
Subject: mm, memory_hotplug: display allowed zones in the preferred ordering
Subject: mm, memory_hotplug: remove zone restrictions
Subject: zram: clean up duplicated codes in __zram_bvec_write
Subject: zram: inline zram_compress
Subject: zram: rename zram_decompress_page to __zram_bvec_read
Subject: zram: add interface to specif backing device
Subject: zram: add free space management in backing device
Subject: zram: identify asynchronous IO's return value
Subject: zram: write incompressible pages to backing device
Subject: zram: read page from backing device
Subject: zram: add config and doc file for writeback feature
Subject: mm, page_alloc: rip out ZONELIST_ORDER_ZONE
Subject: mm, page_alloc: remove boot pageset initialization from memory hotplug
Subject: mm, page_alloc: do not set_cpu_numa_mem on empty nodes initialization
Subject: mm, memory_hotplug: drop zone from build_all_zonelists
Subject: mm, memory_hotplug: remove explicit build_all_zonelists from try_online_node
Subject: mm, page_alloc: simplify zonelist initialization
Subject: mm, page_alloc: remove stop_machine from build_all_zonelists
Subject: mm, memory_hotplug: get rid of zonelists_mutex
Subject: mm, sparse, page_ext: drop ugly N_HIGH_MEMORY branches for allocations
Subject: mm, page_owner: make init_pages_in_zone() faster
Subject: mm, page_ext: periodically reschedule during page_ext_init()
Subject: mm, page_owner: don't grab zone->lock for init_pages_in_zone()
Subject: mm/mremap: fail map duplication attempts for private mappings
Subject: mm/gup: make __gup_device_* require THP
Subject: mm/hugetlb.c: make huge_pte_offset() consistent and document behaviour
Subject: mm: always flush VMA ranges affected by zap_page_range
Subject: zsmalloc: zs_page_migrate: skip unnecessary loops but not return -EBUSY if zspage is not inuse
Subject: mm, vmscan: do not loop on too_many_isolated for ever
Subject: fscache: remove unused ->now_uncached callback
Subject: mm: make pagevec_lookup() update index
Subject: mm: implement find_get_pages_range()
Subject: fs: fix performance regression in clean_bdev_aliases()
Subject: ext4: use pagevec_lookup_range() in ext4_find_unwritten_pgoff()
Subject: ext4: use pagevec_lookup_range() in writeback code
Subject: hugetlbfs: use pagevec_lookup_range() in remove_inode_hugepages()
Subject: fs: use pagevec_lookup_range() in page_cache_seek_hole_data()
Subject: mm: use find_get_pages_range() in filemap_range_has_page()
Subject: mm: remove nr_pages argument from pagevec_lookup{,_range}()
Subject: mm, memcg: reset memory.low during memcg offlining
Subject: cgroup: revert fa06235b8eb0 ("cgroup: reset css on destruction")
Subject: mm/ksm.c: constify attribute_group structures
Subject: mm/slub.c: constify attribute_group structures
Subject: mm/page_idle.c: constify attribute_group structures
Subject: mm/huge_memory.c: constify attribute_group structures
Subject: mm/hugetlb.c: constify attribute_group structures
Subject: mm: memcontrol: use int for event/state parameter in several functions
Subject: mm, THP, swap: support to clear swap cache flag for THP swapped out
Subject: mm, THP, swap: support to reclaim swap space for THP swapped out
Subject: mm, THP, swap: make reuse_swap_page() works for THP swapped out
Subject: mm, THP, swap: don't allocate huge cluster for file backed swap device
Subject: block, THP: make block_device_operations.rw_page support THP
Subject: mm: test code to write THP to swap device as a whole
Subject: mm, THP, swap: support splitting THP for THP swap out
Subject: memcg, THP, swap: support move mem cgroup charge for THP swapped out
Subject: memcg, THP, swap: avoid to duplicated charge THP in swap cache
Subject: memcg, THP, swap: make mem_cgroup_swapout() support THP
Subject: mm, THP, swap: delay splitting THP after swapped out
Subject: mm, THP, swap: add THP swapping out fallback counting
Subject: shmem: shmem_charge: verify max_block is not exceeded before inode update
Subject: shmem: introduce shmem_inode_acct_block
Subject: userfaultfd: shmem: add shmem_mfill_zeropage_pte for userfaultfd support
Subject: userfaultfd: mcopy_atomic: introduce mfill_atomic_pte helper
Subject: userfaultfd: shmem: wire up shmem_mfill_zeropage_pte
Subject: userfaultfd: report UFFDIO_ZEROPAGE as available for shmem VMAs
Subject: userfaultfd: selftest: enable testing of UFFDIO_ZEROPAGE for shmem
Subject: fs/sync.c: remove unnecessary NULL f_mapping check in sync_file_range
Subject: include/linux/fs.h: remove unneeded forward definition of mm_struct
Subject: mm: hugetlb: define system call hugetlb size encodings in single file
Subject: mm: arch: consolidate mmap hugetlb size encodings
Subject: mm: shm: use new hugetlb size encoding definitions
Subject: mm: rename global_page_state to global_zone_page_state
Subject: mm: userfaultfd: add feature to request for a signal delivery
Subject: userfaultfd: selftest: add tests for UFFD_FEATURE_SIGBUS feature
Subject: userfaultfd: selftest: exercise UFFDIO_COPY/ZEROPAGE -EEXIST
Subject: userfaultfd: selftest: explicit failure if the SIGBUS test failed
Subject: userfaultfd: call userfaultfd_unmap_prep only if __split_vma succeeds
Subject: userfaultfd: provide pid in userfault msg
Subject: userfaultfd: provide pid in userfault msg - add feat union
Subject: mm, hugetlb: do not allocate non-migrateable gigantic pages from movable zones
Subject: mm/vmstat: fix divide error at __fragmentation_index
Subject: mm/vmalloc.c: halve the number of comparisons performed in pcpu_get_vm_areas()
Subject: mm, devm_memremap_pages: use multi-order radix for ZONE_DEVICE lookups
Subject: mm/shmem: add hugetlbfs support to memfd_create()
Subject: selftests/memfd: add memfd_create hugetlbfs selftest
Subject: mm/vmstat.c: fix wrong comment
Subject: mm/vmalloc.c: don't reinvent the wheel but use existing llist API
Subject: mm, swap: add swap readahead hit statistics
Subject: mm, swap: fix swap readahead marking
Subject: mm, swap: VMA based swap readahead
Subject: mm, swap: add sysfs interface for VMA based swap readahead
Subject: mm, swap: don't use VMA based swap readahead if HDD is used as swap
Subject: z3fold: use per-cpu unbuddied lists
Subject: mm, oom: do not rely on TIF_MEMDIE for memory reserves access
Subject: mm: replace TIF_MEMDIE checks by tsk_is_oom_victim
Subject: swap: choose swap device according to numa node
Subject: mm: oom: let oom_reap_task and exit_mmap run concurrently
Subject: mm: hugetlb: clear target sub-page last when clearing huge page
Subject: mm: add /proc/pid/smaps_rollup
Subject: x86,mpx: make mpx depend on x86-64 to free up VMA flag
Subject: mm,fork: introduce MADV_WIPEONFORK



