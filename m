From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 12 Dec 2016 16:40:50 -0800
Message-ID: <20161212164050.79b78819e59a64d6d35b24e5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAkG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:40:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- various misc bits

- most of MM (quite a lot of MM material is awaiting the merge of
  linux-next dependencies)

- kasan

- printk updates

- procfs updates

- MAINTAINERS

- /lib updates

- checkpatch updates

123 patches, based on df5f0f0a028c9bf43949398a175dbaafaf513e14:

Subject: kthread: add __printf attributes
Subject: prctl: remove one-shot limitation for changing exe link
Subject: scripts/bloat-o-meter: don't use readlines()
Subject: scripts/bloat-o-meter: compile .NUMBER regex
Subject: scripts/tags.sh: handle OMAP platforms properly
Subject: m32r: add simple dma
Subject: m32r: fix build warning
Subject: drivers/pcmcia/m32r_pcc.c: check return from request_irq
Subject: drivers/pcmcia/m32r_pcc.c: use common error path
Subject: drivers/pcmcia/m32r_pcc.c: check return from add_pcc_socket
Subject: ocfs2/dlm: clean up useless BUG_ON default case in dlm_finalize_reco_handler()
Subject: ocfs2: delete redundant code and set the node bit into maybe_map directly
Subject: ocfs2/dlm: clean up deadcode in dlm_master_request_handler()
Subject: ocfs2: clean up unused 'page' parameter in ocfs2_write_end_nolock()
Subject: ocfs2: fix double put of recount tree in ocfs2_lock_refcount_tree()
Subject: ocfs2: use time64_t to represent orphan scan times
Subject: ocfs2: replace CURRENT_TIME macro
Subject: mm: memcontrol: use special workqueue for creating per-memcg caches
Subject: slub: move synchronize_sched out of slab_mutex on shrink
Subject: slub: avoid false-postive warning
Subject: mm/slab_common.c: check kmem_create_cache flags are common
Subject: mm, slab: faster active and free stats
Subject: mm, slab: maintain total slab count instead of active count
Subject: mm/mprotect.c: don't touch single threaded PTEs which are on the right node
Subject: mm/vmscan.c: set correct defer count for shrinker
Subject: mm/gup.c: make unnecessarily global vma_permits_fault() static
Subject: mm/hugetlb.c: use the right pte val for compare in hugetlb_cow
Subject: mm/hugetlb.c: use huge_pte_lock instead of opencoding the lock
Subject: kmemleak: fix reference to Documentation
Subject: mm: don't steal highatomic pageblock
Subject: mm: prevent double decrease of nr_reserved_highatomic
Subject: mm: try to exhaust highatomic reserve before the OOM
Subject: mm: make unreserve highatomic functions reliable
Subject: mm/vmalloc.c: simplify /proc/vmallocinfo implementation
Subject: mm, thp: avoid unlikely branches for split_huge_pmd
Subject: mm, mempolicy: clean up __GFP_THISNODE confusion in policy_zonelist
Subject: mm, compaction: fix NR_ISOLATED_* stats for pfn based migration
Subject: shmem: avoid maybe-uninitialized warning
Subject: mm: use the correct page size when removing the page
Subject: mm: update mmu_gather range correctly
Subject: mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages
Subject: mm: add tlb_remove_check_page_size_change to track page size change
Subject: mm: remove the page size change check in tlb_remove_page
Subject: mm: fix up get_user_pages* comments
Subject: mm/mempolicy.c: forbid static or relative flags for local NUMA mode
Subject: powerpc/mm: allow memory hotplug into a memoryless node
Subject: mm: remove x86-only restriction of movable_node
Subject: mm: enable CONFIG_MOVABLE_NODE on non-x86 arches
Subject: of/fdt: mark hotpluggable memory
Subject: dt: add documentation of "hotpluggable" memory property
Subject: mm/pkeys: generate pkey system call code only if ARCH_HAS_PKEYS is selected
Subject: mm: disable numa migration faults for dax vmas
Subject: mm: cma: make linux/cma.h standalone includible
Subject: mm/filemap.c: add comment for confusing logic in page_cache_tree_insert()
Subject: fs/fs-writeback.c: remove redundant if check
Subject: shmem: fix compilation warnings on unused functions
Subject: mm: don't cap request size based on read-ahead setting
Subject: include/linux/backing-dev-defs.h: shrink struct backing_dev_info
Subject: mm: khugepaged: close use-after-free race during shmem collapsing
Subject: mm: khugepaged: fix radix tree node leak in shmem collapse error path
Subject: mm: workingset: turn shadow node shrinker bugs into warnings
Subject: lib: radix-tree: native accounting of exceptional entries
Subject: lib: radix-tree: check accounting of existing slot replacement users
Subject: lib: radix-tree: add entry deletion support to __radix_tree_replace()
Subject: lib: radix-tree: update callback for changing leaf nodes
Subject: mm: workingset: move shadow entry tracking to radix tree exceptional tracking
Subject: mm: workingset: restore refault tracking for single-page files
Subject: mm: workingset: update shadow limit to reflect bigger active list
Subject: mm: remove free_unmap_vmap_area_noflush()
Subject: mm: remove free_unmap_vmap_area_addr()
Subject: mm: refactor __purge_vmap_area_lazy()
Subject: mm: add vfree_atomic()
Subject: kernel/fork: use vfree_atomic() to free thread stack
Subject: x86/ldt: use vfree_atomic() to free ldt entries
Subject: mm: mark all calls into the vmalloc subsystem as potentially sleeping
Subject: mm: turn vmap_purge_lock into a mutex
Subject: mm: add preempt points into __purge_vmap_area_lazy()
Subject: mm: move vma_is_anonymous check within pmd_move_must_withdraw
Subject: mm: THP page cache support for ppc64
Subject: mm, debug: print raw struct page data in __dump_page()
Subject: mm, rmap: handle anon_vma_prepare() common case inline
Subject: mm, page_alloc: keep pcp count and list contents in sync if struct page is corrupted
Subject: mm: add three more cond_resched() in swapoff
Subject: mm: add cond_resched() in gather_pte_stats()
Subject: mm: make transparent hugepage size public
Subject: kasan: support panic_on_warn
Subject: kasan: eliminate long stalls during quarantine reduction
Subject: kasan: turn on -fsanitize-address-use-after-scope
Subject: mm/percpu.c: fix panic triggered by BUG_ON() falsely
Subject: proc: report no_new_privs state
Subject: proc: make struct pid_entry::len unsigned
Subject: proc: make struct struct map_files_info::len unsigned int
Subject: proc: just list_del() struct pde_opener
Subject: proc: fix type of struct pde_opener::closing field
Subject: proc: kmalloc struct pde_opener
Subject: proc: tweak comments about 2 stage open and everything
Subject: fs/proc/array.c: slightly improve render_sigset_t
Subject: fs/proc/base.c: save decrement during lookup/readdir in /proc/$PID
Subject: fs/proc: calculate /proc/* and /proc/*/task/* nlink at init time
Subject: hung_task: decrement sysctl_hung_task_warnings only if it is positive
Subject: compiler-gcc.h: use "proved" instead of "proofed"
Subject: printk/NMI: fix up handling of the full nmi log buffer
Subject: printk/NMI: handle continuous lines and missing newline
Subject: printk/kdb: handle more message headers
Subject: printk/btrfs: handle more message headers
Subject: printk/sound: handle more message headers
Subject: printk: add Kconfig option to set default console loglevel
Subject: get_maintainer: look for arbitrary letter prefixes in sections
Subject: MAINTAINERS: add "B:" for URI where to file bugs
Subject: MAINTAINERS: add drm and drm/i915 bug filing info
Subject: MAINTAINERS: add "C:" for URI for chat where developers hang out
Subject: MAINTAINERS: add drm and drm/i915 irc channels
Subject: lib/Kconfig.debug: make CONFIG_STRICT_DEVMEM depend on CONFIG_DEVMEM
Subject: lib/rbtree.c: fix typo in comment of ____rb_erase_color
Subject: lib/ida: document locking requirements a bit better
Subject: checkpatch: don't try to get maintained status when --no-tree is given
Subject: scripts/checkpatch.pl: fix spelling
Subject: checkpatch: don't check .pl files, improve absolute path commit log test
Subject: checkpatch: avoid multiple line dereferences
Subject: checkpatch: don't check c99 types like uint8_t under tools
Subject: checkpatch: don't emit unified-diff error for rename-only patches
Subject: binfmt_elf: use vmalloc() for allocation of vma_filesz
Subject: init: reduce rootwait polling interval time to 5ms



