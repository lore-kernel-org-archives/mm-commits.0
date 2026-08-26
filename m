Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67EA494829;
	Wed, 26 Aug 2026 22:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787783019; cv=none; b=YtBa307qob5J24M9NKZICfu4lzNptlw+PRf5vND2TsXHvt8z9X49rmdyaZV0B/YFU9b3/UuzHjcPEM6x9GD7mo+3DVBNqx3PSbvb192pudIB2e29QFlQXp0qhtbeVlrI0irwv1YMQYNhvw43N5gGPumYfibsSLPfYJPsmopxwCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787783019; c=relaxed/simple;
	bh=LOtyHgeGt/bTvE85RZTLjxqLIMN3nG1Ci7mAUgBiTtI=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=pQscKGesJS/Zy5nraoL63qprt0oJY/lkAUqUc/qj9nn/c/FmebKSGbbunEyMrykIFd8WTpqWvBeYu5lGDXaD8D1Pt4qbQlVJa+yG/dLrQ8/Ij/F8SKEVT9wMH17VPSQ2pJ4B9B71c/+nZdYpb0peAZ91bhqZSgpR2WfVlLbRww4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OXlAEz91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OXlAEz91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD97B1F00ACA;
	Wed, 26 Aug 2026 22:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787783010;
	bh=2dNveVa5cnpmFLz2lMfybEicw8i5n980mJjZtPRtB2c=;
	h=Date:From:To:Cc:Subject;
	b=OXlAEz91lH122gqYlJfCvBqqdMEa1X2J9RF7DX8ofUSMFdWxx2giB9uRVMmM2p0dn
	 7VtSBOV+KCXNY0hWaiqevu2LVVvauF+L4kTp6M2ft0Zm+jtRJFvNQbTG4csWn23Mnv
	 gkTZwtBtb4OG3KZ/f8f/3y/g3ZIWfmRrMgUFldJ0=
Date: Wed, 26 Aug 2026 15:23:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional MM updates for 7.3-rc1
Message-Id: <20260826152330.9cdd482b43726942d6c149cb@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this second and final batch of MM updates for the
upcoming -rc cycle.

I'm seeing no present or upcoming conflicts.

Thanks.


The following changes since commit 08745c62350126bc31b09548137be87e2866f628:

  selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check (2026-08-15 21:12:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-08-26-15-22

for you to fetch changes up to 0685630fdccb62dcb0e3f44525a40578da5f6dc8:

  selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC (2026-08-24 18:43:33 -0700)

----------------------------------------------------------------
mm.git review status for linus..mm-stable

Everything:

Total patches:       171
Reviews/patch:       1.83
Reviewed rate:       82%

Excluding selftests:

Total patches:       149
Reviews/patch:       1.77
Reviewed rate:       80%

Excluding selftests and maple_tree:

Total patches:       129
Reviews/patch:       1.99
Reviewed rate:       89%

Summary of patch series in this merge:

- "mm/rmap: index MAP_PRIVATE file-backed folios by anonymous pgoff"
  (Lorenzo Stoakes):

  Index MAP_PRIVATE file-backed folios by their anonymous page offset to
  resolve confusion around reverse mapping for zeroed and CoW'd
  file-backed memory.

  Use this new VMA anonymous page offset tracking to eliminate index
  conflicts and lay the foundation for scalable CoW performance
  improvements.

- "promote mapped executable folios after first usage for MGLRU" (Baolin
  Wang):

  Make MGLRU's protection of mapped executable file folios more
  reliable.  Follow the classical LRU's logic, promoting mapped executable
  file folios after their first usage to give executable code a better
  chance to stay in memory and improve workload performance.

- "mm: vmscan: fix node reclaim ignoring swappiness parameter" (Ridong Chen):

  Fix per-node proactive reclaim interface's ignoring the swappiness
  parameter when CONFIG_MEMCG is disabled by consolidating sc_swappiness()
  into a single function that checks proactive_swappiness regardless of
  kernel configuration.

- "mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance
  cost" (Usama Arif):

  Reduce lru_lock contention in the reclaim path by deriving
  scan-balance costs from vmstat counters rather than lock-acquired
  producer updates.

  Read and decay these cost signals on the reclaim side under a
  dedicated per-lruvec lock, reducing total LRU lock wait time by over 60%
  without impacting scan throughput.

- "zram: fix zram issues reported by sashiko" (Sergey Senozhatsky):

  Fix two low-risk zram bugs which Sashiko spotted in drive-by review.

- "Honor XA_FLAGS_ACCOUNT in xas_split_alloc() and charge to folio's
  memcg" (Zi Yan):

  Fix xas_split_alloc() by enabling target folio memcg charging during
  splits and adding the missing __GFP_ACCOUNT flag for proper XArray node
  memory accounting.

- "selftests/mm: use pattern matching in .gitignore" (Pratyush Mallick):

  Replace hardcoded binary names in selftests/mm/.gitignore with a
  generic pattern-matching rule to automatically ignore generated test
  files and avoid manual updates when adding new tests.

- "mm/page_ext: remove pgdat_page_ext_init()" (Sang-Heon Jeon):

  Make the incompatibility between FLATMEM and NUMA explicit in
  mm/Kconfig and remove the unused pgdat_page_ext_init() function.

- "zram: fix zstd error paths and add parameter validation" (Haoqin Huang):

  Clean up zram compression backends by removing redundant error
  cleanup, adding parameter and dictionary validation, auto-prefixing
  algorithm error logs, and resetting parameters prior to
  reinitialization.

- "zram: fix stale scan bounds after reinitialization" (Longlong Xia):

  Prevent out-of-bounds slot accesses during concurrent zram resets by
  moving table scan bound calculations under dev_lock in writeback_store()
  and read_block_state().

- "add anon mTHP collapse test cases" (Baolin Wang):

  Extend selftests helper functions to support arbitrary page orders and
  add new test cases and options for mTHP collapse in khugepaged.

- "selftests/mm: Handle unsupported and transient test conditions"
  (Muhammad Usama Anjum):

  Update MM selftests to report a SKIP status instead of a failure when
  required kernel or filesystem features are unsupported, while adding
  retry logic for transient page migration errors.

- "mm/zswap: Fixes and improves the zswap shrink" (Hao Jia):

  Fix the missing zswap global shrinker when CONFIG_MEMCG is disabled
  and extend shrink_memcg() to support batch writeback for improved
  writeback efficiency.

- "alloc_tag: introduce IOCTL-based filtering for MAP" (Suren Baghdasaryan):

  Introduce an IOCTL-based binary interface for memory allocation
  profiling that enables kernel-side filtering before per-CPU counter
  aggregation.

  This eliminates the text-parsing overhead of /proc/allocinfo and
  provides up to a 20x speedup by transferring only filtered allocation
  data to userspace.

- "better block swap batching and a different take on swap_ops v5"
  (Christoph Hellwig):

  Refactor block swap I/O to use swap_iocb for batching instead of
  single-bio requests and rebase the swap_ops interface, achieving faster
  swap throughput during kernel builds.

- "mm: kmemleak: reduce transient false positives by confirming leaks"
  (Catalin Marinas):

  Reduce false-positive kmemleak reports by combining two kmemleak
  enhancements that add a second confirmation scan and a configurable
  minimum unreferenced scan count module parameter.

- "mm: kmemleak: default min_unref_scans to 2 for verbose kernels"
  (Breno Leitao):

  Auto-scanning kernels can generate false-positive memory leak reports
  on single scans, so this patch defaults min_unref_scans to 2 when
  CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled to require a second confirming
  scan.

- "swap_ops updates" (Christoph Hellwig):

  Batching I/O for synchronous swap devices causes performance
  regressions and filesystem-based swap suffers from double-indirection
  overhead.  This series resolves both issues by reintroducing per-folio
  writes for synchronous swap and allowing filesystems to directly export
  their own swap_ops.

- "mm/khugepaged: several cleanups" (Nico Pache):

  khugepaged accumulated redundant state-checking patterns and outdated
  comments following mTHP integration.  Introduce dedicated helpers for
  PTE validation and event counting while refreshing the internal
  documentation.

- "maple_tree: lock checking and clean ups" (Liam Howlett):

  Syzbot reports incorrectly blame memory management exit paths for
  locking bugs, maple tree erase operations risk allocation failures
  without gfp flags and internal documentation lacks clarity.

  Improve lock error detection, update docs, fix race and allocation
  edge cases and optimize erase allocations using a fallback to GFP_KERNEL
  | GFP_NOFAIL.

----------------------------------------------------------------
Abhishek Bapat (6):
      alloc_tag: expose boot-time compression configuration
      alloc_tag: add ioctl filters to /proc/allocinfo
      alloc_tag: add size-based filtering to ioctl
      alloc_tag: add accuracy based filtering to ioctl
      kselftest: alloc_tag: add kselftest for ioctl interface
      kselftest: alloc_tag: extend the allocinfo ioctl kselftest

Alexander Gordeev (1):
      mm: use proper PTE accessor in move_ptes()

Andrew Morton (2):
      Merge branch 'mm-hotfixes-stable' into mm-stable to pick up already-upstream changes to memcontrol.c, needed by "memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h".
      mm/hmm.c:hmm_do_fault(): suppress sparse warning

Anshuman (2):
      selftests/mm: fix unchecked ftruncate return value in soft-dirty test
      selftests/mm: check stat() return value in khugepaged get_finfo()

Artem Lytkin (1):
      mm/vmalloc: make vm_struct.nr_pages an unsigned long

Arvind Yadav (1):
      mm/migrate_device: clear stale mapping after freeing swapcache

Audra Mitchell (1):
      selftests/mm/vm_util.c: correct __pagemap_scan_get_categories return value

Baolin Wang (7):
      mm: vmscan: convert folio_referenced() to use vma_flags_t
      mm: vmscan: add a helper to identify file-backed executable folios
      mm: mglru: promote mapped executable folios after first usage
      selftests: mm: extend the check_huge() to support mTHP check
      selftests: mm: move gather_after_split_folio_orders() into vm_util.c file
      selftests: mm: implement the mTHP-sized hugepage check helpers
      selftests: mm: add mTHP collapse test cases

Bart Van Assche (1):
      mm: make VM_FAULT_RESULT_TRACE compatible with sparse

Breno Leitao (8):
      mm/kmemleak: report RCU-tasks quiescent states during the scan
      mm: kmemleak: report leaks only after N consecutive unreferenced scans
      mm: kmemleak: factor leak confirmation into a helper
      selftests: mm: test kmemleak's N-consecutive-scan leak confirmation
      mm: kmemleak: default min_unref_scans to 2 for verbose auto-scan
      Documentation: kmemleak: document the conditional min_unref_scans default
      selftests/mm: kmemleak: drop stale min_unref_scans default from comments
      mm, swap: ratelimit bad swap entry reports

Catalin Marinas (1):
      mm: kmemleak: confirm suspected leaks with a second scan

Christoph Hellwig (10):
      shmem: provide a shmem_write_folio wrapper
      mm/swap: introduce struct swap_io_ctx
      mm/swap: also use struct swap_iocb for block I/O
      mm/swap: remove count_swpout_vm_event
      mm/swap: use swap_ops to register swap device's methods
      mm/swap: remove SWP_FS_OPS
      mm/vmstat: add NRSWP{IN,OUT} counters
      mm/swap: revert to single-folio writes for synchronous swap devices
      mm/swap: add a new swap_ops.h header to allow for pluggable swap ops
      mm/swap: move swap_ops into file systems for file system-based swap

Daniel Palmer (1):
      tmpfs/ramfs: let memfd_create() work on nommu

David Carlier (1):
      zram: fix slot lock bit position on big-endian 64-bit

David Hildenbrand (Arm) (4):
      mm: standardize printing for pgtable entries
      mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
      mm/gup: factor out LRU cache draining for folio into lru_cache_drain_for_folio()
      mm/gup_test: keep longterm pin state per file

Enlin Mu (1):
      mm/vmscan: fix comment logic in balance_pgdat

Eric Biggers (1):
      mm/swap: reject swapon() on filesystem-level encrypted files

Eric Kim (1):
      mm/rmap: synchronize lock and unlock target in anon_vma_clone

Ethan Nelson-Moore (2):
      maple_tree: remove undocumented CONFIG_MAPLE_RCU_DISABLED macro
      mm: fix CONFIG_STACK_GROWSUP typo in tools/testing/vma/include/dup.h

Guillaume Morin (1):
      hugetlb: only adjust reservation during unmapping if mapcount is 0

Guopeng Zhang (1):
      mm: memcg: stop reclaim when a limit update is superseded

Hajime Tazaki (1):
      mm: nommu: point to the write iterator upon split_vma

Hao Jia (2):
      mm/zswap: fix global shrinker when memory cgroup is disabled
      mm/zswap: support batch writeback in shrink_memcg()

Haoqin Huang (5):
      zram: do not release zstd global params from error paths
      zram: reject zero-size dictionary
      zram: add pr_fmt to backend files
      zram: validate parameters in each backend's setup_params
      zram: reset per-priority params when changing algorithm before init

Henry Elderman (1):
      mm/execmem: fix fallback_end description in kernel-doc

Hongfu Li (6):
      ksm: update comments and docs to reference folio->mapping
      selftests/mm: drop duplicate test_seal_mprotect_two_vma_with_gap() call
      selftests/mm: fix read_file() return value check
      mm/swap: fix swap_cluster_lock() !CONFIG_SWAP stub signature mismatch
      mm/cma: remove stray newline from auto-generated CMA area name
      selftests/mm: drop redundant open() in mprotect_tests()

Hui Su (3):
      kasan: fix cache shrink race with CPU hotplug
      kasan: fix quarantine_size accounting during cache removal
      mm/migrate_device: fix cache flush when replacing huge zero PMD

Hui Zhu (1):
      mm/mglru: fix young counter undercount for large folios

Jann Horn (1):
      mm/page-writeback: document folio_mark_dirty() locking more explicitly

Jianlin Shi (1):
      mm/page_alloc: only update lowmem_reserve_ratio on sysctl write

Johannes Weiner (1):
      mm: mempolicy: fix automatic numa balancing for shmem

Kairui Song (1):
      mm/mglru: fix and remove redundant unevictable folio handling

Kaitao Cheng (2):
      mm/kconfig: drop redundant memory hotplug dependencies
      mm/kconfig: drop redundant dependency wrappers

Karl Mehltretter (1):
      selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC

Kiryl Shutsemau (Meta) (1):
      mm: include swap.h in swapops.h

Liam R. Howlett (Oracle) (19):
      maple_tree: add rcu locking check when LOCKDEP is enabled
      locking/lockdep: add sequence counter to held_lock
      maple_tree: add write lock checking with lockdep sequence numbers
      maple_tree: documentation fix
      maple_tree: drop dead code from mas_extend_spanning_null()
      maple_tree: drop MAPLE_ALLOC_SLOTS
      maple_tree: clarify comments on mas_nomem()
      maple_tree: use prefetched value in mas_wr_store_type()
      maple_tree: optimise mas_wr_node_store() when not in rcu mode
      maple_tree: micro optimisation of mas_wr_store_type()
      maple_tree: add bulk parent set helper
      maple_tree: catch race in mas_alloc_cyclic()
      maple_tree: document that erase may use GFP_KERNEL for allocations
      maple_tree: avoid mas_erase() and mtree_erase() failures
      maple_tree: document erase and allocations better
      maple_tree: change two GFP flags in tests
      maple_tree: fix argument name in header
      maple_tree: avoid extra gap calculation
      maple_tree: add helper mas_make_walkable()

Longlong Xia (4):
      mm/ksm: avoid missing ksmd wakeups in ksm_enter
      zram: fix out-of-bounds access in writeback_store()
      zram: fix out-of-bounds access in read_block_state()
      zsmalloc: account for handle size in class lookup

Lorenzo Stoakes (ARM) (18):
      mm/vma: introduce VMA anon page offset field and add helpers
      mm: provide vma_[flags_]is_cow_mapping() and remove is_cow_mapping()
      mm: introduce linear_anon_page_index()
      mm: abstract vma_address() and introduce vma_anon_address()
      mm: update print_bad_page_map() to show anon index if appropriate
      mm: introduce and use vma_filebacked_address()
      mm/vma: fix self-merge check in copy_vma()
      tools/testing/vma: add tests for copy_vma() self-merge
      mm: propagate VMA anonymous page offset on map, remap, split + merge
      mm/rmap: track whether the page VMA mapped pgoff is anonymous
      mm: clean up vma_address_end()
      mm/huge_memory: update remove_migration_pmd() to accept a folio
      mm/migrate: calculate large folio page index using PFN
      mm/rmap: use anon pgoff to track MAP_PRIVATE file-backed anon folios
      tools/testing/vma: expand VMA merge tests to assert anon pgoff
      tools/testing/selftests/mm: test anonymous page offset merge behaviour
      mm: add some missing includes to mm-local headers
      MAINTAINERS: add drivers/char/mem.c to mm misc, memory mapping sections

Mark Sercombe (1):
      maple_tree: fix comment typo

Mike Rapoport (Microsoft) (1):
      drivers/base, mm: move arch_numa.c to mm/

Muchun Song (1):
      mm/sparse: keep mem_section_usage_size() internal

Muhammad Usama Anjum (4):
      selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
      selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
      selftests/mm: skip hard dirty page-cache test on NFS
      selftests/mm: retry migration failures for the full runtime

Nathan Chancellor (1):
      arch_numa: avoid false positive fortify warning in setup_node_to_cpumask_map()

Nico Pache (Red Hat) (6):
      mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
      mm/khugepaged: extract reference check into folio_pte_referenced() helper
      mm/khugepaged: introduce a count_collapse_event() helper
      mm/khugepaged: fix outdated comments
      mm/khugepaged: unmap pte before releasing vma write lock
      mm: Documentation: clarify where the mTHP stats live

Pratyush Mallick (3):
      mm/page_reporting: add page_reporting_delay_ms module parameter
      selftests/mm: rename local_config.h to local_config.h_gen
      selftests/mm: use pattern matching in .gitignore

Qiang Liu (1):
      lib/test_hmm: fix garbage pfn and wrong direction in devmem fault debug

Ridong Chen (2):
      memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
      mm: vmscan: fix node reclaim ignoring swappiness parameter

Sang-Heon Jeon (3):
      mm/sparse: correct init section annotations
      mm/Kconfig: make FLATMEM depend on !NUMA
      mm/page_ext: remove pgdat_page_ext_init()

Sergey Senozhatsky (4):
      zram: set default primary compressor in zram_destroy_comps()
      zram: validate deflate params
      Documentation: zram: correct algo parameters configuration documentation
      zram: switch to unsigned long indexing

Shakeel Butt (2):
      memcg: bypass the reclaim and oom killer for dying tasks once oom_reaper is done
      memcg: move LRU size accounting on reparenting instead of copying it

Song Hu (2):
      Docs/mm: fix outdated "radix tree" in page_migration
      mm: memcg: release the css reference when a stock slot empties

Sourav Panda (1):
      mm/hugetlb_cma: support percentage-based hugetlb_cma reservation

Suren Baghdasaryan (1):
      alloc_tag: add ioctl to /proc/allocinfo

Tejun Heo (1):
      percpu: drop CONFIG_DEBUG_FORCE_WEAK_PER_CPU

Uladzislau Rezki (Sony) (1):
      mm/vmalloc: do not warn on -ENOMEM from va_alloc()

Usama Arif (4):
      mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
      mm/vmscan: add pgrotate_anon and pgrotate_file vmstat counters
      mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
      mm/memcontrol: avoid false sharing between vmstats and events

Warren Xiong (1):
      selftests/mm: read memory information without popen

Wilson Felipe Pereira (2):
      mm: zswap: drop list_lru param from zswap_lru_add() and _del()
      selftests/cgroup: test_zswap: skip test_no_kmem_bypass if debugfs is unavailable

Xie Yuanbin (1):
      mm/Kconfig: make MEMORY_FAILURE select MIGRATION

Ye Liu (3):
      mm: debug_page_alloc: fix type mismatch for debug_guardpage_minorder
      mm/show_mem: fix format string inconsistencies and type mismatches
      mm: debug_page_alloc: fix NULL buf in debug_guardpage_minorder_setup

Yunzhao Li (1):
      mm/zswap: use ratelimited stats flush in zswap_shrinker_count()

Zhan Xusheng (1):
      maple_tree: remove unused mas_is_root_limits()

Zhiling Zou (1):
      mm: shmem: reject page-aligned fallocate end overflow

Zi Yan (2):
      mm/huge_memory: use folio's memcg inside __folio_split()
      xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()

 .mailmap                                           |   6 +
 Documentation/admin-guide/blockdev/zram.rst        |  34 +-
 Documentation/admin-guide/kernel-parameters.txt    |  16 +-
 Documentation/admin-guide/mm/transhuge.rst         |   6 +-
 Documentation/core-api/maple_tree.rst              |  24 +-
 Documentation/dev-tools/kmemleak.rst               |  10 +
 Documentation/filesystems/fscrypt.rst              |   4 +
 Documentation/filesystems/locking.rst              |   8 +-
 Documentation/filesystems/vfs.rst                  |   8 +-
 Documentation/mm/allocation-profiling.rst          |  16 +
 Documentation/mm/ksm.rst                           |   4 +-
 Documentation/mm/page_migration.rst                |   6 +-
 Documentation/translations/zh_CN/mm/ksm.rst        |   4 +-
 Documentation/userspace-api/ioctl/ioctl-number.rst |   2 +
 MAINTAINERS                                        |  11 +-
 arch/arm64/include/asm/ptdump.h                    |   2 -
 arch/arm64/mm/mmu.c                                |  43 +-
 arch/arm64/mm/ptdump.c                             |  11 +-
 arch/microblaze/kernel/head.S                      |   2 +
 arch/s390/mm/gmap_helpers.c                        |   2 +-
 drivers/base/Kconfig                               |   7 -
 drivers/base/Makefile                              |   1 -
 drivers/block/zram/backend_842.c                   |  10 +
 drivers/block/zram/backend_deflate.c               |  25 +-
 drivers/block/zram/backend_lz4.c                   |  10 +-
 drivers/block/zram/backend_lz4hc.c                 |  16 +-
 drivers/block/zram/backend_lzo.c                   |  10 +
 drivers/block/zram/backend_lzorle.c                |  10 +
 drivers/block/zram/backend_zstd.c                  |  11 +-
 drivers/block/zram/zram_drv.c                      | 188 ++++---
 drivers/block/zram/zram_drv.h                      |  14 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   4 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |   2 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |   2 +-
 drivers/gpu/drm/ttm/ttm_backup.c                   |   2 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   2 +-
 drivers/gpu/drm/xe/xe_device.c                     |   2 +-
 fs/nfs/direct.c                                    |  20 -
 fs/nfs/file.c                                      |  44 +-
 fs/proc/task_mmu.c                                 |   2 +-
 fs/ramfs/file-nommu.c                              |   3 +
 fs/smb/client/file.c                               |  65 ++-
 include/linux/codetag.h                            |   2 +
 include/linux/execmem.h                            |   2 +-
 include/linux/fs.h                                 |   1 -
 include/linux/lockdep.h                            |   3 +
 include/linux/lockdep_types.h                      |   3 +-
 include/linux/maple_tree.h                         |  16 +-
 include/linux/memcontrol.h                         |  21 +-
 include/linux/mm.h                                 | 132 ++++-
 include/linux/mm_types.h                           |  40 +-
 include/linux/mmap_lock.h                          |   1 +
 include/linux/mmzone.h                             |  16 +-
 include/linux/nfs_fs.h                             |   1 -
 include/linux/page_ext.h                           |   5 -
 include/linux/pagemap.h                            |  40 +-
 include/linux/percpu-defs.h                        |   7 +-
 include/linux/rmap.h                               |  11 +-
 include/linux/sched.h                              |   1 +
 include/linux/shmem_fs.h                           |   5 +-
 include/linux/swap.h                               |  30 +-
 include/linux/swap_ops.h                           |  44 ++
 include/linux/swapops.h                            |   7 +-
 include/linux/vm_event_item.h                      |   4 +
 include/linux/vmalloc.h                            |   2 +-
 include/linux/vmstat.h                             |  17 +-
 include/rv/da_monitor.h                            |   2 +-
 include/uapi/linux/alloc_tag.h                     |  99 ++++
 kernel/events/uprobes.c                            |   2 +-
 kernel/locking/lockdep.c                           |  58 +-
 lib/Kconfig.debug                                  |  15 -
 lib/codetag.c                                      |  18 +
 lib/maple_tree.c                                   | 401 +++++++++-----
 lib/test_hmm.c                                     |   5 +-
 lib/xarray.c                                       |   3 +
 mm/Kconfig                                         |  22 +-
 mm/Kconfig.debug                                   |   1 -
 mm/Makefile                                        |   1 +
 mm/alloc_tag.c                                     | 351 ++++++++++++-
 {drivers/base => mm}/arch_numa.c                   |  12 +
 mm/cma.c                                           |   2 +-
 mm/cma.h                                           |   1 +
 mm/damon/lru_sort.c                                |  13 +-
 mm/damon/ops-common.c                              |  13 +-
 mm/damon/paddr.c                                   |   2 +
 mm/damon/reclaim.c                                 |  11 +-
 mm/damon/vaddr.c                                   |   3 +-
 mm/debug_page_alloc.c                              |   8 +-
 mm/filemap.c                                       |   6 +
 mm/folio-compat.c                                  |   1 +
 mm/folio.c                                         | 124 ++---
 mm/gup.c                                           |  23 +-
 mm/gup_test.c                                      |  94 ++--
 mm/hmm.c                                           |   5 +-
 mm/huge_memory.c                                   | 239 +++++----
 mm/hugetlb.c                                       |  10 +-
 mm/hugetlb_cma.c                                   | 142 ++++-
 mm/hugetlb_cma.h                                   |   2 +
 mm/internal.h                                      |  77 ++-
 mm/interval_tree.c                                 |   4 +-
 mm/kasan/quarantine.c                              |  12 +-
 mm/khugepaged.c                                    | 130 ++---
 mm/kmemleak.c                                      | 105 +++-
 mm/ksm.c                                           |  16 +-
 mm/madvise.c                                       |  17 +-
 mm/memcontrol-v1.c                                 |   4 +-
 mm/memcontrol-v1.h                                 |   1 +
 mm/memcontrol.c                                    | 171 +++++-
 mm/memory-failure.c                                |   4 +-
 mm/memory.c                                        | 140 +++--
 mm/mempolicy.c                                     |  23 +-
 mm/migrate.c                                       |  21 +-
 mm/migrate_device.c                                |  15 +-
 mm/mm_init.c                                       |   1 -
 mm/mmzone.c                                        |   1 +
 mm/mremap.c                                        |   8 +-
 mm/nommu.c                                         |   4 +
 mm/page-writeback.c                                |   5 +
 mm/page_alloc.c                                    |  28 +-
 mm/page_ext.c                                      |   9 -
 mm/page_io.c                                       | 581 ++++++++++-----------
 mm/page_reporting.c                                |  28 +-
 mm/page_table_check.c                              |  20 +-
 mm/page_vma_mapped.c                               |   6 +-
 mm/pagewalk.c                                      |  42 +-
 mm/pgalloc-track.h                                 |   3 +
 mm/ptdump.c                                        |   7 +
 mm/rmap.c                                          |  43 +-
 mm/shmem.c                                         |  29 +-
 mm/show_mem.c                                      |  12 +-
 mm/shuffle.h                                       |   2 +
 mm/sparse.c                                        |  18 +-
 mm/sparse.h                                        |   6 +
 mm/swap.h                                          |  65 ++-
 mm/swap_state.c                                    |  54 +-
 mm/swapfile.c                                      |  33 +-
 mm/userfaultfd.c                                   |   4 +-
 mm/vma.c                                           | 113 ++--
 mm/vma.h                                           |  89 ++--
 mm/vma_exec.c                                      |   2 +-
 mm/vma_init.c                                      |   1 +
 mm/vmalloc.c                                       | 111 ++--
 mm/vmalloc.h                                       |   2 +
 mm/vmscan.c                                        | 232 +++++---
 mm/vmstat.c                                        |  19 +-
 mm/workingset.c                                    |   5 -
 mm/zsmalloc.c                                      |  11 +-
 mm/zswap.c                                         |  46 +-
 samples/damon/mtier.c                              |   3 +
 tools/testing/radix-tree/maple.c                   |   4 +-
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/alloc_tag/Makefile         |   8 +
 .../selftests/alloc_tag/allocinfo_ioctl_test.c     | 548 +++++++++++++++++++
 .../selftests/cgroup/lib/include/cgroup_util.h     |   1 +
 tools/testing/selftests/cgroup/test_zswap.c        |  13 +-
 tools/testing/selftests/mm/.gitignore              |  76 +--
 tools/testing/selftests/mm/Makefile                |   7 +-
 tools/testing/selftests/mm/check_config.sh         |   2 +-
 tools/testing/selftests/mm/compaction_test.c       |  38 +-
 tools/testing/selftests/mm/cow.c                   |  11 +-
 tools/testing/selftests/mm/folio_split_race_test.c |   2 +-
 tools/testing/selftests/mm/guard-regions.c         |  10 +-
 tools/testing/selftests/mm/gup_longterm.c          |   2 +-
 tools/testing/selftests/mm/khugepaged.c            | 204 ++++++--
 .../testing/selftests/mm/ksft_kmemleak_confirm.sh  | 130 +++++
 tools/testing/selftests/mm/memory-failure.c        |  14 +-
 tools/testing/selftests/mm/merge.c                 |  57 ++
 tools/testing/selftests/mm/migration.c             |  37 +-
 tools/testing/selftests/mm/mseal_test.c            |   3 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |   8 +-
 tools/testing/selftests/mm/prctl_thp_disable.c     |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh          |   2 +
 tools/testing/selftests/mm/soft-dirty.c            |   5 +-
 tools/testing/selftests/mm/split_huge_page_test.c  | 139 +----
 tools/testing/selftests/mm/uffd-common.c           |   4 +-
 tools/testing/selftests/mm/vm_util.c               | 207 +++++++-
 tools/testing/selftests/mm/vm_util.h               |   8 +-
 tools/testing/selftests/proc/proc-maps-race.c      |   3 +-
 tools/testing/vma/include/dup.h                    |  64 ++-
 tools/testing/vma/shared.c                         |   3 +-
 tools/testing/vma/tests/merge.c                    |  49 +-
 tools/testing/vma/tests/vma.c                      |  50 +-
 tools/testing/vma/vma_internal.h                   |   1 +
 184 files changed, 4907 insertions(+), 1960 deletions(-)
 create mode 100644 include/linux/swap_ops.h
 create mode 100644 include/uapi/linux/alloc_tag.h
 rename {drivers/base => mm}/arch_numa.c (95%)
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
 create mode 100755 tools/testing/selftests/mm/ksft_kmemleak_confirm.sh

