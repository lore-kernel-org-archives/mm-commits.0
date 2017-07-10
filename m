From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 10 Jul 2017 15:46:34 -0700
Message-ID: <20170710154634.3ecbf736fc5baa8516977b8b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41982 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754657AbdGJWqi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- most of the rest of MM

- KASAN updates

- lib/ updates

- checkpatch updates

- some binfmt_elf changes

- various misc bits


115 patches, based on 9eb788800510ae1a6bc419636a66071ee4deafd5:

Subject: swap: add block io poll in swapin path
Subject: mm, page_alloc: fallback to smallest page when not stealing whole pageblock
Subject: mm/memory.c: convert to DEFINE_DEBUGFS_ATTRIBUTE
Subject: mm, vmscan: avoid thrashing anon lru when free + file is low
Subject: mm/memory_hotplug.c: add NULL check to avoid potential NULL pointer dereference
Subject: mm/zsmalloc.c: fix -Wunneeded-internal-declaration warning
Subject: fs/buffer.c: make bh_lru_install() more efficient
Subject: mm: hugetlb: prevent reuse of hwpoisoned free hugepages
Subject: mm: hugetlb: return immediately for hugetlb page in __delete_from_page_cache()
Subject: mm: hwpoison: change PageHWPoison behavior on hugetlb pages
Subject: mm: hugetlb: soft-offline: dissolve source hugepage after successful migration
Subject: mm: soft-offline: dissolve free hugepage if soft-offlined
Subject: mm: hwpoison: introduce memory_failure_hugetlb()
Subject: mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error
Subject: mm: hugetlb: delete dequeue_hwpoisoned_huge_page()
Subject: mm: hwpoison: introduce idenfity_page_state
Subject: mm, vmpressure: pass-through notification support
Subject: mm: make PR_SET_THP_DISABLE immediately active
Subject: mm/memcontrol: exclude @root from checks in mem_cgroup_low
Subject: vmalloc: show lazy-purged vma info in vmallocinfo
Subject: mm/cma.c: warn if the CMA area could not be activated
Subject: mm/hugetlb.c: warn the user when issues arise on boot due to hugepages
Subject: oom, trace: remove ENUM evaluation of COMPACTION_FEEDBACK
Subject: mm: improve readability of transparent_hugepage_enabled()
Subject: mm: always enable thp for dax mappings
Subject: include/linux/page_ref.h: ensure page_ref_unfreeze is ordered against prior accesses
Subject: mm/migrate.c: stabilise page count when migrating transparent hugepages
Subject: zram: use __sysfs_match_string() helper
Subject: mm, memory_hotplug: support movable_node for hotpluggable nodes
Subject: mm, memory_hotplug: simplify empty node mask handling in new_node_page
Subject: hugetlb, memory_hotplug: prefer to use reserved pages for migration
Subject: mm: unify new_node_page and alloc_migrate_target
Subject: mm, hugetlb: schedule when potentially allocating many hugepages
Subject: mm, memcg: fix potential undefined behavior in mem_cgroup_event_ratelimit()
Subject: mm/hugetlb.c: replace memfmt with string_get_size
Subject: mm/truncate.c: fix THP handling in invalidate_mapping_pages()
Subject: userfaultfd: non-cooperative: add madvise() event for MADV_FREE request
Subject: mm/oom_kill.c: add tracepoints for oom reaper-related events
Subject: mm, hugetlb: unclutter hugetlb allocation layers
Subject: hugetlb: add support for preferred node to alloc_huge_page_nodemask
Subject: mm, hugetlb, soft_offline: use new_page_nodemask for soft offline migration
Subject: mm: avoid taking zone lock in pagetypeinfo_showmixed()
Subject: mm: drop useless local parameters of __register_one_node()
Subject: fs/proc/task_mmu.c: remove obsolete comment in show_map_vma()
Subject: mm/page_alloc.c: eliminate unsigned confusion in __rmqueue_fallback
Subject: mm/swap_slots.c: don't disable preemption while taking the per-CPU cache
Subject: include/linux/mmzone.h: remove ancient/ambiguous comment
Subject: include/linux/backing-dev.h: simplify wb_stat_sum
Subject: mm: document highmem_is_dirtyable sysctl
Subject: mm/memory_hotplug.c: remove unused local zone_type from __remove_zone()
Subject: cma: fix calculation of aligned offset
Subject: mm/balloon_compaction.c: enqueue zero page to balloon device
Subject: mm/mmap.c: do not blow on PROT_NONE MAP_FIXED holes in the stack
Subject: mm/mmap.c: expand_downwards: don't require the gap if !vm_prev
Subject: mm/list_lru.c: fix list_lru_count_node() to be race free
Subject: fs/dcache.c: fix spin lockup issue on nlru->lock
Subject: mm: use dedicated helper to access rlimit value
Subject: mm: swap: provide lru_add_drain_all_cpuslocked()
Subject: mm/memory-hotplug: switch locking to a percpu rwsem
Subject: mm: disallow early_pfn_to_nid on configurations which do not implement it
Subject: zram: constify attribute_group structures.
Subject: mm/zsmalloc: simplify zs_max_alloc_size handling
Subject: mm/kasan/kasan_init.c: use kasan_zero_pud for p4d table
Subject: mm/kasan: get rid of speculative shadow checks
Subject: x86/kasan: don't allocate extra shadow memory
Subject: arm64/kasan: don't allocate extra shadow memory
Subject: mm/kasan: add support for memory hotplug
Subject: mm/kasan/kasan.c: rename XXX_is_zero to XXX_is_nonzero
Subject: kasan: make get_wild_bug_type() static
Subject: frv: remove wrapper header for asm/device.h
Subject: frv: use generic fb.h
Subject: frv: cmpxchg: implement cmpxchg64()
Subject: fs/proc/generic.c: switch to ida_simple_get/remove
Subject: asm-generic/bug.h: declare struct pt_regs; before function prototype
Subject: linux/bug.h: correct formatting of block comment
Subject: linux/bug.h: correct "(foo*)" should be "(foo *)"
Subject: linux/bug.h: correct "space required before that '-'"
Subject: bug: split BUILD_BUG stuff out into <linux/build_bug.h>
Subject: ARM: fix rd_size declaration
Subject: kernel/ksysfs.c: constify attribute_group structures.
Subject: kernel/groups.c: use sort library function
Subject: kernel/kallsyms.c: replace all_var with IS_ENABLED(CONFIG_KALLSYMS_ALL)
Subject: MAINTAINERS: give proc sysctl some maintainer love
Subject: lib/test_bitmap.c: add optimisation tests
Subject: bitmap: optimise bitmap_set and bitmap_clear of a single bit
Subject: include/linux/bitmap.h: turn bitmap_set and bitmap_clear into memset when possible
Subject: bitmap: use memcmp optimisation in more situations
Subject: lib/kstrtox.c: delete end-of-string test
Subject: lib/kstrtox.c: use "unsigned int" more
Subject: lib/interval_tree_test.c: allow the module to be compiled-in
Subject: lib/interval_tree_test.c: make test options module parameters
Subject: lib/interval_tree_test.c: allow users to limit scope of endpoint
Subject: lib/interval_tree_test.c: allow full tree search
Subject: lib/rhashtable.c: use kvzalloc() in bucket_table_alloc() when possible
Subject: lib/extable.c: use bsearch() library function in search_extable()
Subject: lib/bsearch.c: micro-optimize pivot position calculation
Subject: checkpatch: improve the unnecessary OOM message test
Subject: checkpatch: warn when a MAINTAINERS entry isn't [A-Z]:\t
Subject: checkpatch: [HLP]LIST_HEAD is also declaration
Subject: checkpatch: fix stepping through statements with $stat and ctx_statement_block
Subject: checkpatch: remove false warning for commit reference
Subject: checkpatch: improve tests for multiple line function definitions
Subject: checkpatch: silence perl 5.26.0 unescaped left brace warnings
Subject: checkpatch: change format of --color argument to --color[=WHEN]
Subject: checkpatch: improve macro reuse test
Subject: checkpatch: improve multi-line alignment test
Subject: fs, epoll: short circuit fetching events if thread has been killed
Subject: binfmt_elf: use ELF_ET_DYN_BASE only for PIE
Subject: arm: move ELF_ET_DYN_BASE to 4MB
Subject: arm64: move ELF_ET_DYN_BASE to 4GB / 4MB
Subject: powerpc: move ELF_ET_DYN_BASE to 4GB / 4MB
Subject: s390: reduce ELF_ET_DYN_BASE
Subject: binfmt_elf: safely increment argv pointers
Subject: kernel/signal.c: avoid undefined behaviour in kill_something_info
Subject: kernel/exit.c: avoid undefined behaviour when calling wait4()



