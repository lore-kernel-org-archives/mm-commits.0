Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE69204C3B;
	Wed, 30 Jul 2025 22:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753914487; cv=none; b=fEAFoSMZhRIImPDTos145jnkc2PXx6YFqMnJ+i3sOqMRoPMAXX63MtHqN8O1dU1Nj3GsBmwrfN/IsXnlpLwcnqkvXVjdsFZ4A4gNJrFWWe4psypJiTWX6YSi7pIY/u5mpPDanlQgaNUYyi0++BowHlraDlsGaqX461OHaKavpDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753914487; c=relaxed/simple;
	bh=57icp3RxAcxkXM41IG0brjrJlBx06NqrGnIy/A0QIuM=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Zh1oelIIL6+X1Eb3AE52lPa3UuZ+fiR+kJDdmLu5u1MtcQn1IAetMhiFlmQ8tojyOdS7wc0wlavcb2k3KnjXMmfZ0/P9TCcxOIR7t/llX2pM0gbWa2VFkw5K5GceNlggxcG2qN+6iraVlsq6UqmMxcsoRIaqNE1z8I6cDfVYOmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9iSGgdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9iSGgdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89E9C4CEE3;
	Wed, 30 Jul 2025 22:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753914487;
	bh=57icp3RxAcxkXM41IG0brjrJlBx06NqrGnIy/A0QIuM=;
	h=Date:From:To:Cc:Subject:From;
	b=p9iSGgdx/newfPPTWkWjf1y3rR7IWtmFauRQTuN6QbJ9+B9r+3INaRQQHMYwMyWbF
	 QZqP9jzAR47fQNT6hE8YOuzYvnquybCRL6bK/MfKKVlhph8zEACKolgG8gQaZoFZ+/
	 jVlZipVQMahRA8rB189L02h5dad8rM08cxeqD12I=
Date: Wed, 30 Jul 2025 15:28:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 6.17-rc1
Message-Id: <20250730152806.16f5c618e3af0d3b8dea3159@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull the first batch of MM updates for the 6.17-rc1 merge
window.

I'm planning a second (significantly smaller) batch for next week.  For
somewhat late-arriving material which might benefit from a little more
test and review time.

As usual, many cleanups.  The below blurbiage describes 42 patchsets. 
21 of those are partially or fully cleanup work.  "cleans up",
"cleanup", "maintainability", "rationalizes", etc.  I never knew the MM
code was so dirty.

Thanks!


Conflicts which I'm presently seeing, along with their linux-next
resolutions:

include/linux/proc_fs.h, vs fs-next tree:
https://lkml.kernel.org/r/20250616105846.45af3a7b@canb.auug.org.au



Forthcoming conflicts of which I am aware are:

.mailmap, vs riscv-fixes tree:
https://lkml.kernel.org/r/20250623101407.4fe17973@canb.auug.org.au

kernel/panic.c, vs sysctl tree:
https://lkml.kernel.org/r/20250708190003.4eabc8ab@canb.auug.org.au

fs/proc/page.c, vs slab tree:
https://lkml.kernel.org/r/20250721142001.3d1c8777@canb.auug.org.au

lib/Kconfig.debug, vs paulmck tree:
https://lkml.kernel.org/r/20250729104245.6be6957a@canb.auug.org.au



The following changes since commit db6cc3f4ac2e6cdc898fc9cbc8b32ae1bf56bdad:

  Revert "sched/numa: add statistics of numa balance task" (2025-07-09 21:07:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-07-30-15-25

for you to fetch changes up to af915c3c13b64d196d1c305016092f5da20942c4:

  MAINTAINERS: add missing headers to mempory policy & migration section (2025-07-26 15:08:24 -0700)

----------------------------------------------------------------
Summary of significant series in this pull request:

- The 4 patch series "mm: ksm: prevent KSM from breaking merging of new
  VMAs" from Lorenzo Stoakes addresses an issue with KSM's
  PR_SET_MEMORY_MERGE mode: newly mapped VMAs were not eligible for
  merging with existing adjacent VMAs.

- The 4 patch series "mm/damon: introduce DAMON_STAT for simple and
  practical access monitoring" from SeongJae Park adds a new kernel module
  which simplifies the setup and usage of DAMON in production
  environments.

- The 6 patch series "stop passing a writeback_control to swap/shmem
  writeout" from Christoph Hellwig is a cleanup to the writeback code
  which removes a couple of pointers from struct writeback_control.

- The 7 patch series "drivers/base/node.c: optimization and cleanups"
  from Donet Tom contains largely uncorrelated cleanups to the NUMA node
  setup and management code.

- The 4 patch series "mm: userfaultfd: assorted fixes and cleanups" from
  Tal Zussman does some maintenance work on the userfaultfd code.

- The 5 patch series "Readahead tweaks for larger folios" from Ryan
  Roberts implements some tuneups for pagecache readahead when it is
  reading into order>0 folios.

- The 4 patch series "selftests/mm: Tweaks to the cow test" from Mark
  Brown provides some cleanups and consistency improvements to the
  selftests code.

- The 4 patch series "Optimize mremap() for large folios" from Dev Jain
  does that.  A 37% reduction in execution time was measured in a
  memset+mremap+munmap microbenchmark.

- The 5 patch series "Remove zero_user()" from Matthew Wilcox expunges
  zero_user() in favor of the more modern memzero_page().

- The 3 patch series "mm/huge_memory: vmf_insert_folio_*() and
  vmf_insert_pfn_pud() fixes" from David Hildenbrand addresses some warts
  which David noticed in the huge page code.  These were not known to be
  causing any issues at this time.

- The 3 patch series "mm/damon: use alloc_migrate_target() for
  DAMOS_MIGRATE_{HOT,COLD" from SeongJae Park provides some cleanup and
  consolidation work in DAMON.

- The 3 patch series "use vm_flags_t consistently" from Lorenzo Stoakes
  uses vm_flags_t in places where we were inappropriately using other
  types.

- The 3 patch series "mm/memfd: Reserve hugetlb folios before
  allocation" from Vivek Kasireddy increases the reliability of large page
  allocation in the memfd code.

- The 14 patch series "mm: Remove pXX_devmap page table bit and pfn_t
  type" from Alistair Popple removes several now-unneeded PFN_* flags.

- The 5 patch series "mm/damon: decouple sysfs from core" from SeongJae
  Park implememnts some cleanup and maintainability work in the DAMON
  sysfs layer.

- The 5 patch series "madvise cleanup" from Lorenzo Stoakes does quite a
  lot of cleanup/maintenance work in the madvise() code.

- The 4 patch series "madvise anon_name cleanups" from Vlastimil Babka
  provides additional cleanups on top or Lorenzo's effort.

- The 11 patch series "Implement numa node notifier" from Oscar Salvador
  creates a standalone notifier for NUMA node memory state changes.
  Previously these were lumped under the more general memory on/offline
  notifier.

- The 6 patch series "Make MIGRATE_ISOLATE a standalone bit" from Zi Yan
  cleans up the pageblock isolation code and fixes a potential issue which
  doesn't seem to cause any problems in practice.

- The 5 patch series "selftests/damon: add python and drgn based DAMON
  sysfs functionality tests" from SeongJae Park adds additional drgn- and
  python-based DAMON selftests which are more comprehensive than the
  existing selftest suite.

- The 5 patch series "Misc rework on hugetlb faulting path" from Oscar
  Salvador fixes a rather obscure deadlock in the hugetlb fault code and
  follows that fix with a series of cleanups.

- The 3 patch series "cma: factor out allocation logic from
  __cma_declare_contiguous_nid" from Mike Rapoport rationalizes and cleans
  up the highmem-specific code in the CMA allocator.

- The 28 patch series "mm/migration: rework movable_ops page migration
  (part 1)" from David Hildenbrand provides cleanups and
  future-preparedness to the migration code.

- The 2 patch series "mm/damon: add trace events for auto-tuned
  monitoring intervals and DAMOS quota" from SeongJae Park adds some
  tracepoints to some DAMON auto-tuning code.

- The 6 patch series "mm/damon: fix misc bugs in DAMON modules" from
  SeongJae Park does that.

- The 6 patch series "mm/damon: misc cleanups" from SeongJae Park also
  does what it claims.

- The 4 patch series "mm: folio_pte_batch() improvements" from David
  Hildenbrand cleans up the large folio PTE batching code.

- The 13 patch series "mm/damon/vaddr: Allow interleaving in
  migrate_{hot,cold} actions" from SeongJae Park facilitates dynamic
  alteration of DAMON's inter-node allocation policy.

- The 3 patch series "Remove unmap_and_put_page()" from Vishal Moola
  provides a couple of page->folio conversions.

- The 4 patch series "mm: per-node proactive reclaim" from Davidlohr
  Bueso implements a per-node control of proactive reclaim - beyond the
  current memcg-based implementation.

- The 14 patch series "mm/damon: remove damon_callback" from SeongJae
  Park replaces the damon_callback interface with a more general and
  powerful damon_call()+damos_walk() interface.

- The 10 patch series "mm/mremap: permit mremap() move of multiple VMAs"
  from Lorenzo Stoakes implements a number of mremap cleanups (of course)
  in preparation for adding new mremap() functionality: newly permit the
  remapping of multiple VMAs when the user is specifying MREMAP_FIXED.  It
  still excludes some specialized situations where this cannot be
  performed reliably.

- The 3 patch series "drop hugetlb_free_pgd_range()" from Anthony Yznaga
  switches some sparc hugetlb code over to the generic version and removes
  the thus-unneeded hugetlb_free_pgd_range().

- The 4 patch series "mm/damon/sysfs: support periodic and automated
  stats update" from SeongJae Park augments the present
  userspace-requested update of DAMON sysfs monitoring files.  Automatic
  update is now provided, along with a tunable to control the update
  interval.

- The 4 patch series "Some randome fixes and cleanups to swapfile" from
  Kemeng Shi does what is claims.

- The 4 patch series "mm: introduce snapshot_page" from Luiz Capitulino
  and David Hildenbrand provides (and uses) a means by which debug-style
  functions can grab a copy of a pageframe and inspect it locklessly
  without tripping over the races inherent in operating on the live
  pageframe directly.

- The 6 patch series "use per-vma locks for /proc/pid/maps reads" from
  Suren Baghdasaryan addresses the large contention issues which can be
  triggered by reads from that procfs file.  Latencies are reduced by more
  than half in some situations.  The series also introduces several new
  selftests for the /proc/pid/maps interface.

- The 6 patch series "__folio_split() clean up" from Zi Yan cleans up
  __folio_split()!

- The 7 patch series "Optimize mprotect() for large folios" from Dev
  Jain provides some quite large (>3x) speedups to mprotect() when dealing
  with large folios.

- The 2 patch series "selftests/mm: reuse FORCE_READ to replace "asm
  volatile("" : "+r" (XXX));" and some cleanup" from wang lian does some
  cleanup work in the selftests code.

- The 3 patch series "tools/testing: expand mremap testing" from Lorenzo
  Stoakes extends the mremap() selftest in several ways, including adding
  more checking of Lorenzo's recently added "permit mremap() move of
  multiple VMAs" feature.

- The 22 patch series "selftests/damon/sysfs.py: test all parameters"
  from SeongJae Park extends the DAMON sysfs interface selftest so that it
  tests all possible user-requested parameters.  Rather than the present
  minimal subset.

----------------------------------------------------------------
Alistair Popple (14):
      mm: convert pXd_devmap checks to vma_is_dax
      mm: filter zone device pages returned from folio_walk_start()
      mm: remove remaining uses of PFN_DEV
      mm: convert vmf_insert_mixed() from using pte_devmap to pte_special
      mm/gup: remove pXX_devmap usage from get_user_pages()
      mm/huge_memory: remove pXd_devmap usage from insert_pXd_pfn()
      mm: remove redundant pXd_devmap calls
      mm/khugepaged: remove redundant pmd_devmap() check
      powerpc: remove checks for devmap pages and PMDs/PUDs
      fs/dax: remove FS_DAX_LIMITED config option
      mm: remove devmap related functions and page table bits
      mm: remove PFN_DEV, PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and PFN_SG_LAST
      mm: remove callers of pfn_t functionality
      mm/memremap: remove unused devmap_managed_key

Andrew Morton (1):
      Merge branch 'mm-hotfixes-stable' into mm-stable to pick up changes which are required for a merge of the series "mm: folio_pte_batch() improvements".

Andy Shevchenko (1):
      mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery

Anshuman Khandual (2):
      mm/ptdump: take the memory hotplug lock inside ptdump_walk_pgd()
      fs/Kconfig: enable HUGETLBFS only if ARCH_SUPPORTS_HUGETLBFS

Anthony Yznaga (3):
      sparc64: remove hugetlb_free_pgd_range()
      mm: remove call to hugetlb_free_pgd_range()
      mm: drop hugetlb_free_pgd_range()

Arnd Bergmann (1):
      lib/test_hmm: reduce stack usage

Baolin Wang (4):
      selftests: khugepaged: fix the shmem collapse failure
      selftests: mm: add shmem collapse as a default test item
      mm: huge_memory: fix the check for allowed huge orders in shmem
      mm: fault in complete folios instead of individual pages for tmpfs

Barry Song (3):
      mm: madvise: use walk_page_range_vma() instead of walk_page_range()
      mm: use per_vma lock for MADV_DONTNEED
      mm: madvise: use per_vma lock for MADV_FREE

Bijan Tabatabai (8):
      mm/damon/core: commit damos->target_nid
      mm/damon/core: commit damos->migrate_dests
      mm/damon: move migration helpers from paddr to ops-common
      mm/damon/vaddr: add vaddr versions of migrate_{hot,cold}
      Docs/mm/damon/design: document vaddr support for migrate_{hot,cold}
      mm/damon/vaddr: use damos->migrate_dests in migrate_{hot,cold}
      mm/damon: move folio filtering from paddr to ops-common
      mm/damon/vaddr: apply filters in migrate_{hot/cold}

Caleb Sander Mateos (1):
      mm: remove unused mmap tracepoints

Casey Chen (1):
      alloc_tag: remove empty module tag section

Chi Zhiling (2):
      readahead: fix return value of page_cache_next_miss() when no hole is found
      readahead: use folio_nr_pages() instead of shift operation

Christoph Hellwig (6):
      mm: split out a writeout helper from pageout
      mm: stop passing a writeback_control structure to shmem_writeout
      mm: tidy up swap_writeout
      mm: stop passing a writeback_control structure to __swap_writepage
      mm: stop passing a writeback_control structure to swap_writeout
      mm: remove the for_reclaim field from struct writeback_control

David Hildenbrand (38):
      mm/gup: remove (VM_)BUG_ONs
      mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()
      mm/huge_memory: don't mark refcounted folios special in vmf_insert_folio_pmd()
      mm/huge_memory: don't mark refcounted folios special in vmf_insert_folio_pud()
      mm/balloon_compaction: we cannot have isolated pages in the balloon list
      mm/balloon_compaction: convert balloon_page_delete() to balloon_page_finalize()
      mm/zsmalloc: drop PageIsolated() related VM_BUG_ONs
      mm/page_alloc: let page freeing clear any set page type
      mm/balloon_compaction: make PageOffline sticky until the page is freed
      mm/zsmalloc: make PageZsmalloc() sticky until the page is freed
      mm/migrate: rename isolate_movable_page() to isolate_movable_ops_page()
      mm/migrate: rename putback_movable_folio() to putback_movable_ops_page()
      mm/migrate: factor out movable_ops page handling into migrate_movable_ops_page()
      mm/migrate: remove folio_test_movable() and folio_movable_ops()
      mm/migrate: move movable_ops page handling out of move_to_new_folio()
      mm/zsmalloc: stop using __ClearPageMovable()
      mm/balloon_compaction: stop using __ClearPageMovable()
      mm/migrate: remove __ClearPageMovable()
      mm/migration: remove PageMovable()
      mm: rename __PageMovable() to page_has_movable_ops()
      mm/page_isolation: drop __folio_test_movable() check for large folios
      mm: remove __folio_test_movable()
      mm: stop storing migration_ops in page->mapping
      mm: convert "movable" flag in page->mapping to a page flag
      mm: rename PG_isolated to PG_movable_ops_isolated
      mm/page-flags: rename PAGE_MAPPING_MOVABLE to PAGE_MAPPING_ANON_KSM
      mm/page-alloc: remove PageMappingFlags()
      mm/page-flags: remove folio_mapping_flags()
      mm: simplify folio_expected_ref_count()
      mm: rename PAGE_MAPPING_* to FOLIO_MAPPING_*
      docs/mm: convert from "Non-LRU page migration" to "movable_ops page migration"
      mm/balloon_compaction: "movable_ops" doc updates
      mm/balloon_compaction: provide single balloon_page_insert() and balloon_mapping_gfp_mask()
      mm: convert FPB_IGNORE_* into FPB_RESPECT_*
      mm: smaller folio_pte_batch() improvements
      mm: split folio_pte_batch() into folio_pte_batch() and folio_pte_batch_flags()
      mm: remove boolean output parameters from folio_pte_batch_ext()
      mm/memory: introduce is_huge_zero_pfn() and use it in vm_normal_page_pmd()

David Wang (2):
      alloc_tag: add sequence number for module and iterator
      alloc_tag: keep codetag iterator active between read()

Davidlohr Bueso (4):
      mm/vmscan: respect psi_memstall region in node reclaim
      mm/memcg: make memory.reclaim interface generic
      mm/vmscan: make __node_reclaim() more generic
      mm: introduce per-node proactive reclaim interface

Dev Jain (13):
      xarray: add a BUG_ON() to ensure caller is not sibling
      mm: call pointers to ptes as ptep
      mm: optimize mremap() by PTE batching
      maple tree: use goto label to simplify code
      maple tree: add some comments
      khugepaged: reduce race probability between migration and khugepaged
      mm: refactor MM_CP_PROT_NUMA skipping case into new function
      mm: optimize mprotect() for MM_CP_PROT_NUMA by batch-skipping PTEs
      mm: add batched versions of ptep_modify_prot_start/commit
      mm: introduce FPB_RESPECT_WRITE for PTE batching infrastructure
      mm: split can_change_pte_writable() into private and shared parts
      mm: optimize mprotect() by PTE batching
      arm64: add batched versions of ptep_modify_prot_start/commit

Donet Tom (5):
      drivers/base/node: optimize memory block registration to reduce boot time
      drivers/base/node: remove register_mem_block_under_node_early()
      drivers/base/node: remove register_memory_blocks_under_node() function call from register_one_node
      drivers/base/node: rename register_memory_blocks_under_node() and remove context argument
      drivers/base/node: rename __register_one_node() to register_one_node()

Enze Li (1):
      selftests/damon: introduce _common.sh to host shared function

Gerald Schaefer (1):
      mm/debug_vm_pgtable: use a swp_entry_t input value for swap tests

Hao Ge (1):
      mm/percpu: conditionally define _shared_alloc_tag via CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU

Hao Jia (1):
      mm/mglru: stop try_to_inc_min_seq() if min_seq[type] has not increased

Honggyu Kim (1):
      samples/damon: change enable parameters to enabled

Hugh Dickins (3):
      mm: optimize lru_note_cost() by adding lru_note_cost_unlock_irq()
      mm/shmem: hold shmem_swaplist spinlock (not mutex) much less
      mm/shmem: writeout free swap if swap_writeout() reactivates

Jeongjun Park (1):
      mm/percpu: prevent concurrency problem for pcpu_nr_populated read with spin lock

Joshua Hahn (2):
      mm/mempolicy: skip unnecessary synchronize_rcu()
      MAINTAINERS: add missing headers to mempory policy & migration section

Kairui Song (1):
      mm, list_lru: refactor the locking code

Kemeng Shi (4):
      mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()
      mm: swap: correctly use maxpages in swapon syscall to avoid potential deadloop
      mm: swap: fix potential buffer overflow in setup_clusters()
      mm: swap: remove stale comment stale comment in cluster_alloc_swap_entry()

Kirill A. Shutemov (3):
      mm/vmstat: make MEMCG select VM_EVENT_COUNTERS
      mm: strictly check vmstat_text array size
      mm/vmstat: utilize designated initializers for the vmstat_text array

Koichiro Den (1):
      mm: vmscan: apply proportional reclaim pressure for memcg when MGLRU is enabled

Kuniyuki Iwashima (1):
      memcg: convert memcg->socket_pressure to u64

Li Wang (2):
      selftests/mm: fix UFFDIO_API usage with proper two-step feature negotiation
      ksm_tests: skip hugepage test when Transparent Hugepages are disabled

Li Zhe (1):
      gup: optimize longterm pin_user_pages() for large folio

Li Zhijian (1):
      mm/memory-tier: fix abstract distance calculation overflow

Liam R. Howlett (4):
      testing/radix-tree/maple: increase readers and reduce delay for faster machines
      tools/testing/radix-tree: test maple tree chaining mas_preallocate() calls
      maple_tree: fix status setup on restore to active
      maple_tree: add testing for restoring maple state to active

Lorenzo Stoakes (40):
      docs/mm: expand vma doc to highlight pte freeing, non-vma traversal
      mm: ksm: have KSM VMA checks not require a VMA pointer
      mm: ksm: refer to special VMAs via VM_SPECIAL in ksm_compatible()
      mm: prevent KSM from breaking VMA merging for new VMAs
      tools/testing/selftests: add VMA merge tests for KSM merge
      mm/pagewalk: split walk_page_range_novma() into kernel/user parts
      mm/vma: use vmg->target to specify target VMA for new VMA merge
      mm: change vm_get_page_prot() to accept vm_flags_t argument
      mm: update core kernel code to use vm_flags_t consistently
      mm: update architecture and driver code to use vm_flags_t
      mm/madvise: remove the visitor pattern and thread anon_vma state
      mm/madvise: thread mm_struct through madvise_behavior
      mm/madvise: thread VMA range state through madvise_behavior
      mm/madvise: thread all madvise state through madv_behavior
      mm/madvise: eliminate very confusing manipulation of prev VMA
      tools/testing/selftests: add mremap() unfaulted/faulted test cases
      mm/vma: refactor vma_modify_flags_name() to vma_modify_name()
      mm/mremap: perform some simple cleanups
      mm/mremap: refactor initial parameter sanity checks
      mm/mremap: put VMA check and prep logic into helper function
      mm/mremap: cleanup post-processing stage of mremap
      mm/mremap: use an explicit uffd failure path for mremap
      mm/mremap: check remap conditions earlier
      mm/mremap: move remap_is_valid() into check_prep_vma()
      mm/mremap: clean up mlock populate behaviour
      mm/mremap: permit mremap() move of multiple VMAs
      tools/testing/selftests: extend mremap_test to test multi-VMA mremap
      tools/testing/selftests: add mremap() shrink test for multiple VMAs
      tools/testing/selftests: test MREMAP_DONTUNMAP on multiple VMA move
      tools/testing/selftests: explicitly test split multi VMA mremap move
      docs: update THP documentation to clarify sysfs "never" setting
      MAINTAINERS: add missing percpu-internal.h file to per-cpu section
      MAINTAINERS: add missing interval_tree.c to memory mapping section
      MAINTAINERS: add missing mm_slot.h file THP section
      MAINTAINERS: move memremap.[ch] to hotplug section
      MAINTAINERS: add missing shrinker files
      MAINTAINERS: add missing files to page alloc section
      MAINTAINERS: add missing zsmalloc file
      MAINTAINERS: add MM MISC section, add missing files to MISC and CORE
      MAINTAINERS: add missing file to cgroup section

Luiz Capitulino (3):
      mm/util: introduce snapshot_page()
      proc: kpagecount: use snapshot_page()
      fs: stable_page_flags(): use snapshot_page()

Mark Brown (6):
      kselftest/mm: clarify errors for pipe()
      selftests/mm: convert some cow error reports to ksft_perror()
      selftests/mm: don't compare return values to in cow
      selftests/mm: add messages about test errors to the cow tests
      selftests/mm: check for YAMA ptrace_scope configuraiton before modifying it
      selftest/mm: skip if fallocate() is unsupported in gup_longterm

Matthew Wilcox (Oracle) (9):
      mm: restore documentation for __free_pages()
      bio: use memzero_page() in bio_truncate()
      null_blk: use memzero_page()
      direct-io: use memzero_page()
      ceph: convert ceph_zero_partial_page() to use a folio
      mm: remove zero_user()
      secretmem: remove uses of struct page
      highmem: remove a use of folio->page
      mm: remove grab_cache_page()

Mike Rapoport (Microsoft) (3):
      cma: move __cma_declare_contiguous_nid() before its usage
      cma: split reservation of fixed area into a helper function
      cma: move memory allocation to a helper function

Moon Hee Lee (1):
      selftests/mm: remove duplicate .gitignore entries

Muhammad Usama Anjum (1):
      selftests/mm: pagemap_scan ioctl: add PFN ZERO test cases

Nathan Gao (1):
      mm/damon: fix minor typos in damon header

Oscar Salvador (16):
      mm,slub: do not special case N_NORMAL nodes for slab_nodes
      mm,memory_hotplug: remove status_change_nid_normal and update documentation
      mm,memory_hotplug: implement numa node notifier
      mm,slub: use node-notifier instead of memory-notifier
      mm,memory-tiers: use node-notifier instead of memory-notifier
      drivers,cxl: use node-notifier instead of memory-notifier
      drivers,hmat: use node-notifier instead of memory-notifier
      kernel,cpuset: use node-notifier instead of memory-notifier
      mm,mempolicy: use node-notifier instead of memory-notifier
      mm,page_ext: derive the node from the pfn
      mm,memory_hotplug: drop status_change_nid parameter from memory_notify
      mm,hugetlb: change mechanism to detect a COW on private mapping
      mm,hugetlb: sort out folio locking in the faulting path
      mm,hugetlb: rename anon_rmap to new_anon_folio and make it boolean
      mm,hugetlb: drop obsolete comment about non-present pte and second faults
      mm,hugetlb: drop unlikelys from hugetlb_fault

Paul Menzel (1):
      mm: Kconfig: use verb *use* in plural form in description

Peter Xu (3):
      selftests/mm: reduce uffd-unit-test poison test to minimum
      mm/hugetlb: remove prepare_hugepage_range()
      mm: deduplicate mm_get_unmapped_area()

Petr Pavlu (1):
      codetag: avoid unused alloc_tags sections/symbols

Pu Lehui (1):
      selftests/mm: use generic read_sysfs in thuge-gen test

Raghavendra K T (1):
      lib/test_vmalloc.c: introduce xfail for failing tests

Richard Chang (1):
      mm/cma: pair the trace_cma_alloc_start/finish

Ryan Roberts (6):
      mm/readahead: honour new_order in page_cache_ra_order()
      mm/readahead: terminate async readahead on natural boundary
      mm/readahead: make space in struct file_ra_state
      mm/readahead: store folio order in struct file_ra_state
      mm/filemap: allow arch to request folio size for exec memory
      mm: remove arch_flush_tlb_batched_pending() arch helper

Sabyrzhan Tasbolatov (1):
      mm: unexport globally copy_to_kernel_nofault

SeongJae Park (81):
      mm/damon: introduce DAMON_STAT module
      mm/damon/stat: calculate and expose estimated memory bandwidth
      mm/damon/stat: calculate and expose idle time percentiles
      Docs/admin-guide/mm/damon: add DAMON_STAT usage document
      mm/damon/paddr: use alloc_migartion_target() with no migration fallback nodemask
      Revert "mm: rename alloc_demote_folio to alloc_migrate_folio"
      Revert "mm: make alloc_demote_folio externally invokable for migration"
      selftets/damon: add a test for memcg_path leak
      mm/damon/sysfs-schemes: decouple from damos_quota_goal_metric
      mm/damon/sysfs-schemes: decouple from damos_action
      mm/damon/sysfs-schemes: decouple from damos_wmark_metric
      mm/damon/sysfs-schemes: decouple from damos_filter_type
      mm/damon/sysfs: decouple from damon_ops_id
      selftests/damon: add drgn script for extracting damon status
      selftests/damon/_damon_sysfs: set Kdamond.pid in start()
      selftests/damon: add python and drgn-based DAMON sysfs test
      selftests/damon/sysfs.py: test monitoring attribute parameters
      selftests/damon/sysfs.py: test adaptive targets parameter
      selftests/damon/sysfs.py: test DAMOS schemes parameters setup
      mm/damon: add trace event for auto-tuned monitoring intervals
      mm/damon: add trace event for effective size quota
      samples/damon/wsse: fix boot time enable handling
      samples/damon/prcl: fix boot time enable crash
      samples/damon/mtier: support boot time enable setup
      mm/damon/reclaim: reset enabled when DAMON start failed
      mm/damon/lru_sort: reset enabled when DAMON start failed
      mm/damon/reclaim: use parameter context correctly
      samples/damon/wsse: rename to have damon_sample_ prefix
      samples/damon/prcl: rename to have damon_sample_ prefix
      samples/damon/mtier: rename to have damon_sample_ prefix
      mm/damon/sysfs: use DAMON core API damon_is_running()
      mm/damon/sysfs: don't hold kdamond_lock in before_terminate()
      Docs/mm/damon/maintainer-profile: update for mm-new tree
      mm/damon: add struct damos_migrate_dests
      mm/damon/core: add damos->migrate_dests field
      mm/damon/sysfs-schemes: implement DAMOS action destinations directory
      mm/damon/sysfs-schemes: set damos->migrate_dests
      Docs/ABI/damon: document schemes dests directory
      Docs/admin-guide/mm/damon/usage: document dests directory
      mm/damon: accept parallel damon_call() requests
      mm/damon/core: introduce repeat mode damon_call()
      mm/damon/stat: use damon_call() repeat mode instead of damon_callback
      mm/damon/reclaim: use damon_call() repeat mode instead of damon_callback
      mm/damon/lru_sort: use damon_call() repeat mode instead of damon_callback
      samples/damon/prcl: use damon_call() repeat mode instead of damon_callback
      samples/damon/wsse: use damon_call() repeat mode instead of damon_callback
      mm/damon/core: do not call ops.cleanup() when destroying targets
      mm/damon/core: add cleanup_target() ops callback
      mm/damon/vaddr: put pid in cleanup_target()
      mm/damon/sysfs: remove damon_sysfs_destroy_targets()
      mm/damon/core: destroy targets when kdamond_fn() finish
      mm/damon/sysfs: remove damon_sysfs_before_terminate()
      mm/damon/core: remove damon_callback
      mm/damon/sysfs: implement refresh_ms file under kdamond directory
      mm/damon/sysfs: implement refresh_ms file internal work
      Docs/admin-guide/mm/damon/usage: document refresh_ms file
      Docs/ABI/damon: update for refresh_ms
      mm/damon/ops-common: ignore migration request to invalid nodes
      selftests/damon/sysfs.py: stop DAMON for dumping failures
      selftests/damon/_damon_sysfs: support DAMOS watermarks setup
      selftests/damon/_damon_sysfs: support DAMOS filters setup
      selftests/damon/_damon_sysfs: support monitoring intervals goal setup
      selftests/damon/_damon_sysfs: support DAMOS quota weights setup
      selftests/damon/_damon_sysfs: support DAMOS quota goal nid setup
      selftests/damon/_damon_sysfs: support DAMOS action dests setup
      selftests/damon/_damon_sysfs: support DAMOS target_nid setup
      selftests/damon/_damon_sysfs: use 2**32 - 1 as max nr_accesses and age
      selftests/damon/drgn_dump_damon_status: dump damos->migrate_dests
      selftests/damon/drgn_dump_damon_status: dump ctx->ops.id
      selftests/damon/drgn_dump_damon_status: dump DAMOS filters
      selftests/damon/sysfs.py: generalize DAMOS Watermarks commit assertion
      selftests/damon/sysfs.py: generalize DamosQuota commit assertion
      selftests/damon/sysfs.py: test quota goal commitment
      selftests/damon/sysfs.py: test DAMOS destinations commitment
      selftests/damon/sysfs.py: generalize DAMOS scheme commit assertion
      selftests/damon/sysfs.py: test DAMOS filters commitment
      selftests/damon/sysfs.py: generalize DAMOS schemes commit assertion
      selftests/damon/sysfs.py: generalize monitoring attributes commit assertion
      selftests/damon/sysfs.py: generalize DAMON context commit assertion
      selftests/damon/sysfs.py: test non-default parameters runtime commit
      selftests/damon/sysfs.py: test runtime reduction of DAMON parameters

Shivank Garg (1):
      mm: use folio_expected_ref_count() helper for reference counting

Sidhartha Kumar (2):
      mm/hugetlb: convert hugetlb_change_protection() to folios
      mm/page_owner: convert set_page_owner_migrate_reason() to folios

Suren Baghdasaryan (6):
      selftests/proc: add /proc/pid/maps tearing from vma split test
      selftests/proc: extend /proc/pid/maps tearing test to include vma resizing
      selftests/proc: extend /proc/pid/maps tearing test to include vma remapping
      selftests/proc: add verbose mode for /proc/pid/maps tearing tests
      fs/proc/task_mmu: remove conversion of seq_file position to unsigned
      fs/proc/task_mmu: read proc/pid/maps under per-vma lock

Tal Zussman (4):
      userfaultfd: correctly prevent registering VM_DROPPABLE regions
      userfaultfd: prevent unregistering VMAs through a different userfaultfd
      userfaultfd: remove (VM_)BUG_ON()s
      userfaultfd: remove UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET

Thorsten Blum (3):
      mm/hugetlb: use str_plural() in report_hugepages()
      mm/cma: use str_plural() in cma_declare_contiguous_multi()
      mm/memfd: replace deprecated strcpy() with memcpy() in alloc_name()

Uladzislau Rezki (Sony) (2):
      lib/test_vmalloc.c: use late_initcall() if built-in for init ordering
      lib/test_vmalloc.c: restrict default test mask to avoid test warnings

Vishal Moola (Oracle) (3):
      mm/memory.c: use folios in __copy_remote_vm_str()
      mm/memory.c: use folios in __access_remote_vm()
      mm: remove unmap_and_put_page()

Vivek Kasireddy (3):
      mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated
      mm/memfd: reserve hugetlb folios before allocation
      selftests/udmabuf: add a test to pin first before writing to memfd

Vlastimil Babka (5):
      mm, madvise: simplify anon_name handling
      mm, madvise: extract mm code from prctl_set_vma() to mm/madvise.c
      mm, madvise: move madvise_set_anon_name() down the file
      mm, madvise: use standard madvise locking in madvise_set_anon_name()
      mm, vmstat: remove the NR_WRITEBACK_TEMP node_stat_item counter

Wei Yang (1):
      mm/migrate: remove the -EEXIST conversion for move_pages()

Xuanye Liu (3):
      mm: fix spelling issue in swap.h
      mm: remove outdated filename comment in percpu-stats.c
      mm: simplify min_brk handling in brk()

Yadan Fan (1):
      mm: mempool: fix wake-up edge case bug for zero-minimum pools

Ye Liu (2):
      tools/mm: add script to display page state for a given PID and VADDR
      mm/memfd: clarify error handling labels in memfd_create()

Yunjeong Mun (2):
      samples/damon/mtier: add parameters for node0 memory usage
      samples/damon: support automatic node address detection

Yury Norov (NVIDIA) (2):
      mm: cma: simplify cma_debug_show_areas()
      mm: cma: simplify cma_maxchunk_get()

Zi Yan (14):
      mm: rename CONFIG_PAGE_BLOCK_ORDER to CONFIG_PAGE_BLOCK_MAX_ORDER
      mm/page_alloc: pageblock flags functions clean up
      mm/page_isolation: make page isolation a standalone bit
      mm/page_alloc: add support for initializing pageblock as isolated
      mm/page_isolation: remove migratetype from move_freepages_block_isolate()
      mm/page_isolation: remove migratetype from undo_isolate_page_range()
      mm/page_isolation: remove migratetype parameter from more functions
      mm/huge_memory: move unrelated code out of __split_unmapped_folio()
      mm/huge_memory: remove after_split label in __split_unmapped_folio()
      mm/huge_memory: deduplicate code in __folio_split()
      mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split
      mm/huge_memory: get frozen folio refcount with folio_expected_ref_count()
      mm/huge_memory: refactor after-split (page) cache code
      mm/page_alloc: remove trace_mm_alloc_contig_migrate_range_info()

wang lian (2):
      selftests/mm: reuse FORCE_READ to replace "asm volatile("" : "+r" (XXX));"
      selftests/mm: guard-regions: Use SKIP() instead of ksft_exit_skip()

wangzijie (1):
      proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al

 Documentation/ABI/stable/sysfs-devices-node        |   9 +
 Documentation/ABI/testing/sysfs-kernel-mm-damon    |  29 +
 Documentation/admin-guide/mm/damon/index.rst       |   1 +
 Documentation/admin-guide/mm/damon/stat.rst        |  69 ++
 Documentation/admin-guide/mm/damon/usage.rst       |  46 +-
 Documentation/admin-guide/mm/transhuge.rst         |  19 +-
 Documentation/core-api/memory-hotplug.rst          |  91 ++-
 Documentation/filesystems/proc.rst                 |   8 +-
 Documentation/mm/arch_pgtable_helpers.rst          |  14 +-
 Documentation/mm/damon/design.rst                  |   4 +-
 Documentation/mm/damon/maintainer-profile.rst      |  35 +-
 Documentation/mm/page_migration.rst                |  39 +-
 Documentation/mm/physical_memory.rst               |   2 +-
 Documentation/mm/process_addrs.rst                 |  54 +-
 .../translations/zh_CN/core-api/memory-hotplug.rst |   3 -
 MAINTAINERS                                        |  94 ++-
 arch/alpha/Kconfig                                 |   1 +
 arch/alpha/include/asm/percpu.h                    |   5 +-
 arch/arm/mm/fault.c                                |   2 +-
 arch/arm64/Kconfig                                 |   1 -
 arch/arm64/include/asm/mman.h                      |  10 +-
 arch/arm64/include/asm/pgtable-prot.h              |   1 -
 arch/arm64/include/asm/pgtable.h                   |  42 +-
 arch/arm64/include/asm/tlbflush.h                  |  11 -
 arch/arm64/mm/fault.c                              |   2 +-
 arch/arm64/mm/mmap.c                               |   2 +-
 arch/arm64/mm/mmu.c                                |  30 +-
 arch/arm64/mm/ptdump_debugfs.c                     |   3 -
 arch/loongarch/Kconfig                             |   1 -
 arch/loongarch/include/asm/hugetlb.h               |  14 -
 arch/loongarch/include/asm/pgtable-bits.h          |   6 +-
 arch/loongarch/include/asm/pgtable.h               |  19 -
 arch/loongarch/mm/pageattr.c                       |   2 +-
 arch/mips/include/asm/hugetlb.h                    |  14 -
 arch/openrisc/kernel/dma.c                         |   4 +-
 arch/powerpc/Kconfig                               |   1 -
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |   6 -
 arch/powerpc/include/asm/book3s/64/hash-64k.h      |   7 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  53 +-
 arch/powerpc/include/asm/book3s/64/pkeys.h         |   2 +-
 arch/powerpc/include/asm/book3s/64/radix.h         |  14 +-
 arch/powerpc/include/asm/mman.h                    |   2 +-
 arch/powerpc/include/asm/pkeys.h                   |   4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   2 +-
 arch/powerpc/mm/book3s64/hash_hugepage.c           |   2 +-
 arch/powerpc/mm/book3s64/hash_pgtable.c            |   3 +-
 arch/powerpc/mm/book3s64/hugetlbpage.c             |   2 +-
 arch/powerpc/mm/book3s64/pgtable.c                 |  12 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   5 +-
 arch/powerpc/mm/pgtable.c                          |   2 +-
 arch/powerpc/platforms/pseries/cmm.c               |   2 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |   2 +-
 arch/riscv/Kconfig                                 |   1 -
 arch/riscv/include/asm/pgtable-64.h                |  16 -
 arch/riscv/include/asm/pgtable-bits.h              |   1 -
 arch/riscv/include/asm/pgtable.h                   |  22 -
 arch/riscv/include/asm/tlbflush.h                  |   1 -
 arch/riscv/mm/pageattr.c                           |   8 +-
 arch/riscv/mm/ptdump.c                             |   3 -
 arch/riscv/mm/tlbflush.c                           |   5 -
 arch/s390/Kconfig                                  |   1 +
 arch/s390/include/asm/percpu.h                     |   5 +-
 arch/s390/mm/dump_pagetables.c                     |   2 -
 arch/sparc/Kconfig                                 |   1 +
 arch/sparc/include/asm/hugetlb.h                   |   5 -
 arch/sparc/include/asm/mman.h                      |   4 +-
 arch/sparc/mm/hugetlbpage.c                        | 119 ---
 arch/sparc/mm/init_64.c                            |   2 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/include/asm/pgtable.h                     |  51 +-
 arch/x86/include/asm/pgtable_types.h               |   5 +-
 arch/x86/include/asm/tlbflush.h                    |   5 -
 arch/x86/kernel/cpu/sgx/encl.c                     |   8 +-
 arch/x86/kernel/cpu/sgx/encl.h                     |   2 +-
 arch/x86/mm/pat/memtype.c                          |   1 -
 arch/x86/mm/pgprot.c                               |   2 +-
 block/bio.c                                        |   4 +-
 drivers/acpi/numa/hmat.c                           |   8 +-
 drivers/base/memory.c                              |  21 +-
 drivers/base/node.c                                | 121 ++-
 drivers/block/null_blk/main.c                      |   2 +-
 drivers/cxl/core/region.c                          |  16 +-
 drivers/cxl/cxl.h                                  |   4 +-
 drivers/dax/device.c                               |  23 +-
 drivers/dax/hmem/hmem.c                            |   1 -
 drivers/dax/kmem.c                                 |   1 -
 drivers/dax/pmem.c                                 |   1 -
 drivers/dax/super.c                                |   3 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |   1 -
 drivers/gpu/drm/gma500/fbdev.c                     |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   1 -
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |   3 +-
 drivers/gpu/drm/msm/msm_gem.c                      |   1 -
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   7 +-
 drivers/gpu/drm/ttm/ttm_backup.c                   |   9 +-
 drivers/gpu/drm/v3d/v3d_bo.c                       |   1 -
 drivers/hwtracing/intel_th/msu.c                   |   3 +-
 drivers/md/dm-linear.c                             |   2 +-
 drivers/md/dm-log-writes.c                         |   2 +-
 drivers/md/dm-stripe.c                             |   2 +-
 drivers/md/dm-target.c                             |   2 +-
 drivers/md/dm-writecache.c                         |  11 +-
 drivers/md/dm.c                                    |   2 +-
 drivers/misc/vmw_balloon.c                         |   3 +-
 drivers/nvdimm/pmem.c                              |   8 +-
 drivers/nvdimm/pmem.h                              |   4 +-
 drivers/s390/block/dcssblk.c                       |  10 +-
 drivers/vfio/pci/vfio_pci_core.c                   |   7 +-
 drivers/virtio/virtio_balloon.c                    |   4 +-
 drivers/virtio/virtio_mem.c                        |   2 +-
 fs/Kconfig                                         |  11 +-
 fs/ceph/file.c                                     |  22 +-
 fs/cramfs/inode.c                                  |   5 +-
 fs/dax.c                                           |  67 +-
 fs/direct-io.c                                     |   2 +-
 fs/exec.c                                          |   2 +-
 fs/ext4/file.c                                     |   2 +-
 fs/fuse/dax.c                                      |   3 +-
 fs/fuse/file.c                                     |  11 -
 fs/fuse/virtio_fs.c                                |   5 +-
 fs/hugetlbfs/inode.c                               |  16 +-
 fs/nfs/write.c                                     |   2 +-
 fs/proc/generic.c                                  |   2 +
 fs/proc/inode.c                                    |   2 +-
 fs/proc/internal.h                                 |  10 +
 fs/proc/meminfo.c                                  |   3 +-
 fs/proc/page.c                                     |  54 +-
 fs/proc/task_mmu.c                                 | 158 +++-
 fs/userfaultfd.c                                   |  97 +--
 fs/xfs/xfs_file.c                                  |   2 +-
 include/asm-generic/codetag.lds.h                  |  16 +-
 include/asm-generic/hugetlb.h                      |  17 -
 include/linux/alloc_tag.h                          |   6 +-
 include/linux/balloon_compaction.h                 |  90 +--
 include/linux/codetag.h                            |   1 +
 include/linux/coredump.h                           |   2 +-
 include/linux/damon.h                              |  80 +-
 include/linux/dax.h                                |   9 +-
 include/linux/device-mapper.h                      |   2 +-
 include/linux/fs.h                                 |  13 +-
 include/linux/gfp.h                                |   7 +-
 include/linux/highmem-internal.h                   |   2 +-
 include/linux/highmem.h                            |  12 -
 include/linux/huge_mm.h                            |  52 +-
 include/linux/hugetlb.h                            |  20 +-
 include/linux/khugepaged.h                         |   4 +-
 include/linux/ksm.h                                |  12 +-
 include/linux/maple_tree.h                         |   4 +-
 include/linux/memcontrol.h                         |  44 +-
 include/linux/memfd.h                              |   4 +-
 include/linux/memory-tiers.h                       |   2 +-
 include/linux/memory.h                             |  20 +-
 include/linux/memory_hotplug.h                     |   3 +-
 include/linux/migrate.h                            |  46 +-
 include/linux/mm.h                                 |  77 +-
 include/linux/mm_types.h                           |   3 +-
 include/linux/mman.h                               |   4 +-
 include/linux/mmap_lock.h                          |  11 +
 include/linux/mmdebug.h                            |  12 +
 include/linux/mmzone.h                             |  36 +-
 include/linux/node.h                               |  77 +-
 include/linux/page-flags.h                         | 106 ++-
 include/linux/page-isolation.h                     |  47 +-
 include/linux/page_owner.h                         |   8 +-
 include/linux/pageblock-flags.h                    |  56 +-
 include/linux/pagemap.h                            |  14 +-
 include/linux/pagewalk.h                           |   9 +-
 include/linux/percpu-defs.h                        |   7 +-
 include/linux/pfn.h                                |   9 -
 include/linux/pfn_t.h                              | 131 ----
 include/linux/pgtable.h                            | 118 ++-
 include/linux/proc_fs.h                            |   1 +
 include/linux/rmap.h                               |   4 +-
 include/linux/shmem_fs.h                           |   5 +-
 include/linux/swap.h                               |  23 +-
 include/linux/userfaultfd_k.h                      |  15 +-
 include/linux/vmstat.h                             |   4 +-
 include/linux/writeback.h                          |  11 -
 include/linux/zsmalloc.h                           |   2 +
 include/trace/events/btrfs.h                       |   7 +-
 include/trace/events/damon.h                       |  41 +
 include/trace/events/fs_dax.h                      |   6 +-
 include/trace/events/kmem.h                        |  38 -
 include/trace/events/mmap.h                        |  52 --
 include/trace/events/writeback.h                   |   8 +-
 init/Kconfig                                       |   1 +
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/events/uprobes.c                            |   5 +-
 kernel/kexec_handover.c                            |   4 +-
 kernel/sys.c                                       |  50 +-
 lib/alloc_tag.c                                    |  31 +-
 lib/codetag.c                                      |  17 +-
 lib/maple_tree.c                                   |  40 +-
 lib/test_hmm.c                                     |  14 +-
 lib/test_maple_tree.c                              |  32 +
 lib/test_vmalloc.c                                 |  42 +-
 lib/xarray.c                                       |   3 +
 mm/Kconfig                                         |  28 +-
 mm/balloon_compaction.c                            |  21 +-
 mm/cma.c                                           | 341 ++++-----
 mm/cma_debug.c                                     |  10 +-
 mm/compaction.c                                    |  44 +-
 mm/damon/Kconfig                                   |  16 +
 mm/damon/Makefile                                  |   1 +
 mm/damon/core.c                                    | 189 +++--
 mm/damon/lru_sort.c                                |  75 +-
 mm/damon/ops-common.c                              | 274 +++++++
 mm/damon/ops-common.h                              |   5 +
 mm/damon/paddr.c                                   | 277 +------
 mm/damon/reclaim.c                                 |  71 +-
 mm/damon/stat.c                                    | 264 +++++++
 mm/damon/sysfs-schemes.c                           | 504 +++++++++++--
 mm/damon/sysfs.c                                   | 171 +++--
 mm/damon/tests/core-kunit.h                        |   4 +-
 mm/damon/tests/vaddr-kunit.h                       |   2 +-
 mm/damon/vaddr.c                                   | 241 ++++++
 mm/debug.c                                         |  44 +-
 mm/debug_vm_pgtable.c                              | 113 +--
 mm/execmem.c                                       |   8 +-
 mm/filemap.c                                       |  68 +-
 mm/gup.c                                           | 245 ++----
 mm/hmm.c                                           |  14 +-
 mm/huge_memory.c                                   | 489 ++++++------
 mm/hugetlb.c                                       | 173 ++---
 mm/hugetlb_vmemmap.c                               |   2 +-
 mm/internal.h                                      | 150 ++--
 mm/kasan/kasan_test_c.c                            |   8 +
 mm/khugepaged.c                                    |  23 +-
 mm/ksm.c                                           |  55 +-
 mm/list_lru.c                                      |  34 +-
 mm/maccess.c                                       |   1 -
 mm/madvise.c                                       | 824 +++++++++++++--------
 mm/mapping_dirty_helpers.c                         |   6 +-
 mm/memcontrol.c                                    |  82 +-
 mm/memfd.c                                         |  38 +-
 mm/memory-failure.c                                |   4 +-
 mm/memory-tiers.c                                  |  19 +-
 mm/memory.c                                        | 153 ++--
 mm/memory_hotplug.c                                | 197 +++--
 mm/mempolicy.c                                     |  31 +-
 mm/mempool.c                                       |  34 +-
 mm/memremap.c                                      |  34 +-
 mm/migrate.c                                       | 283 ++++---
 mm/migrate_device.c                                |   2 +-
 mm/mlock.c                                         |   4 +-
 mm/mm_init.c                                       |  26 +-
 mm/mmap.c                                          |  28 +-
 mm/mmap_lock.c                                     |  93 +++
 mm/mprotect.c                                      | 305 ++++++--
 mm/mremap.c                                        | 625 ++++++++++------
 mm/nommu.c                                         |  12 +-
 mm/page-writeback.c                                |   4 +-
 mm/page_alloc.c                                    | 394 +++++++---
 mm/page_ext.c                                      |  17 +-
 mm/page_io.c                                       |  71 +-
 mm/page_isolation.c                                | 112 ++-
 mm/page_owner.c                                    |   4 +-
 mm/page_vma_mapped.c                               |   5 +-
 mm/pagewalk.c                                      |  90 ++-
 mm/percpu-stats.c                                  |   1 -
 mm/percpu.c                                        |   2 +-
 mm/pgtable-generic.c                               |   7 +-
 mm/ptdump.c                                        |   5 +-
 mm/readahead.c                                     |  36 +-
 mm/rmap.c                                          |  26 +-
 mm/secretmem.c                                     |  16 +-
 mm/shmem.c                                         | 112 ++-
 mm/show_mem.c                                      |   2 -
 mm/slub.c                                          |  61 +-
 mm/swap.c                                          |  33 +-
 mm/swap.h                                          |   9 +-
 mm/swapfile.c                                      |  70 +-
 mm/userfaultfd.c                                   |  92 ++-
 mm/util.c                                          | 116 ++-
 mm/vma.c                                           | 159 ++--
 mm/vma.h                                           |  29 +-
 mm/vma_exec.c                                      |   2 +-
 mm/vmpressure.c                                    |   2 +-
 mm/vmscan.c                                        | 466 ++++++++----
 mm/vmstat.c                                        | 454 ++++++------
 mm/zpdesc.h                                        |  15 +-
 mm/zsmalloc.c                                      |  33 +-
 mm/zswap.c                                         |   5 +-
 samples/damon/mtier.c                              |  78 +-
 samples/damon/prcl.c                               |  53 +-
 samples/damon/wsse.c                               |  53 +-
 scripts/module.lds.S                               |   5 -
 tools/mm/show_page_info.py                         | 169 +++++
 tools/testing/nvdimm/pmem-dax.c                    |   6 +-
 tools/testing/nvdimm/test/iomap.c                  |  11 -
 tools/testing/nvdimm/test/nfit_test.h              |   1 -
 tools/testing/radix-tree/maple.c                   |  19 +-
 tools/testing/selftests/damon/Makefile             |   2 +
 tools/testing/selftests/damon/_common.sh           |  11 +
 tools/testing/selftests/damon/_damon_sysfs.py      | 304 +++++++-
 .../selftests/damon/drgn_dump_damon_status.py      | 222 ++++++
 tools/testing/selftests/damon/lru_sort.sh          |   8 +-
 tools/testing/selftests/damon/reclaim.sh           |   8 +-
 tools/testing/selftests/damon/sysfs.py             | 272 +++++++
 tools/testing/selftests/damon/sysfs.sh             |  11 +-
 .../selftests/damon/sysfs_memcg_path_leak.sh       |  43 ++
 .../damon/sysfs_update_removed_scheme_dir.sh       |   8 +-
 tools/testing/selftests/drivers/dma-buf/udmabuf.c  |  20 +-
 tools/testing/selftests/mm/.gitignore              |   3 -
 tools/testing/selftests/mm/cow.c                   | 101 ++-
 tools/testing/selftests/mm/guard-regions.c         |   9 +-
 tools/testing/selftests/mm/gup_longterm.c          |  10 +-
 tools/testing/selftests/mm/hugetlb-madvise.c       |   5 +-
 tools/testing/selftests/mm/khugepaged.c            |   7 +-
 tools/testing/selftests/mm/ksm_functional_tests.c  |  28 +-
 tools/testing/selftests/mm/ksm_tests.c             |   6 +
 tools/testing/selftests/mm/merge.c                 | 677 ++++++++++++++++-
 tools/testing/selftests/mm/migration.c             |  21 +-
 tools/testing/selftests/mm/mremap_test.c           | 361 ++++++++-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  70 +-
 tools/testing/selftests/mm/run_vmtests.sh          |   8 +-
 tools/testing/selftests/mm/soft-dirty.c            |   9 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |   4 +-
 tools/testing/selftests/mm/thp_settings.c          |  11 +
 tools/testing/selftests/mm/thp_settings.h          |   2 +
 tools/testing/selftests/mm/thuge-gen.c             |  38 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |  20 +-
 tools/testing/selftests/mm/vm_util.c               |  31 +
 tools/testing/selftests/mm/vm_util.h               |  12 +
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 tools/testing/selftests/proc/proc-maps-race.c      | 741 ++++++++++++++++++
 tools/testing/vma/vma.c                            | 272 +++----
 tools/testing/vma/vma_internal.h                   |  23 +-
 329 files changed, 10711 insertions(+), 5779 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/damon/stat.rst
 delete mode 100644 include/linux/pfn_t.h
 create mode 100644 mm/damon/stat.c
 create mode 100644 tools/mm/show_page_info.py
 create mode 100644 tools/testing/selftests/damon/_common.sh
 create mode 100755 tools/testing/selftests/damon/drgn_dump_damon_status.py
 create mode 100755 tools/testing/selftests/damon/sysfs.py
 create mode 100755 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
 create mode 100644 tools/testing/selftests/proc/proc-maps-race.c

