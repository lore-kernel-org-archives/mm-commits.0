Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA3E2EDD69;
	Thu, 18 Jun 2026 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781800232; cv=none; b=tenit0uT0yW3LtooY3UsIgN1+Qa2I2VH8TWCnqGmk6z7ndbfIBP51ZZww5c7k2z5Hd8U/hVx9f2T7eI09jrIIU2M/FK483GwBZY2wRJ9h5fTjyhjIXYOht01hc90nBGHffiBhTEqxXnctzUsNaQHQYLgwGJ8ydWws5sMd6+v1i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781800232; c=relaxed/simple;
	bh=cyumghRFY/0FaHglLov7Ub29BQx3cv13k6sgF2Rs5CA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=UsBbKgI2FzuRLCLsVMW8RR8UtC4T1MHKkuQMwgJsQqidQ8dctWwuu6jPn7ktVeJXDnUAkpkXGOM0FhZXX3Ce80yPolBra4VMUKBe94RoXeorgwWj3MWMEdSN8vnuY3BkHdCT+myr/CP70WdEhyebRIDSqK/QT41c4GUJGBcWw/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gB/jEQMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gB/jEQMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC261F000E9;
	Thu, 18 Jun 2026 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781800227;
	bh=UyXI/D6VkbDiiidhX4RTUx09BvPjfrmZove7bH1v/is=;
	h=Date:From:To:Cc:Subject;
	b=gB/jEQMqhP90k+JTqbb0+q2NVd3+5tufLKxgzJ+AdzRKHfFSkT+UkuZzacYpAZTE1
	 yUG7fqHkjUq/1Pzz0DMvXod7LWEB6+lDPLPiWf3qlkAVLEbLOdO1oeorOkXFDlGwcD
	 7gZytBU54FwABsgir/55ItSG8uI6Azh7CbJD7rmA=
Date: Thu, 18 Jun 2026 09:30:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 7.2-rc1 (v2)
Message-Id: <20260618093027.803700be945480575260b0f3@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge these MM updates for the 7.2-rc1 development tree,
thanks.


Conflicts I'm presently seeing, along with their linux-resolutions:

mm/page_io.c, vs block tree:
	https://lore.kernel.org/ah26UmcBXVJMy-Cc@sirena.org.uk

tools/testing/selftests/cgroup/test_memcontrol.c, vs cgroup tree:
	https://lore.kernel.org/ags6BawOir3IQHIZ@sirena.org.uk



Possible upcoming possible conflicts and build issues, along with their
linux-next resolutions:

include/net/netmem.h, vs net tree:
	https://lore.kernel.org/aaGiDINfnUexT9Px@sirena.org.uk

drivers/android/binder/page_range.rs, vs char-misc.current tree:
	https://lore.kernel.org/aarPg_AVR3TN9frW@sirena.org.uk

fs/ntfs/file.c, vs fs tree:
	https://lore.kernel.org/aa7ZT-cQMVdQOOAj@sirena.org.uk

virt/kvm/guest_memfd.c, vs kvm-x86 tree:
	https://lore.kernel.org/abGDp4jguPV2H2Mf@sirena.org.uk

init/main.c, vs tip tree:
	https://lore.kernel.org/abLMq8TWJIQH5uTj@sirena.org.uk

fs/f2fs/compress.c, vs fs tree:
	https://lore.kernel.org/acPtrrkwagtafDT8@sirena.org.uk

fs/exfat/file.c, vs fs tree:
	https://lore.kernel.org/acbY5CCmsk8C95m5@sirena.co.uk

lib/vdso/datastore.c, vs tip tree:
	https://lore.kernel.org/acbz78Mbv55Vzfh8@sirena.co.uk

arch/loongarch/mm/init.c, vs loongarch tree:
	https://lore.kernel.org/ahBDDF2noinoSIg5@sirena.org.uk

fs/btrfs/defrag.c, vs fs tree:
	https://lore.kernel.org/ahRU4OQiGMaLf2Y-@sirena.org.uk



The following changes since commit 9d7bea186ba5a002456471edf36cc9b69f809397:

  userfaultfd: remove redundant check in vm_uffd_ops() (2026-05-31 21:50:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-18-09-26

for you to fetch changes up to e3d8707358ea76b78bdec9928937bb9a797f2c8f:

  selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries (2026-06-08 18:21:33 -0700)

----------------------------------------------------------------
mm.git review status for mm-hotfixes-stable..mm-stable

Everything:

Total patches:       321
Reviews/patch:       1.52
Reviewed rate:       68%

Excluding DAMON:

Total patches:       227
Reviews/patch:       2.07
Reviewed rate:       90%

Excluding DAMON and selftests:

Total patches:       203
Reviews/patch:       2.14
Reviewed rate:       91%

Patchsets in this merge:

- The 2 patch series "selftests/mm: clean up build output and verbosity"
  from Li Wang removes some noise from the MM selftests build out.

- The 3 patch series "mm: Free contiguous order-0 pages efficiently"
  from Ryan Roberts speeds up the freeing of a batch of 0-order pages by
  first scanning them for coalescing opportunities.  This is applicable to
  vfree() and to the releasing of frozen pages.

- The 11 patch series "mm/damon: introduce DAMOS failed region quota
  charge ratio" from SeongJae Park addresses a DAMOS usability issue: The
  DAMOS quota often exhausts prematurely because it charges for all memory
  attempted, causing slow and inconsistent performance when actions fail
  on unreclaimable memory.

  To fix this, a new feature lets users set a smaller, flexible quota
  charge ratio (via a numerator and denominator) for failed regions.
  Since failed actions cause less overhead, reducing their quota cost
  ensures more predictable and efficient DAMOS processing

- The 8 patch series "selftests/cgroup: improve zswap tests robustness
  and support large page sizes" from Li Wang fixes various spurious
  failures and improves the overall robustness of the cgroup zswap
  selftests.

- The 3 patch series "fix MAP_DROPPABLE not supported errno" from
  Anthony Yznaga fixes an issue in the mlock selftests on arm32.

- The 2 patch series "mm: huge_memory: clean up defrag sysfs with
  shared" from Breno Leitao does some maintenance work in the huge_memory
  code.

- The 3 patch series "treewide: fixup gfp_t printks" from Brendan
  Jackman uses the special vprintf() gfp_t conversion in various places.

- The 6 patch series "mm: Fix vmemmap optimization accounting and
  initialization" from Muchun Song fixes several bugs in the vmemmap
  optimization, mainly around incorrect page accounting and memmap
  initialization in the DAX and memory hotplug paths.  It also fixes
  pageblock migratetype initialization and struct page initialization for
  ZONE_DEVICE compound pages.

- The 4 patch series "mm/damon: repost non-hotfix reviewed patches in
  damon/next tree" from is a sprinkle of unrelated minor bugfixes for
  DAMON.

- The 3 patch series "mm: remove page_mapped()" from David Hildenbrand
  remove this function from the tree, replacing it with folio_mapped().

- The 10 patch series "mm/damon: let DAMON be paused and resumed" from
  SeongJae Park permits DAMON to be paused and resumed without losing its
  current state.

- The 3 patch series "kasan: hw_tags: Disable tagging for stack and
  page-tables" from Muhammad Usama Anjum simplifies and speeds up kasan by
  removing its ineffective tagging of stacks and page tables.

- The 7 patch series "mm/damon/reclaim,lru_sort: monitor all system rams
  by default" from SeongJae Park simplifies deployment on diverse hardware
  like NUMA systems by updating DAMON_RECLAIM and DAMON_LRU_SORT to
  automatically monitor the physical address range covering all System RAM
  areas by default, replacing the overly restrictive behavior that only
  targeted the single largest memory block to save on negligible overhead.

- The 2 patch series "mm/damon/sysfs: document filters/ directory as
  deprecated" from SeongJae Park updates some DAMON docs.

- The 8 patch series "mm: use spinlock guards for zone lock" from Dmitry
  Ilvokhin switches zone->lock handling over to using the guard()
  mechanisms.

- The 2 patch series "mm/filemap: tighten mmap_miss hit accounting" from
  fujunjie fixes a flaw where the mmap_miss counter over-credited page
  cache hits during fault-arounds and page-fault retries.  This results in
  significant reduction of redundant synchronous mmap readahead I/O,
  drastically cutting down execution time and gigabytes read for sparse
  random or strided memory access workloads.

- The 2 patch series "selftests/cgroup: Fix false positive failures in
  test_percpu_basic" from Li Wang fixes a couple of false-positives in the
  cgroup kmem selftests.

- The 2 patch series "mm/damon/reclaim: support monitoring intervals
  auto-tuning" from SeongJae Park adds a new parameter to DAMON permitting
  DAMON_RECLAIM to automatically tune DAMON's sampling and aggregation
  intervals.

- The 2 patch series "mm/damon/stat: add kdamond_pid parameter" from
  SeongJae Park chnges DAMON_STAT to provide the pid of its kdamond.

- The 2 patch series "mm/kmemleak: dedupe verbose scan output" from
  Breno Leitao removes large amounts of duplicated backtraces from the
  verbose-mode kmemleak output.

- The 8 patch series "mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 1)"
  from David Hildenbrand reduces our use of CONFIG_HAVE_BOOTMEM_INFO_NODE,
  with a view to removing it entirely in a later series.

- The 2 patch series "mm/damon: validate min_region_size to be power of
  2" from Liew Rui Yan prevents users from passing a non-power-of-2 value
  of `addr_unit', as this later results in undesirable behavior.

- The 2 patch series "mm: document read_pages and simplify usage" from
  Frederick Mayle does as claimed.

- The 3 patch series "tools/mm/page-types: Fix misc bugs" from Ye Liu
  fixes three issues in tools/mm/page-types.c.

- The 4 patch series "mm: misc cleanups from __GFP_UNMAPPED series" from
  Brendan Jackman implements several cleanups in the page allocator and
  related code.

- The 12 patch series "mm, swap: swap table phase IV: unify allocation"
  from Kairui Song unifies the allocation and charging of anon and shmem
  swap in folios, provides better synchronization, consolidates the
  metadata management, hence dropping the static array and map, and
  improves performance.

- The 28 patch series "mm/damon: introduce data attributes monitoring"
  from SeongJae Park extends DAMON for monitoring general data attributes
  other than accesses.

- The 5 patch series "mm/vmalloc: free unused pages on vrealloc()
  shrink" from Shivam Kalra implements the TODO in vrealloc() to unmap and
  free unused pages when shrinking across a page boundary.

- The 3 patch series "mm/damon: documentation and comment fixes" from
  niecheng does as advertised.

- The 3 patch series "remove mmap_action success, error hooks" from
  Lorenzo Stoakes eliminates custom hooks from mmap_action by removing the
  problematic success_hook which allowed drivers to improperly access
  uninitialized VMAs.  It replaces the error_hook with a simple error-code
  field and updates the memory char driver accordingly.

- The 14 patch series "mm/damon: minor improvements for code readability
  and tests" from SeongJae Park implements minor improvements in code
  readability and tests for DAMON.

- The 2 patch series "mm/damon: fix macro arguments and clarify quota
  goals doc" from Maksym Shcherba does those things.

- The 2 patch series "userfaultfd: merge fs/userfaultfd.c into
  mm/userfaultfd.c" from Mike Rapoport performs that code movement.

- The 15 patch series "mm/mglru: improve reclaim loop and dirty folio"
  from Kairui Song and others cleans up and slightly improves MGLRU's
  reclaim loop and dirty writeback handling.  Large performance
  improvements are measured.

- The 3 patch series "use vma locks for proc/pid/{smaps|numa_maps}
  reads" from Suren Baghdasaryan uses per-vma locks when reading
  /proc/pid/smaps and /proc/pid/numa_maps similar to reduce contention on
  central mmap_lock.

- The 2 patch series "refactors thpsize_shmem_enabled_store() and
  thpsize_shmem_enabled_show()" from Ran Xiaokai provides some cleanup
  work in the THP code.

- The 2 patch series "selftests/memfd: fix compilation warnings" from
  Konstantin Khorenko fixes a few build glitches in the memfd selftest
  code.

- The 4 patch series "memcg: shrink obj_stock_pcp and cache multiple
  objcgs" from Shakeel Butt resolves a 68% performance regression caused
  by NUMA-node cache thrashing around struct obj_stock_pcp by shrinking
  its existing fields and expanding it into a multi-slot array that caches
  up to five obj_cgroup pointers per CPU, allowing per-node variants of
  the same memcg to coexist within a single 64-byte cache line.

- The 2 patch series "zram: writeback fixes" from Sergey Senozhatsky
  addresses a couple of unrelated zram writeback issues.

- The 9 patch series "mm: switch THP shrinker to list_lru" from Johannes
  Weiner resolves NUMA-awareness issues and streamlines callsite
  interaction by refactoring and extending the list_lru API to completely
  replace the complex, open-coded deferred split queue for Transparent
  Huge Pages (THPs).

- The 2 patch series "mm: improve large folio readahead for exec memory"
  from Usama Arif improves large-folio readahead on systems like 64K-page
  arm64 by preventing the mmap_miss check from permanently disabling
  target-oriented VM_EXEC readahead, and by generalizing the
  force_thp_readahead gate to support mappings with any usefully large
  maximum folio order under the cache cap.

- The 6 patch series "userfaultfd/pagemap: pre-existing fixes" from
  Kiryl Shutsemau fixes a bunch of minor issues in the
  userfaultfd/pagemap, all of which were flagged by Sashiko review of
  proposed new material.

- The 5 patch series "mm/sparse-vmemmap: Provide generic
  vmemmap_set_pmd() and vmemmap_check_pmd()" from Muchun Song provides
  generic versions of these two functions so the four arch-specific
  implementations can be removed.

- The 2 patch series "mm/swap, PM: hibernate: fix swapoff race in
  uswsusp by pinning swap device" from Youngjun Park addresses a
  uswsusp-vs-swapoff race and reduces the swap device reference
  taking/releasing frequency.

- The 2 patch series "mm/hmm: A fix and a selftest" from Dev Jain does
  as claimed.

----------------------------------------------------------------
Aditya Sharma (1):
      mm/memory: update stale locking comments for fault handlers

Alexander Gordeev (2):
      mm/gup: cleanup pgtable entry accessors
      mm/page_vma_mapped_walk: use ptep_get_lockless() for lockless access

Alexander Potapenko (1):
      lib/test_meminit: use && for bools

Andrew Morton (1):
      Merge branch 'mm-hotfixes-stable' into mm-stable to pick up the series "userfaultfd: verify VMA state across UFFDIO_COPY retry", which is a prerequisite for mm-unnstable's series "userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c".

Anthony Yznaga (3):
      mm: fix mmap errno value when MAP_DROPPABLE is not supported
      selftests/mm: verify droppable mappings cannot be locked
      selftests/mm: run the MAP_DROPPABLE selftest

Asier Gutierrez (1):
      mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action

Baolin Wang (1):
      Revert "tmpfs: don't enable large folios if not supported"

Barry Song (Xiaomi) (3):
      mm/huge_memory: fix outdated comment about freeing subpages in __folio_split
      mm/mglru: use folio_mark_accessed to replace folio_set_active
      mm/mglru: avoid reclaim type fall back when isolation makes no progress

Brendan Jackman (12):
      mm/page_alloc: cleanup flag vars in alloc_pages_bulk_noprof()
      drm/managed: use special gfp_t format specifier
      mm/kfence: use special gfp_t format specifier
      net/rds: use special gfp_t format specifier
      mm: introduce for_each_free_list()
      mm/page_alloc: don't overload migratetype in find_suitable_fallback()
      mm: rejig pageblock mask definitions
      mm/page_alloc: remove ifdefs from pindex helpers
      mm/page_alloc: drop a misleading __always_inline
      mm/page_alloc: document that alloc_pages_nolock() uses RCU
      mm/page_alloc: remove VM_BUG_ON()s from pindex helpers
      mm: delete stale comment about cachelines

Breno Leitao (4):
      mm: huge_memory: use sysfs_match_string() in defrag_store()
      mm: huge_memory: refactor defrag_show() to use defrag_flags[]
      mm/kmemleak: dedupe verbose scan output by allocation backtrace
      selftests/mm: add kmemleak verbose dedup test

Brian Masney (2):
      MAINTAINERS: add vm.rst to memory management core
      docs: mm: clarify that user_reserve_kbytes has no effect when overcommit_memory is set to 0 or 1

Bunyod Suvonov (1):
      mm/vmscan: add balance_pgdat begin/end tracepoints

Cheng-Han Wu (1):
      Docs/admin-guide/mm/damon: fix 'parametrs' typo

Chengkaitao (1):
      mm: convert vmemmap_p?d_populate() to static functions

Cunlong Li (1):
      zram: drop unused bio parameter from write helpers

David Carlier (2):
      mm/page_io: rename swap_iocb fields for clarity
      mm/shrinker: avoid out-of-bounds read in set_shrinker_bit()

David Hildenbrand (Arm) (11):
      sh: use folio_mapped() instead of page_mapped() in sh4_flush_cache_page()
      bpf: arena: use page_ref_count() instead of page_mapped() in arena_free_pages()
      mm: remove page_mapped()
      sparc/mm: remove register_page_bootmem_info()
      mm/bootmem_info: drop initialization of page->lru
      mm/bootmem_info: stop using PG_private
      mm/bootmem_info: remove call to kmemleak_free_part_phys()
      mm/bootmem_info: stop marking the pgdat as NODE_INFO
      mm/bootmem_info: stop marking mem_section_usage as MIX_SECTION_INFO
      s390/mm: use free_reserved_page() in vmem_free_pages()
      powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE

David Rientjes (1):
      mm, page_alloc: reintroduce page allocation stall warning

Davidlohr Bueso (1):
      dax/kmem: account for partial discontiguous resource upon removal

Deepanshu Kartikey (1):
      mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch

Dev Jain (3):
      selftests/mm: simplify byte pattern checking in mremap_test
      fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
      selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries

Dmitry Ilvokhin (9):
      mm: use zone lock guard in reserve_highatomic_pageblock()
      mm: use zone lock guard in unset_migratetype_isolate()
      mm: use zone lock guard in unreserve_highatomic_pageblock()
      mm: use zone lock guard in set_migratetype_isolate()
      mm: use zone lock guard in take_page_off_buddy()
      mm: use zone lock guard in put_page_back_buddy()
      mm: use zone lock guard in free_pcppages_bulk()
      mm: use zone lock guard in __offline_isolated_pages()
      mm/page_alloc: fix defrag_mode for non-reclaimable allocations

Frederick Mayle (4):
      mm: limit filemap_fault readahead to VMA boundaries
      mm/readahead: add kerneldoc for read_pages
      mm/readahead: simplify page_cache_ra_unbounded loop counter reset
      mm/readahead: no PG_readahead on EOF

Georgi Djakov (1):
      drivers/base/memory: set mem->altmap after successful device registration

Hao Ge (3):
      proc/meminfo: expose per-node balloon pages in node meminfo
      lib/test_hmm: use kvfree() to free kvcalloc() allocations
      lib/test_hmm: fix memory leak in dmirror_migrate_to_system()

Hongfu Li (1):
      selftests/mm: fix mmap() return value check in run_migration_benchmark

Hrushikesh Salunke (1):
      mm/page_alloc: replace kernel_init_pages() with batch page clearing

Hui Zhu (2):
      mm/memcontrol: hoist pstatc_pcpu assignment out of CPU loop
      vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()

JP Kobryn (1):
      mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX

JP Kobryn (Meta) (2):
      mm/vmpressure: skip socket pressure for costly order reclaim
      mm/lruvec: preemptively free dead folios during lru_add drain

Jiayuan Chen (1):
      mm/damon: replace damon_rand() with a per-ctx lockless PRNG

Johannes Weiner (9):
      mm: list_lru: fix set_shrinker_bit() call during race with cgroup deletion
      mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
      mm: list_lru: deduplicate unlock_list_lru()
      mm: list_lru: move list dead check to lock_list_lru_of_memcg()
      mm: list_lru: deduplicate lock_list_lru()
      mm: list_lru: introduce caller locking for additions and deletions
      mm: list_lru: introduce folio_memcg_list_lru_alloc()
      mm: memory: flatten alloc_anon_folio() retry loop
      mm: switch deferred split shrinker to list_lru

Jose Fernandez (Anthropic) (1):
      mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host

Joshua Hahn (1):
      mm/nodemask: correctly describe nodemask operation return types

Julian Braha (1):
      mm/thp: dead code cleanup in Kconfig

Kairui Song (27):
      mm, swap: avoid leaving unused extend table after alloc race
      mm, swap: simplify swap cache allocation helper
      mm, swap: move common swap cache operations into standalone helpers
      mm/huge_memory: move THP gfp limit helper into header
      mm, swap: add support for stable large allocation in swap cache directly
      mm, swap: unify large folio allocation
      mm/memcg, swap: tidy up cgroup v1 memsw swap helpers
      mm, swap: support flexible batch freeing of slots in different memcgs
      mm, swap: delay and unify memcg lookup and charging for swapin
      mm, swap: consolidate cluster allocation helpers
      mm/memcg, swap: store cgroup id in cluster table directly
      mm/memcg: remove no longer used swap cgroup array
      mm, swap: merge zeromap into swap table
      mm/mglru: consolidate common code for retrieving evictable size
      mm/mglru: rename variables related to aging and rotation
      mm/mglru: relocate the LRU scan batch limit to callers
      mm/mglru: restructure the reclaim loop
      mm/mglru: scan and count the exact number of folios
      mm/mglru: use a smaller batch for reclaim
      mm/mglru: don't abort scan immediately right after aging
      mm/mglru: remove redundant swap constrained check upon isolation
      mm/mglru: use the common routine for dirty/writeback reactivation
      mm/mglru: simplify and improve dirty writeback handling
      mm/mglru: remove no longer used reclaim argument for folio protection
      mm/vmscan: remove sc->file_taken
      mm/vmscan: remove sc->unqueued_dirty
      mm/vmscan: unify writeback reclaim statistic and throttling

Kaitao Cheng (1):
      mm/memory-failure: use zone_pcp_disable() for poison handling

Kefeng Wang (1):
      mm/damon/vaddr: attempt per-vma lock during page table walk

Kiryl Shutsemau (Meta) (6):
      fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race
      fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()
      fs/proc/task_mmu: fix hugetlb self-deadlock in pagemap_scan_pte_hole()
      mm/huge_memory: preserve pmd_swp_uffd_wp on device-private PMD downgrade
      userfaultfd: gate must_wait writability check on pte_present()
      userfaultfd: build __VMA_UFFD_FLAGS from config-gated masks

Konstantin Khorenko (2):
      selftests/memfd: fix -Wmaybe-uninitialized warning in memfd_test
      selftests/memfd: remove unused variable 'sig' in fuse_test

Lance Yang (1):
      mm/thp: clear deferred split shrinker bits when queues drain

Leon Hwang (1):
      Documentation/admin-guide/mm: fix typos in transhuge.rst

Li Wang (12):
      selftests/mm: respect build verbosity settings for 32/64-bit targets
      selftests/mm: suppress compiler error in liburing check
      selftests/cgroup: skip test_zswap if zswap is globally disabled
      selftests/cgroup: avoid OOM in test_swapin_nozswap
      selftests/cgroup: use runtime page size for zswpin check
      selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
      selftests/cgroup: replace hardcoded page size values in test_zswap
      selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large pagesize system
      selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
      selftests/cgroup: test_zswap: wait for asynchronous writeback
      selftests/cgroup: fix hardcoded page size in test_percpu_basic
      selftests/cgroup: include slab in test_percpu_basic memory check

Liew Rui Yan (4):
      mm/damon/ops-common: optimize damon_hot_score() using ilog2()
      mm/damon: add synchronous commit for commit_inputs
      mm/damon/lru_sort: validate min_region_size to be power of 2
      mm/damon/reclaim: validate min_region_size to be power of 2

Lorenzo Stoakes (3):
      drivers/char/mem: eliminate unnecessary use of success_hook
      mm/vma: remove mmap_action->success_hook
      mm/vma: eliminate mmap_action->error_hook, introduce error_override

Maksym Shcherba (2):
      mm/damon: fix missing parens in macro arguments
      Docs/admin-guide/mm/damon/usage: clarify current_value of quota goals

Matthew Wilcox (Oracle) (2):
      mm: remove mentions of PageWriteback
      mm: document the folio refcount a little better

Mike Rapoport (Microsoft) (3):
      userfaultfd: ensure mremap_userfaultfd_fail() releases mmap_changing
      userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
      userfaultfd: make functions that are not used outside uffd static

Muchun Song (14):
      mm/sparse: remove sparse buffer pre-allocation mechanism
      mm/sparse-vmemmap: fix vmemmap accounting underflow
      mm/memory_hotplug: fix incorrect altmap passing in error path
      mm/sparse-vmemmap: pass @pgmap argument to memory deactivation paths
      mm/sparse-vmemmap: fix DAX vmemmap accounting with optimization
      mm/mm_init: fix pageblock migratetype for ZONE_DEVICE compound pages
      mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE
      mm/memory_hotplug: factor out altmap freeing checks
      drivers/base/memory: make memory block get/put explicit
      mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
      arm64/mm: drop vmemmap_pmd helpers and use generic code
      riscv/mm: drop vmemmap_pmd helpers and use generic code
      loongarch/mm: drop vmemmap_check_pmd helper and use generic code
      sparc/mm: drop vmemmap_check_pmd helper and use generic code

Muhammad Usama Anjum (4):
      mm/page_alloc: optimize __free_contig_frozen_range()
      vmalloc: add __GFP_SKIP_KASAN support
      kasan: skip HW tagging for all kernel thread stacks
      mm: skip KASAN tagging for page-allocated page tables

Nakamura Shuta (1):
      rust: page: mark Page::nid as inline

Oleg Nesterov (1):
      mm/migrate: find_mm_struct: fix race between security checks and suid exec

Qiang Liu (2):
      lib/test_hmm: fix error path in dmirror_devmem_fault()
      lib/test_hmm: check alloc_page_vma() return value and handle OOM

Ran Xiaokai (2):
      mm: shmem: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
      mm: shmem: refactor thpsize_shmem_enabled_show() with helper arrays

Ravi Jonnalagadda (1):
      mm/damon: add node_eligible_mem_bp goal metric

Ryan Roberts (2):
      mm/page_alloc: optimize free_contig_range()
      vmalloc: optimize vfree with free_pages_bulk()

Sakurai Shun (2):
      docs/mm: fix typo in process_addrs.rst
      Docs/mm/damon/design: fix three typos

Sang-Heon Jeon (2):
      mm/sparse: remove unnecessary NULL check before allocating mem_section
      mm/hugetlb_cma: restrict hugetlb_cma parameter to gigantic-page alignment

SeongJae Park (80):
      mm/damon/core: make charge_addr_from aware of end-address exclusivity
      mm/damon/core: handle <min_region_sz remaining quota as empty
      mm/damon/core: merge regions after applying DAMOS schemes
      mm/damon/core: introduce failed region quota charge ratio
      mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
      Docs/mm/damon/design: document fail_charge_{num,denom}
      Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
      Docs/ABI/damon: document fail_charge_{num,denom}
      mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
      selftests/damon/_damon_sysfs: support failed region quota charge ratio
      selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
      selftests/damon/sysfs.py: test failed region quota charge ratio
      Docs/mm/damon/maintainer-profile: add AI review usage guideline
      mm/damon/core: introduce damon_ctx->paused
      mm/damon/sysfs: add pause file under context dir
      Docs/mm/damon/design: update for context pause/resume feature
      Docs/admin-guide/mm/damon/usage: update for pause file
      Docs/ABI/damon: update for pause sysfs file
      mm/damon/tests/core-kunit: test pause commitment
      selftests/damon/_damon_sysfs: support pause file staging
      selftests/damon/drgn_dump_damon_status: dump pause
      selftests/damon/sysfs.py: check pause on assert_ctx_committed()
      selftests/damon/sysfs.py: pause DAMON before dumping status
      mm/damon: introduce damon_set_region_system_rams_default()
      mm/damon/reclaim: cover all system rams
      mm/damon/lru_sort: cover all system rams
      mm/damon/core: remove damon_set_region_biggest_system_ram_default()
      mm/damon/stat: use damon_set_region_system_rams_default()
      Docs/admin-guide/mm/damon/reclaim: update for entire memory monitoring
      Docs/admin-guide/mm/damon/lru_sort: update for entire memory monitoring
      Docs/admin-guide/mm/damon/usage: mark scheme filters sysfs dir as deprecated
      Docs/ABI/damon: mark schemes/<S>/filters/ deprecated
      mm/damon/reclaim: add autotune_monitoring_intervals parameter
      Docs/admin-guide/mm/damon/reclaim: update for autotune_monitoring_intervals
      mm/damon/stat: add a parameter for reading kdamond pid
      Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter
      mm/damon/core: introduce struct damon_probe
      mm/damon/core: embed damon_probe objects in damon_ctx
      mm/damon/core: introduce damon_filter
      mm/damon/core: commit probes
      mm/damon/core: introduce damon_region->probe_hits
      mm/damon/core: introduce damon_ops->apply_probes
      mm/damon/core: do data attributes monitoring
      mm/damon/paddr: support data attributes monitoring
      mm/damon/sysfs: implement probes dir
      mm/damon/sysfs: implement probe dir
      mm/damon/sysfs: implement filters directory
      mm/damon/sysfs: implement filter dir
      mm/damon/sysfs: implement filter dir files
      mm/damon/sysfs: setup probes on DAMON core API parameters
      mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/
      mm/damon/sysfs-schemes: implement probe dir
      mm/damon/sysfs-schemes: implement probe/hits file
      mm/damon: trace probe_hits
      selftests/damon/sysfs.sh: test probes dir
      Docs/mm/damon/design: document data attributes monitoring
      Docs/admin-guide/mm/damon/usage: document data attributes monitoring
      mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG
      mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG
      mm/damon/sysfs: add filters/<F>/path file
      mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
      mm/damon/sysfs: setup damon_filter->memcg_id from path
      Docs/mm/damon/design: update for memcg damon filter
      Docs/admin-guide/mm/damon/usage: update for memcg damon filter
      mm/damon/core: safely handle no region case in damon_set_regions()
      mm/damon/core: do not use region out of a loop in damon_set_regions()
      samples/damon/mtier: replace damon_add_region() with damon_set_regions()
      mm/damon/tests/vaddr-kunit: replace damon_add_region() with damon_set_regions()
      mm/damon/core: hide damon_add_region()
      mm/damon/core: hide damon_insert_region()
      mm/damon/core: hide damon_destroy_region()
      mm/damon/core: add kdamond_call() debug_sanity check
      mm/damon/core: remove damon_verify_nr_regions()
      mm/damon/tests/core-kunit: add damon_set_regions() test cases
      selftests/damon/sysfs.py: stop kdamonds before failing
      selftests/damon/sysfs.sh: test monitoring intervals goal dir
      selftests/damon/sysfs.sh: test addr_unit file existence
      selftests/damon/sysfs.sh: test pause file existence
      mm/damon/core: trace esz at first setup
      MAINTAINERS: add testing ABI documents for mm

Sergey Senozhatsky (2):
      zram: do not leak blk idx at the end of writeback
      zram: clear trailing bytes of compressed writeback pages

Shakeel Butt (4):
      memcg: store node_id instead of pglist_data pointer
      memcg: uint16_t for nr_bytes in obj_stock_pcp
      memcg: int16_t for cached slab stats
      memcg: multi objcg charge support

Shivam Kalra (5):
      mm/vmalloc: extract vm_area_free_pages() helper from vfree()
      mm/vmalloc: use physical page count for vrealloc() grow-in-place check
      mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas
      mm/vmalloc: free unused pages on vrealloc() shrink
      lib/test_vmalloc: add vrealloc test case

Shivank Garg (1):
      mm/migrate: rename PAGE_ migration flags to FOLIO_

Steven Rostedt (1):
      maple_tree: document that "last" in mtree_insert_range() is inclusive

Sunny Patel (1):
      mm/migrate_device: cleanup up PMD Checks and warnings

Suren Baghdasaryan (3):
      fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock
      selftests/proc: ensure the test is performed at the right page boundary
      selftests/proc: add /proc/pid/smaps tearing tests

Takahiro Itazuri (1):
      mm/mmu_notifier: fix a begin vs. start typo in the invalidate range comment

Tal Zussman (2):
      mm/filemap: fix page_cache_prev_miss() when no hole is found
      MAINTAINERS: add more files to PAGE CACHE section

Thorsten Blum (1):
      mm/mseal: use min/max in mseal_apply

Usama Arif (3):
      mm: make mmap_miss accounting symmetric for VM_SEQ_READ
      mm: bypass mmap_miss heuristic for VM_EXEC readahead
      mm: use mapping_max_folio_order() for force_thp_readahead order

Vineet Agarwal (5):
      selftests/mm: khugepaged: initialize file contents via mmap
      mm/khugepaged: return -EAGAIN for SCAN_PAGE_HAS_PRIVATE in MADV_COLLAPSE
      selftests/mm: check file initialization writes in split_huge_page_test
      mm/damon/sysfs-schemes: fix double increment of nr_regions
      selftests/mm: ksm-functional-tests: fix partial write handling

Wang Wensheng (1):
      kasan/test: only do kmalloc_double_kzfree for generic mode

Wei Yang (1):
      selftests/mm/split_huge_page_test.c: close fd on write error

Xiang Gao (1):
      mm/vmscan: fix typos in comments

Ye Liu (7):
      mm/memory-failure: use bool for forcekill state
      mm/khugepaged: use ALIGN helpers for PMD alignment
      mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag due to allocation failure order
      tools/mm/page-types: fix typo in madvise() error message
      tools/mm/page-types: fix ternary operator precedence in sigbus handler
      tools/mm/page-types: fix kpageflags option argument in getopt_long
      mm/memory-failure: remove hugetlb output parameter from try_memory_failure_hugetlb()

Youngjun Park (2):
      mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device
      mm/swap: remove redundant swap device reference in alloc/free

Zenghui Yu (1):
      Docs/{ABI,admin-guide}/damon: fix various typoes

Zhen Ni (1):
      mm/page_owner: fix %pGp format specifier argument type

Zhouyi Zhou (1):
      highmem-internal.h: fix typo in the comment for kunmap_atomic()

Zijiang Huang (1):
      mm/swap: add cond_resched() in swap_reclaim_full_clusters to prevent softlockup

fujunjie (5):
      mm/madvise: reject invalid process_madvise() advice for zero-length vectors
      mm/filemap: count only the faulting address as a mmap hit
      mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits
      mm/compaction: respect cpusets when checking retry suitability
      mm/page_alloc: fix deferred compaction accounting

niecheng (1):
      mm/damon/core: clarify next_intervals_tune_sis update path

tanze (1):
      mm/filemap: use folio_next_index() for start

wangxuewen (2):
      mm/memory-failure: replace magic number 3 with GET_PAGE_MAX_RETRY_NUM
      mm/shrinker: simplify shrinker_memcg_alloc() using guard()

zenghongling (1):
      mm/percpu-internal.h: optimise pcpu_chunk struct to save memory

 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   81 +-
 Documentation/admin-guide/kernel-parameters.txt    |    4 +
 Documentation/admin-guide/mm/damon/lru_sort.rst    |    8 +-
 Documentation/admin-guide/mm/damon/reclaim.rst     |   19 +-
 Documentation/admin-guide/mm/damon/stat.rst        |    7 +
 Documentation/admin-guide/mm/damon/usage.rst       |  108 +-
 Documentation/admin-guide/mm/transhuge.rst         |    4 +-
 Documentation/admin-guide/sysctl/vm.rst            |    2 +
 Documentation/mm/damon/design.rst                  |   78 +-
 Documentation/mm/damon/maintainer-profile.rst      |   21 +
 Documentation/mm/process_addrs.rst                 |    2 +-
 MAINTAINERS                                        |   16 +-
 arch/arm64/mm/mmu.c                                |   19 +-
 arch/loongarch/mm/init.c                           |   16 +-
 arch/powerpc/mm/init_64.c                          |    8 -
 arch/powerpc/mm/mem.c                              |    5 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   14 +-
 arch/riscv/mm/init.c                               |   18 +-
 arch/s390/mm/init.c                                |    5 +-
 arch/s390/mm/vmem.c                                |    3 +-
 arch/sh/mm/cache-sh4.c                             |    2 +-
 arch/sparc/mm/init_64.c                            |   31 -
 arch/x86/mm/init_64.c                              |    5 +-
 drivers/base/memory.c                              |   41 +-
 drivers/base/node.c                                |    6 +-
 drivers/block/zram/zram_drv.c                      |   13 +-
 drivers/char/mem.c                                 |   25 +-
 drivers/dax/kmem.c                                 |    6 +
 drivers/gpu/drm/drm_managed.c                      |    4 +-
 drivers/s390/char/sclp_mem.c                       |   17 +-
 fs/Makefile                                        |    1 -
 fs/proc/task_mmu.c                                 |  269 ++-
 fs/userfaultfd.c                                   | 2231 -------------------
 include/asm-generic/pgalloc.h                      |    2 +-
 include/linux/bootmem_info.h                       |    1 -
 include/linux/compaction.h                         |   10 +-
 include/linux/damon.h                              |  136 +-
 include/linux/gfp.h                                |    4 +
 include/linux/gfp_types.h                          |    6 +-
 include/linux/highmem-internal.h                   |    2 +-
 include/linux/huge_mm.h                            |   47 +-
 include/linux/list_lru.h                           |   70 +
 include/linux/memcontrol.h                         |   31 +-
 include/linux/memory.h                             |    7 +-
 include/linux/memory_hotplug.h                     |    8 +-
 include/linux/mm.h                                 |   62 +-
 include/linux/mm_inline.h                          |    2 +-
 include/linux/mm_types.h                           |   19 +-
 include/linux/mmu_notifier.h                       |    4 +-
 include/linux/mmzone.h                             |   23 +-
 include/linux/nodemask.h                           |   18 +-
 include/linux/page_ref.h                           |   18 +
 include/linux/pageblock-flags.h                    |    6 +-
 include/linux/pagemap.h                            |    2 +
 include/linux/swap.h                               |   24 +-
 include/linux/swap_cgroup.h                        |   47 -
 include/linux/thread_info.h                        |    2 +-
 include/linux/userfaultfd_k.h                      |   40 +-
 include/linux/vmalloc.h                            |    4 +-
 include/linux/vmpressure.h                         |    9 +-
 include/trace/events/damon.h                       |   38 +
 include/trace/events/vmscan.h                      |   52 +
 kernel/bpf/arena.c                                 |    2 +-
 kernel/fork.c                                      |    5 +-
 kernel/power/snapshot.c                            |    8 +-
 kernel/power/swap.c                                |    2 +-
 kernel/power/user.c                                |   15 +-
 lib/maple_tree.c                                   |    7 +-
 lib/test_hmm.c                                     |   49 +-
 lib/test_meminit.c                                 |    2 +-
 lib/test_vmalloc.c                                 |   62 +
 mm/Kconfig                                         |    7 +-
 mm/Makefile                                        |    3 -
 mm/bootmem_info.c                                  |   25 +-
 mm/compaction.c                                    |   11 +-
 mm/damon/core.c                                    |  655 +++++-
 mm/damon/lru_sort.c                                |   59 +-
 mm/damon/ops-common.c                              |    9 +-
 mm/damon/paddr.c                                   |   84 +-
 mm/damon/reclaim.c                                 |   98 +-
 mm/damon/stat.c                                    |   92 +-
 mm/damon/sysfs-common.c                            |   41 +
 mm/damon/sysfs-common.h                            |    2 +
 mm/damon/sysfs-schemes.c                           |  289 ++-
 mm/damon/sysfs.c                                   |  588 +++++
 mm/damon/tests/core-kunit.h                        |  180 +-
 mm/damon/tests/vaddr-kunit.h                       |   27 +-
 mm/damon/vaddr.c                                   |   79 +-
 mm/filemap.c                                       |  133 +-
 mm/gup.c                                           |    8 +-
 mm/huge_memory.c                                   |  479 ++---
 mm/hugetlb.c                                       |    7 +-
 mm/hugetlb_cma.c                                   |   35 +-
 mm/internal.h                                      |   27 +-
 mm/kasan/kasan_test_c.c                            |   10 +
 mm/kfence/kfence_test.c                            |    2 +-
 mm/khugepaged.c                                    |   21 +-
 mm/kmemleak.c                                      |  148 +-
 mm/list_lru.c                                      |  238 ++-
 mm/madvise.c                                       |   60 +-
 mm/memcontrol-v1.c                                 |   68 +-
 mm/memcontrol.c                                    |  294 ++-
 mm/memory-failure.c                                |   47 +-
 mm/memory.c                                        |  206 +-
 mm/memory_hotplug.c                                |   34 +-
 mm/mempolicy.c                                     |    2 +-
 mm/memremap.c                                      |    4 +-
 mm/migrate.c                                       |   63 +-
 mm/migrate_device.c                                |    9 +-
 mm/mm_init.c                                       |   73 +-
 mm/mmap.c                                          |    2 +-
 mm/mseal.c                                         |    5 +-
 mm/page_alloc.c                                    |  383 +++-
 mm/page_io.c                                       |  103 +-
 mm/page_isolation.c                                |   67 +-
 mm/page_owner.c                                    |    2 +-
 mm/page_vma_mapped.c                               |    9 +-
 mm/percpu-internal.h                               |    6 +-
 mm/readahead.c                                     |   36 +-
 mm/rmap.c                                          |    8 +-
 mm/shmem.c                                         |  278 ++-
 mm/shrinker.c                                      |   18 +-
 mm/sparse-vmemmap.c                                |   82 +-
 mm/sparse.c                                        |   68 +-
 mm/swap.c                                          |   57 +-
 mm/swap.h                                          |   90 +-
 mm/swap_cgroup.c                                   |  172 --
 mm/swap_state.c                                    |  533 +++--
 mm/swap_table.h                                    |  179 +-
 mm/swapfile.c                                      |  460 ++--
 mm/userfaultfd.c                                   | 2259 +++++++++++++++++++-
 mm/util.c                                          |   32 +-
 mm/vma.c                                           |    3 +
 mm/vmalloc.c                                       |  130 +-
 mm/vmpressure.c                                    |   15 +-
 mm/vmscan.c                                        |  370 ++--
 mm/workingset.c                                    |   10 +-
 mm/zswap.c                                         |   25 +-
 net/rds/tcp_recv.c                                 |    2 +-
 rust/kernel/page.rs                                |    1 +
 samples/damon/mtier.c                              |   10 +-
 tools/mm/page-types.c                              |    8 +-
 tools/testing/selftests/cgroup/lib/cgroup_util.c   |   18 +-
 .../selftests/cgroup/lib/include/cgroup_util.h     |    4 +-
 tools/testing/selftests/cgroup/test_core.c         |    2 +-
 tools/testing/selftests/cgroup/test_freezer.c      |    2 +-
 tools/testing/selftests/cgroup/test_kmem.c         |   13 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |   19 +-
 tools/testing/selftests/cgroup/test_zswap.c        |  181 +-
 tools/testing/selftests/damon/_damon_sysfs.py      |   31 +-
 .../selftests/damon/drgn_dump_damon_status.py      |    3 +
 tools/testing/selftests/damon/sysfs.py             |   60 +-
 tools/testing/selftests/damon/sysfs.sh             |   62 +
 tools/testing/selftests/memfd/fuse_test.c          |    2 +-
 tools/testing/selftests/memfd/memfd_test.c         |    4 +-
 tools/testing/selftests/mm/Makefile                |   10 +-
 tools/testing/selftests/mm/check_config.sh         |    2 +-
 tools/testing/selftests/mm/droppable.c             |    9 +-
 tools/testing/selftests/mm/hmm-tests.c             |   36 +-
 tools/testing/selftests/mm/khugepaged.c            |   18 +-
 tools/testing/selftests/mm/ksft_kmemleak_dedup.sh  |  222 ++
 tools/testing/selftests/mm/ksm_functional_tests.c  |   19 +-
 tools/testing/selftests/mm/mlock2-tests.c          |   84 +-
 tools/testing/selftests/mm/mremap_test.c           |  109 +-
 tools/testing/selftests/mm/process_madv.c          |   28 +
 tools/testing/selftests/mm/run_vmtests.sh          |    1 +
 tools/testing/selftests/mm/split_huge_page_test.c  |   12 +-
 tools/testing/selftests/proc/proc-maps-race.c      |  293 ++-
 tools/testing/vma/include/dup.h                    |   20 +-
 169 files changed, 9218 insertions(+), 5621 deletions(-)
 delete mode 100644 fs/userfaultfd.c
 delete mode 100644 include/linux/swap_cgroup.h
 delete mode 100644 mm/swap_cgroup.c
 create mode 100755 tools/testing/selftests/mm/ksft_kmemleak_dedup.sh

