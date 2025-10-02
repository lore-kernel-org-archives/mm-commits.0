Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BECB34BA29;
	Thu,  2 Oct 2025 02:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759370539; cv=none; b=Cx5b8njS0LuVyMwYfI5+0FFACU162eLo3lLoOe4xBS+Rl66rmYwewSJiX4s/YlgVN5aYmBsJEDpKhp9qwYGOD1zLQ9wX3zJymMegc0kbysw9/9twfO6foVC0nXr7P665p8PJlrDXQYaXDHf1fRCGXQBajqZblsVRJiAzUfs0oXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759370539; c=relaxed/simple;
	bh=xtojIJUqjieGVVA5v3sSAVFtiIU0LTbs0MjSLZwY7OQ=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=EgvoAH37KlQ5OR482ZvPbShfZlc18sFLL/fJLZuBt00p7r7BdB4JxkjkQwPSKPR18uWKTV9k0KazigGLS3IGwCQ8uuhjdN+R/EnC28HcTuZ61XYpSerVtsBPRLgKp70TnyUTJfG60L8AhPmOwNcQ4lewdq9VQ7a2k8UrSJ1al4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FI30G1GH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FI30G1GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050EDC4CEF1;
	Thu,  2 Oct 2025 02:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759370539;
	bh=xtojIJUqjieGVVA5v3sSAVFtiIU0LTbs0MjSLZwY7OQ=;
	h=Date:From:To:Cc:Subject:From;
	b=FI30G1GHtiyO3XgP57atkL0H1I9fc6iRIwPmcOu/8y2ZmNM1wW7qqzikughyNbtIr
	 LUOrhTyXHrOLeo/rj6RN1t+kz6ZMGely6gO0XDS8J81GeB6BY61Zozz4bfZGflRg+l
	 6ySiOZt+rBIuo4D+Ub24S4g0yzNga9D3Tv9TXqM8=
Date: Wed, 1 Oct 2025 19:02:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [GIT PULL] MM updates for 6.18-rc1
Message-Id: <20251001190218.f33f695b869696c2df9e841d@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of MM updates for the 6.18 developmet
cycle, thanks.


Conflicts which I am seeing at this time are:

arch/riscv/include/asm/pgtable.h, vs mainline:
https://lkml.kernel.org/r/aNU8moQVmqvduSPU@sirena.org.uk
Please just drop the mm.git change and use Paul's version.  There was some
wire-crossing here.

fs/bcachefs/darray.c, vs mainline:
fs/bcachefs/util.h, vs mainline:
Please drop the attempted bcachefs changes.

rust/kernel/alloc.rs, vs mainline:
https://lkml.kernel.org/r/20250818122053.355aab17@canb.auug.org.au



Possible upcoming conflicts and their linux-next resolutions are:

rust/kernel/alloc/allocator.rs, vs drm tree:
https://lkml.kernel.org/r/20250813111151.6a261ca1@canb.auug.org.au

rust/kernel/alloc/allocator_test.rs, vs rust-alloc tree:
https://lkml.kernel.org/r/20250826173041.3140da7b@canb.auug.org.au

rust/kernel/alloc/kbox.rs, vs drm-rust tree:
https://lkml.kernel.org/r/20250905124634.68da9a1e@canb.auug.org.au

rust/kernel/alloc/allocator.rs, vs drm-rust tree:
https://lkml.kernel.org/r/20250905125139.109081b2@canb.auug.org.au

Documentation/filesystems/porting.rst, vs fs-next tree:
https://lkml.kernel.org/r/aMhQ6Po0hAIyB0dM@sirena.org.uk

Documentation/filesystems/porting.rst, vs fs-next tree:
https://lkml.kernel.org/r/aNPGHEYMk-6vFJlW@finisterre.sirena.org.uk



The following changes since commit ce4be9e4307c5a60701ff6e0cafa74caffdc54ce:

  zram: fix slot write race condition (2025-09-15 20:01:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-01-19-00

for you to fetch changes up to 1367da7eb875d01102d2ed18654b24d261ff5393:

  mm: swap: check for stable address space before operating on the VMA (2025-09-28 11:51:34 -0700)

----------------------------------------------------------------
Summary of significant series in this pull request:

- The 3 patch series "mm, swap: improve cluster scan strategy" from
  Kairui Song improves performance and reduces the failure rate of swap
  cluster allocation.

- The 4 patch series "support large align and nid in Rust allocators"
  from Vitaly Wool permits Rust allocators to set NUMA node and large
  alignment when perforning slub and vmalloc reallocs.

- The 2 patch series "mm/damon/vaddr: support stat-purpose DAMOS" from
  Yueyang Pan extend DAMOS_STAT's handling of the DAMON operations sets
  for virtual address spaces for ops-level DAMOS filters.

- The 3 patch series "execute PROCMAP_QUERY ioctl under per-vma lock"
  from Suren Baghdasaryan reduces mmap_lock contention during reads of
  /proc/pid/maps.

- The 2 patch series "mm/mincore: minor clean up for swap cache
  checking" from Kairui Song performs some cleanup in the swap code.

- The 11 patch series "mm: vm_normal_page*() improvements" from David
  Hildenbrand provides code cleanup in the pagemap code.

- The 5 patch series "add persistent huge zero folio support" from
  Pankaj Raghav provides a block layer speedup by optionalls making the
  huge_zero_pagepersistent, instead of releasing it when its refcount
  falls to zero.

- The 3 patch series "kho: fixes and cleanups" from Mike Rapoport adds a
  few touchups to the recently added Kexec Handover feature.

- The 10 patch series "mm: make mm->flags a bitmap and 64-bit on all
  arches" from Lorenzo Stoakes turns mm_struct.flags into a bitmap.  To
  end the constant struggle with space shortage on 32-bit conflicting with
  64-bit's needs.

- The 2 patch series "mm/swapfile.c and swap.h cleanup" from Chris Li
  cleans up some swap code.

- The 7 patch series "selftests/mm: Fix false positives and skip
  unsupported tests" from Donet Tom fixes a few things in our selftests
  code.

- The 7 patch series "prctl: extend PR_SET_THP_DISABLE to only provide
  THPs when advised" from David Hildenbrand "allows individual processes
  to opt-out of THP=always into THP=madvise, without affecting other
  workloads on the system".

  It's a long story - the [1/N] changelog spells out the considerations.

- The 11 patch series "Add and use memdesc_flags_t" from Matthew Wilcox
  gets us started on the memdesc project.  Please see
  https://kernelnewbies.org/MatthewWilcox/Memdescs and
  https://blogs.oracle.com/linux/post/introducing-memdesc.

- The 3 patch series "Tiny optimization for large read operations" from
  Chi Zhiling improves the efficiency of the pagecache read path.

- The 5 patch series "Better split_huge_page_test result check" from Zi
  Yan improves our folio splitting selftest code.

- The 2 patch series "test that rmap behaves as expected" from Wei Yang
  adds some rmap selftests.

- The 3 patch series "remove write_cache_pages()" from Christoph Hellwig
  removes that function and converts its two remaining callers.

- The 2 patch series "selftests/mm: uffd-stress fixes" from Dev Jain
  fixes some UFFD selftests issues.

- The 3 patch series "introduce kernel file mapped folios" from Boris
  Burkov introduces the concept of "kernel file pages".  Using these
  permits btrfs to account its metadata pages to the root cgroup, rather
  than to the cgroups of random inappropriate tasks.

- The 2 patch series "mm/pageblock: improve readability of some
  pageblock handling" from Wei Yang provides some readability improvements
  to the page allocator code.

- The 11 patch series "mm/damon: support ARM32 with LPAE" from SeongJae
  Park teaches DAMON to understand arm32 highmem.

- The 4 patch series "tools: testing: Use existing atomic.h for
  vma/maple tests" from Brendan Jackman performs some code cleanups and
  deduplication under tools/testing/.

- The 2 patch series "maple_tree: Fix testing for 32bit compiles" from
  Liam Howlett fixes a couple of 32-bit issues in
  tools/testing/radix-tree.c.

- The 2 patch series "kasan: unify kasan_enabled() and remove
  arch-specific implementations" from Sabyrzhan Tasbolatov moves KASAN
  arch-specific initialization code into a common arch-neutral
  implementation.

- The 3 patch series "mm: remove zpool" from Johannes Weiner removes
  zspool - an indirection layer which now only redirects to a single thing
  (zsmalloc).

- The 2 patch series "mm: task_stack: Stack handling cleanups" from
  Pasha Tatashin makes a couple of cleanups in the fork code.

- The 37 patch series "mm: remove nth_page()" from David Hildenbrand
  makes rather a lot of adjustments at various nth_page() callsites,
  eventually permitting the removal of that undesirable helper function.

- The 2 patch series "introduce kasan.write_only option in hw-tags" from
  Yeoreum Yun creates a KASAN read-only mode for ARM, using that
  architecture's memory tagging feature.  It is felt that a read-only mode
  KASAN is suitable for use in production systems rather than debug-only.

- The 3 patch series "mm: hugetlb: cleanup hugetlb folio allocation"
  from Kefeng Wang does some tidying in the hugetlb folio allocation code.

- The 12 patch series "mm: establish const-correctness for pointer
  parameters" from Max Kellermann makes quite a number of the MM API
  functions more accurate about the constness of their arguments.  This
  was getting in the way of subsystems (in this case CEPH) when they
  attempt to improving their own const/non-const accuracy.

- The 7 patch series "Cleanup free_pages() misuse" from Vishal Moola
  fixes a number of code sites which were confused over when to use
  free_pages() vs __free_pages().

- The 3 patch series "Add Rust abstraction for Maple Trees" from Alice
  Ryhl makes the mapletree code accessible to Rust.  Required by nouveau
  and by its forthcoming successor: the new Rust Nova driver.

- The 2 patch series "selftests/mm: split_huge_page_test:
  split_pte_mapped_thp improvements" from David Hildenbrand adds a fix and
  some cleanups to the thp selftesting code.

- The 14 patch series "mm, swap: introduce swap table as swap cache
  (phase I)" from Chris Li and Kairui Song is the first step along the
  path to implementing "swap tables" - a new approach to swap allocation
  and state tracking which is expected to yield speed and space
  improvements.  This patchset itself yields a 5-20% performance benefit
  in some situations.

- The 3 patch series "Some ptdesc cleanups" from Matthew Wilcox utilizes
  the new memdesc layer to clean up the ptdesc code a little.

- The 3 patch series "Fix va_high_addr_switch.sh test failure" from
  Chunyu Hu fixes some issues in our 5-level pagetable selftesting code.

- The 2 patch series "Minor fixes for memory allocation profiling" from
  Suren Baghdasaryan addresses a couple of minor issues in relatively new
  memory allocation profiling feature.

- The 3 patch series "Small cleanups" from Matthew Wilcox has a few
  cleanups in preparation for more memdesc work.

- The 2 patch series "mm/damon: add addr_unit for DAMON_LRU_SORT and
  DAMON_RECLAIM" from Quanmin Yan makes some changes to DAMON in
  furtherance of supporting arm highmem.

- The 2 patch series "selftests/mm: Add -Wunreachable-code and fix
  warnings" from Muhammad Anjum adds that compiler check to selftests code
  and fixes the fallout, by removing dead code.

- The 10 patch series "Improvements to Victim Process Thawing and OOM
  Reaper Traversal Order" from zhongjinji makes a number of improvements
  in the OOM killer: mainly thawing a more appropriate group of victim
  threads so they can release resources.

- The 5 patch series "mm/damon: misc fixups and improvements for 6.18"
  from SeongJae Park is a bunch of small and unrelated fixups for DAMON.

- The 7 patch series "mm/damon: define and use DAMON initialization
  check function" from SeongJae Park implement reliability and
  maintainability improvements to a recently-added bug fix.

- The 2 patch series "mm/damon/stat: expose auto-tuned intervals and
  non-idle ages" from SeongJae Park provides additional transparency to
  userspace clients of the DAMON_STAT information.

- The 2 patch series "Expand scope of khugepaged anonymous collapse"
  from Dev Jain removes some constraints on khubepaged's collapsing of
  anon VMAs.  It also increases the success rate of MADV_COLLAPSE against
  an anon vma.

- The 2 patch series "mm: do not assume file == vma->vm_file in
  compat_vma_mmap_prepare()" from Lorenzo Stoakes moves us further towards
  removal of file_operations.mmap().  This patchset concentrates upon
  clearing up the treatment of stacked filesystems.

- The 6 patch series "mm: Improve mlock tracking for large folios" from
  Kiryl Shutsemau provides some fixes and improvements to mlock's tracking
  of large folios.  /proc/meminfo's "Mlocked" field became more accurate.

- The 2 patch series "mm/ksm: Fix incorrect accounting of KSM counters
  during fork" from Donet Tom fixes several user-visible KSM stats
  inaccuracies across forks and adds selftest code to verify these
  counters.

- The 2 patch series "mm_slot: fix the usage of mm_slot_entry" from Wei
  Yang addresses some potential but presently benign issues in KSM's
  mm_slot handling.

----------------------------------------------------------------
Aboorva Devarajan (3):
      selftests/mm: fix child process exit codes in ksm_functional_tests
      selftests/mm: skip thuge-gen test if system is not setup properly
      selftests/mm: skip hugepage-mremap test if userfaultfd unavailable

Adrian Huang (Lenovo) (1):
      mm: correct misleading comment on mmap_lock field in mm_struct

Alexandre Ghiti (2):
      selftests/damon: fix damon selftests by installing _common.sh
      riscv: use an atomic xchg in pudp_huge_get_and_clear()

Alice Ryhl (4):
      rust: maple_tree: add MapleTree
      rust: maple_tree: add lock guard for maple tree
      rust: maple_tree: add MapleTreeAlloc
      maple_tree: remove lockdep_map_p typedef

Alistair Popple (2):
      mm/gup: remove dead pgmap refcounting code
      mm/memremap: remove unused get_dev_pagemap() parameter

Andrew Morton (2):
      Merge branch 'mm-hotfixes-stable' into mm-stable in order to pick up changes required by mm-stable material: hugetlb and damon.
      include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines

Aristeu Rozanski (1):
      mm: make folio page count functions return unsigned

Bala-Vignesh-Reddy (1):
      selftests: centralise maybe-unused definition in kselftest.h

Baokun Li (1):
      tmpfs: preserve SB_I_VERSION on remount

Baolin Wang (3):
      mm: shmem: use 'folio' for shmem_partial_swap_usage()
      mm: shmem: drop the unnecessary folio_nr_pages()
      mm: shmem: fix the strategy for the tmpfs 'huge=' options

Bijan Tabatabai (1):
      mm/damon/core: skip needless update of damon_attrs in damon_commit_ctx()

Boris Burkov (3):
      mm/filemap: add AS_KERNEL_FILE
      mm: add vmstat for kernel_file pages
      btrfs: set AS_KERNEL_FILE on the btree_inode

Brendan Jackman (6):
      mm: remove is_migrate_highatomic()
      mm/page_alloc: harmonize should_compact_retry() type
      tools/include: implement a couple of atomic_t ops
      tools: testing: allow importing arch headers in shared.mk
      tools: testing: support EXTRA_CFLAGS in shared.mk
      tools: testing: use existing atomic.h for vma/maple tests

Brian Norris (1):
      mm: vm_event_item: explicit #include for THREAD_SIZE

Chanwon Park (1):
      mm: re-enable kswapd when memory pressure subsides or demotion is toggled

Charan Teja Kalla (1):
      mm: swap: check for stable address space before operating on the VMA

Chi Zhiling (4):
      mm/filemap: do not use is_partially_uptodate for entire folio
      mm/filemap: skip non-uptodate folio if there are available folios
      mpage: terminate read-ahead on read error
      mpage: convert do_mpage_readpage() to return void type

Chris Li (3):
      mm/swapfile.c: introduce function alloc_swap_scan_list()
      mm: swap.h: Remove deleted field from comments
      docs/mm: add document for swap table

Christoph Hellwig (4):
      mempool: rename struct mempool_s to struct mempool
      ntfs3: stop using write_cache_pages
      bcachefs: stop using write_cache_pages
      mm: remove write_cache_pages

Chunyu Hu (3):
      selftests/mm: fix hugepages cleanup too early
      selftests/mm: alloc hugepages in va_high_addr_switch test
      selftests/mm: fix va_high_addr_switch.sh failure on x86_64

Colin Ian King (1):
      selftests/mm: fix spelling mistake "mrmeap" -> "mremap"

David Hildenbrand (58):
      mm/migrate: remove MIGRATEPAGE_UNMAP
      treewide: remove MIGRATEPAGE_SUCCESS
      mm/huge_memory: move more common code into insert_pmd()
      mm/huge_memory: move more common code into insert_pud()
      mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
      fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio
      mm/huge_memory: mark PMD mappings of the huge zero folio special
      powerpc/ptdump: rename "struct pgtable_level" to "struct ptdump_pg_level"
      mm/rmap: convert "enum rmap_level" to "enum pgtable_level"
      mm/memory: convert print_bad_pte() to print_bad_page_map()
      mm/memory: factor out common code from vm_normal_page_*()
      mm: introduce and use vm_normal_page_pud()
      mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()
      prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
      mm/huge_memory: convert "tva_flags" to "enum tva_type"
      mm/huge_memory: respect MADV_COLLAPSE with PR_THP_DISABLE_EXCEPT_ADVISED
      mm: stop making SPARSEMEM_VMEMMAP user-selectable
      arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
      s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
      x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
      wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
      mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
      mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
      mm/hugetlb: check for unreasonable folio sizes when registering hstate
      mm/mm_init: make memmap_init_compound() look more like prep_compound_page()
      mm: sanity-check maximum folio size in folio_set_order()
      mm: limit folio/compound page sizes in problematic kernel configs
      mm: simplify folio_page() and folio_page_idx()
      mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
      mm/mm/percpu-km: drop nth_page() usage within single allocation
      fs: hugetlbfs: remove nth_page() usage within folio in adjust_range_hwpoison()
      fs: hugetlbfs: cleanup folio in adjust_range_hwpoison()
      mm/pagewalk: drop nth_page() usage within folio in folio_walk_start()
      mm/gup: drop nth_page() usage within folio when recording subpages
      mm/gup: remove record_subpages()
      io_uring/zcrx: remove nth_page() usage within folio
      mips: mm: convert __flush_dcache_pages() to __flush_dcache_folio_pages()
      mm/cma: refuse handing out non-contiguous page ranges
      dma-remap: drop nth_page() in dma_common_contiguous_remap()
      scatterlist: disallow non-contigous page ranges in a single SG entry
      ata: libata-sff: drop nth_page() usage within SG entry
      drm/i915/gem: drop nth_page() usage within SG entry
      mspro_block: drop nth_page() usage within SG entry
      memstick: drop nth_page() usage within SG entry
      mmc: drop nth_page() usage within SG entry
      scsi: scsi_lib: drop nth_page() usage within SG entry
      scsi: sg: drop nth_page() usage within SG entry
      vfio/pci: drop nth_page() usage within SG entry
      crypto: remove nth_page() usage within SG entry
      mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
      kfence: drop nth_page() usage
      block: update comment of "struct bio_vec" regarding nth_page()
      mm: remove nth_page()
      selftests/mm: split_huge_page_test: fix occasional is_backed_by_folio() wrong results
      selftests/mm: split_huge_page_test: cleanups for split_pte_mapped_thp test
      mm/gup: fix handling of errors from arch_make_folio_accessible() in follow_page_pte()
      selftests/mm: gup_tests: option to GUP all pages in a single call
      mm: convert folio_page() back to a macro

Deepanshu Kartikey (1):
      hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list

Dev Jain (5):
      selftests/mm/uffd-stress: make test operate on less hugetlb memory
      selftests/mm/uffd-stress: stricten constraint on free hugepages needed before the test
      mm: enable khugepaged anonymous collapse on non-writable regions
      mm: drop all references of writable and SCAN_PAGE_RO
      mm: remove PMD alignment constraint in execmem_vmalloc()

Donet Tom (8):
      mm/selftests: fix incorrect pointer being passed to mark_range()
      selftests/mm: add support to test 4PB VA on PPC64
      selftest/mm: fix ksm_funtional_test failures
      mm/selftests: fix split_huge_page_test failure on systems with 64KB page size
      drivers/base/node: handle error properly in register_one_node()
      drivers/base/node: fix double free in register_one_node()
      mm/ksm: fix incorrect KSM counter handling in mm_struct during fork
      selftests/mm: add fork inheritance test for ksm_merging_pages counter

Enze Li (2):
      selftests/damon/access_memory_even: remove unused header file
      mm/damon/Kconfig: make DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT

Francois Dugast (1):
      mm/hmm: populate PFNs from PMD swap entry

Hao Jia (1):
      mm/mglru: update MG-LRU proactive reclaim statistics only to memcg

Hugh Dickins (1):
      mm: lru_add_drain_all() do local lru_add_drain() first

Hui Zhu (1):
      rust: allocator: add KUnit tests for alignment guarantees

I Viswanath (1):
      selftests/mm: use calloc instead of malloc in pagemap_ioctl.c

Jackie Liu (1):
      mm/shmem: remove unused entry_order after large swapin rework

Jan Kara (1):
      readahead: add trace points

Jann Horn (1):
      kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping

Jinjiang Tu (1):
      filemap: optimize folio refount update in filemap_map_pages

Joey Pabalinas (1):
      mm/memfd: remove redundant casts

Johannes Weiner (4):
      mm: zswap: interact directly with zsmalloc
      mm: remove unused zpool layer
      mm: zpdesc: minor naming and comment corrections
      mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions

Joshua Hahn (1):
      mempolicy: clarify what zone reclaim means

Kairui Song (20):
      mm, swap: only scan one cluster in fragment list
      mm, swap: remove fragment clusters counter
      mm, swap: prefer nonfull over free clusters
      mm/mincore, swap: consolidate swap cache checking for mincore
      mm/mincore: use a helper for checking the swap cache
      mm/page-writeback: drop usage of folio_index
      mm, swap: use unified helper for swap cache look up
      mm, swap: fix swap cache index error when retrying reclaim
      mm, swap: check page poison flag after locking it
      mm, swap: always lock and check the swap cache folio before use
      mm, swap: rename and move some swap cluster definition and helpers
      mm, swap: tidy up swap device and cluster info helpers
      mm, swap: cleanup swap cache API and add kerneldoc
      mm/shmem, swap: remove redundant error handling for replacing folio
      mm, swap: wrap swap cache replacement with a helper
      mm, swap: use the swap table for the swap cache and switch API
      mm, swap: mark swap address space ro and add context debug check
      mm, swap: remove contention workaround for swap cache
      mm, swap: implement dynamic allocation of swap table
      mm, swap: use a single page for swap table when the size fits

Kaushlendra Kumar (1):
      tools/mm/slabinfo: fix access to null terminator in string boundary

Kefeng Wang (5):
      mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
      mm: hugetlb: convert to account_new_hugetlb_folio()
      mm: hugetlb: directly pass order when allocate a hugetlb folio
      mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
      mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()

Kiryl Shutsemau (7):
      mm/khugepaged: do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL
      mm/page_vma_mapped: track if the page is mapped across page table boundary
      mm/rmap: fix a mlock race condition in folio_referenced_one()
      mm/rmap: mlock large folios in try_to_unmap_one()
      mm/fault: try to map the entire file folio in finish_fault()
      mm/filemap: map entire large folio faultaround
      mm/rmap: improve mlock tracking for large folios

Lance Yang (3):
      mm: skip mlocked THPs that are underused early in deferred_split_scan()
      selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
      mm: silence data-race in update_hiwater_rss

Li RongQing (2):
      mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0
      mm/hugetlb: retry to allocate for early boot hugepage allocation

Li Zhe (1):
      hugetlb: increase number of reserving hugepages via cmdline

Liam R. Howlett (2):
      maple_tree: fix testing for 32 bit builds
      maple_tree: testing fix for spanning store on 32b

Liao Yuanhong (1):
      lib/test_maple_tree.c: remove redundant semicolons

Lokesh Gidra (1):
      userfaultfd: opportunistic TLB-flush batching for present pages in MOVE

Lorenzo Stoakes (13):
      mm: add bitmap mm->flags field
      mm: convert core mm to mm_flags_*() accessors
      mm: convert prctl to mm_flags_*() accessors
      mm: convert arch-specific code to mm_flags_*() accessors
      mm: convert uprobes to mm_flags_*() accessors
      mm: update coredump logic to correctly use bitmap mm flags
      mm: correct sign-extension issue in MMF_* flag masks
      mm: update fork mm->flags initialisation to use bitmap
      mm: convert remaining users to mm_flags_*() accessors
      mm: replace mm->flags with bitmap entirely and set to 64 bits
      mm: specify separate file and vm_file params in vm_area_desc
      mm: do not assume file == vma->vm_file in compat_vma_mmap_prepare()
      mm/oom_kill.c: fix inverted check

Manish Kumar (1):
      mm/memory_hotplug: fix typo 'esecially' -> 'especially'

Matthew Wilcox (Oracle) (19):
      mm: introduce memdesc_flags_t
      mm: convert page_to_section() to memdesc_section()
      mm: introduce memdesc_nid()
      mm: introduce memdesc_zonenum()
      slab: use memdesc_flags_t
      slab: use memdesc_nid()
      mm: introduce memdesc_is_zone_device()
      mm: reimplement folio_is_device_private()
      mm: reimplement folio_is_device_coherent()
      mm: reimplement folio_is_fsdax()
      mm: add folio_is_pci_p2pdma()
      mm: remove mlock_count from struct page
      ptdesc: convert __page_flags to pt_flags
      ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()
      ptdesc: remove ptdesc_to_virt()
      mm: constify compound_order() and page_size()
      mm: remove redundant test in validate_page_before_insert()
      mm: remove page->order
      ksm: use a folio inside cmp_and_merge_page()

Matthieu Baerts (NGI0) (3):
      scripts/decode_stacktrace.sh: symbol: avoid trailing whitespaces
      scripts/decode_stacktrace.sh: symbol: preserve alignment
      scripts/decode_stacktrace.sh: code: preserve alignment

Max Kellermann (14):
      pagevec.h: add `const` to pointer parameters of getter functions
      huge_mm.h: disallow is_huge_zero_folio(NULL)
      mm: constify shmem related test functions for improved const-correctness
      mm: constify pagemap related test/getter functions
      mm: constify zone related test/getter functions
      fs: constify mapping related test functions for improved const-correctness
      mm: constify process_shares_mm() for improved const-correctness
      mm, s390: constify mapping related test/getter functions
      parisc: constify mmap_upper_limit() parameter
      mm: constify arch_pick_mmap_layout() for improved const-correctness
      mm: constify ptdesc_pmd_pts_count() and folio_get_private()
      mm: constify various inline functions for improved const-correctness
      mm: constify assert/test functions in mm.h
      mm: constify highmem related functions for improved const-correctness

Miaohe Lin (2):
      Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
      mm/hwpoison: decouple hwpoison_filter from mm/memory-failure.c

Mike Rapoport (Microsoft) (3):
      kho: allow scratch areas with zero size
      lib/test_kho: fixes for error handling
      selftest/kho: update generation of initrd

Muhammad Usama Anjum (3):
      selftests/mm: centralize the __always_unused macro
      selftests/mm: add -Wunreachable-code and fix warnings
      selftests/mm: protection_keys: fix dead code

Nhat Pham (1):
      mm/zswap: reduce the size of the compression buffer to a single page

Pankaj Raghav (6):
      mm: rename huge_zero_page to huge_zero_folio
      mm: rename MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO
      mm: add persistent huge zero folio
      mm: add largest_zero_folio() routine
      block: use largest_zero_folio in __blkdev_issue_zero_pages()
      huge_memory: return -EINVAL in folio split functions when THP is disabled

Pasha Tatashin (2):
      fork: check charging success before zeroing stack
      task_stack.h: clean-up stack_not_used() implementation

Pranav Tyagi (1):
      selftests/mm: use __auto_type in swap() macro

Pratyush Yadav (3):
      kho: make sure kho_scratch argument is fully consumed
      kho: move sanity checks to kho_restore_page()
      kho: make sure page being restored is actually from KHO

Qianfeng Rong (2):
      xarray: remove redundant __GFP_NOWARN
      mm: remove redundant __GFP_NOWARN

Quanmin Yan (3):
      mm/damon: add damon_ctx->min_sz_region
      mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT
      mm/damon/reclaim: support addr_unit for DAMON_RECLAIM

Ran Xiaokai (1):
      alloc_tag: fix boot failure due to NULL pointer dereference

Roman Gushchin (1):
      mm: readahead: improve mmap_miss heuristic for concurrent faults

Ruan Shiyang (1):
      mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting

Sabyrzhan Tasbolatov (2):
      kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
      kasan: call kasan_init_generic in kasan_init

Sang-Heon Jeon (4):
      mm/damon: update expired description of damos_action
      docs/mm/damon/design: fix typo: s/sz_trtied/sz_tried/
      selftests/damon: test no-op commit broke DAMON status
      mm/damon/tests/core-kunit: add damos_commit_filter test

SeongJae Park (27):
      mm/zswap: store <PAGE_SIZE compression failed page as-is
      mm/damon/core: add damon_ctx->addr_unit
      mm/damon/paddr: support addr_unit for access monitoring
      mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
      mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
      mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
      mm/damon/paddr: support addr_unit for DAMOS_STAT
      mm/damon/sysfs: implement addr_unit file under context dir
      Docs/mm/damon/design: document 'address unit' parameter
      Docs/admin-guide/mm/damon/usage: document addr_unit file
      Docs/ABI/damon: document addr_unit file
      mm/damon/lru_sort: use param_ctx for damon_attrs staging
      mm/damon/core: reset age if nr_accesses changes between non-zero and zero
      mm/damon/core: set effective quota on first charge window
      Docs/mm/damon/maintainer-profile: update community meetup for reservation requirements
      Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example command
      MAINTAINERS: rename DAMON section
      mm/damon/core: implement damon_initialized() function
      mm/damon/stat: use damon_initialized()
      mm/damon/reclaim: use damon_initialized()
      mm/damon/lru_sort: use damon_initialized()
      samples/damon/wsse: use damon_initialized()
      samples/damon/prcl: use damon_initialized()
      samples/damon/mtier: use damon_initialized()
      mm/damon/stat: expose the current tuned aggregation interval
      mm/damon/stat: expose negative idle time
      mm/damon/sysfs: set damon_ctx->min_sz_region only for paddr use case

Sergey Senozhatsky (1):
      zram: protect recomp_algorithm_show() with ->init_lock

Shankari Anand (1):
      rust: mm: update ARef and AlwaysRefCounted imports from sync::aref

Sidhartha Kumar (2):
      mm/nommu: convert kobjsize() to folios
      maple_tree: fix MAPLE_PARENT_RANGE32 and parent pointer docs

Stanislav Fort (1):
      mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control

Steven Rostedt (1):
      mm, x86/mm: move creating the tlb_flush event back to x86 code

Sudarsan Mahendran (1):
      selftests/mm: pass filename as input param to VM_PFNMAP tests

Sumanth Korikkar (1):
      resource: improve child resource handling in release_mem_region_adjustable()

Suren Baghdasaryan (9):
      mm: limit the scope of vma_start_read()
      mm: change vma_start_read() to drop RCU lock on failure
      selftests/proc: test PROCMAP_QUERY ioctl while vma is concurrently modified
      fs/proc/task_mmu: factor out proc_maps_private fields used by PROCMAP_QUERY
      fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks
      alloc_tag: use release_pages() in the cleanup path
      alloc_tag: prevent enabling memory profiling if it was shut down
      alloc_tag: avoid warnings when freeing non-compound "tail" pages
      alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output

Thadeu Lima de Souza Cascardo (2):
      mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH allocations
      mm: show_mem: show number of zspages in show_free_areas

Thomas Gleixner (1):
      memcg: optimize exit to user space

Ujwal Kundur (1):
      selftests/mm/uffd: refactor non-composite global vars into struct

Uladzislau Rezki (Sony) (1):
      mm/vmalloc: move resched point into alloc_vmap_area()

Usama Arif (5):
      docs: transhuge: document process level THP controls
      selftest/mm: extract sz2ord function into vm_util.h
      selftests: prctl: introduce tests for disabling THPs completely
      selftests: prctl: introduce tests for disabling THPs except for madvise
      mm/huge_memory: remove enforce_sysfs from __thp_vma_allowable_orders

Vishal Moola (Oracle) (7):
      mm/page_alloc: add kernel-docs for free_pages()
      aoe: stop calling page_address() in free_page()
      x86: stop calling page_address() in free_pages()
      riscv: stop calling page_address() in free_pages()
      powerpc: stop calling page_address() in free_pages()
      arm64: stop calling page_address() in free_pages()
      virtio_balloon: stop calling page_address() in free_pages()

Vitaly Wool (4):
      mm/vmalloc: allow to set node and align in vrealloc
      mm/slub: allow to set node and align in k[v]realloc
      rust: add support for NUMA ids in allocations
      rust: support large alignments in allocations

Wander Lairson Costa (1):
      kmem/tracing: add kmem name to kmem_cache_alloc tracepoint

Wei Yang (15):
      mm/rmap: do __folio_mod_stat() in __folio_add_rmap()
      selftests/mm: do check_huge_anon() with a number been passed in
      selftests/mm: put general ksm operation into vm_util
      selftests/mm: test that rmap behaves as expected
      mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
      mm/rmap: use folio_large_nr_pages() when we are sure it is a large folio
      mm/khugepaged: use list_xxx() helper to improve readability
      mm/page_alloc: use xxx_pageblock_isolate() for better reading
      mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end
      mm/page_alloc: find_large_buddy() from start_pfn aligned order
      mm/page_alloc: check the correct buddy if it is a starting block
      mm/compaction: fix low_pfn advance on isolating hugetlb
      mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL
      mm/khugepaged: remove definition of struct khugepaged_mm_slot
      mm/khugepaged: use start_addr/addr for improved readability

Xichao Zhao (2):
      mm/kasan/init.c: remove unnecessary pointer variables
      lib/test_hmm: drop redundant conversion to bool

Xie Yuanbin (1):
      mm/memory-failure: don't select MEMORY_ISOLATION

Ye Liu (4):
      mm: replace (20 - PAGE_SHIFT) with common macros for pages<->MB conversion
      mm/page_alloc: simplify lowmem_reserve max calculation
      mm: fix typos in VMA comments
      mm/page_alloc: remove redundant pcp->free_count initialization in per_cpu_pages_init()

Yeoreum Yun (2):
      kasan/hw-tags: introduce kasan.write_only option
      kasan: apply write-only mode in kasan kunit testcases

Youling Tang (1):
      mm/filemap: align last_index to folio size

Yueyang Pan (4):
      mm/damon/paddr: move filters existence check function to ops-common
      mm/damon/vaddr: support stat-purpose DAMOS filters
      mm/show_mem: dump the status of the mem alloc profiling before printing
      mm/show_mem: add trylock while printing alloc info

Zach O'Keefe (1):
      selftests/mm: remove PROT_EXEC req from file-collapse tests

Zhang Qilong (1):
      /dev/zero: try to align PMD_SIZE for private mapping

Zi Yan (5):
      mm/huge_memory: add new_order and offset to split_huge_pages*() pr_debug
      selftests/mm: mark all functions static in split_huge_page_test.c
      selftests/mm: reimplement is_backed_by_thp() with more precise check
      selftests/mm: add check_after_split_folio_orders() helper
      selftests/mm: check after-split folio orders in split_huge_page_test

ally heev (1):
      kselftest: mm: fix typos in test_vmalloc.sh

gaoxiang17 (1):
      mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start

liuqiqi (1):
      mm: fix duplicate accounting of free pages in should_reclaim_retry()

zhang jiao (1):
      samples/cgroup: rm unused MEMCG_EVENTS macro

zhongjinji (2):
      mm/oom_kill: thaw the entire OOM victim process
      mm/oom_kill: the OOM reaper traverses the VMA maple tree in reverse order

 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   7 +
 Documentation/admin-guide/mm/damon/start.rst       |   2 +-
 Documentation/admin-guide/mm/damon/usage.rst       |  11 +-
 Documentation/admin-guide/mm/transhuge.rst         |  42 +-
 Documentation/admin-guide/mm/zswap.rst             |  33 +-
 Documentation/core-api/mm-api.rst                  |   1 -
 Documentation/dev-tools/kasan.rst                  |   3 +
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst |   2 -
 Documentation/filesystems/proc.rst                 |  18 +-
 Documentation/mm/damon/design.rst                  |  18 +-
 Documentation/mm/damon/maintainer-profile.rst      |  17 +-
 Documentation/mm/index.rst                         |   1 +
 Documentation/mm/swap-table.rst                    |  69 +++
 MAINTAINERS                                        |  11 +-
 arch/arc/include/asm/arcregs.h                     |   3 -
 arch/arc/mm/cache.c                                |   8 +-
 arch/arc/mm/tlb.c                                  |   2 +-
 arch/arm/include/asm/highmem.h                     |   6 +-
 arch/arm/include/asm/hugetlb.h                     |   2 +-
 arch/arm/mm/copypage-v4mc.c                        |   2 +-
 arch/arm/mm/copypage-v6.c                          |   2 +-
 arch/arm/mm/copypage-xscale.c                      |   2 +-
 arch/arm/mm/dma-mapping.c                          |   2 +-
 arch/arm/mm/fault-armv.c                           |   2 +-
 arch/arm/mm/flush.c                                |  10 +-
 arch/arm/mm/kasan_init.c                           |   2 +-
 arch/arm/mm/mmu.c                                  |   2 +-
 arch/arm64/Kconfig                                 |   1 -
 arch/arm64/include/asm/hugetlb.h                   |   6 +-
 arch/arm64/include/asm/memory.h                    |   1 +
 arch/arm64/include/asm/mte-kasan.h                 |   6 +
 arch/arm64/include/asm/mte.h                       |  16 +-
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kernel/mte.c                            |  18 +
 arch/arm64/mm/flush.c                              |   8 +-
 arch/arm64/mm/kasan_init.c                         |   4 +-
 arch/arm64/mm/mmu.c                                |   2 +-
 arch/csky/abiv1/cacheflush.c                       |   6 +-
 arch/loongarch/Kconfig                             |   1 +
 arch/loongarch/configs/loongson3_defconfig         |   1 -
 arch/loongarch/include/asm/kasan.h                 |   7 -
 arch/loongarch/mm/kasan_init.c                     |   8 +-
 arch/mips/include/asm/cacheflush.h                 |  17 +-
 arch/mips/mm/cache.c                               |   8 +-
 arch/nios2/mm/cacheflush.c                         |   6 +-
 arch/openrisc/include/asm/cacheflush.h             |   2 +-
 arch/openrisc/mm/cache.c                           |   2 +-
 arch/parisc/include/asm/processor.h                |   2 +-
 arch/parisc/kernel/cache.c                         |   6 +-
 arch/parisc/kernel/sys_parisc.c                    |   2 +-
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/include/asm/cacheflush.h              |   4 +-
 arch/powerpc/include/asm/kasan.h                   |  12 -
 arch/powerpc/include/asm/kvm_ppc.h                 |   4 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |   4 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   2 +-
 arch/powerpc/mm/kasan/init_32.c                    |   2 +-
 arch/powerpc/mm/kasan/init_book3e_64.c             |   2 +-
 arch/powerpc/mm/kasan/init_book3s_64.c             |   6 +-
 arch/powerpc/mm/pgtable.c                          |  12 +-
 arch/powerpc/mm/ptdump/8xx.c                       |   2 +-
 arch/powerpc/mm/ptdump/book3s64.c                  |   2 +-
 arch/powerpc/mm/ptdump/ptdump.h                    |   4 +-
 arch/powerpc/mm/ptdump/shared.c                    |   2 +-
 arch/powerpc/platforms/pseries/cmm.c               |   2 +-
 arch/riscv/include/asm/cacheflush.h                |   4 +-
 arch/riscv/include/asm/hugetlb.h                   |   2 +-
 arch/riscv/include/asm/pgtable.h                   |  11 +
 arch/riscv/mm/cacheflush.c                         |   4 +-
 arch/riscv/mm/init.c                               |   4 +-
 arch/riscv/mm/kasan_init.c                         |   1 +
 arch/s390/Kconfig                                  |   1 -
 arch/s390/include/asm/hugetlb.h                    |   2 +-
 arch/s390/kernel/early.c                           |   3 +-
 arch/s390/kernel/uv.c                              |  12 +-
 arch/s390/mm/gmap.c                                |   2 +-
 arch/s390/mm/hugetlbpage.c                         |   2 +-
 arch/s390/mm/mmap.c                                |  10 +-
 arch/s390/mm/pgalloc.c                             |   6 +-
 arch/sh/include/asm/hugetlb.h                      |   2 +-
 arch/sh/mm/cache-sh4.c                             |   2 +-
 arch/sh/mm/cache-sh7705.c                          |   2 +-
 arch/sh/mm/cache.c                                 |  14 +-
 arch/sh/mm/kmap.c                                  |   2 +-
 arch/sparc/kernel/sys_sparc_64.c                   |   6 +-
 arch/sparc/mm/init_64.c                            |  10 +-
 arch/um/Kconfig                                    |   1 +
 arch/um/include/asm/kasan.h                        |   5 +-
 arch/um/kernel/mem.c                               |  13 +-
 arch/x86/Kconfig                                   |   1 -
 arch/x86/mm/init.c                                 |   1 +
 arch/x86/mm/init_64.c                              |   2 +-
 arch/x86/mm/kasan_init_64.c                        |   2 +-
 arch/x86/mm/mmap.c                                 |  10 +-
 arch/x86/mm/pat/memtype.c                          |   6 +-
 arch/x86/platform/efi/memmap.c                     |   2 +-
 arch/xtensa/include/asm/highmem.h                  |   2 +-
 arch/xtensa/mm/cache.c                             |  12 +-
 arch/xtensa/mm/kasan_init.c                        |   2 +-
 block/blk-lib.c                                    |  15 +-
 crypto/ahash.c                                     |   4 +-
 crypto/scompress.c                                 |   8 +-
 drivers/ata/libata-sff.c                           |   6 +-
 drivers/base/node.c                                |   4 +
 drivers/block/aoe/aoecmd.c                         |   2 +-
 drivers/block/zram/zram_drv.c                      |  23 +-
 drivers/char/mem.c                                 |  21 +-
 drivers/gpu/drm/drm_gem.c                          |   4 +-
 drivers/gpu/drm/i915/gem/i915_gem_pages.c          |   2 +-
 drivers/memstick/core/mspro_block.c                |   3 +-
 drivers/memstick/host/jmb38x_ms.c                  |   3 +-
 drivers/memstick/host/tifm_ms.c                    |   3 +-
 drivers/misc/vmw_balloon.c                         |   4 +-
 drivers/mmc/host/tifm_sd.c                         |   4 +-
 drivers/mmc/host/usdhi6rol0.c                      |   4 +-
 drivers/scsi/scsi_lib.c                            |   3 +-
 drivers/scsi/sg.c                                  |   3 +-
 drivers/vfio/pci/pds/lm.c                          |   3 +-
 drivers/vfio/pci/virtio/migrate.c                  |   3 +-
 drivers/virtio/virtio_balloon.c                    |  10 +-
 drivers/xen/Kconfig                                |   1 +
 drivers/xen/gntdev.c                               |   5 +-
 fs/Kconfig                                         |   1 -
 fs/aio.c                                           |   2 +-
 fs/bcachefs/darray.c                               |   2 +-
 fs/bcachefs/fs-io-buffered.c                       |  13 +-
 fs/bcachefs/util.h                                 |   2 +-
 fs/btrfs/disk-io.c                                 |   1 +
 fs/btrfs/inode.c                                   |   4 +-
 fs/coredump.c                                      |   4 +-
 fs/dax.c                                           |  47 +-
 fs/exec.c                                          |   2 +-
 fs/fuse/dev.c                                      |   2 +-
 fs/gfs2/glops.c                                    |   2 +-
 fs/hugetlbfs/inode.c                               |  49 +-
 fs/jffs2/file.c                                    |   4 +-
 fs/jfs/jfs_metapage.c                              |   8 +-
 fs/mpage.c                                         |  14 +-
 fs/nilfs2/page.c                                   |   2 +-
 fs/ntfs3/inode.c                                   |  15 +-
 fs/pidfs.c                                         |   7 +-
 fs/proc/array.c                                    |   2 +-
 fs/proc/base.c                                     |  12 +-
 fs/proc/internal.h                                 |  15 +-
 fs/proc/page.c                                     |   5 +-
 fs/proc/task_mmu.c                                 | 190 ++++--
 fs/proc/task_nommu.c                               |  14 +-
 fs/ubifs/file.c                                    |   6 +-
 include/asm-generic/memory_model.h                 |   2 +-
 include/crypto/scatterwalk.h                       |   4 +-
 include/linux/alloc_tag.h                          |  12 +
 include/linux/blkdev.h                             |   2 +-
 include/linux/bpfptr.h                             |   2 +-
 include/linux/bvec.h                               |   7 +-
 include/linux/codetag.h                            |   5 +-
 include/linux/damon.h                              |  18 +-
 include/linux/freezer.h                            |   2 +
 include/linux/fs.h                                 |   8 +-
 include/linux/highmem-internal.h                   |  36 +-
 include/linux/highmem.h                            |   8 +-
 include/linux/huge_mm.h                            | 112 +++-
 include/linux/hugetlb.h                            |   7 +-
 include/linux/kasan-enabled.h                      |  32 +-
 include/linux/kasan.h                              |   6 +
 include/linux/khugepaged.h                         |   6 +-
 include/linux/ksm.h                                |  12 +-
 include/linux/maple_tree.h                         |  27 +-
 include/linux/memcontrol.h                         |  10 +-
 include/linux/mempool.h                            |   2 +-
 include/linux/memremap.h                           |  45 +-
 include/linux/migrate.h                            |  11 +-
 include/linux/mm.h                                 | 273 ++++++---
 include/linux/mm_inline.h                          |  37 +-
 include/linux/mm_types.h                           | 136 +++--
 include/linux/mman.h                               |   2 +-
 include/linux/mmap_lock.h                          |  85 ---
 include/linux/mmzone.h                             |  91 +--
 include/linux/netfs.h                              |   2 +-
 include/linux/oom.h                                |   2 +-
 include/linux/page-flags.h                         |  42 +-
 include/linux/pageblock-flags.h                    |  12 +-
 include/linux/pagemap.h                            |  65 ++-
 include/linux/pagevec.h                            |   4 +-
 include/linux/pgalloc_tag.h                        |   7 +-
 include/linux/pgtable.h                            |  32 +-
 include/linux/rmap.h                               |  67 ++-
 include/linux/scatterlist.h                        |   3 +-
 include/linux/sched/coredump.h                     |  18 +-
 include/linux/sched/mm.h                           |   4 +-
 include/linux/shmem_fs.h                           |   4 +-
 include/linux/slab.h                               |  39 +-
 include/linux/swap.h                               |  50 +-
 include/linux/vm_event_item.h                      |   2 +
 include/linux/vmalloc.h                            |  12 +-
 include/linux/writeback.h                          |   6 -
 include/linux/zpool.h                              |  86 ---
 include/trace/events/cma.h                         |  19 +-
 include/trace/events/huge_memory.h                 |  19 +-
 include/trace/events/kmem.h                        |   5 +-
 include/trace/events/page_ref.h                    |   4 +-
 include/trace/events/readahead.h                   | 132 +++++
 include/uapi/linux/mempolicy.h                     |  12 +-
 include/uapi/linux/prctl.h                         |  10 +
 io_uring/zcrx.c                                    |   4 +-
 kernel/dma/remap.c                                 |   2 +-
 kernel/events/uprobes.c                            |  32 +-
 kernel/exit.c                                      |  23 +-
 kernel/fork.c                                      |  19 +-
 kernel/freezer.c                                   |  20 +-
 kernel/kexec_handover.c                            |  72 ++-
 kernel/rcu/rcuscale.c                              |   2 +-
 kernel/resource.c                                  |  50 +-
 kernel/sched/fair.c                                |  10 +-
 kernel/sys.c                                       |  69 ++-
 lib/Kconfig.kasan                                  |  12 +
 lib/alloc_tag.c                                    |  30 +-
 lib/maple_tree.c                                   |  12 +-
 lib/rhashtable.c                                   |   4 +-
 lib/test_hmm.c                                     |   2 +-
 lib/test_kho.c                                     |  52 +-
 lib/test_maple_tree.c                              |   2 +-
 lib/xarray.c                                       |   2 +-
 mm/Kconfig                                         |  71 +--
 mm/Makefile                                        |   1 -
 mm/backing-dev.c                                   |   2 +-
 mm/cma.c                                           |  41 +-
 mm/compaction.c                                    |   2 +-
 mm/damon/Kconfig                                   |   2 +-
 mm/damon/core.c                                    | 111 ++--
 mm/damon/lru_sort.c                                |  51 +-
 mm/damon/ops-common.c                              |  11 +-
 mm/damon/ops-common.h                              |   2 +
 mm/damon/paddr.c                                   | 130 +++--
 mm/damon/reclaim.c                                 |  49 +-
 mm/damon/stat.c                                    |  26 +-
 mm/damon/sysfs.c                                   |  44 +-
 mm/damon/tests/core-kunit.h                        |  38 +-
 mm/damon/tests/vaddr-kunit.h                       |   2 +-
 mm/damon/vaddr.c                                   | 105 +++-
 mm/debug.c                                         |   4 +-
 mm/execmem.c                                       |   3 -
 mm/filemap.c                                       |  89 ++-
 mm/gup.c                                           | 126 ++--
 mm/highmem.c                                       |  10 +-
 mm/hmm.c                                           |  70 ++-
 mm/huge_memory.c                                   | 246 ++++----
 mm/hugetlb.c                                       | 169 +++---
 mm/hugetlb_cma.c                                   |   3 +-
 mm/hugetlb_cma.h                                   |   6 +-
 mm/hwpoison-inject.c                               |  91 +++
 mm/internal.h                                      |  22 +-
 mm/kasan/common.c                                  |  17 +-
 mm/kasan/generic.c                                 |  19 +-
 mm/kasan/hw_tags.c                                 |  54 +-
 mm/kasan/init.c                                    |   4 +-
 mm/kasan/kasan.h                                   |  15 +-
 mm/kasan/kasan_test_c.c                            | 245 +++++---
 mm/kasan/shadow.c                                  |  12 +-
 mm/kasan/sw_tags.c                                 |   1 +
 mm/kasan/tags.c                                    |   2 +-
 mm/kfence/core.c                                   |  12 +-
 mm/khugepaged.c                                    | 176 +++---
 mm/ksm.c                                           |  67 ++-
 mm/memcontrol-v1.c                                 |   8 +-
 mm/memcontrol.c                                    |   8 +-
 mm/memfd.c                                         |   4 +-
 mm/memory-failure.c                                | 122 +---
 mm/memory-tiers.c                                  |  12 +
 mm/memory.c                                        | 391 ++++++++-----
 mm/memory_hotplug.c                                |   4 +-
 mm/memremap.c                                      |  25 +-
 mm/migrate.c                                       | 113 ++--
 mm/migrate_device.c                                |   2 +-
 mm/mincore.c                                       |  70 ++-
 mm/mm_init.c                                       |  15 +-
 mm/mmap.c                                          |  10 +-
 mm/mmap_lock.c                                     | 109 +++-
 mm/mmu_gather.c                                    |   4 +-
 mm/mmzone.c                                        |   4 +-
 mm/nommu.c                                         |  17 +-
 mm/oom_kill.c                                      |  52 +-
 mm/page-writeback.c                                |  46 +-
 mm/page_alloc.c                                    | 157 +++--
 mm/page_io.c                                       |  12 +-
 mm/page_vma_mapped.c                               |   1 +
 mm/pagewalk.c                                      |  22 +-
 mm/percpu-km.c                                     |   2 +-
 mm/readahead.c                                     |   8 +
 mm/rmap.c                                          | 235 ++++----
 mm/shmem.c                                         | 139 ++---
 mm/show_mem.c                                      |  17 +-
 mm/slab.h                                          |   6 +-
 mm/slub.c                                          |  97 ++-
 mm/sparse.c                                        |   6 +-
 mm/swap.c                                          |  13 +-
 mm/swap.h                                          | 321 ++++++++--
 mm/swap_state.c                                    | 488 ++++++++--------
 mm/swap_table.h                                    | 130 +++++
 mm/swapfile.c                                      | 566 +++++++++++-------
 mm/userfaultfd.c                                   | 227 +++++---
 mm/util.c                                          | 110 +++-
 mm/vma.c                                           |   5 +-
 mm/vma.h                                           |  30 +-
 mm/vma_init.c                                      |   2 +-
 mm/vmalloc.c                                       |  39 +-
 mm/vmscan.c                                        |  65 ++-
 mm/vmstat.c                                        |   4 +-
 mm/workingset.c                                    |   2 +-
 mm/zpdesc.h                                        |  14 +-
 mm/zpool.c                                         | 328 -----------
 mm/zsmalloc.c                                      |  83 +--
 mm/zswap.c                                         | 269 ++++-----
 rust/helpers/helpers.c                             |   1 +
 rust/helpers/maple_tree.c                          |   8 +
 rust/helpers/slab.c                                |  10 +-
 rust/helpers/vmalloc.c                             |   5 +-
 rust/kernel/alloc.rs                               |  54 +-
 rust/kernel/alloc/allocator.rs                     | 105 +++-
 rust/kernel/alloc/allocator_test.rs                |   3 +-
 rust/kernel/alloc/kbox.rs                          |   4 +-
 rust/kernel/alloc/kvec.rs                          |  11 +-
 rust/kernel/lib.rs                                 |   1 +
 rust/kernel/maple_tree.rs                          | 647 +++++++++++++++++++++
 rust/kernel/mm.rs                                  |   3 +-
 rust/kernel/mm/mmput_async.rs                      |   2 +-
 samples/cgroup/memcg_event_listener.c              |   2 -
 samples/damon/mtier.c                              |  11 +-
 samples/damon/prcl.c                               |  11 +-
 samples/damon/wsse.c                               |  15 +-
 scripts/decode_stacktrace.sh                       |  35 +-
 tools/include/linux/atomic.h                       |  22 +
 tools/mm/slabinfo.c                                |   7 +-
 tools/testing/radix-tree/maple.c                   |  10 +-
 tools/testing/scatterlist/linux/mm.h               |   1 -
 tools/testing/selftests/damon/Makefile             |   2 +
 tools/testing/selftests/damon/access_memory_even.c |   1 -
 .../selftests/damon/sysfs_no_op_commit_break.py    |  72 +++
 tools/testing/selftests/kho/init.c                 |  13 +-
 tools/testing/selftests/kho/vmtest.sh              |  28 +-
 tools/testing/selftests/kselftest.h                |   8 +
 tools/testing/selftests/landlock/audit.h           |   6 +-
 tools/testing/selftests/landlock/common.h          |   4 -
 tools/testing/selftests/mm/.gitignore              |   2 +
 tools/testing/selftests/mm/Makefile                |   5 +
 tools/testing/selftests/mm/cow.c                   |  13 +-
 tools/testing/selftests/mm/gup_test.c              |   2 +
 tools/testing/selftests/mm/hmm-tests.c             |   5 +-
 tools/testing/selftests/mm/hugepage-mremap.c       |  16 +-
 tools/testing/selftests/mm/khugepaged.c            |   2 +-
 tools/testing/selftests/mm/ksm_functional_tests.c  | 199 +++----
 tools/testing/selftests/mm/madv_populate.c         |  21 +-
 tools/testing/selftests/mm/mremap_test.c           |   6 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  24 +-
 tools/testing/selftests/mm/pfnmap.c                |  48 +-
 tools/testing/selftests/mm/pkey-helpers.h          |   3 -
 tools/testing/selftests/mm/pkey_sighandler_tests.c |   2 +-
 tools/testing/selftests/mm/prctl_thp_disable.c     | 291 +++++++++
 tools/testing/selftests/mm/protection_keys.c       |   6 +-
 tools/testing/selftests/mm/rmap.c                  | 433 ++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh          |  31 +-
 tools/testing/selftests/mm/soft-dirty.c            |   5 +-
 tools/testing/selftests/mm/split_huge_page_test.c  | 469 +++++++++++----
 tools/testing/selftests/mm/test_vmalloc.sh         |   6 +-
 tools/testing/selftests/mm/thp_settings.c          |   9 +-
 tools/testing/selftests/mm/thp_settings.h          |   1 +
 tools/testing/selftests/mm/thuge-gen.c             |  11 +-
 tools/testing/selftests/mm/uffd-common.c           | 271 +++++----
 tools/testing/selftests/mm/uffd-common.h           |  78 +--
 tools/testing/selftests/mm/uffd-stress.c           | 243 ++++----
 tools/testing/selftests/mm/uffd-unit-tests.c       | 559 +++++++++---------
 tools/testing/selftests/mm/uffd-wp-mremap.c        |  29 +-
 tools/testing/selftests/mm/va_high_addr_switch.c   |   4 +-
 tools/testing/selftests/mm/va_high_addr_switch.sh  |  37 ++
 tools/testing/selftests/mm/virtual_address_range.c |  13 +-
 tools/testing/selftests/mm/vm_util.c               | 167 +++++-
 tools/testing/selftests/mm/vm_util.h               |  18 +
 tools/testing/selftests/net/ovpn/ovpn-cli.c        |   3 +-
 tools/testing/selftests/net/psock_lib.h            |   4 -
 .../selftests/perf_events/watermark_signal.c       |   2 -
 tools/testing/selftests/proc/proc-maps-race.c      |  65 +++
 tools/testing/selftests/ublk/utils.h               |   2 -
 .../testing/selftests/wireguard/qemu/kernel.config |   1 -
 tools/testing/selftests/zram/README                |   1 -
 tools/testing/shared/linux/maple_tree.h            |   6 +-
 tools/testing/shared/shared.mk                     |   6 +-
 tools/testing/vma/linux/atomic.h                   |  17 -
 tools/testing/vma/vma_internal.h                   |  85 ++-
 387 files changed, 9103 insertions(+), 5059 deletions(-)
 create mode 100644 Documentation/mm/swap-table.rst
 delete mode 100644 include/linux/zpool.h
 create mode 100644 include/trace/events/readahead.h
 create mode 100644 mm/swap_table.h
 delete mode 100644 mm/zpool.c
 create mode 100644 rust/helpers/maple_tree.c
 create mode 100644 rust/kernel/maple_tree.rs
 create mode 100755 tools/testing/selftests/damon/sysfs_no_op_commit_break.py
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c
 create mode 100644 tools/testing/selftests/mm/rmap.c
 delete mode 100644 tools/testing/vma/linux/atomic.h

