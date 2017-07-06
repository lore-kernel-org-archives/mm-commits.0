From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 6 Jul 2017 15:34:38 -0700
Message-ID: <20170706153438.fd42a43408ad60b43130672e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbdGFWet (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- a few hotfixes

- various misc updates

- ocfs2 updates

- most of MM

108 patches, based on 9ced560b82606b35adb33a27012a148d418a4c1f:

Subject: compiler, clang: always inline when CONFIG_OPTIMIZE_INLINING is disabled
Subject: thp, mm: fix crash due race in MADV_FREE handling
Subject: kernel/extable.c: mark core_kernel_text notrace
Subject: mn10300: remove wrapper header for asm/device.h
Subject: mn10300: use generic fb.h
Subject: tile: provide default ioremap declaration
Subject: scripts/gen_initramfs_list.sh: teach INITRAMFS_ROOT_UID and INITRAMFS_ROOT_GID that -1 means "current user".
Subject: ramfs: clarify help text that compression applies to ramfs as well as legacy ramdisk.
Subject: scripts/spelling.txt: add a bunch more spelling mistakes
Subject: provide linux/set_memory.h
Subject: kernel/power/snapshot.c: use linux/set_memory.h
Subject: kernel/module.c: use linux/set_memory.h
Subject: include/linux/filter.h: use linux/set_memory.h
Subject: drivers/sh/intc/virq.c: delete an error message for a failed memory allocation in add_virq_to_pirq()
Subject: ocfs2: fix a static checker warning
Subject: ocfs2: use magic.h
Subject: ocfs2: free 'dummy_sc' in sc_fop_release() to prevent memory leak
Subject: ocfs2: constify attribute_group structures
Subject: fs/file.c: replace alloc_fdmem() with kvmalloc() alternative
Subject: mm/slub.c: remove a redundant assignment in ___slab_alloc()
Subject: mm/slub: reset cpu_slab's pointer in deactivate_slab()
Subject: mm/slub.c: pack red_left_pad with another int to save a word
Subject: mm/slub.c: wrap cpu_slab->partial in CONFIG_SLUB_CPU_PARTIAL
Subject: mm/slub.c: wrap kmem_cache->cpu_partial in config CONFIG_SLUB_CPU_PARTIAL
Subject: mm/slab.c: replace open-coded round-up code with ALIGN
Subject: mm: allow slab_nomerge to be set at build time
Subject: mm, sparsemem: break out of loops early
Subject: mm/mmap.c: mark protection_map as __ro_after_init
Subject: mm/vmscan.c: fix unsequenced modification and access warning
Subject: mm/nobootmem.c: return 0 when start_pfn equals end_pfn
Subject: ksm: introduce ksm_max_page_sharing per page deduplication limit
Subject: ksm: fix use after free with merge_across_nodes = 0
Subject: ksm: cleanup stable_node chain collapse case
Subject: ksm: swap the two output parameters of chain/chain_prune
Subject: ksm: optimize refile of stable_node_dup at the head of the chain
Subject: zram: count same page write as page_stored
Subject: mm/vmstat.c: standardize file operations variable names
Subject: mm, THP, swap: delay splitting THP during swap out
Subject: mm, THP, swap: unify swap slot free functions to put_swap_page
Subject: mm, THP, swap: move anonymous THP split logic to vmscan
Subject: mm, THP, swap: check whether THP can be split firstly
Subject: mm, THP, swap: enable THP swap optimization only if has compound map
Subject: mm: remove return value from init_currently_empty_zone
Subject: mm, memory_hotplug: use node instead of zone in can_online_high_movable
Subject: mm: drop page_initialized check from get_nid_for_pfn
Subject: mm, memory_hotplug: get rid of is_zone_device_section
Subject: mm, memory_hotplug: split up register_one_node()
Subject: mm, memory_hotplug: consider offline memblocks removable
Subject: mm: consider zone which is not fully populated to have holes
Subject: mm, compaction: skip over holes in __reset_isolation_suitable
Subject: mm: __first_valid_page skip over offline pages
Subject: mm, vmstat: skip reporting offline pages in pagetypeinfo
Subject: mm, memory_hotplug: do not associate hotadded memory to zones until online
Subject: mm, memory_hotplug: fix MMOP_ONLINE_KEEP behavior
Subject: mm, memory_hotplug: do not assume ZONE_NORMAL is default kernel zone
Subject: mm, memory_hotplug: replace for_device by want_memblock in arch_add_memory
Subject: mm, memory_hotplug: fix the section mismatch warning
Subject: mm, memory_hotplug: remove unused cruft after memory hotplug rework
Subject: kernel/exit.c: don't include unused userfaultfd_k.h
Subject: fs/userfaultfd.c: drop dead code
Subject: mm/madvise: enable (soft|hard) offline of HugeTLB pages at PGD level
Subject: mm/hugetlb/migration: use set_huge_pte_at instead of set_pte_at
Subject: mm/follow_page_mask: split follow_page_mask to smaller functions.
Subject: mm/hugetlb: export hugetlb_entry_migration helper
Subject: mm/follow_page_mask: add support for hugetlb pgd entries
Subject: mm/hugetlb: move default definition of hugepd_t earlier in the header
Subject: mm/follow_page_mask: add support for hugepage directory entry
Subject: powerpc/hugetlb: add follow_huge_pd implementation for ppc64
Subject: powerpc/mm/hugetlb: remove follow_huge_addr for powerpc
Subject: powerpc/hugetlb: enable hugetlb migration for ppc64
Subject: mm: zero hash tables in allocator
Subject: mm: update callers to use HASH_ZERO flag
Subject: mm: adaptive hash table scaling
Subject: mm/hugetlb: clean up ARCH_HAS_GIGANTIC_PAGE
Subject: powerpc/mm/hugetlb: add support for 1G huge pages
Subject: mm/page_alloc.c: mark bad_range() and meminit_pfn_in_nid() as __maybe_unused
Subject: mm: drop NULL return check of pte_offset_map_lock()
Subject: arm64: hugetlb: refactor find_num_contig()
Subject: arm64: hugetlb: remove spurious calls to huge_ptep_offset()
Subject: mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages
Subject: mm, gup: ensure real head page is ref-counted when using hugepages
Subject: mm/hugetlb: add size parameter to huge_pte_offset()
Subject: mm/hugetlb: allow architectures to override huge_pte_clear()
Subject: mm/hugetlb: introduce set_huge_swap_pte_at() helper
Subject: mm: rmap: use correct helper when poisoning hugepages
Subject: mm, page_alloc: fix more premature OOM due to race with cpuset update
Subject: mm, mempolicy: stop adjusting current->il_next in mpol_rebind_nodemask()
Subject: mm, page_alloc: pass preferred nid instead of zonelist to allocator
Subject: mm, mempolicy: simplify rebinding mempolicies when updating cpusets
Subject: mm, cpuset: always use seqlock when changing task's nodemask
Subject: mm, mempolicy: don't check cpuset seqlock where it doesn't matter
Subject: mm: kmemleak: slightly reduce the size of some structures on 64-bit architectures
Subject: mm: kmemleak: factor object reference updating out of scan_block()
Subject: mm: kmemleak: treat vm_struct as alternative reference to vmalloc'ed objects
Subject: mm: per-cgroup memory reclaim stats
Subject: mm/oom_kill: count global and memory cgroup oom kills
Subject: mm/swapfile.c: sort swap entries before free
Subject: mm/zswap.c: delete an error message for a failed memory allocation in zswap_pool_create()
Subject: mm/zswap.c: improve a size determination in zswap_frontswap_init()
Subject: mm/zswap.c: delete an error message for a failed memory allocation in zswap_dstmem_prepare()
Subject: mm: vmstat: move slab statistics from zone to node counters
Subject: mm: memcontrol: use the node-native slab memory counters
Subject: mm: memcontrol: use generic mod_memcg_page_state for kmem pages
Subject: mm: memcontrol: per-lruvec stats infrastructure
Subject: mm: memcontrol: account slab stats per lruvec
Subject: mm, memory_hotplug: drop artificial restriction on online/offline
Subject: mm, memory_hotplug: drop CONFIG_MOVABLE_NODE
Subject: mm, memory_hotplug: move movable_node to the hotplug proper



