Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA349482EF;
	Sat, 31 May 2025 21:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748728423; cv=none; b=CPX2s/e94M8h7xmU3m5YkzfyrFc0yDnRnmCz4zoJJMZKYRzkmDiVVnZAgtpYcwDNqA9txQ9KW4ILqMnlwSHK4SlvrrYClLsdqQfCQsfZAWgd/dqswXk9625aHG94yK8gl8zJ47fpsfAgRd8XQz8U4V3AOMGpyw6kpCFNI42YFcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748728423; c=relaxed/simple;
	bh=H77DHMQ2TrKZiiZ4n6/Il4El3ltqXWleita+bbnDFMo=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=j6ZauJkRYdyrchyg82wQOK55Wi4hFSHSOpKBmJzw63FXNjCR8J4YMdT5ILIi/bCb/emnzFgNEm1lvJI6kdh3thKfSq+SpgOEswUtEcuTTsjZWNEKhbk6OgW9nqkK7kFdYHZttAetgOwyjiKPVoLpTC3rCD+2S2yC3vE5ynuikmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uG11LF1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uG11LF1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2654C4CEE3;
	Sat, 31 May 2025 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748728423;
	bh=H77DHMQ2TrKZiiZ4n6/Il4El3ltqXWleita+bbnDFMo=;
	h=Date:From:To:Cc:Subject:From;
	b=uG11LF1Pk1TyQTPT1qgH+xejUSyRhPiVAkL1YcWFDjopQ4g2OKVx4gXMdwLFcAVi1
	 dJIjtiBo5XWk04BR1Qs0dGlK8fEVTAI5GIfrIdU7ffppLJn+nyFgCWGS+nhBtvz3wo
	 BjTTfGAYymTk4xTLARUOFIez+SLxeJ2QEMYhQ4ls=
Date: Sat, 31 May 2025 14:53:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 6.16-rc1
Message-Id: <20250531145342.383090aa5ed5bcefee0740d5@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this set of MM updates for the 6.16-rcX cycle.

I'll be sending another batch of 50ish updates later in the week, then
another tiny update.

Thanks.

Conflicts which I'm seeing today, and their linux-resolutions:

arch/x86/mm/pat/memtype.c, vs tip tree:
https://lkml.kernel.org/r/20250515151102.5b0f9e4f@canb.auug.org.au

mm/memcontrol.c, vs cgroup tree:
https://lkml.kernel.org/r/20250521174958.0b7354da@canb.auug.org.au
https://lkml.kernel.org/r/20250522173518.68d11f41@canb.auug.org.au
https://lkml.kernel.org/r/20250529111223.3987a514@canb.auug.org.au

Possible upcoming conflicts which Stephen reported.  Some of these are now
resolved.

arch/x86/kernel/e820.c, vs tip-fixes tree:
https://lkml.kernel.org/r/20250422124402.4b891d14@canb.auug.org.au

kernel/kexec_file.c, vs integrity tree:
https://lkml.kernel.org/r/20250430142331.468074f1@canb.auug.org.au

fs/fuse/file.c, vs fuse tree:
https://lkml.kernel.org/r/20250509105750.6281e2ab@canb.auug.org.au
https://lkml.kernel.org/r/20250514105313.5e2c367a@canb.auug.org.au

rust/kernel/task.rs, vs rust tree:
https://lkml.kernel.org/r/20250526173741.2dd77e75@canb.auug.org.au


The following changes since commit 75cb1cca2c880179a11c7dd9380b6f14e41a06a4:

  mm: userfaultfd: correct dirty flags set for both present and swap pte (2025-05-11 17:29:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-05-31-14-50

for you to fetch changes up to c544a952ba61b1a025455098033c17e0573ab085:

  mm: pcp: increase pcp->free_count threshold to trigger free_high (2025-05-27 19:38:27 -0700)

----------------------------------------------------------------
- The 11 patch series "Add folio_mk_pte()" from Matthew Wilcox
  simplifies the act of creating a pte which addresses the first page in a
  folio and reduces the amount of plumbing which architecture must
  implement to provide this.

- The 8 patch series "Misc folio patches for 6.16" from Matthew Wilcox
  is a shower of largely unrelated folio infrastructure changes which
  clean things up and better prepare us for future work.

- The 3 patch series "memory,x86,acpi: hotplug memory alignment
  advisement" from Gregory Price adds early-init code to prevent x86 from
  leaving physical memory unused when physical address regions are not
  aligned to memory block size.

- The 2 patch series "mm/compaction: allow more aggressive proactive
  compaction" from Michal Clapinski provides some tuning of the (sadly,
  hard-coded (more sadly, not auto-tuned)) thresholds for our invokation
  of proactive compaction.  In a simple test case, the reduction of a guest
  VM's memory consumption was dramatic.

- The 8 patch series "Minor cleanups and improvements to swap freeing
  code" from Kemeng Shi provides some code cleaups and a small efficiency
  improvement to this part of our swap handling code.

- The 6 patch series "ptrace: introduce PTRACE_SET_SYSCALL_INFO API"
  from Dmitry Levin adds the ability for a ptracer to modify syscalls
  arguments.  At this time we can alter only "system call information that
  are used by strace system call tampering, namely, syscall number,
  syscall arguments, and syscall return value.

  This series should have been incorporated into mm.git's "non-MM"
  branch, but I goofed.

- The 3 patch series "fs/proc: extend the PAGEMAP_SCAN ioctl to report
  guard regions" from Andrei Vagin extends the info returned by the
  PAGEMAP_SCAN ioctl against /proc/pid/pagemap.  This permits CRIU to more
  efficiently get at the info about guard regions.

- The 2 patch series "Fix parameter passed to page_mapcount_is_type()"
  from Gavin Shan implements that fix.  No runtime effect is expected
  because validate_page_before_insert() happens to fix up this error.

- The 3 patch series "kernel/events/uprobes: uprobe_write_opcode()
  rewrite" from David Hildenbrand basically brings uprobe text poking into
  the current decade.  Remove a bunch of hand-rolled implementation in
  favor of using more current facilities.

- The 3 patch series "mm/ptdump: Drop assumption that pxd_val() is u64"
  from Anshuman Khandual provides enhancements and generalizations to the
  pte dumping code.  This might be needed when 128-bit Page Table
  Descriptors are enabled for ARM.

- The 12 patch series "Always call constructor for kernel page tables"
  from Kevin Brodsky "ensures that the ctor/dtor is always called for
  kernel pgtables, as it already is for user pgtables".  This permits the
  addition of more functionality such as "insert hooks to protect page
  tables".  This change does result in various architectures performing
  unnecesary work, but this is fixed up where it is anticipated to occur.

- The 9 patch series "Rust support for mm_struct, vm_area_struct, and
  mmap" from Alice Ryhl adds plumbing to permit Rust access to core MM
  structures.

- The 3 patch series "fix incorrectly disallowed anonymous VMA merges"
  from Lorenzo Stoakes takes advantage of some VMA merging opportunities
  which we've been missing for 15 years.

- The 4 patch series "mm/madvise: batch tlb flushes for MADV_DONTNEED
  and MADV_FREE" from SeongJae Park optimizes process_madvise()'s TLB
  flushing.  Instead of flushing each address range in the provided iovec,
  we batch the flushing across all the iovec entries.  The syscall's cost
  was approximately halved with a microbenchmark which was designed to
  load this particular operation.

- The 6 patch series "Track node vacancy to reduce worst case allocation
  counts" from Sidhartha Kumar makes the maple tree smarter about its node
  preallocation.  stress-ng mmap performance increased by single-digit
  percentages and the amount of unnecessarily preallocated memory was
  dramaticelly reduced.

- The 3 patch series "mm/gup: Minor fix, cleanup and improvements" from
  Baoquan He removes a few unnecessary things which Baoquan noted when
  reading the code.

- The 3 patch series ""Enhance sysfs handling for memory hotplug in
  weighted interleave" from Rakie Kim "enhances the weighted interleave
  policy in the memory management subsystem by improving sysfs handling,
  fixing memory leaks, and introducing dynamic sysfs updates for memory
  hotplug support".  Fixes things on error paths which we are unlikely to
  hit.

- The 7 patch series "mm/damon: auto-tune DAMOS for NUMA setups
  including tiered memory" from SeongJae Park introduces new DAMOS quota
  goal metrics which eliminate the manual tuning which is required when
  utilizing DAMON for memory tiering.

- The 5 patch series "mm/vmalloc.c: code cleanup and improvements" from
  Baoquan He provides cleanups and small efficiency improvements which
  Baoquan found via code inspection.

- The 2 patch series "vmscan: enforce mems_effective during demotion"
  from Gregory Price "changes reclaim to respect cpuset.mems_effective
  during demotion when possible".  because "presently, reclaim explicitly
  ignores cpuset.mems_effective when demoting, which may cause the cpuset
  settings to violated." "This is useful for isolating workloads on a
  multi-tenant system from certain classes of memory more consistently."

- The 2 patch series ""Clean up split_huge_pmd_locked() and remove
  unnecessary folio pointers" from Gavin Guo provides minor cleanups and
  efficiency gains in in the huge page splitting and migrating code.

- The 3 patch series "Use kmem_cache for memcg alloc" from Huan Yang
  creates a slab cache for `struct mem_cgroup', yielding improved memory
  utilization.

- The 4 patch series "add max arg to swappiness in memory.reclaim and
  lru_gen" from Zhongkun He adds a new "max" argument to the "swappiness="
  argument for memory.reclaim MGLRU's lru_gen.  This directs proactive
  reclaim to reclaim from only anon folios rather than file-backed folios.

- The 17 patch series "kexec: introduce Kexec HandOver (KHO)" from Mike
  Rapoport is the first step on the path to permitting the kernel to
  maintain existing VMs while replacing the host kernel via file-based
  kexec.  At this time only memblock's reserve_mem is preserved.

- The 7 patch series "mm: Introduce for_each_valid_pfn()" from David
  Woodhouse provides and uses a smarter way of looping over a pfn range.
  By skipping ranges of invalid pfns.

- The 2 patch series "sched/numa: Skip VMA scanning on memory pinned to
  one NUMA node via cpuset.mems" from Libo Chen removes a lot of pointless
  VMA scanning when a task is pinned a single NUMA mode.  Dramatic
  performance benefits were seen in some real world cases.

- The 2 patch series "JFS: Implement migrate_folio for
  jfs_metapage_aops" from Shivank Garg addresses a warning which occurs
  during memory compaction when using JFS.

- The 4 patch series "move all VMA allocation, freeing and duplication
  logic to mm" from Lorenzo Stoakes moves some VMA code from kernel/fork.c
  into the more appropriate mm/vma.c.

- The 6 patch series "mm, swap: clean up swap cache mapping helper" from
  Kairui Song provides code consolidation and cleanups related to the
  folio_index() function.

- The 2 patch series "mm/gup: Cleanup memfd_pin_folios()" from Vishal
  Moola does that.

- The 8 patch series "memcg: Fix test_memcg_min/low test failures" from
  Waiman Long addresses some bogus failures which are being reported by
  the test_memcontrol selftest.

- The 3 patch series "eliminate mmap() retry merge, add .mmap_prepare
  hook" from Lorenzo Stoakes commences the deprecation of
  file_operations.mmap() in favor of the new
  file_operations.mmap_prepare().  The latter is more restrictive and
  prevents drivers from messing with things in ways which, amongst other
  problems, may defeat VMA merging.

- The 4 patch series "memcg: decouple memcg and objcg stocks"" from
  Shakeel Butt decouples the per-cpu memcg charge cache from the objcg's
  one.  This is a step along the way to making memcg and objcg charging
  NMI-safe, which is a BPF requirement.

- The 6 patch series "mm/damon: minor fixups and improvements for code,
  tests, and documents" from SeongJae Park is "yet another batch of
  miscellaneous DAMON changes.  Fix and improve minor problems in code,
  tests and documents."

- The 7 patch series "memcg: make memcg stats irq safe" from Shakeel
  Butt converts memcg stats to be irq safe.  Another step along the way to
  making memcg charging and stats updates NMI-safe, a BPF requirement.

- The 4 patch series "Let unmap_hugepage_range() and several related
  functions take folio instead of page" from Fan Ni provides folio
  conversions in the hugetlb code.

----------------------------------------------------------------
Alexander Graf (12):
      memblock: add support for scratch memory
      kexec: add Kexec HandOver (KHO) generation helpers
      kexec: add KHO parsing support
      kexec: add KHO support to kexec file loads
      kexec: add config option for KHO
      arm64: add KHO support
      x86/kexec: add support for passing kexec handover (KHO) data
      x86/e820: temporarily enable KHO scratch for memory below 1M
      x86/boot: make sure KASLR does not step over KHO preserved memory
      x86/Kconfig: enable kexec handover for 64 bits
      memblock: add KHO support for reserve_mem
      Documentation: add documentation for KHO

Alexander Potapenko (5):
      kmsan: apply clang-format to files mm/kmsan/
      kmsan: fix usage of kmsan_enter_runtime() in kmsan_vmap_pages_range_noflush()
      kmsan: drop the declaration of kmsan_save_stack()
      kmsan: enter the runtime around kmsan_internal_memmove_metadata() call
      kmsan: rework kmsan_in_runtime() handling in kmsan_report()

Alexei Starovoitov (1):
      mm: rename try_alloc_pages() to alloc_pages_nolock()

Alice Ryhl (9):
      mm: rust: add abstraction for struct mm_struct
      mm: rust: add vm_area_struct methods that require read access
      mm: rust: add vm_insert_page
      mm: rust: add lock_vma_under_rcu
      mm: rust: add mmput_async support
      mm: rust: add VmaNew for f_ops->mmap()
      rust: miscdevice: add mmap support
      task: rust: rework how current is accessed
      mm: rust: add MEMORY MANAGEMENT [RUST]

Andrei Vagin (3):
      fs/proc: extend the PAGEMAP_SCAN ioctl to report guard regions
      tools headers UAPI: sync linux/fs.h with the kernel sources
      selftests/mm: add PAGEMAP_SCAN guard region test

Andrew Morton (1):
      Merge branch 'mm-hotfixes-stable' into mm-stable in order to successfully merge mm-unstable's "mm: add folio_mk_pte()",

Andy Shevchenko (1):
      util_macros.h: make the header more resilient

Anshuman Khandual (3):
      mm/ptdump: split note_page() into level specific callbacks
      mm/ptdump: split effective_prot() into level specific callbacks
      arm64/mm: define ptdesc_t

Baolin Wang (5):
      mm: huge_memory: add folio_mark_accessed() when zapping file THP
      mm: mincore: use pte_batch_hint() to batch process large folios
      mm: khugepaged: convert set_huge_pmd() to take a folio
      mm: convert do_set_pmd() to take a folio
      mm: khugepaged: decouple SHMEM and file folios' collapse

Baoquan He (8):
      mm/gup: remove unneeded checking in follow_page_pte()
      mm/gup: remove gup_fast_pgd_leaf() and clean up the relevant codes
      mm/gup: clean up codes in fault_in_xxx() functions
      mm/vmalloc.c: change purge_ndoes as local static variable
      mm/vmalloc.c: find the vmap of vmap_nodes in reverse order
      mm/vmalloc.c: optimize code in decay_va_pool_node() a little bit
      mm/vmalloc: optimize function vm_unmap_aliases()
      mm/vmalloc.c: return explicit error value in alloc_vmap_area()

Casey Chen (1):
      alloc_tag: check mem_profiling_support in alloc_tag_init

Chen Ni (1):
      mm: memcontrol: remove unnecessary NULL check before free_percpu()

Cheng-Han Wu (1):
      mm: remove unused macro INIT_PASID

Christoph Hellwig (1):
      xarray: fix kerneldoc for __xa_cmpxchg

Christoph Lameter (Ampere) (1):
      Update Christoph's Email address and make it consistent

David Hildenbrand (15):
      kernel/events/uprobes: pass VMA instead of MM to remove_breakpoint()
      kernel/events/uprobes: pass VMA to set_swbp(), set_orig_insn() and uprobe_write_opcode()
      kernel/events/uprobes: uprobe_write_opcode() rewrite
      selftests/mm: add simple VM_PFNMAP tests based on mmap'ing /dev/mem
      x86/mm/pat: factor out setting cachemode into pgprot_set_cachemode()
      mm: convert track_pfn_insert() to pfnmap_setup_cachemode*()
      mm: introduce pfnmap_track() and pfnmap_untrack() and use them for memremap
      mm: convert VM_PFNMAP tracking to pfnmap_track() + pfnmap_untrack()
      x86/mm/pat: remove old pfnmap tracking interface
      mm: remove VM_PAT
      x86/mm/pat: remove strict_prot parameter from reserve_pfn_range()
      x86/mm/pat: remove MEMTYPE_*_MATCH
      x86/mm/pat: inline memtype_match() into memtype_erase()
      drm/i915: track_pfn() -> "pfnmap tracking"
      mm/io-mapping: track_pfn() -> "pfnmap tracking"

David Woodhouse (7):
      mm: introduce for_each_valid_pfn() and use it from reserve_bootmem_region()
      mm: implement for_each_valid_pfn() for CONFIG_FLATMEM
      mm: implement for_each_valid_pfn() for CONFIG_SPARSEMEM
      mm, PM: use for_each_valid_pfn() in kernel/power/snapshot.c
      mm, x86: use for_each_valid_pfn() from __ioremap_check_ram()
      mm: use for_each_valid_pfn() in memory_hotplug
      mm/mm_init: use for_each_valid_pfn() in init_unavailable_range()

Dev Jain (1):
      mempolicy: optimize queue_folios_pte_range by PTE batching

Dmitry V. Levin (6):
      hexagon: add syscall_set_return_value()
      syscall.h: add syscall_set_arguments()
      syscall.h: introduce syscall_set_nr()
      ptrace_get_syscall_info: factor out ptrace_get_syscall_info_op
      ptrace: introduce PTRACE_SET_SYSCALL_INFO request
      selftests/ptrace: add a test case for PTRACE_SET_SYSCALL_INFO

Donet Tom (1):
      selftests/mm: restore default nr_hugepages value during cleanup in hugetlb_reparenting_test.sh

Enze Li (2):
      selftests/damon: remove the remaining test scripts for DAMON debugfs interface
      samples/damon/prcl: fix a comment typo

Fan Ni (6):
      mm: convert free_page_and_swap_cache() to free_folio_and_swap_cache()
      khugepaged: pass folio instead of head page to trace events
      mm/hugetlb: pass folio instead of page to unmap_ref_private()
      mm/hugetlb: refactor unmap_hugepage_range() to take folio instead of page
      mm/hugetlb: refactor __unmap_hugepage_range() to take folio instead of page
      mm/hugetlb: convert use of struct page to folio in __unmap_hugepage_range()

Feng Lee (1):
      mm: remove obsolete pgd_offset_gate()

Frank van der Linden (1):
      mm/hugetlb: use separate nodemask for bootmem allocations

Gavin Guo (2):
      mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()
      mm/huge_memory: remove useless folio pointers passing

Gavin Shan (2):
      mm: fix parameter passed to page_mapcount_is_type()
      mm/debug: fix parameter passed to page_mapcount_is_type()

Gregory Price (6):
      memory: implement memory_block_advise/probe_max_size
      x86: probe memory block size advisement value during mm init
      acpi,srat: give memory block size advice based on CFMWS alignment
      cpuset: rename cpuset_node_allowed to cpuset_current_node_allowed
      vmscan,cgroup: apply mems_effective to reclaim
      DAX: warn when kmem regions are truncated for memory block alignment

Guilherme Giacomo Simoes (1):
      mm: page-flags-layout.h: change the KASAN_TAG_WIDTH for HW_TAGS

Hao Ge (1):
      mm/vmscan: modify the assignment logic of the scan and total_scan variables

Huan Yang (3):
      mm/memcg: move mem_cgroup_init() ahead of cgroup_init()
      mm/memcg: use kmem_cache when alloc memcg
      mm/memcg: use kmem_cache when alloc memcg pernode info

Ignacio Encinas (1):
      mm: annotate data race in update_hiwater_rss

Jeongjun Park (1):
      mm/vmalloc: fix data race in show_numa_info()

Jinliang Zheng (1):
      mm: fix ratelimit_pages update error in dirty_ratio_handler()

Johannes Weiner (1):
      mm: page_alloc: tighten up find_suitable_fallback()

Joshua Hahn (1):
      mm/mempolicy: Weighted Interleave Auto-tuning

Kairui Song (5):
      fuse: drop usage of folio_index
      f2fs: drop usage of folio_index
      filemap: do not use folio_contains for swap cache folios
      mm: move folio_index to mm/swap.h and remove no longer needed helper
      mm, swap: remove no longer used swap mapping helper

Kemeng Shi (8):
      mm: swap: rename __swap_[entry/entries]_free[_locked] to swap_[entry/entries]_put[_locked]
      mm: swap: enable swap_entry_range_free() to drop any kind of last ref
      mm: swap: use swap_entries_free() to free swap entry in swap_entry_put_locked()
      mm: swap: use swap_entries_free() drop last ref count in swap_entries_put_nr()
      mm: swap: drop last SWAP_MAP_SHMEM flag in batch in swap_entries_put_nr()
      mm: swap: free each cluster individually in swap_entries_put_map_nr()
      mm: swap: factor out helper to drop cache of entries within a single cluster
      mm: swap: replace cluster_swap_free_nr() with swap_entries_put_[map/cache]()

Kevin Brodsky (12):
      mm: pass mm down to pagetable_{pte,pmd}_ctor
      x86: pgtable: always use pte_free_kernel()
      mm: call ctor/dtor for kernel PTEs
      m68k: mm: call ctor/dtor for kernel PTEs
      powerpc: mm: call ctor/dtor for kernel PTEs
      sparc64: mm: call ctor/dtor for kernel PTEs
      mm: skip ptlock_init() for kernel PMDs
      arm64: mm: use enum to identify pgtable level instead of *_SHIFT
      arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()
      riscv: mm: clarify ctor mm argument in alloc_{pte,pmd}_late
      arm64: mm: call PUD/P4D ctor in __create_pgd_mapping()
      riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc

Lance Yang (1):
      mm/rmap: inline folio_test_large_maybe_mapped_shared() into callers

Li Wang (1):
      selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting

Libo Chen (2):
      sched/numa: skip VMA scanning on memory pinned to one NUMA node via cpuset.mems
      sched/numa: add tracepoint that tracks the skipping of numa balancing due to cpuset memory pinning

Liu Ye (1):
      fs/proc/page: refactor to reduce code duplication

Lorenzo Stoakes (13):
      mm/vma: fix incorrectly disallowed anonymous VMA merges
      tools/testing: add PROCMAP_QUERY helper functions in mm self tests
      tools/testing/selftests: assert that anon merge cases behave as expected
      mm: move mmap/vma locking logic into specific files
      mm: establish mm/vma_exec.c for shared exec/mm VMA functionality
      mm: abstract initial stack setup to mm subsystem
      mm: move dup_mmap() to mm
      mm: perform VMA allocation, freeing, duplication in mm
      mm: introduce new .mmap_prepare() file callback
      mm: secretmem: convert to .mmap_prepare() hook
      mm/vma: remove mmap() retry merge
      MAINTAINERS: add kernel/fork.c to relevant sections
      mm: remove WARN_ON_ONCE() in file_has_valid_mmap_hooks()

Luiz Capitulino (3):
      mm: kmemleak: drop kmemleak_warning variable
      mm: kmemleak: drop wrong comment
      mm: kmemleak: mark variables as __read_mostly

Mark Brown (1):
      selftests/mm: deduplicate second mmap() of 5*PAGE_SIZE at base

Matthew Wilcox (Oracle) (19):
      mm: set the pte dirty if the folio is already dirty
      mm: introduce a common definition of mk_pte()
      sparc32: remove custom definition of mk_pte()
      x86: remove custom definition of mk_pte()
      um: remove custom definition of mk_pte()
      mm: make mk_pte() definition unconditional
      mm: add folio_mk_pte()
      hugetlb: simplify make_huge_pte()
      mm: remove mk_huge_pte()
      mm: add folio_mk_pmd()
      arch: remove mk_pmd()
      filemap: remove readahead_page()
      mm: remove offset_in_thp()
      iov_iter: convert iter_xarray_populate_pages() to use folios
      iov_iter: convert iov_iter_extract_xarray_pages() to use folios
      filemap: remove find_subpage()
      filemap: convert __readahead_batch() to use a folio
      filemap: remove readahead_page_batch()
      mm: delete thp_nr_pages()

Michal Clapinski (2):
      mm/compaction: remove low watermark cap for proactive compaction
      mm/compaction: reduce the difference between low and high watermarks

Michal Hocko (1):
      memcg, oom: do not bypass oom killer for dying tasks

Mike Rapoport (Microsoft) (6):
      execmem: enforce allocation size aligment to PAGE_SIZE
      memblock: add MEMBLOCK_RSRV_KERN flag
      memblock: introduce memmap_init_kho_scratch()
      kexec: enable KHO support for memory preservation
      x86/setup: use memblock_reserve_kern for memory used by kernel
      Documentation: KHO: add memblock bindings

Nhat Pham (1):
      zsmalloc: prefer the the original page's node for compressed data

Nikhil Dhama (1):
      mm: pcp: increase pcp->free_count threshold to trigger free_high

Oscar Salvador (2):
      mm, hugetlb: avoid passing a null nodemask when there is mbind policy
      mm,hugetlb: allocate frozen pages in alloc_buddy_hugetlb_folio

Pedro Falcato (1):
      mm: workingset: simplify lockdep check in update_node

Peter Xu (1):
      mm/selftests: add a test to verify mmap_changing race with -EAGAIN

Prabhav Kumar Vaish (1):
      mm: fix typos in comments in mm_init.c

Przemek Kitszel (1):
      xarray: make xa_alloc_cyclic() return 0 on all success cases

Rakie Kim (3):
      mm/mempolicy: fix memory leaks in weighted interleave sysfs
      mm/mempolicy: prepare weighted interleave sysfs for memory hotplug
      mm/mempolicy: support memory hotplug in weighted interleave

Ryan Chung (1):
      selftests/eventfd: correct test name and improve messages

SeongJae Park (17):
      mm/madvise: define and use madvise_behavior struct for madvise_do_behavior()
      mm/madvise: batch tlb flushes for MADV_FREE
      mm/memory: split non-tlb flushing part from zap_page_range_single()
      mm/madvise: batch tlb flushes for MADV_DONTNEED[_LOCKED]
      mm/damon/core: introduce damos quota goal metrics for memory node utilization
      mm/damon/sysfs-schemes: implement file for quota goal nid parameter
      mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer
      Docs/mm/damon/design: document node_mem_{used,free}_bp
      Docs/admin-guide/mm/damon/usage: document 'nid' file
      Docs/ABI/damon: document nid file
      samples/damon: implement a DAMON module for memory tiering
      mm/damon/core: warn and fix nr_accesses[_bp] corruption
      mm/damon/sysfs-schemes: fix wrong comment on damons_sysfs_quota_goal_metric_strs
      mm/damon/paddr: remove unused variable, folio_list, in damon_pa_stat()
      mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()
      selftests/damon/_damon_sysfs: read tried regions directories in order
      Docs/damon: update titles and brief introductions to explain DAMOS

Sergey Senozhatsky (3):
      zram: modernize writeback interface
      zsmalloc: cleanup headers includes
      Documentation: zram: update IDLE pages tracking documentation

Shakeel Butt (24):
      memcg: vmalloc: simplify MEMCG_VMALLOC updates
      memcg: remove root memcg check from refill_stock
      memcg: decouple drain_obj_stock from local stock
      memcg: introduce memcg_uncharge
      memcg: manually inline __refill_stock
      memcg: no refilling stock from obj_cgroup_release
      memcg: do obj_cgroup_put inside drain_obj_stock
      memcg: use __mod_memcg_state in drain_obj_stock
      memcg: manually inline replace_stock_objcg
      memcg: optimize memcg_rstat_updated
      memcg: multi-memcg percpu charge cache
      memcg: introduce non-blocking limit setting option
      memcg-introduce-non-blocking-limit-setting-option-v3
      memcg: simplify consume_stock
      memcg: separate local_trylock for memcg and obj
      memcg: completely decouple memcg and obj stocks
      memcg: no irq disable for memcg stock lock
      memcg: memcg_rstat_updated re-entrant safe against irqs
      memcg: move preempt disable to callers of memcg_rstat_updated
      memcg: make mod_memcg_state re-entrant safe against irqs
      memcg: make count_memcg_events re-entrant safe against irqs
      memcg: make __mod_memcg_lruvec_state re-entrant safe against irqs
      memcg: no stock lock for cpu hot-unplug
      memcg: objcg stock trylock without irq disabling

Shivank Garg (2):
      mm: add folio_expected_ref_count() for reference count calculation
      jfs: implement migrate_folio for jfs_metapage_aops

Siddarth G (2):
      selftests/mm: convert page_size to unsigned long
      selftests/mm: use long for dwRegionSize

Sidhartha Kumar (6):
      maple_tree: convert mas_prealloc_calc() to take in a maple write state
      maple_tree: use height and depth consistently
      maple_tree: use vacant nodes to reduce worst case allocations
      maple_tree: break on convergence in mas_spanning_rebalance()
      maple_tree: add sufficient height
      maple_tree: reorder mas->store_type case statements

Songtang Liu (1):
      mm: page_alloc: remove redundant READ_ONCE

SoumishDas (1):
      mm: add kernel-doc comment for free_pgd_range()

Su Hui (1):
      mm/damon/sysfs-schemes: use kmalloc_array() and size_add()

Thushara.M.S (1):
      docs/mm/damon/design: fix spelling mistake

Uladzislau Rezki (Sony) (8):
      vmalloc: add for_each_vmap_node() helper
      vmalloc: switch to for_each_vmap_node() helper
      vmalloc: use for_each_vmap_node() in purge-vmap-area
      vmalloc: use atomic_long_add_return_relaxed()
      lib/test_vmalloc.c: replace RWSEM to SRCU for setup
      lib/test_vmalloc.c: allow built-in execution
      MAINTAINERS: add test_vmalloc.c to VMALLOC section
      vmalloc: align nr_vmalloc_pages and vmap_lazy_nr

Vishal Moola (Oracle) (3):
      mm/compaction: use folio in hugetlb pathway
      mm/gup: remove unnecessary check in memfd_pin_folios()
      mm/gup: remove page_folio() in memfd_pin_folios()

Vlastimil Babka (1):
      memcg: combine slab obj stock charging and accounting

Waiman Long (2):
      selftests: memcg: allow low event with no memory.low and memory_recursiveprot on
      selftests: memcg: increase error tolerance of child memory.current check in test_memcg_protection()

Ye Liu (7):
      mm/show_mem: optimize si_meminfo_node by reducing redundant code
      mm/page_alloc: simplify free_page_is_bad by removing free_page_is_bad_report
      mm/rmap: rename page__anon_vma to anon_vma for consistency
      mm/rmap: fix typo in comment in page_address_in_vma
      mm/io-mapping: precompute remap protection flags for clarity
      mm/debug_page_alloc: improve error message for invalid guardpage minorder
      mm/numa: remove unnecessary local variable in alloc_node_data()

Yuquan Wang (1):
      mm: numa_memblks: introduce numa_add_reserved_memblk

Zhongkun He (5):
      mm: add swappiness=max arg to memory.reclaim for only anon reclaim
      mm: vmscan: add more comments about cache_trim_mode
      mm: add max swappiness arg to lru_gen for anonymous memory only
      mm: use SWAPPINESS_ANON_ONLY in MGLRU
      mm: cma: set early_pfn and bitmap as a union in cma_memrange

gaoxu (1):
      mm: add nr_free_highatomic in show_free_areas

 CREDITS                                            |    2 +-
 Documentation/ABI/testing/sysfs-kernel-mm-damon    |    6 +
 .../sysfs-kernel-mm-mempolicy-weighted-interleave  |   35 +-
 Documentation/ABI/testing/sysfs-kernel-mm-numa     |   16 +-
 Documentation/ABI/testing/sysfs-kernel-slab        |   96 +-
 Documentation/admin-guide/blockdev/zram.rst        |   58 +-
 Documentation/admin-guide/cgroup-v1/cgroups.rst    |    2 +-
 Documentation/admin-guide/cgroup-v1/cpusets.rst    |    2 +-
 Documentation/admin-guide/cgroup-v2.rst            |   27 +
 Documentation/admin-guide/kernel-parameters.txt    |   25 +
 Documentation/admin-guide/mm/damon/index.rst       |   11 +-
 Documentation/admin-guide/mm/damon/usage.rst       |   12 +-
 Documentation/admin-guide/mm/index.rst             |    1 +
 Documentation/admin-guide/mm/kho.rst               |  115 ++
 Documentation/admin-guide/mm/multigen_lru.rst      |    5 +-
 Documentation/admin-guide/mm/pagemap.rst           |    1 +
 Documentation/admin-guide/sysctl/vm.rst            |    6 +
 Documentation/core-api/index.rst                   |    1 +
 Documentation/core-api/kho/bindings/kho.yaml       |   43 +
 .../core-api/kho/bindings/memblock/memblock.yaml   |   39 +
 .../kho/bindings/memblock/reserve-mem.yaml         |   40 +
 Documentation/core-api/kho/bindings/sub-fdt.yaml   |   27 +
 Documentation/core-api/kho/concepts.rst            |   74 ++
 Documentation/core-api/kho/fdt.rst                 |   80 ++
 Documentation/core-api/kho/index.rst               |   13 +
 Documentation/mm/damon/design.rst                  |   15 +-
 Documentation/mm/damon/index.rst                   |    6 +-
 Documentation/networking/arcnet-hardware.rst       |    2 +-
 MAINTAINERS                                        |   37 +-
 arch/alpha/include/asm/pgtable.h                   |    7 -
 arch/arc/include/asm/hugepage.h                    |    2 -
 arch/arc/include/asm/pgtable-levels.h              |    2 -
 arch/arc/include/asm/syscall.h                     |   25 +
 arch/arm/include/asm/pgtable-3level.h              |    1 -
 arch/arm/include/asm/pgtable.h                     |    1 -
 arch/arm/include/asm/syscall.h                     |   37 +
 arch/arm/mm/mmu.c                                  |    2 +-
 arch/arm/probes/uprobes/core.c                     |    4 +-
 arch/arm64/Kconfig                                 |    3 +
 arch/arm64/include/asm/pgtable-types.h             |   20 +-
 arch/arm64/include/asm/pgtable.h                   |    7 -
 arch/arm64/include/asm/ptdump.h                    |   24 +-
 arch/arm64/include/asm/syscall.h                   |   29 +
 arch/arm64/kernel/efi.c                            |    4 +-
 arch/arm64/kernel/pi/map_kernel.c                  |    2 +-
 arch/arm64/kernel/pi/map_range.c                   |    4 +-
 arch/arm64/kernel/pi/pi.h                          |    2 +-
 arch/arm64/mm/mmap.c                               |    2 +-
 arch/arm64/mm/mmu.c                                |   93 +-
 arch/arm64/mm/ptdump.c                             |   50 +-
 arch/csky/include/asm/pgalloc.h                    |    2 +-
 arch/csky/include/asm/pgtable.h                    |    5 -
 arch/csky/include/asm/syscall.h                    |   13 +
 arch/hexagon/include/asm/pgtable.h                 |    3 -
 arch/hexagon/include/asm/syscall.h                 |   21 +
 arch/loongarch/include/asm/pgalloc.h               |    2 +-
 arch/loongarch/include/asm/pgtable.h               |    7 -
 arch/loongarch/include/asm/syscall.h               |   15 +
 arch/loongarch/mm/pgtable.c                        |    9 -
 arch/m68k/include/asm/mcf_pgalloc.h                |    8 +-
 arch/m68k/include/asm/mcf_pgtable.h                |    6 -
 arch/m68k/include/asm/motorola_pgalloc.h           |   10 +-
 arch/m68k/include/asm/motorola_pgtable.h           |    6 -
 arch/m68k/include/asm/sun3_pgtable.h               |    6 -
 arch/m68k/include/asm/syscall.h                    |    7 +
 arch/m68k/mm/motorola.c                            |    6 +-
 arch/microblaze/include/asm/pgtable.h              |    8 -
 arch/microblaze/include/asm/syscall.h              |    7 +
 arch/microblaze/mm/pgtable.c                       |    2 +-
 arch/mips/include/asm/pgalloc.h                    |    2 +-
 arch/mips/include/asm/pgtable.h                    |    9 -
 arch/mips/include/asm/syscall.h                    |   43 +
 arch/mips/mm/pgtable-32.c                          |   10 -
 arch/mips/mm/pgtable-64.c                          |    9 -
 arch/nios2/include/asm/pgtable.h                   |    6 -
 arch/nios2/include/asm/syscall.h                   |   16 +
 arch/openrisc/include/asm/pgtable.h                |    2 -
 arch/openrisc/include/asm/syscall.h                |   13 +
 arch/openrisc/mm/ioremap.c                         |    2 +-
 arch/parisc/include/asm/pgalloc.h                  |    2 +-
 arch/parisc/include/asm/pgtable.h                  |    6 -
 arch/parisc/include/asm/syscall.h                  |   19 +
 arch/powerpc/include/asm/book3s/64/pgtable.h       |    1 -
 arch/powerpc/include/asm/pgtable.h                 |    3 +-
 arch/powerpc/include/asm/syscall.h                 |   20 +
 arch/powerpc/mm/book3s64/pgtable.c                 |    7 +-
 arch/powerpc/mm/pgtable-frag.c                     |   30 +-
 arch/powerpc/mm/ptdump/ptdump.c                    |   46 +-
 arch/riscv/include/asm/pgtable-64.h                |    2 -
 arch/riscv/include/asm/pgtable.h                   |    2 -
 arch/riscv/include/asm/syscall.h                   |   19 +
 arch/riscv/mm/init.c                               |   26 +-
 arch/riscv/mm/ptdump.c                             |   46 +-
 arch/s390/include/asm/pgalloc.h                    |    2 +-
 arch/s390/include/asm/pgtable.h                    |   11 -
 arch/s390/include/asm/syscall.h                    |   21 +
 arch/s390/include/asm/tlb.h                        |    4 +-
 arch/s390/mm/dump_pagetables.c                     |   46 +-
 arch/s390/mm/pgalloc.c                             |    2 +-
 arch/sh/include/asm/pgtable_32.h                   |    8 -
 arch/sh/include/asm/syscall_32.h                   |   24 +
 arch/sparc/include/asm/pgtable_32.h                |   15 +-
 arch/sparc/include/asm/pgtable_64.h                |    2 -
 arch/sparc/include/asm/syscall.h                   |   22 +
 arch/sparc/mm/init_64.c                            |   29 +-
 arch/sparc/mm/srmmu.c                              |    2 +-
 arch/um/include/asm/pgtable-2level.h               |    1 -
 arch/um/include/asm/pgtable-4level.h               |    9 -
 arch/um/include/asm/pgtable.h                      |   18 +-
 arch/um/include/asm/syscall-generic.h              |   19 +
 arch/x86/Kconfig                                   |    3 +
 arch/x86/boot/compressed/kaslr.c                   |   50 +-
 arch/x86/include/asm/pgtable.h                     |   21 +-
 arch/x86/include/asm/setup.h                       |    2 +
 arch/x86/include/asm/syscall.h                     |   43 +
 arch/x86/include/uapi/asm/setup_data.h             |   13 +-
 arch/x86/kernel/e820.c                             |   18 +
 arch/x86/kernel/kexec-bzimage64.c                  |   37 +
 arch/x86/kernel/setup.c                            |   42 +-
 arch/x86/mm/dump_pagetables.c                      |   71 +-
 arch/x86/mm/init_64.c                              |   15 +-
 arch/x86/mm/ioremap.c                              |    7 +-
 arch/x86/mm/pat/memtype.c                          |  194 +--
 arch/x86/mm/pat/memtype_interval.c                 |   63 +-
 arch/x86/mm/pgtable.c                              |    9 +-
 arch/x86/realmode/init.c                           |    2 +
 arch/xtensa/include/asm/pgtable.h                  |    6 -
 arch/xtensa/include/asm/syscall.h                  |   18 +
 drivers/acpi/numa/srat.c                           |   15 +-
 drivers/base/memory.c                              |   51 +
 drivers/base/node.c                                |    9 +
 drivers/block/zram/zram_drv.c                      |  331 +++--
 drivers/dax/kmem.c                                 |   10 +-
 drivers/gpu/drm/i915/i915_mm.c                     |    4 +-
 drivers/of/fdt.c                                   |   34 +
 drivers/of/kexec.c                                 |   42 +
 fs/dax.c                                           |    3 +-
 fs/exec.c                                          |   69 +-
 fs/f2fs/data.c                                     |    4 +-
 fs/f2fs/inline.c                                   |    4 +-
 fs/f2fs/super.c                                    |    2 +-
 fs/fuse/file.c                                     |    4 +-
 fs/jfs/jfs_metapage.c                              |  106 ++
 fs/proc/page.c                                     |  161 +--
 fs/proc/task_mmu.c                                 |   17 +-
 include/asm-generic/hugetlb.h                      |    5 -
 include/asm-generic/memory_model.h                 |   10 +-
 include/asm-generic/pgalloc.h                      |   11 +-
 include/asm-generic/syscall.h                      |   30 +
 include/linux/cpuset.h                             |    9 +-
 include/linux/damon.h                              |    6 +
 include/linux/fs.h                                 |   25 +
 include/linux/gfp.h                                |    8 +-
 include/linux/huge_mm.h                            |   17 +-
 include/linux/hugetlb.h                            |   15 +-
 include/linux/kexec.h                              |    5 +
 include/linux/kexec_handover.h                     |  109 ++
 include/linux/khugepaged.h                         |    8 -
 include/linux/maple_tree.h                         |    4 +
 include/linux/memblock.h                           |   41 +-
 include/linux/memcontrol.h                         |   55 +-
 include/linux/memory.h                             |   10 +
 include/linux/mempolicy.h                          |    4 +
 include/linux/mm.h                                 |  357 ++----
 include/linux/mm_inline.h                          |    2 +
 include/linux/mm_types.h                           |   36 +-
 include/linux/mmap_lock.h                          |  227 ++++
 include/linux/mmzone.h                             |   88 ++
 include/linux/numa_memblks.h                       |    1 +
 include/linux/page-flags-layout.h                  |    4 +-
 include/linux/page-flags.h                         |   21 +-
 include/linux/pagemap.h                            |   91 +-
 include/linux/percpu-defs.h                        |    2 +-
 include/linux/pgtable.h                            |  131 +-
 include/linux/ptdump.h                             |   15 +-
 include/linux/rmap.h                               |    2 +-
 include/linux/swap.h                               |   12 +-
 include/linux/uprobes.h                            |    6 +-
 include/linux/util_macros.h                        |    3 +
 include/linux/xarray.h                             |   24 +-
 include/linux/zpool.h                              |    4 +-
 include/linux/zsmalloc.h                           |    3 +-
 include/trace/events/huge_memory.h                 |   12 +-
 include/trace/events/mmflags.h                     |    4 +-
 include/trace/events/sched.h                       |   33 +
 include/uapi/linux/fs.h                            |    1 +
 include/uapi/linux/ptrace.h                        |    7 +-
 init/main.c                                        |    2 +
 kernel/Kconfig.kexec                               |   14 +
 kernel/Makefile                                    |    1 +
 kernel/bpf/syscall.c                               |    2 +-
 kernel/cgroup/cpuset.c                             |   40 +-
 kernel/events/uprobes.c                            |  357 +++---
 kernel/fork.c                                      |  277 +----
 kernel/kexec_file.c                                |   13 +
 kernel/kexec_handover.c                            | 1266 ++++++++++++++++++++
 kernel/kexec_internal.h                            |   16 +
 kernel/power/snapshot.c                            |   42 +-
 kernel/ptrace.c                                    |  179 ++-
 kernel/sched/fair.c                                |    9 +
 lib/Kconfig.debug                                  |    3 +-
 lib/alloc_tag.c                                    |   34 +-
 lib/iov_iter.c                                     |   30 +-
 lib/maple_tree.c                                   |  191 +--
 lib/test_vmalloc.c                                 |   22 +-
 lib/test_xarray.c                                  |   17 +-
 lib/xarray.c                                       |    9 +-
 mm/Kconfig                                         |    6 +-
 mm/Makefile                                        |    4 +-
 mm/cma.c                                           |   11 +-
 mm/cma.h                                           |    6 +-
 mm/compaction.c                                    |   24 +-
 mm/damon/core.c                                    |   41 +
 mm/damon/paddr.c                                   |    1 -
 mm/damon/sysfs-schemes.c                           |   47 +-
 mm/damon/tests/core-kunit.h                        |   70 ++
 mm/debug.c                                         |    6 +-
 mm/debug_page_alloc.c                              |    2 +-
 mm/debug_vm_pgtable.c                              |   18 +-
 mm/execmem.c                                       |    2 +
 mm/filemap.c                                       |    2 +-
 mm/gup.c                                           |  145 +--
 mm/huge_memory.c                                   |   63 +-
 mm/hugetlb.c                                       |  137 +--
 mm/hugetlb_cma.c                                   |   11 +-
 mm/internal.h                                      |    9 +-
 mm/io-mapping.c                                    |    9 +-
 mm/khugepaged.c                                    |   34 +-
 mm/kmemleak.c                                      |    9 +-
 mm/kmsan/core.c                                    |   12 +-
 mm/kmsan/hooks.c                                   |    6 +-
 mm/kmsan/init.c                                    |    3 +-
 mm/kmsan/instrumentation.c                         |    4 -
 mm/kmsan/kmsan.h                                   |    1 -
 mm/kmsan/report.c                                  |    6 +-
 mm/kmsan/shadow.c                                  |    7 +-
 mm/madvise.c                                       |  101 +-
 mm/memblock.c                                      |  317 ++++-
 mm/memcontrol-v1.c                                 |    9 +-
 mm/memcontrol.c                                    |  648 +++++-----
 mm/memfd.c                                         |    1 +
 mm/memory.c                                        |  430 +++----
 mm/memory_hotplug.c                                |    8 +-
 mm/mempolicy.c                                     |  558 ++++++---
 mm/memremap.c                                      |    8 +-
 mm/migrate.c                                       |   23 +-
 mm/mincore.c                                       |   22 +-
 mm/mm_init.c                                       |   50 +-
 mm/mmap.c                                          |  306 +++--
 mm/mmap_lock.c                                     |  273 +++++
 mm/mmu_notifier.c                                  |    2 +-
 mm/mprotect.c                                      |    2 +-
 mm/mremap.c                                        |    4 -
 mm/nommu.c                                         |   28 +-
 mm/numa.c                                          |    4 +-
 mm/numa_memblks.c                                  |   22 +
 mm/page-writeback.c                                |    3 +-
 mm/page_alloc.c                                    |   62 +-
 mm/page_owner.c                                    |    2 +-
 mm/ptdump.c                                        |   62 +-
 mm/rmap.c                                          |   30 +-
 mm/secretmem.c                                     |   14 +-
 mm/show_mem.c                                      |   18 +-
 mm/slab_common.c                                   |    2 +-
 mm/swap.c                                          |    8 +-
 mm/swap.h                                          |   18 +
 mm/swap_state.c                                    |    8 +-
 mm/swapfile.c                                      |  184 ++-
 mm/userfaultfd.c                                   |    2 +-
 mm/vma.c                                           |  204 +++-
 mm/vma.h                                           |   15 +
 mm/vma_exec.c                                      |  161 +++
 mm/vma_init.c                                      |  151 +++
 mm/vmalloc.c                                       |  208 ++--
 mm/vmscan.c                                        |  107 +-
 mm/vmstat.c                                        |    2 +-
 mm/workingset.c                                    |    4 +-
 mm/zpdesc.h                                        |    3 +
 mm/zpool.c                                         |    8 +-
 mm/zsmalloc.c                                      |   32 +-
 mm/zswap.c                                         |    2 +-
 rust/helpers/helpers.c                             |    1 +
 rust/helpers/mm.c                                  |   50 +
 rust/kernel/lib.rs                                 |    1 +
 rust/kernel/miscdevice.rs                          |   45 +
 rust/kernel/mm.rs                                  |  344 ++++++
 rust/kernel/mm/virt.rs                             |  471 ++++++++
 rust/kernel/task.rs                                |  247 ++--
 samples/Makefile                                   |    1 +
 samples/damon/Kconfig                              |   13 +
 samples/damon/Makefile                             |    1 +
 samples/damon/mtier.c                              |  178 +++
 samples/damon/prcl.c                               |    2 +-
 tools/include/uapi/linux/fs.h                      |   19 +-
 tools/testing/memblock/tests/alloc_api.c           |   22 +-
 tools/testing/memblock/tests/alloc_helpers_api.c   |    4 +-
 tools/testing/memblock/tests/alloc_nid_api.c       |   20 +-
 tools/testing/radix-tree/maple.c                   |  126 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |   22 +-
 tools/testing/selftests/damon/Makefile             |    2 +-
 tools/testing/selftests/damon/_chk_dependency.sh   |   52 -
 tools/testing/selftests/damon/_damon_sysfs.py      |    5 +
 tools/testing/selftests/damon/_debugfs_common.sh   |   64 -
 .../selftests/filesystems/eventfd/eventfd_test.c   |    7 +-
 tools/testing/selftests/mm/.gitignore              |    2 +
 tools/testing/selftests/mm/Makefile                |    2 +
 tools/testing/selftests/mm/guard-regions.c         |   57 +
 .../selftests/mm/hugetlb_reparenting_test.sh       |   98 +-
 tools/testing/selftests/mm/map_fixed_noreplace.c   |    2 +-
 tools/testing/selftests/mm/merge.c                 |  455 +++++++
 tools/testing/selftests/mm/pagemap_ioctl.c         |   16 +-
 tools/testing/selftests/mm/pfnmap.c                |  196 +++
 tools/testing/selftests/mm/run_vmtests.sh          |    8 +
 tools/testing/selftests/mm/uffd-unit-tests.c       |  202 ++++
 tools/testing/selftests/mm/vm_util.c               |   62 +
 tools/testing/selftests/mm/vm_util.h               |   21 +
 tools/testing/selftests/ptrace/Makefile            |    2 +-
 tools/testing/selftests/ptrace/set_syscall_info.c  |  519 ++++++++
 tools/testing/vma/Makefile                         |    2 +-
 tools/testing/vma/vma.c                            |  127 +-
 tools/testing/vma/vma_internal.h                   |  281 ++++-
 321 files changed, 11607 insertions(+), 4263 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/kho.rst
 create mode 100644 Documentation/core-api/kho/bindings/kho.yaml
 create mode 100644 Documentation/core-api/kho/bindings/memblock/memblock.yaml
 create mode 100644 Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
 create mode 100644 Documentation/core-api/kho/bindings/sub-fdt.yaml
 create mode 100644 Documentation/core-api/kho/concepts.rst
 create mode 100644 Documentation/core-api/kho/fdt.rst
 create mode 100644 Documentation/core-api/kho/index.rst
 create mode 100644 include/linux/kexec_handover.h
 create mode 100644 kernel/kexec_handover.c
 create mode 100644 mm/vma_exec.c
 create mode 100644 mm/vma_init.c
 create mode 100644 rust/helpers/mm.c
 create mode 100644 rust/kernel/mm.rs
 create mode 100644 rust/kernel/mm/virt.rs
 create mode 100644 samples/damon/mtier.c
 delete mode 100644 tools/testing/selftests/damon/_chk_dependency.sh
 delete mode 100644 tools/testing/selftests/damon/_debugfs_common.sh
 create mode 100644 tools/testing/selftests/mm/merge.c
 create mode 100644 tools/testing/selftests/mm/pfnmap.c
 create mode 100644 tools/testing/selftests/ptrace/set_syscall_info.c

