Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999EB30D418;
	Wed, 19 Aug 2026 05:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787116037; cv=none; b=Ji+v2+9wN1JgHieruuR5LYXUHasPUr+F/UA0Xd0PXnzBnuxXuosTNDjTpRzUS0PYFaeP+GmYOVY9E67IAwnX/tRjnQwTuWWT9H+BSxtJlHEQhASbN1UxgdFtgU2XwEqVY7XbsifE6p/ljjqEgait4pPw4gxDoGnj3rbdBoVGvn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787116037; c=relaxed/simple;
	bh=ssFXNvJOyytoGdLja1bSqJKjD+OMV5298ifG41rDlHE=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=WiCrAFtGxfSUvvETbunbxIaGZD/lix/1B4RKZNGz7bXimXkoNDV1+n7tLkwsWDdEfTzYUyxlZKcL1HMJ89dKD1wjlGV2H56BTveWhsgL67NaoicmTS7G7pD/F61bd9h/qEW5nQBRxytztME5Qlf28Jw2HS6jcfWSVBFEoVId1nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wDhQxRI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wDhQxRI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4991F000E9;
	Wed, 19 Aug 2026 05:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787116032;
	bh=iOoe7ySoPHzICbaD0qL0j1Y6wkpC9+lDEm0FCY+jcxo=;
	h=Date:From:To:Cc:Subject;
	b=wDhQxRI2uokWvkrnmx5TKRm/pHvk30Z4wzTbYpk/89HylN4XHyNMwg4/L3QCxG5qQ
	 0/KtdIyxrl+nbtI9ZQzJAtfzDzOsNpaodI3olpqyGFw7wS5p9bru4F8v6odL6MFTzE
	 slbIvHEhaoQl32QiyBHetCrmwj1VPPjOZvInFVHU=
Date: Tue, 18 Aug 2026 22:07:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 7.3-rc1
Message-Id: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge the first batch of MM updates for the upcoming -rc
cycle.

It's been busy.  This cycle I squirted out 1250 "added-to-mm" emails. 
In the previous cycle it was 920.  So lots of material.  500 patches
here, nearly 200 lined up for next week.


I don't enjoy typing up those patch series summaries, so I haven't been
doing them well.  This time I recruited Gemini to draft many of the
bullets and then I did a review/edit pass.  I think the result is
better(?).


I'm seeing no merge conflicts at this time.

Possible upcoming merge and build issues and their linux-next
resolutions are:

arch/riscv/Kconfig, vs risc-v tree:
	https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk

drivers/gpu/drm/ttm/ttm_backup.c, vs drm tree:
	https://lore.kernel.org/al4jGBGNG_QACaNL@sirena.org.uk

mm/hugetlb.c, mm/mm_init.c vs liveupdate tree:
	https://lore.kernel.org/amjYWetl6_WVyumg@sirena.org.uk

drivers/misc/sgi-xp/xpc_uv.c vs char-misc tree:
	https://lore.kernel.org/anSSANY5zZu4kytE@sirena.org.uk


Thanks.


The following changes since commit 9f1d75a4ce04095afdb63d8e540092ff8151dacf:

  selftests/mm: fix potential wild pointer access of getline due to missing init (2026-07-28 17:37:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-08-18-18-39

for you to fetch changes up to 08745c62350126bc31b09548137be87e2866f628:

  selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check (2026-08-15 21:12:24 -0700)

----------------------------------------------------------------
mm.git review status for mm-hotfixes-stable..mm-stable

Everything:

Total patches:       501
Reviews/patch:       1.66
Reviewed rate:       70%

Excluding DAMON:

Total patches:       356
Reviews/patch:       2.26
Reviewed rate:       90%

Excluding DAMON and selftests:

Total patches:       329
Reviews/patch:       2.31
Reviewed rate:       92%

Excluding DAMON, selftests and maple_tree:

Total patches:       328
Reviews/patch:       2.31
Reviewed rate:       92%

Summary of patch series in this merge:

- The 2 patch series "mm: drop "sub" prefix from various places" from
  Dev Jain implements some page->folio conversion and a naming cleanup.

- The 2 patch series "mm/kasan: remove redundant initialization for
  kasan_flag_write_only" from Igor Putko provides some KASAN cleanup work.

- The 2 patch series "mm/filemap: reduce unnecessary xarray lookups"
  from Chi Zhiling provides a small speedup in the pagecaache read code.

- The 4 patch series "mm/percpu: Fix possible NOFS/NOIO reclaim
  recursion" from Kaitao Cheng improves a few things in the vmalloc code -
  mainly the avoidance of GFP_KERNEL allocations when the caller asked for
  GFP_NOFS or GFP_NOIO.

- The 3 patch series "mm/kmemleak: avoid soft lockup when scanning task
  stacks" from Breno Leitao avoids a soft lockup watchdog trigger from the
  kmemleak scanning code in extreme situations.

- The 6 patch series "mm/page_owner: misc cleanups" from Ye Liu is a
  collection of unrelated cleanups to the page_owner code.  For some
  reason lots of people have been working on the page_owner code this
  cycle.

- The 4 patch series "mm: convert to walk_page_range_vma() to eliminate
  find_vma()" from Kefeng Wang simplifies and accelerates the page walking
  library function.

- The 3 patch series "mm/migrate: preparatory cleanups for batch copy
  and offload" from Shivank Garg implements cleanups in the migration
  code.

- The 4 patch series "mm/page_owner: add per-fd filter infrastructure
  for print_mode and NUMA filtering" from Zhen Ni provides per-fd
  filtering to page_owner in order to reduce the sometimes vast amount of
  output it can produce.

- The 19 patch series "mm: Refactor bootmem gigantic hugepage
  allocation" from Muchun Song is a "set of fixes and preparatory cleanups
  around bootmem HugeTLB handling, sparse initialization ordering, and
  related vmemmap setup".

- The 4 patch series "mm/zsmalloc: reduce lock contention in zs_free()"
  from Wenchao Hao reduces lock contention in zs_free(), which dominates
  the unmap path under memory pressure on Android (LMK kills) and on x86
  servers running zswap-heavy workloads.  Up to 1.83x improvement in
  microbenchmarking.

- The 2 patch series "move alloc_tag.c file under mm/" from Suren
  Baghdasaryan does that.

- The 6 patch series "samples/damon: handle damon_{start,stop}()
  failures" from SJ Park fixes improper handling of damon_start(),
  damon_stop(), and damon_call() failures across DAMON sample modules to
  prevent potential memory leaks, operation disruptions and use-after-free
  bugs.

- The 11 patch series "mm/damon/sysfs: kobject_del() directories that
  users can create/remove" from SJ Park resolves an issue where delayed
  sysfs directory removal under CONFIG_DEBUG_KOBJECT_RELEASE causes
  creation failures due to duplicate directory names by adding missing
  kobject_del() calls before creating new directories.

- The 3 patch series "mm: cleanup clear_not_present_full_ptes()" from
  David Hildenbrand cleans up the core pte handling code.

- The 3 patch series "selftests/damon: misc fixes for test bugs" from
  Kunwu Chan fixes several bugs in the DAMON selftests.

- The 2 patch series "selftests/damon: fix memcg_path staging handling"
  from Cheng Nie fixes a bug in _damon_sysfs.py for damos_filter
  memcg_path setup, and adds a test case for it in sysfs.py.

- The 2 patch series "selftests/damon: test kdamond refresh_ms" from
  Ruslan Valiyev introduces selftest coverage for DAMON's refresh_ms sysfs
  feature by updating the test control module and verifying that scheme
  stats update automatically without manual intervention.

- The 5 patch series "mm/damon: five misc fixups" from Akinobu Mita
  contains miscellaneous DAMON fixups.

- The 2 patch series "mm/damon/core: detect internal variation above
  max_nr_regions/2" from Jiayuan Chen fixes DAMON's region splitting
  behavior when region counts exceed half the maximum budget by
  dynamically scaling down the split fraction as the limit approaches,
  preventing large regions from staying un-split, and adds corresponding
  KUnit test coverage.

- The 6 patch series "mm: preparatory patches for PMD level swap
  entries" from Usama Arif refactors and cleans up PMD softleaf helpers,
  call sites, and architecture flags to lay the groundwork for a follow-up
  series that introduces PMD page table swap entries.

- The 11 patch series "mm/damon: update, optimize, and clean up doc,
  tests, and code" from SJ Park updates DAMON design and ABI
  documentation, expands unit and selftest coverage, optimizes
  damon_commit_target_regions(), and cleans up recently added sysfs
  interface code for better readability.

- The 2 patch series "mm/vmpressure: reduce CPU, memory and code
  overhead on cgroup v2" from Usama Arif optimizes vmpressure() by
  skipping unnecessary work on cgroup v2 for userspace event notifications
  and refactors v1-only eventfd handling into mm/memcontrol-v1.c to reduce
  memory overhead and code complexity.

- The 10 patch series "selftests/mm: refactor pkey helpers and fix mmap
  error handling" from Hongfu Li refactors pkeys shared tracing and
  assertion helpers into a common file, unifies protection key selftests
  to use consistent diagnostic logging and assertions, and enforces
  standardized MAP_FAILED return checks for mmap() calls across the tests.

- The 18 patch series "mm/damon: optimize out nr_accesses_bp" from SJ
  Park replaces the error-prone, continuously updated nr_accesses_bp field
  in damon_region with an on-demand moving sum function
  (damon_nr_accesses_mvsum()), reducing structure memory overhead and
  avoiding state corruption bugs.

- The 6 patch series "Open HugeTLB allocation routine for more generic
  use" from Ackerley Tng decouples HugeTLB folio allocation from VMA
  dependencies by introducing hugetlb_alloc_folio(), enabling subsystems
  like guest_memfd to allocate HugeTLB folios without standard VMA
  reservations or pseudo-VMAs.

- The 3 patch series "mm/damon: provide pseudo moving sum probe_hits"
  from SJ Park integrates DAMON's probe_hits attribute counter into the
  pseudo moving sum infrastructure, enabling real-time, online monitoring
  without waiting for full aggregation intervals.

- The 18 patch series "mm: Some cleanups for page allocator APIs" from
  Brendan Jackman simplifies and refactors the page allocator entry points
  and flags by unifying allocation paths, adding internal alloc_flags
  arguments, and eliminating redundant __ prefixed alloc_pages variants.

- The 5 patch series "Fix incorrect access of hugetlb pte entries" from
  Dev Jain enforces the consistent use of huge_ptep_get() instead of
  ptep_get() for HugeTLB entries and fixes an unaligned address issue in
  arm64's huge_ptep_get() implementation.

- The 8 patch series "mm/damon: validate all parameters in the core"
  from SJ Park consolidates parameter validation into the DAMON core
  specifically within damon_start() and damon_commit_ctx() to centralize
  error checking, eliminate caller-side redundant checks and to improve
  maintenance efficiency.

- The 3 patch series "tools/mm/page_owner_sort: fix filtering and
  cleanup issues" from Yichong Chen renames is_need() to filter_record()
  for clearer return semantics, fixes per-record allocation memory leaks
  and bounds output copies in search_pattern() to address an existing
  buffer issue.

- The 4 patch series "memcg: bail out reclaim when memcg is dying" from
  Jiayuan Chen mitigates a system-wide stall which occurs when a cgroup is
  removed while one of its memory control files is doing synchronous
  reclaim.

- The 5 patch series "mm/memory-failure: add panic option for
  unrecoverable pages" from Breno Leitao introduces an opt-in
  vm.panic_on_unrecoverable_memory_failure sysctl that immediately panics
  the kernel on unrecoverable memory errors in kernel-owned pages to
  preserve error context and prevent delayed, silent data corruption.

- The 11 patch series "mm/damon: refactor damon_{start,stop,commit}()
  for simple error handling" from SJ Park refactors the DAMON core API
  functions to guarantee that all contexts are fully stopped when
  damon_start(), damon_stop(), or damon_commit() fail, eliminating the
  need for complex and error-prone caller-side cleanup code.

- The 5 patch series "Keep tail page private zero at free and folio
  split" from Zi Yan adds checks to ensure tail_page->private is zero when
  freeing compound or high-order pages and when promoting tail pages
  during large folio splits.  By validating these fields at free and split
  time, it allows the removal of redundant private field clearing inside
  prep_compound_tail().

- The 4 patch series "mm: drop redundant lru_add_drain in anon folio
  reuse paths" from Barry Song eliminates redundant lru_add_drain() calls
  in wp_can_reuse_anon_folio() and do_swap_page() to reduce LRU lock
  contention and system overhead.

  By validating folio refcounts against the LRU cache before draining
  and removing unnecessary drains in the swap path, it achieves up to a
  30.5% reduction in drain calls during heavy swap workloads.

- The 3 patch series "mm: clean up folio LRU and swap declarations" from
  Jianyue Wu reorganizes folio LRU and swap code by relocating
  page-cluster state to mm/swap_state.c, renaming mm/swap.c to mm/folio.c,
  and moving MM-internal reclaim declarations into mm/internal.h.

- The 15 patch series "userfaultfd: working set tracking for VM guest
  memory" from Kiryl Shutsemau adds userfaultfd support for tracking the
  working set of VM guest memory, so a VMM can identify hot pages and
  reclaim cold ones to tiered or remote storage.

- The 10 patch series "mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part
  2)" from David Hildenbrand removes the remaining pieces of
  CONFIG_HAVE_BOOTMEM_INFO_NODE, performing some smaller cleanups around
  freeing of reserved vmemmap pages on the way.

- The 7 patch series "mm/damon: update probe hits for runtime parameter
  commits" from SJ Park ensures that DAMON's probe_hits attribute counter
  is properly updated when monitoring intervals are changed at runtime,
  matching the behavior of nr_accesses.  To achieve this, it refactors and
  renames existing helper functions for shared use, applies the updates to
  probe_hits, and handles edge cases in damon_probe_hits_mvsum() to
  maintain measurement accuracy.

- The 3 patch series "KSM: performance optimizations for rmap_walk_ksm"
  from xu xin resolves a severe KSM reverse-mapping performance bottleneck
  where thousands of split VMAs sharing a single anon_vma cause extended
  lock contention.  By adding an interval-filtering check during the rmap
  walk, it reduces worst-case anon_vma lock hold times from over 500ms
  down to under 2ms, preventing application freezes and latency spikes
  under memory pressure.

- The 3 patch series "mm: split a couple of headers from internal.h"
  from Mike Rapoport splits declarations related to mm_init, memblock,
  vmalloc and sparse into new headers.

- The 2 patch series "KSM: use linear_page_index in collect_procs_ksm()"
  from xu xin applies the interval tree optimization from rmap_walk_ksm()
  to collect_procs_ksm() to avoid iterating over non-matching VMAs during
  KSM memory error handling.  It hoists loop-invariant address
  initialization and restricts the anon_vma_interval_tree_foreach walk to
  a targeted page offset range, reducing redundant checks and improving
  lookup efficiency.

- The 3 patch series "selftests/mm: avoid false failures in hugetlb and
  KSM tests" from Sayali Patil fixes issues in the hugetlb and KSM MM
  selftest categories that can report failures when the prerequisites for
  the tests are not satisfied.

- The 19 patch series "mm/damon: introduce data attributes only
  monitoring" from SJ Park introduces attribute-weighted region management
  in DAMON, allowing users to prioritize specific data attributes (such as
  page sizes or cgroups) over or instead of access monitoring.

  By assigning weights to attribute probes, DAMON can completely disable
  access tracking and adjust monitoring regions based on weighted
  probe-hit counters to optimize monitoring quality for attribute-focused
  workloads.

- The 8 patch series "mm/hmm: Add mmap lock-drop support for
  userfaultfd-backed mappings" from Stanislav Kinsburskii extends
  hmm_range_fault() to support userfaultfd-backed regions by allowing the
  mmap lock to be dropped during fault handling via a new
  hmm_range_fault_locked() helper.

  By accepting a locked pointer and signaling retry status when lock
  release occurs, it enables page fault resolution in userfaultfd regions
  while preserving backward compatibility for existing callers.

- The 33 patch series "mm: make VMA page offset handling more
  consistent" from Lorenzo Stoakes cleans up and standardizes how
  vma->vm_pgoff is accessed and manipulated across file-backed and
  anonymous mappings in the kernel.

  It introduces dedicated helper functions such as vma_start_pgoff(),
  vma_end_pgoff(), vma_set_pgoff() and linear_page_delta() while renaming
  rmap interval tree helpers to better reflect their functionality.

  These changes establish a cleaner foundation for future work that will
  unify virtual page offset indexing for all anonymous and CoW'd folios.

- The 3 patch series "mm: handle device-private PMDs in walk callbacks"
  from Usama Arif addresses kernel panics and state corruption caused by
  MM walk callbacks reaching non-present device-private PMD swap entries
  created during HMM migrations.

  It ensures that functions which acquire pmd_trans_huge_lock() properly
  recognize device-private PMDs instead of assuming a present THP or a
  standard migration entry.

- The 5 patch series "mm/rmap: Refactor try_to_unmap_one" from Dev Jain
  refactors try_to_unmap_one by modularizing Hugetlb, anonymous-lazyfree,
  and anonymous-swapbacked logic into dedicated functions, laying the
  structural groundwork for batched anonymous large folio unmapping.

- The 4 patch series "Docs/ABI/damon: sysfs ABI document fixes and
  additions" from Song Hu fixes typos and fills in missing entries in the
  DAMON sysfs ABI document.

- The 10 patch series "dax/kmem: atomic whole-device hotplug via sysfs"
  from Gregory Price introduces an atomic sysfs state attribute and
  supporting DAX/MM infrastructure to prevent userland races when
  offlining and removing entire memory regions.

  By adding an unplugged state alongside standard online modes, it
  enables whole-device atomic hotplug control while preserving backward
  compatibility.

- The 13 patch series "mm: convert more vm_flags_t users to vma_flags_t"
  from Lorenzo Stoakes continues transitioning the kernel from the
  deprecated vm_flags_t type to vma_flags_t across core memory management
  infrastructure.

  It replaces legacy type usage in core functions such as do_mmap(),
  unmapped area allocation, mm->def_vma_flags, and VMA operations like
  mlock, mprotect, and mremap.

- The 2 patch series "Two small patches to clean up mm/mm_slot.h" from
  xu xin refactors mm_slot.h by introducing mm_slot_remove() to unify
  duplicate slot deletion sequences in khugepaged and KSM.  It also adds
  code documentation explaining why mm_slot_lookup and mm_slot_insert must
  remain as preprocessor macros rather than static inline functions.

- The 10 patch series "mm/damon/core: hide core-private struct fields"
  from SJ Park cleans up DAMON core structures by consistently marking
  internal-only fields with private: comment tags to prevent improper
  direct access from outer layers.

  It enforces encapsulation across core structures including
  damon_region, damon_target, and damon_ctx and updates DAMON_SYSFS to
  interact through approved access APIs instead of exposing raw struct
  members.

- The 6 patch series "mm/damon: unurgent fixes for infinite loop, NULL
  de-ref and races" from SJ Park addresses potential infinite loops, NULL
  dereferences, and race conditions identified in DAMON.

  It fixes an infinite loop triggered by extreme user configurations, a
  NULL pointer dereference within unit tests and minor monitoring
  accuracy degradation caused by subtle runtime races.

- The 2 patch series "mm/page_alloc: fixes for free_pages_nolock() on
  RT/UP" from Brendan Jackman fixes an NMI safety flaw in
  __free_frozen_pages() where freeing pages on non-SMP or PREEMPT_RT
  kernels can bypass can_spin_trylock() checks via non-PCP or isolated
  migration paths.

  It also resolves potential kernel crashes and privilege escalation
  risks triggered when BPF tracing runs in NMI context alongside memory
  hotplug or large allocation frees.

- The 4 patch series "mm/page_alloc: couple of followups for recent
  cleanups" from Brendan Jackman cleans up and updates page allocator
  nomenclature, documentation, and debug assertions.

  It aligns internal FPI_ flags with the public "nolock" naming
  convention, removes outdated internal implementation details from
  high-level page allocator comments, and eliminates obsolete VM_BUG_ON()
  assertions in allocation paths.

- The 3 patch series "mm/mseal: further cleanups" from Lorenzo Stoakes
  refactors and simplifies the mseal implementation by clarifying API
  boundaries and removing unnecessary code complexity.

  It replaces generic do_mseal() usage outside the syscall with a
  dedicated mseal_mmap_page_zero() helper for MMAP_PAGE_ZERO, eliminates
  mm_struct parameters to enforce that sealing applies only to
  current->mm, and streamlines overall logic and comments with no
  functional changes intended.

- The 4 patch series "mm/vmscan: fix swappiness=max and clean up
  per-node proactive reclaim" from Ridong Chen resolves reclaim behavior
  bugs and cleans up function parameters across memory reclaim paths.

  It fixes swappiness=max in both standard reclaim and MGLRU so
  unswappable anonymous memory no longer falls back to evicting page
  cache, ensures reclaim_store() returns accurate error codes instead of
  collapsing all failures into -EAGAIN, and removes the obsolete gfp_mask
  parameter from __node_reclaim().

- The 6 patch series "mm: mincore: misc cleanups" from Kefeng Wang
  cleans up and simplifies the mincore code.  Most importantly, it removes
  the historical special behavior that always reports VM_PFNMAP pages as
  non-resident.

- The 2 patch series "mm/huge_memory: drop dead split helper variants"
  from Kiryl Shutsemau implements two trivial cleanups in the folio split
  API.

- The 7 patch series "mm/damon: fix uninitialized DAMOS field and kunit
  exec expectation bugs" from SJ Park resolves minor operational and
  testing bugs in DAMON identified by Sashiko.  It initializes the
  damos->last_applied field to prevent occasional efficiency degradation
  and fixes invalid memory accesses in DAMON KUnit tests during test
  failure handling.

- The 3 patch series "cleanup for stable_page_flags()" from Jinjiang Tu
  cleans up and refactors stable_page_flags() used by /proc/kpageflags
  without altering functionality.

  It uses BIT_ULL() to prevent shift-overflow warnings on 64-bit flag
  bits, converts folio-specific flag checks to standard folio_test_*()
  helpers, and removes redundant CONFIG_PAGE_IDLE_FLAG handling.

- The 3 patch series "Batch unmap of uffd-wp file folios" from Dev Jain
  extends batched folio unmapping support to file folios within
  userfaultfd write-protect (uffd-wp) VMAs by adding batching capabilities
  to pte_install_uffd_wp_if_needed().

  This removes special-case restrictions on uffd-wp VMAs in
  try_to_unmap_one(), significantly simplifying the function's control
  flow and complexity.

- The 3 patch series "mm/early_ioremap: clarify and clean up
  early_ioremap_reset()" from Sang-Heon Jeon clarifies and cleans up the
  architecture-specific usage of __late_set_fixmap() and
  __late_clear_fixmap() after early_ioremap_reset().

  It adds explicit documentation regarding when early_ioremap_reset()
  must be called and removes redundant macro definitions and reset calls
  in the RISC-V and ARM64 architectures.

- The 4 patch series "mm: fix reclaim storms in defrag_mode" from
  Johannes Weiner addresses severe performance regressions, swap storms,
  and spurious OOMs caused by vm.defrag_mode=1 under high memory pressure
  in Meta production.

  It updates the page allocator slowpath so non-movable allocation
  requests actively trigger direct reclaim and direct compaction at
  pageblock_order scale, allowing them to claim whole pageblocks rather
  than spinning unproductively.

- The 2 patch series "zram: lockmap tweaks" from Sebastian Siewior
  optimizes and fixes lockdep tracking for zram devices by consolidating
  per-entry lockmaps and isolating lock classes across multiple instances.

  It reduces memory overhead by replacing per-entry lockdep_map instances
  with a single map per struct zram, and assigns a dynamic lock_class_key
  to each instance to prevent false deadlock reports when different zram
  devices are backed by distinct filesystems.

----------------------------------------------------------------
Ackerley Tng (6):
      mm: hugetlb: consolidate interpretation of gbl_chg within alloc_hugetlb_folio()
      mm: hugetlb: move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
      mm: hugetlb: move mpol interpretation out of dequeue_hugetlb_folio_vma()
      mm: hugetlb: use error variable in alloc_hugetlb_folio
      mm: hugetlb: move mem_cgroup_charge_hugetlb() earlier in allocation
      mm: hugetlb: refactor out hugetlb_alloc_folio()

Akinobu Mita (1):
      mm/damon/core: use kvmalloc for target regions array

Andreas Gruenbacher (1):
      writeback.h: fix a typo in the wbc_init_bio() description

Andrew Morton (3):
      csky: implement flush_cache_vmap() in C
      Merge branch 'mm-hotfixes-stable' into mm-stable in order to pick up vmscan.c changes which are required by "memcg: bail out proactive reclaim when memcg is dying".
      mm/hmm: make CONFIG_HMM_MIRROR select CONFIG_MMU_NOTIFIER

Arnd Bergmann (1):
      mm/damon/core: reduce kernel stack usage

Arukonda Rahul (1):
      docs: ABI: zram: fix spelling mistakes

Asier Gutierrez (1):
      samples/damon: fix typos in Kconfig help text

Baolin Wang (1):
      mm: vmscan: remove the redundant FOLIOREF_RECLAIM_CLEAN logic

Barry Song (Xiaomi) (4):
      mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
      mm: drop stale folio_ref_count()==1 check in do_swap_page reuse logic
      mm: entirely remove lru_add_drain in do_swap_page
      mm: clarify the folio_free_swap() for do_swap_page()

Ben Dooks (1):
      mm/page_alloc: don't build vm_numa_stat_key if CONFIG_NUMA=n

Brendan Jackman (25):
      mm/page_alloc: drop flag-conversion "optimisation"
      mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
      mm/page_alloc: some renames to clarify alloc_flags scopes
      mm: name some args in a function declaration
      mm: split out internal page_alloc.h
      mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
      mm/page_alloc: relax GFP WARN in nolock allocs
      mm: move some stuff to mm/page_alloc.h
      perf/x86/intel: use higher-level allocator API
      KVM: VMX: use higher-level allocator API
      x86/virt: use higher-level allocator API
      sgi-xp: use higher-level allocator API
      net/funeth: switch to higher-level allocator API
      mm: remove __alloc_pages_node()
      mm: move __alloc_pages() to mm/page_alloc.h
      mm: replace __GFP_NO_CODETAG with ALLOC_NO_CODETAG
      mm/page_alloc: drop alloc_flags arg from alloc_flags_cma()
      mm: factor out can_spin_trylock()
      mm/secretmem: don't allow highmem folios
      mm/page_alloc: don't spin_trylock() in NMI on UP
      mm/page_alloc: don't spin_trylock() when disallowed in free_one_page()
      mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
      cgroup/cpuset: update some comments about the page allocator
      mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
      mm/page_alloc: remove a couple of VM_BUG_ON()st

Breno Leitao (10):
      mm/kmemleak: avoid soft lockup when scanning task stacks
      mm/kmemleak: stop the task stack scan early when interrupted
      mm/kmemleak: stop the per-cpu and struct page scans early too
      mm/kmemleak: skip the remaining scan phases when interrupted
      mm/memory-failure: drop dead error_states[] entry for reserved pages
      mm/memory-failure: surface unhandlable kernel pages as -ENOTRECOVERABLE
      mm/memory-failure: report MF_MSG_KERNEL for unrecoverable kernel pages
      mm/memory-failure: add panic option for unrecoverable pages
      Documentation: document panic_on_unrecoverable_memory_failure sysctl
      mm/migrate: report RCU-tasks quiescent states in migrate_pages_batch()

Cheng Nie (2):
      selftests/damon/_damon_sysfs.py: fix memcg_path assignment
      selftests/damon/sysfs.py: validate memcg_path staging readback

Chi Zhiling (2):
      mm/filemap: reduce unnecessary xarray lookups when read cached pages
      mm/filemap: reduce unnecessary xarray lookups in filemap_get_folios_contig()

Christoph Hellwig (1):
      mm: remove wb_writeout_inc

David Hildenbrand (Arm) (13):
      sparc/mm: drop custom pte_clear_not_present_full()
      mm: drop pte_clear_not_present_full()
      mm: cleanup clear_not_present_full_ptes() and rename to clear_non_present_ptes()
      x86/mm: drop order parameter from free_pagetable()
      mm: provide free_reserved_pages(), removing x86 variant
      s390/mm: use free_reserved_pages() in vmem_free_pages()
      mm/bootmem_info: allow calling free_bootmem_page() on pages without a bootmem_type
      x86/mm: stop marking vmemmap as SECTION_INFO
      x86/mm: stop marking page tables as MIX_SECTION_INFO
      x86/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
      mm/hugetlb_vmemmap: remove bootmem_info leftovers
      mm/sparse: remove bootmem_info.h include
      mm/bootmem_info: remove CONFIG_HAVE_BOOTMEM_INFO_NODE

Dev Jain (15):
      mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
      mm/mprotect: drop 'sub' from batching context
      mm/rmap: use huge_ptep_get() in try_to_unmap_one()
      mm/rmap: use huge_ptep_get() in try_to_migrate_one()
      mm/migrate: use huge_ptep_get() in remove_migration_pte()
      mm/page_vma_mapped: use huge_ptep_get() for hugetlb
      mm/mprotect: use huge_ptep_get() for hugetlb
      mm/rmap: convert page -> folio for hwpoison checks
      mm/rmap: add try_to_unmap_poisoned_hugetlb_one
      mm/rmap: refactor some code around lazyfree folio unmapping
      mm/rmap: refactor anon folio unmap in try_to_unmap_one
      mm/rmap: add anon folio unmap dispatcher
      mm/memory: move pte_install_uffd_wp_if_needed() into memory.c
      mm/memory: batch set uffd-wp markers during zapping
      mm/rmap: batch unmap file folios belonging to uffd-wp VMAs

Doehyun Baek (1):
      Docs/{admin-guide,mm}/damon: fix DAMON documentation details

Enze Li (1):
      mm/damon/ops-common: remove redundant local variable in damon_migrate_folio_list()

Ethan Nelson-Moore (1):
      mm: hugetlb: correct CONFIG_CGROUP_HUGETLB macro name in comment

Feng Tang (1):
      mm/vmalloc: add alignment info in warning print as possible failure reason

Gregory Price (12):
      mm: constify oom_control, scan_control, and alloc_context nodemask
      mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug
      mm/memory: add memory_block_aligned_range() helper
      mm/memory_hotplug: add mhp_online_type_to_str() and export string helpers
      mm/memory_hotplug: pass online_type to online_memory_block() via arg
      mm/memory_hotplug: export mhp_get_default_online_type
      mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
      mm/memory_hotplug: add offline_and_remove_memory_ranges()
      dax/kmem: resolve default online type at probe time
      dax/kmem: extract hotplug/hotremove helper functions
      dax/kmem: add sysfs interface for atomic whole-device hotplug
      selftests/dax: add dax/kmem hotplug sysfs regression test

Guopeng Zhang (7):
      mm: memcg: remove stray text from obj_stock_pcp comment
      mm: memcontrol: update state_local when flushing NMI stats
      mm: memcg-v1: account vmpressure event allocations
      mm: memcg-v1: fix wrong linux-mm list address in deprecation warnings
      mm: memcontrol: drop unused cpu argument from flush_nmi_stats
      mm: memcontrol: factor out memcg kmem uncharge sequence
      mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void

Hajime Tazaki (2):
      mm: nommu: add sysctl_max_map_count() check for do_mmap()
      mm: nommu: fix the error path when vma_iter_prealloc() fails

Hongfu Li (9):
      selftests/mm: move pkey selftest helpers to pkey_util.c
      selftests/mm: unify pkey sighandler selftest assertions and tracing
      selftests/mm: use pkey_assert on clone_raw failure in pkey test
      selftests/mm: add missing mmap() return checks in pkey tests
      selftests/mm: add missing pthread_create() return checks in pkey tests
      selftests/mm: fix clone cleartid race in pkey sighandler tests
      selftests/mm: fix memleak in migration benchmark
      selftests/mm: factor out hmm_buffer_alloc() to consolidate buffer setup
      selftests/mm: fix BUG_ON checking wrong variable in mremap_dontunmap

Hongling Zeng (1):
      mm: huge_memory: fix kobject cleanup in thpsize_create error

Hui Zhu (1):
      mm: fix ASSERT_EXCLUSIVE_BITS by passing memdesc_flags_t by pointer

Igor Putko (2):
      mm/kasan: remove redundant initialization for kasan_flag_write_only
      mm/memory-failure: remove redundant initialization for hw_memory_failure

Imran Khan (1):
      mm/vmstat: avoid taking zone lock in /proc/buddyinfo reads

Injae Ryou (1):
      selftests/mm: fix on-fault-limit false failure under sudo-rs

JP Kobryn (2):
      mm/lruvec: trace LRU add drains and drain-all requests
      mm/page_alloc: use existing highatomic reserves on the buddy fastpath

Jaeyeon Lee (1):
      mm/shmem: annotate benign data-race in shmem_getattr()

Jakov Novak (1):
      mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro

Jiacheng Yu (1):
      mm/shmem: downgrade final i_blocks check in shmem_evict_inode() to pr_warn()

Jiahui Zhang (1):
      mm/damon/ops-common: prevent migration fallback to non-target nodes

Jianyue Wu (3):
      mm/swap: colocate page-cluster sysctl with swap readahead
      mm: rename swap.c to folio.c
      mm: move reclaim-internal declarations out of swap.h

Jiayuan Chen (8):
      mm/damon/core: split a fraction of regions when nr_regions exceeds max/2
      mm/damon/tests/core-kunit: test split above max_nr_regions/2
      mm: memcg: reset zswap settings in css_reset
      mm: memcg: reset oom_group in css_reset
      memcg: bail out memory.high when memcg is dying
      memcg: bail out memory.max when memcg is dying
      memcg: bail out proactive reclaim when memcg is dying
      memcg-v1: bail out reclaim when memcg is dying

Jinjiang Tu (3):
      fs: stable_page_flags(): use BIT_ULL() for KPF flags
      fs: stable_page_flags(): use folio_test_*() helpers
      fs: stable_page_flags(): simplify KPF_IDLE handling

Johannes Weiner (4):
      mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT documentation
      mm: page_alloc: __GFP_FS lockdep annotation for direct compaction
      mm: compaction: support non-movable compaction for pageblock requests
      mm: page_alloc: fix non-movable reclaim storm in defrag_mode

John Hubbard (1):
      mm/gup: fix GUP-fast fallback for NULL-mapping order-0 folios

Joshua Hahn (1):
      mm/memcontrol: remove unused for_each_mem_cgroup macro and cleanup

Kaitao Cheng (4):
      mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
      mm/percpu: honor GFP constraints when populating chunks
      mm/percpu: make cached pages lookup explicit
      mm/percpu: avoid IO/FS reclaim in backing allocations

Kefeng Wang (11):
      mm: remove PageTransCompound()
      mm: mincore: use walk_page_range_vma() in do_mincore()
      mm: mprotect: use walk_page_range_vma() in mprotect_fixup()
      mm: mlock: use walk_page_range_vma() in mlock_vma_pages_range()
      mm: migrate_device: use walk_page_range_vma() in migrate_vma_collect()
      mm: introduce pud_is_huge() helper
      mm: mincore: remove special handling for VM_PFNMAP
      mm: mincore: replace __get_free_page() with kmalloc()
      mm: mincore: remove xa_is_value() in mincore_swap()
      mm: mincore: improve mincore_hugetlb()
      mm: mincore: refactor mincore_page()

Kiryl Shutsemau (Meta) (19):
      mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
      mm: rename uffd-wp PTE bit macros to uffd
      mm: rename uffd-wp PTE accessors to uffd
      userfaultfd: test uffd VMA flags through the vma_flags_t API
      mm: add VM_UFFD_RWP VMA flag
      mm: add MM_CP_UFFD_RWP change_protection() flag
      mm: preserve RWP marker across PTE rewrites
      mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
      userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
      mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP
      mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
      userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
      userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
      selftests/mm: add userfaultfd RWP tests
      Documentation/userfaultfd: document RWP working set tracking
      selftests/mm: add PAGEMAP_SCAN test for THP PMD holes
      mm/huge_memory: remove unused can_split_folio()
      mm/huge_memory: fold split_folio_to_list_to_order() into split_folio_to_order()
      mm: fold userfaultfd_rwp() to false without CONFIG_ARCH_HAS_PTE_PROTNONE

Kunwu Chan (3):
      selftests/damon: prevent cross-context state pollution in DamonCtx
      selftests/damon/damos_tried_regions: fix expectation output and join TypeError
      selftests/damon: fix dead code, skipped checks, and broken lookups

Leon Hwang (1):
      mm/mseal: fix mseal documentation for 32-bit kernels

Lorenzo Stoakes (47):
      mm: move alloc tag to mm
      mm: move vma_start_pgoff() into mm.h and clean up
      mm: add kdoc comments for vma_start/last_pgoff()
      tools/testing/vma: use vma_start_pgoff() in merge tests
      mm: introduce and use vma_end_pgoff()
      mm/rmap: update mm/interval_tree.c comments
      mm/rmap: parameterise vma_interval_tree_*() by address_space
      mm/rmap: elide unnecessary static inline's in interval_tree.c
      mm/rmap: rename vma_interval_tree_*() to mapping_rmap_tree_*()
      mm/rmap: parameterise anon_vma_interval_tree_*() by anon_vma
      mm/rmap: rename anon_vma_interval_tree_*() params and use pgoff_t
      mm/rmap: rename anon_vma_interval_tree_*() to anon_rmap_tree_*()
      MAINTAINERS: move mm/interval_tree.c to rmap section
      mm/vma: introduce and use vmg_pages(), vmg_[start, end]_pgoff()
      mm/vma: clean up anon_vma_compatible()
      mm/vma: refactor vmg_adjust_set_range() for clarity
      mm/vma: minor cleanup of expand_[upwards, downwards]()
      mm: introduce and use linear_page_delta()
      mm/vma: use vma_start_pgoff(), linear_page_index() in mm code
      mm: prefer vma_[start,end]_pgoff() to vma->vm_pgoff in kernel/
      mm/vma: remove duplicative vma_pgoff_offset() helper
      mm: use linear_page_[index, delta]() consistently
      mm/vma: introduce vma_assert_can_modify()
      mm/vma: add and use vma_[add/sub]_pgoff()
      mm/vma: move __install_special_mapping() to vma.c
      mm/vma: make vma_set_range() static, drop insert_vm_struct() decl
      mm/vma: update vma_shrink() to not pass start, pgoff parameters
      mm/vma: update vmg_adjust_set_range() to offset pgoff instead
      mm/vma: slightly rework the anonymous check in __mmap_new_vma()
      mm/vma: introduce and use vma_set_pgoff()
      mm/vma: correct incorrect vma.h inclusion
      mm/vma: use guard clauses in can_vma_merge_[before, after]()
      tools/testing/vma: default VMA, mm flag bits to 64-bit
      tools/testing/vma: output compared expression on ASSERT_[EQ, NE]()
      mm: introduce vma_flags_can_grow() and vma_can_grow()
      mm/vma: update do_mmap() to use vma_flags_t
      mm: convert __get_unmapped_area() to use vma_flags_t
      mm: update generic_get_unmapped_area[_topdown]() to use vma_flags_t
      mm: prefer mm->def_vma_flags in mm logic
      mm/vma: convert vm_pgprot_modify() to use vma_flags_t and rename
      mm/vma: rename vma_get_page_prot to vma_flags_to_page_prot
      mm: introduce vma_get_page_prot() and use it
      mm/vma: update create_init_stack_vma() to use vma_flags_t
      mm/vma: convert miscellaneous uses of VMA flags in core mm
      mm/mlock: convert mlock code to use vma_flags_t
      mm/mprotect: convert mprotect code to use vma_flags_t
      mm/mremap: convert mremap code to use vma_flags_t

Lorenzo Stoakes (ARM) (3):
      mm/mseal: remove superfluous comments, fix confusion around mm
      mm/mseal: limit scope of mseal address zero to address zero
      mm/mseal: remove further superfluous comments, do_mseal()

Manuel Ebner (1):
      docs/mm: fix braces

Markus Elfring (1):
      mm/vmalloc: use more common error handling code in pcpu_get_vm_areas()

Matthew Wilcox (Oracle) (2):
      mm: add writeback.h to docs build
      percpu_ref: fix documentation of maximum value

Mike Rapoport (Microsoft) (5):
      selftests/mm/uffd: don't treat UFFDIO_COPY -ENOENT as a failure
      mm: split out mm_init and memblock declarations from internal.h
      mm: split out sparse declarations from internal.h
      mm: split out vmalloc declarations from internal.h
      selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check

Muchun Song (20):
      mm/hugetlb: fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
      mm/hugetlb_vmemmap: fix __hugetlb_vmemmap_optimize_folios()
      powerpc/mm: fix wrong addr_pfn tracking in compound vmemmap population
      mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier
      mm/mm_init: simplify deferred_free_pages() migratetype init
      mm/sparse: panic on memmap and usemap allocation failure
      mm/sparse: move subsection_map_init() into sparse_init()
      mm/mm_init: defer sparse_init() until after zone initialization
      mm/mm_init: defer hugetlb reservation until after zone initialization
      mm/mm_init: remove set_pageblock_order() call from sparse_init()
      mm/sparse: move sparse_vmemmap_init_nid_late() into sparse_init_nid()
      mm/hugetlb_cma: validate hugetlb CMA range by zone at reserve time
      mm/hugetlb: refactor early boot gigantic hugepage allocation
      mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
      mm/hugetlb_vmemmap: move bootmem HVO setup to early init
      mm/hugetlb: remove obsolete bootmem cross-zone checks
      mm/sparse-vmemmap: remove sparse_vmemmap_init_nid_late()
      mm/hugetlb: remove unused bootmem cma field
      mm/mm_init: fold __init_page_from_nid() into __init_deferred_page()
      selftests/mm: remove obsolete hugetlb vmemmap test

Muhammad Usama Anjum (1):
      selftests/mm: unpoison pages in memory-failure teardown

Petr Tesarik (1):
      mm: let node_reclaim() return the number of pages reclaimed

Philippe Laferriere (1):
      mm/damon/stat: use secs_to_jiffies() instead of msecs_to_jiffies()

Randy Dunlap (1):
      radix-tree: add/correct some kernel-doc

Richard Chang (1):
      mm/zsmalloc: fix release order of locks in zs_page_migrate()

Ridong Chen (4):
      mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
      mm: vmscan: propagate real error code from per-node proactive reclaim
      mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
      mm/mglru: fix anon-only reclaim evicting file pages when swappiness=max

Ritesh Harjani (IBM) (1):
      include/linux/swap.h: remove unused leftovers

Ruslan Valiyev (2):
      selftests/damon/_damon_sysfs: support kdamond refresh_ms
      selftests/damon/sysfs_refresh: test kdamond refresh_ms

SJ Park (120):
      samples/damon/wsse: handle damon_start() failure
      samples/damon/prcl: handle damon_start() failure
      samples/damon/mtier: handle damon_start() failure
      samples/damon/mtier: handle damon_stop() failure
      samples/damon/wsse: stop and free damon ctx when damon_call() fails
      samples/damon/prcl: stop and free damon ctx when damon_call() fails
      mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs
      mm/damon/sysfs: kobject_del() region and target (error) dirs
      mm/damon/sysfs-schemes: kobject_del() scheme dirs
      mm/damon/sysfs-schemes: kobject_del() scheme region dirs
      mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
      mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
      mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
      mm/damon/sysfs: kobject_del() probe dirs
      mm/damon/sysfs: kobject_del() probe filter dirs
      mm/damon/sysfs: kobject_del() probe dirs in probes_addd_dir error path
      mm/damon/sysfs-schemes: kobject_del() region for populate_region error
      Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
      Docs/ABI/damon: document probe files
      mm/damon/tests/core-kunit: test damon_rand()
      selftests/damon/sysfs.sh: test multiple probe dirs creation
      selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
      selftests/damon/sysfs.sh: test dests dir
      selftests/damon/sysfs.sh: test all files in quota goal dir
      mm/damon/core: reduce range setup in damon_commit_target_regions()
      mm/damon/sysfs: split probe setup function out
      mm/damon/sysfs: split out filters setup function
      mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/
      mm/damon/core: introduce damon_nr_accesses_mvsum()
      mm/damon/tests/core-kunit: test damon_mvsum()
      mm/damon/core: always update ->last_nr_accesses for intervals change
      mm/damon/core: handle unreset nr_accesses in damon_nr_accesses_mvsum()
      mm/damon/core: use damon_nr_accesses_mvsum() in __damos_valid_target()
      mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
      mm/damon/sysfs-schemes: use damon_nr_accesses_mvsum() for damo regions
      mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
      mm/damon/core: remove damon_verify_reset_aggregated()
      mm/damon/core: remove damon_verify_merge_regions_of()
      mm/damon/tests/core-kunit: remove nr_accesses_bp setup and tests
      selftests/damon/drgn_dump_damon_status: do not dump nr_accesses_bp
      mm/damon/core: remove nr_accesses_bp setups and updates
      mm/damon/core: remove attrs param from damon_update_region_access_rate()
      mm/damon/paddr: remove attrs param from __damon_pa_check_access()
      mm/damon/vaddr: remove attrs param from __damon_va_check_access()
      mm/damon/core: remove damon_moving_sum() and its unit test
      mm/damon/core: remove damon_region->nr_accesses_bp
      mm/damon: add damon_region->last_probe_hits
      mm/damon/core: introduce damon_probe_hits_mvsum()
      mm/damon/sysfs-schemes: set probe hits as pseudo moving sums
      mm/damon/core: safely validate src on damon_commit_ctx()
      mm/damon/core: do parameter testing commit on damon_start()
      mm/damon/sysfs: remove duplicated commit input validity check
      mm/damon/reclaim: remove duplicated min_region_sz power of 2 check
      mm/damon/lru_sort: remove duplicated min_region_sz power_of_2() check
      mm/damon: document region size validation in damon_set_regions()
      mm/damon/core: remove start, end check in damon_set_region_system_rams()
      mm/damon/sysfs: remove region size validation
      mm/damon/core: stop ctxs in damon_start() before returning an error
      samples/damon/mtier: do not stop first context for damon_start() failure
      mm/damon/core: make damon_stop() never fail
      mm/damon/sysfs: ignore damon_stop() return value
      mm/damon/reclaim: ignore damon_stop() return value
      mm/damon/lru_sort: ignore damon_stop() return value
      mm/damon/core: change damon_stop() return type to void
      samples/damon/mtier: stop all contexts with single damon_stop() call
      mm/damon/core: wait ctx stop in damon_call() before reruning an error
      samples/damon/wsse: do not stop ctx for damon_call() failure
      samples/damon/prcl: do not stop DAMON for damon_call() failure
      mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero
      mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
      mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
      mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
      mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
      mm/damon/core: update probe hits for new parameter commit
      mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()
      mm/damon/core: introduce damon_probe->weight
      mm/damon/core: ask apply_probes() ops callback to set sampling address
      mm/damon/paddr: set samples in apply_probes() if requested
      mm/damon/core: ask apply_probe() to return max probe hits weighted sum
      mm/damon/core: implement damon_probe_hits_wsum()
      mm/damon/paddr: respect return_max_wsum
      mm/damon/core: use abs_diff() instead of abs()
      mm/damon/core: extend merge function to work with probe hits
      mm/damon/core: disallow probe_hits overflow on attrs only monitoring
      mm/damon/core: validate params for probe hits weighted sum overflow
      mm/damon/core: disable access monitoring when probe weights are set
      mm/damon/core: set samples in apply_probes() if probe weights are set
      mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()
      mm/damon/core: get merge threshold from probe hits when weights are set
      mm/damon/core: implement damon_has_probe_weight()
      mm/damon/sysfs: implement probe/weight file
      Docs/mm/damon/design: document attrs-only monitoring
      Docs/admin-guide/mm/damon/usage: document weight sysfs file
      Docs/ABI/damon: document probe weight file
      mm/damon/core: skip aging from repeated aggressive merging
      mm/damon/core: hide private damon_region fields
      mm/damon/core: hide private damon_target fields
      mm/damon/core: hide private damos_quota_goal fields
      mm/damon/core: hide private damos_quota fields
      mm/damon/core: hide private damos_filter fields
      mm/damon/core: hide private damos fields
      mm/damon/core: hide private damon_filter fields
      mm/damon/core: hide private damon_probe fields
      mm/damon/sysfs: do not directly access damon_ctx->ops
      mm/damon/core: hide core-private damon_ctx fields
      mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
      mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
      mm/damon/vaddr: drop last same folio access check optimization
      mm/damon/paddr: drop last same folio access check reuse optimization
      mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()
      mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()
      mm/damon/core: initialize damos->last_applied
      mm/damon/core-kunit: check region count before testing in split_at()
      mm/damon/vaddr-kunit: check region count in three_regions test
      mm/damon/core-kunit: handle region split failure in filter_out()
      mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
      mm/damon/core-kunit: skip wrong quota goal walk in commit_quota_goals()
      mm/damon/core-kunit: skip wrong region walk in commit_target_regions()
      mm/damon/ops-common: use nr_accesses moving sum for quota score
      mm/damon/core: handle region split failure in apply_min_nr_regions()

Sailesh Nandanavanam (1):
      mm/damon/tests/core-kunit: add KUnit test for walk_control_obsolete behavior

Sang-Heon Jeon (4):
      arch_numa: remove redundant nodemask clears in numa_init()
      mm/early_ioremap: clarify early_ioremap_reset() semantics
      riscv: remove unused __late_set_fixmap() and __late_clear_fixmap()
      arm64: remove early_ioremap_reset() call and __late_* macros

Sayali Patil (3):
      selftests/mm: handle EINVAL when configuring gigantic hugepages
      selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes
      selftests/mm: fix ternary operator precedence in ksm_tests

Sebastian Andrzej Siewior (2):
      zram: move lockmap to be per-zram instead per table
      zram: use a custom key for each zram object

Sergey Senozhatsky (1):
      Documentation: zram: remove sections numbering

Shivank Garg (3):
      mm/migrate: rename page to folio leftovers
      mm/migrate: fix stale list name in migrate_folios_move() comment
      mm/migrate: use migrate_info field instead of private

Song Hu (6):
      mm/damon/tests/core-kunit: test damon_nr_accesses_mvsum()
      Docs/ABI/damon: fix typo in intervals_goal sysfs path
      Docs/ABI/damon: fix typos
      Docs/ABI/damon: document update_tuned_intervals state command
      Docs/ABI/damon: document tried_regions probe hits
      mm/damon: update outdated comment about DAMOS filter handling

Stanislav Kinsburskii (9):
      lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone
      mm/hmm: move page fault handling out of walk callbacks
      mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
      selftests/mm: add HMM test for mmap lock-dropping faults
      mshv: use hmm_range_fault_unlocked_timeout() for region faults
      drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
      RDMA/umem: use hmm_range_fault_unlocked_timeout() for ODP faults
      accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
      drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults

Suren Baghdasaryan (1):
      MAINTAINERS: move inactive maintainer to CREDITS

Thomas Huth (2):
      mm: replace __ASSEMBLY__ with __ASSEMBLER__ in memory management header files
      percpu: replace __ASSEMBLY__ with __ASSEMBLER__ in percpu-defs.h header file

Usama Arif (13):
      mm/swap_state: remove unnecessary lru_add_drain() from readahead
      mm: add softleaf_to_pmd() and convert existing callers
      mm: extract mm_prepare_for_swap_entries() helper
      fs/proc: use softleaf_has_pfn() in pagemap PMD walker
      mm/huge_memory: move softleaf_to_folio() inside migration branch
      mm/migrate_device: move softleaf_to_folio() inside device-private branch
      mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES
      mm/vmpressure: skip tree=true accounting on cgroup v2
      mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c
      mm/migrate_device: pin large folios before splitting
      mm/mempolicy: skip non-present PMDs when queueing folios
      mm/madvise: skip device-private PMDs in cold and pageout walks
      mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd

Vlastimil Babka (SUSE) (2):
      mm: remove the __GFP_NO_OBJ_EXT flag
      mm: page_alloc: move capture_control to the page allocator

Wang Wensheng (1):
      ksm: stop iterating VMAs when ksm_test_exit returns true

Watson Wheeler (1):
      lib/maple_tree: add missing spaces after switch keyword

Wenchao Hao (3):
      mm/zsmalloc: encode class index in obj value for lockless class lookup
      mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
      mm/zsmalloc: document free_zspage helper variants

Wentao Guan (1):
      mm/hugetlb: avoid unnecessary TLB flush for empty folio list in vmemmap optimize

Xuewen Wang (2):
      mm: annotate data-race in cpu_needs_drain()
      mm/damon: remove trailing semicolons after function definitions

Xueyuan Chen (1):
      mm/zsmalloc: drop class lock before freeing zspage

Ye Liu (9):
      mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
      mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
      mm: use enum migrate_reason instead of int for migration reason parameters
      mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
      mm/page_owner: add missing newline to count_threshold format string
      mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
      mm/page_owner: drop redundant page_owner prefix from static symbols
      mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
      mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()

Yichong Chen (6):
      tools/mm/page_owner_sort: return explicit filter results
      tools/mm/page_owner_sort: free per-record allocations
      tools/mm/page_owner_sort: bound pattern output copies
      hugetlbfs: release subpool on fill_super failure
      hugetlb: make hugepage_put_subpool() tolerate NULL
      hugetlb: evaluate subpool free state while locked

Yijia Wang (1):
      selftests: mincore: count file-mmap readahead on both sides

Youngjun Park (1):
      mm/swap: clarify unreachable cond_resched() in swap_reclaim_full_clusters

Yousef Alhouseen (1):
      tmpfs: zero unused folio tail for long symlinks

Zenghui Yu (1):
      tools/mm: add thp_swap_allocator_test binary to .gitignore

Zenghui Yu (Huawei) (2):
      MAINTAINERS: add ABI docs and selftests to ZRAM entry
      docs/mm: Physical Memory: remove deferred_split_queue

Zhen Ni (4):
      mm/page_owner: add print_mode filter
      mm/page_owner: add NUMA node filter
      tools/mm: add page_owner_filter userspace tool
      mm/page_owner: document page_owner filter

Zhen Yan (1):
      mm: fix mapping_seek_hole_data() overflow on last page

Zi Yan (5):
      mm/percpu-km: clear page->private before free them
      mm/compaction: stop recording free page order in page->private
      mm/huge_memory: add page->private check back in __split_folio_to_order()
      mm/page_alloc: make sure tail_page->private is zero at page free time
      mm/page_alloc: remove set_page_private() in prep_compound_tail()

longlong yan (2):
      selftests/mm: use MAP_FAILED for mmap error check
      selftests/mm/pagemap_ioctl: fix missing NULL checks after calloc()

wang wei (1):
      selftests/damon: check correct path in ensure_file() not_exist case

xu xin (7):
      ksm: add linear_page_index into ksm_rmap_item
      ksm: optimize rmap_walk_ksm by passing a suitable page index
      ksm: add mremap selftests for ksm_rmap_walk
      mm/ksm: initialize the addr only once in collect_procs_ksm
      ksm: use precise linear_page_index instead of the whole address space
      mm/mm_slot.h: add a helper function mm_slot_remove
      mm/mm_slot.h: add comments for mm_slot_lookup/insert

yahia ahmed (1):
      mm/shmem: fix data-race in shmem_fault

zhaozhengzhuo (1):
      selftests/mm: fix gup_longterm EINVAL error message

 CREDITS                                            |    4 +
 Documentation/ABI/testing/sysfs-block-zram         |    6 +-
 Documentation/ABI/testing/sysfs-bus-dax            |   24 +
 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   75 +-
 Documentation/admin-guide/blockdev/zram.rst        |   40 +-
 Documentation/admin-guide/cgroup-v1/cpusets.rst    |    2 +-
 Documentation/admin-guide/mm/damon/usage.rst       |   19 +-
 Documentation/admin-guide/mm/pagemap.rst           |   13 +-
 Documentation/admin-guide/mm/transhuge.rst         |    2 +-
 Documentation/admin-guide/mm/userfaultfd.rst       |  269 +++++-
 Documentation/admin-guide/sysctl/vm.rst            |   83 +-
 Documentation/core-api/mm-api.rst                  |    3 +-
 Documentation/driver-api/basics.rst                |    3 +
 Documentation/filesystems/proc.rst                 |    1 +
 Documentation/mm/damon/design.rst                  |   43 +-
 Documentation/mm/hmm.rst                           |   81 +-
 Documentation/mm/page_owner.rst                    |   78 +-
 Documentation/mm/physical_memory.rst               |    3 -
 Documentation/mm/process_addrs.rst                 |    2 +-
 Documentation/userspace-api/mseal.rst              |   14 +-
 MAINTAINERS                                        |   34 +-
 arch/arm/mm/fault-armv.c                           |    4 +-
 arch/arm/mm/flush.c                                |    2 +-
 arch/arm64/Kconfig                                 |    3 +-
 arch/arm64/include/asm/fixmap.h                    |    3 -
 arch/arm64/include/asm/pgtable-prot.h              |    8 +-
 arch/arm64/include/asm/pgtable.h                   |   51 +-
 arch/arm64/kernel/setup.c                          |    2 -
 arch/csky/abiv1/inc/abi/cacheflush.h               |    7 +-
 arch/loongarch/Kconfig                             |    3 +-
 arch/loongarch/include/asm/pgtable.h               |    4 +-
 arch/mips/kernel/vdso.c                            |    4 +-
 arch/nios2/mm/cacheflush.c                         |    2 +-
 arch/parisc/kernel/cache.c                         |    2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   10 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |    7 +-
 arch/powerpc/mm/book3s64/slice.c                   |    6 +-
 arch/powerpc/mm/hugetlbpage.c                      |   13 +-
 arch/powerpc/platforms/Kconfig.cputype             |    3 +-
 arch/riscv/Kconfig                                 |    3 +-
 arch/riscv/include/asm/fixmap.h                    |    3 -
 arch/riscv/include/asm/pgtable-bits.h              |   12 +-
 arch/riscv/include/asm/pgtable.h                   |   67 +-
 arch/s390/Kconfig                                  |    3 +-
 arch/s390/include/asm/hugetlb.h                    |   12 +-
 arch/s390/include/asm/pgtable.h                    |    6 +-
 arch/s390/mm/vmem.c                                |    4 +-
 arch/sparc/include/asm/pgtable_64.h                |    4 -
 arch/x86/Kconfig                                   |    3 +-
 arch/x86/events/intel/ds.c                         |    6 +-
 arch/x86/include/asm/pgtable.h                     |   58 +-
 arch/x86/include/asm/pgtable_types.h               |   16 +-
 arch/x86/kernel/cpu/sgx/virt.c                     |    3 +-
 arch/x86/kvm/vmx/vmx.c                             |    2 +-
 arch/x86/mm/init_64.c                              |  134 +--
 arch/x86/virt/hw.c                                 |    2 +-
 drivers/accel/amdxdna/aie2_ctx.c                   |   23 +-
 drivers/base/arch_numa.c                           |    4 -
 drivers/base/memory.c                              |    9 +
 drivers/block/zram/zram_drv.c                      |   26 +-
 drivers/block/zram/zram_drv.h                      |    3 +-
 drivers/dax/bus.h                                  |    2 +
 drivers/dax/kmem.c                                 |  500 ++++++++--
 drivers/gpu/drm/drm_gem.c                          |    2 +-
 drivers/gpu/drm/drm_gem_dma_helper.c               |    2 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |    2 +-
 drivers/gpu/drm/drm_gpusvm.c                       |   60 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |    5 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |    6 +-
 drivers/gpu/drm/gma500/gem.c                       |    2 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   12 +-
 drivers/gpu/drm/msm/msm_gem.c                      |    5 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |   20 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c               |    2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   11 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |    2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |    2 +-
 drivers/gpu/drm/tegra/gem.c                        |    5 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |    7 +-
 drivers/gpu/drm/virtio/virtgpu_vram.c              |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c         |    2 +-
 drivers/gpu/drm/xe/xe_device.c                     |    2 +-
 drivers/gpu/drm/xe/xe_mmio_gem.c                   |    2 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c            |    2 +-
 drivers/hv/mshv_regions.c                          |   54 +-
 drivers/infiniband/core/umem_odp.c                 |   18 +-
 drivers/misc/sgi-xp/xpc_uv.c                       |    5 +-
 drivers/net/ethernet/fungible/funeth/funeth_rx.c   |    2 +-
 drivers/vfio/pci/nvgrace-gpu/main.c                |    3 +-
 drivers/vfio/pci/vfio_pci_core.c                   |    3 +-
 drivers/video/fbdev/core/fb_io_fops.c              |    2 +-
 fs/aio.c                                           |    2 +-
 fs/binfmt_elf.c                                    |    7 +-
 fs/dax.c                                           |    2 +-
 fs/hugetlbfs/inode.c                               |   23 +-
 fs/proc/page.c                                     |   56 +-
 fs/proc/task_mmu.c                                 |  119 ++-
 include/asm-generic/fixmap.h                       |    4 +-
 include/asm-generic/getorder.h                     |    4 +-
 include/asm-generic/hugetlb.h                      |   18 +-
 include/asm-generic/memory_model.h                 |    6 +-
 include/asm-generic/mmu.h                          |    2 +-
 include/asm-generic/pgtable-nop4d.h                |    4 +-
 include/asm-generic/pgtable-nopmd.h                |    4 +-
 include/asm-generic/pgtable-nopud.h                |    4 +-
 include/asm-generic/pgtable_uffd.h                 |   32 +-
 include/linux/alloc_tag.h                          |    4 +-
 include/linux/backing-dev.h                        |    2 -
 include/linux/bootmem_info.h                       |   89 --
 include/linux/compaction.h                         |    3 +-
 include/linux/cpuset.h                             |    4 +-
 include/linux/damon.h                              |  173 ++--
 include/linux/gfp.h                                |   55 +-
 include/linux/gfp_types.h                          |   12 +-
 include/linux/hmm.h                                |    2 +
 include/linux/huge_mm.h                            |   56 +-
 include/linux/hugetlb.h                            |   57 +-
 include/linux/hugetlb_cgroup.h                     |    2 +-
 include/linux/leafops.h                            |   32 +-
 include/linux/memfd.h                              |    6 +-
 include/linux/memory.h                             |   27 +
 include/linux/memory_hotplug.h                     |   16 +-
 include/linux/migrate.h                            |    8 +-
 include/linux/migrate_mode.h                       |    1 +
 include/linux/mm.h                                 |  281 ++++--
 include/linux/mm_inline.h                          |   57 +-
 include/linux/mm_types.h                           |    3 +
 include/linux/mmap_lock.h                          |    8 +
 include/linux/mmzone.h                             |   43 +-
 include/linux/oom.h                                |    2 +-
 include/linux/page-flags.h                         |   14 -
 include/linux/page_owner.h                         |    7 +-
 include/linux/pagemap.h                            |   35 +-
 include/linux/percpu-defs.h                        |    4 +-
 include/linux/percpu-refcount.h                    |    5 +-
 include/linux/pfn.h                                |    2 +-
 include/linux/pgtable.h                            |   71 +-
 include/linux/radix-tree.h                         |    5 +-
 include/linux/sched/mm.h                           |   13 +-
 include/linux/skbuff.h                             |    2 +-
 include/linux/swap.h                               |   83 +-
 include/linux/swapops.h                            |   10 +-
 include/linux/userfaultfd_k.h                      |  106 +-
 include/linux/vmalloc.h                            |    4 +-
 include/linux/vmpressure.h                         |   46 +-
 include/linux/writeback.h                          |    2 +-
 include/trace/events/damon.h                       |    8 +-
 include/trace/events/huge_memory.h                 |    2 +-
 include/trace/events/migrate.h                     |   11 +-
 include/trace/events/mmflags.h                     |   17 +-
 include/trace/events/pagemap.h                     |    8 +
 include/uapi/linux/fs.h                            |    1 +
 include/uapi/linux/mempolicy.h                     |    2 +-
 include/uapi/linux/userfaultfd.h                   |   54 +-
 init/Kconfig                                       |   10 +-
 ipc/shm.c                                          |    3 +-
 kernel/cgroup/cpuset.c                             |   15 +-
 kernel/dma/coherent.c                              |    7 +-
 kernel/dma/direct.c                                |    6 +-
 kernel/dma/mapping.c                               |    8 +-
 kernel/dma/ops_helpers.c                           |    4 +-
 kernel/events/core.c                               |   20 +-
 kernel/events/uprobes.c                            |   13 +-
 kernel/kcov.c                                      |    2 +-
 kernel/liveupdate/kexec_handover.c                 |    3 +-
 kernel/trace/ring_buffer.c                         |    3 +-
 lib/Kconfig.debug                                  |   28 -
 lib/Makefile                                       |    1 -
 lib/maple_tree.c                                   |    8 +-
 lib/percpu-refcount.c                              |    2 +-
 lib/test_hmm.c                                     |  109 ++-
 lib/test_hmm_uapi.h                                |    1 +
 mm/Kconfig                                         |   20 +-
 mm/Kconfig.debug                                   |   28 +
 mm/Makefile                                        |    4 +-
 mm/alloc_tag.c                                     | 1020 ++++++++++++++++++++
 mm/bootmem_info.c                                  |   72 --
 mm/cma.c                                           |    4 +-
 mm/compaction.c                                    |  106 +-
 mm/damon/core.c                                    |  662 ++++++++-----
 mm/damon/lru_sort.c                                |   13 +-
 mm/damon/ops-common.c                              |    9 +-
 mm/damon/paddr.c                                   |   38 +-
 mm/damon/reclaim.c                                 |   11 +-
 mm/damon/stat.c                                    |    2 +-
 mm/damon/sysfs-schemes.c                           |   31 +-
 mm/damon/sysfs.c                                   |  202 ++--
 mm/damon/tests/core-kunit.h                        |  275 +++++-
 mm/damon/tests/vaddr-kunit.h                       |    5 +
 mm/damon/vaddr.c                                   |   44 +-
 mm/debug.c                                         |    7 +-
 mm/debug_vm_pgtable.c                              |   16 +-
 mm/early_ioremap.c                                 |   10 +-
 mm/execmem.c                                       |    1 +
 mm/filemap.c                                       |   50 +-
 mm/{swap.c => folio.c}                             |   68 +-
 mm/gup.c                                           |   13 +-
 mm/hmm.c                                           |  266 +++--
 mm/huge_memory.c                                   |  227 +++--
 mm/hugetlb.c                                       |  715 ++++++++------
 mm/hugetlb_cma.c                                   |   44 +-
 mm/hugetlb_cma.h                                   |    8 +-
 mm/hugetlb_vmemmap.c                               |  127 +--
 mm/hugetlb_vmemmap.h                               |    5 -
 mm/internal.h                                      |  612 +++---------
 mm/interval_tree.c                                 |  111 ++-
 mm/kasan/hw_tags.c                                 |    2 +-
 mm/khugepaged.c                                    |   85 +-
 mm/kmemleak.c                                      |   91 +-
 mm/kmsan/hooks.c                                   |    1 +
 mm/kmsan/init.c                                    |    2 +-
 mm/kmsan/shadow.c                                  |    1 +
 mm/ksm.c                                           |   97 +-
 mm/madvise.c                                       |   16 +-
 mm/mapping_dirty_helpers.c                         |    2 +-
 mm/memblock.c                                      |    1 +
 mm/memcontrol-v1.c                                 |  309 +++++-
 mm/memcontrol-v1.h                                 |    6 -
 mm/memcontrol.c                                    |   48 +-
 mm/memfd.c                                         |   16 +-
 mm/memory-failure.c                                |  119 ++-
 mm/memory.c                                        |  328 +++++--
 mm/memory_hotplug.c                                |  167 +++-
 mm/mempolicy.c                                     |   32 +-
 mm/migrate.c                                       |   97 +-
 mm/migrate_device.c                                |   42 +-
 mm/mincore.c                                       |   75 +-
 mm/mlock.c                                         |  101 +-
 mm/mm_init.c                                       |  104 +-
 mm/mm_init.h                                       |  120 +++
 mm/mm_slot.h                                       |   11 +
 mm/mmap.c                                          |  205 ++--
 mm/mmu_notifier.c                                  |    2 +-
 mm/mmzone.c                                        |    5 +-
 mm/mprotect.c                                      |  117 ++-
 mm/mremap.c                                        |   67 +-
 mm/mseal.c                                         |  160 ++-
 mm/msync.c                                         |    4 +-
 mm/nommu.c                                         |   64 +-
 mm/page-writeback.c                                |   10 -
 mm/page_alloc.c                                    |  500 ++++++----
 mm/page_alloc.h                                    |  312 ++++++
 mm/page_frag_cache.c                               |    6 +-
 mm/page_isolation.c                                |    1 +
 mm/page_owner.c                                    |  303 ++++--
 mm/page_reporting.c                                |    1 +
 mm/page_table_check.c                              |    8 +-
 mm/page_vma_mapped.c                               |    8 +-
 mm/pagewalk.c                                      |    4 +-
 mm/percpu-km.c                                     |    9 +-
 mm/percpu-vm.c                                     |   49 +-
 mm/percpu.c                                        |   20 +-
 mm/rmap.c                                          |  481 ++++-----
 mm/secretmem.c                                     |    2 +-
 mm/shmem.c                                         |   30 +-
 mm/show_mem.c                                      |   10 +-
 mm/shuffle.c                                       |    1 +
 mm/slab.h                                          |    2 +-
 mm/slub.c                                          |   17 +-
 mm/sparse-vmemmap.c                                |   28 +-
 mm/sparse.c                                        |   53 +-
 mm/sparse.h                                        |   63 ++
 mm/swap.h                                          |    6 +-
 mm/swap_state.c                                    |   52 +-
 mm/swapfile.c                                      |   31 +-
 mm/userfaultfd.c                                   |  393 +++++++-
 mm/util.c                                          |   14 +-
 mm/vma.c                                           |  307 ++++--
 mm/vma.h                                           |   88 +-
 mm/vma_exec.c                                      |   32 +-
 mm/vma_init.c                                      |    6 +-
 mm/vma_internal.h                                  |    4 +-
 mm/vmalloc.c                                       |   32 +-
 mm/vmalloc.h                                       |   46 +
 mm/vmpressure.c                                    |  301 +-----
 mm/vmscan.c                                        |   89 +-
 mm/vmstat.c                                        |    3 +-
 mm/zsmalloc.c                                      |  243 ++++-
 samples/damon/Kconfig                              |    2 +-
 samples/damon/mtier.c                              |    9 +-
 samples/damon/prcl.c                               |    9 +-
 samples/damon/wsse.c                               |    9 +-
 scripts/gdb/linux/page_owner.py                    |    4 +-
 sound/core/memalloc.c                              |    2 +-
 tools/include/linux/gfp_types.h                    |    7 -
 tools/include/uapi/linux/fs.h                      |    1 +
 tools/include/uapi/linux/userfaultfd.h             |   54 +-
 tools/mm/.gitignore                                |    1 +
 tools/mm/Makefile                                  |    4 +-
 tools/mm/page_owner_filter.c                       |  310 ++++++
 tools/mm/page_owner_sort.c                         |   87 +-
 tools/testing/memblock/internal.h                  |   20 -
 tools/testing/memblock/mm_init.h                   |   24 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/damon/Makefile             |    1 +
 tools/testing/selftests/damon/_damon_sysfs.py      |   23 +-
 .../selftests/damon/damos_apply_interval.py        |    2 +-
 tools/testing/selftests/damon/damos_quota_goal.py  |    2 +-
 .../testing/selftests/damon/damos_tried_regions.py |    4 +-
 .../selftests/damon/drgn_dump_damon_status.py      |    3 +-
 tools/testing/selftests/damon/sysfs.py             |   35 +-
 tools/testing/selftests/damon/sysfs.sh             |   79 +-
 tools/testing/selftests/damon/sysfs_refresh.py     |   75 ++
 ..._update_schemes_tried_regions_wss_estimation.py |    2 +-
 tools/testing/selftests/dax/Makefile               |    6 +
 tools/testing/selftests/dax/config                 |    4 +
 tools/testing/selftests/dax/dax-kmem-hotplug.sh    |  317 ++++++
 tools/testing/selftests/dax/settings               |    1 +
 tools/testing/selftests/mincore/mincore_selftest.c |   12 +-
 tools/testing/selftests/mm/Makefile                |    1 -
 tools/testing/selftests/mm/gup_longterm.c          |    2 +-
 tools/testing/selftests/mm/hmm-tests.c             |  792 +++++++--------
 tools/testing/selftests/mm/hugepage_settings.c     |    2 +-
 tools/testing/selftests/mm/hugetlb-vmemmap.c       |  132 ---
 tools/testing/selftests/mm/ksm_tests.c             |   28 +-
 tools/testing/selftests/mm/memory-failure.c        |   44 +-
 tools/testing/selftests/mm/mremap_dontunmap.c      |    2 +-
 tools/testing/selftests/mm/mseal_test.c            |  106 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  110 ++-
 tools/testing/selftests/mm/pkey-helpers.h          |    4 +-
 tools/testing/selftests/mm/pkey-powerpc.h          |    2 +-
 tools/testing/selftests/mm/pkey_sighandler_tests.c |  115 ++-
 tools/testing/selftests/mm/pkey_util.c             |   90 ++
 tools/testing/selftests/mm/protection_keys.c       |   99 +-
 tools/testing/selftests/mm/rmap.c                  |   81 ++
 tools/testing/selftests/mm/run_vmtests.sh          |    3 +-
 tools/testing/selftests/mm/thuge-gen.c             |   15 +-
 tools/testing/selftests/mm/uffd-common.c           |    9 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |  919 ++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c               |   26 +-
 tools/testing/selftests/mm/vm_util.h               |    1 +
 tools/testing/vma/Makefile                         |    2 +-
 tools/testing/vma/include/dup.h                    |   52 +-
 tools/testing/vma/include/stubs.h                  |   16 +-
 tools/testing/vma/shared.c                         |    9 -
 tools/testing/vma/shared.h                         |   43 +-
 tools/testing/vma/tests/merge.c                    |   40 +-
 tools/testing/vma/vma_internal.h                   |    4 +-
 virt/kvm/guest_memfd.c                             |    2 +-
 340 files changed, 12482 insertions(+), 6334 deletions(-)
 delete mode 100644 include/linux/bootmem_info.h
 create mode 100644 mm/alloc_tag.c
 delete mode 100644 mm/bootmem_info.c
 rename mm/{swap.c => folio.c} (95%)
 create mode 100644 mm/mm_init.h
 create mode 100644 mm/page_alloc.h
 create mode 100644 mm/sparse.h
 create mode 100644 mm/vmalloc.h
 create mode 100644 tools/mm/page_owner_filter.c
 create mode 100644 tools/testing/memblock/mm_init.h
 create mode 100755 tools/testing/selftests/damon/sysfs_refresh.py
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings
 delete mode 100644 tools/testing/selftests/mm/hugetlb-vmemmap.c

