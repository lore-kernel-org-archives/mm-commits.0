From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 8 Sep 2017 16:10:01 -0700
Message-ID: <20170908161001.e84271585208bb6f898a321d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757258AbdIHXKD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:10:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

126 patches, based on 015a9e66b9b8c1f28097ed09bf9350708e26249a:

- most of the rest of MM

- a small number of misc things

- lib/ updates

- checkpatch

- autofs updates

- ipc/ updates


Subject: mm: mempolicy: add queue_pages_required()
Subject: mm: x86: move _PAGE_SWP_SOFT_DIRTY from bit 7 to bit 1
Subject: mm: thp: introduce separate TTU flag for thp freezing
Subject: mm: thp: introduce CONFIG_ARCH_ENABLE_THP_MIGRATION
Subject: mm: thp: enable thp migration in generic path
Subject: mm: thp: check pmd migration entry in common path
Subject: mm: soft-dirty: keep soft-dirty bits over thp migration
Subject: mm: mempolicy: mbind and migrate_pages support thp migration
Subject: mm: migrate: move_pages() supports thp migration
Subject: mm: memory_hotplug: memory hotremove supports thp migration
Subject: hmm: heterogeneous memory management documentation
Subject: mm/hmm: heterogeneous memory management (HMM for short)
Subject: mm/hmm/mirror: mirror process address space on device with HMM helpers
Subject: mm/hmm/mirror: helper to snapshot CPU page table
Subject: mm/hmm/mirror: device page fault handler
Subject: mm/memory_hotplug: introduce add_pages
Subject: mm/ZONE_DEVICE: new type of ZONE_DEVICE for unaddressable memory
Subject: mm/ZONE_DEVICE: special case put_page() for device private pages
Subject: mm/memcontrol: allow to uncharge page without using page->lru field
Subject: mm/memcontrol: support MEMORY_DEVICE_PRIVATE
Subject: mm/hmm/devmem: device memory hotplug using ZONE_DEVICE
Subject: mm/hmm/devmem: dummy HMM device for ZONE_DEVICE memory
Subject: mm/migrate: new migrate mode MIGRATE_SYNC_NO_COPY
Subject: mm/migrate: new memory migration helper for use with device memory
Subject: mm/migrate: migrate_vma() unmap page from vma while collecting pages
Subject: mm/migrate: support un-addressable ZONE_DEVICE page in migration
Subject: mm/migrate: allow migrate_vma() to alloc new page on empty entry
Subject: mm/device-public-memory: device memory cache coherent with CPU
Subject: mm/hmm: add new helper to hotplug CDM memory region
Subject: mm/hmm: avoid bloating arch that do not make use of HMM
Subject: mm/hmm: fix build when HMM is disabled
Subject: mm: remove useless vma parameter to offset_il_node
Subject: userfaultfd: non-cooperative: closing the uffd without triggering SIGBUS
Subject: mm/memory.c: remove reduntant check for write access
Subject: mm: change the call sites of numa statistics items
Subject: mm: update NUMA counter threshold size
Subject: mm: consider the number in local CPUs when reading NUMA stats
Subject: mm/mlock.c: use page_zone() instead of page_zone_id()
Subject: mm/zsmalloc.c: change stat type parameter to int
Subject: mm: fadvise: avoid fadvise for fs without backing device
Subject: mm: memcontrol: use per-cpu stocks for socket memory uncharging
Subject: mm/memory.c: fix mem_cgroup_oom_disable() call missing
Subject: mm/sparse.c: fix typo in online_mem_sections
Subject: tools/testing/selftests/kcmp/kcmp_test.c: add KCMP_EPOLL_TFD testing
Subject: mm/page_alloc.c: apply gfp_allowed_mask before the first allocation attempt
Subject: mm: kvfree the swap cluster info if the swap file is unsatisfactory
Subject: mm/swapfile.c: fix swapon frontswap_map memory leak on error
Subject: mm/mempolicy.c: remove BUG_ON() checks for VMA inside mpol_misplaced()
Subject: fs, proc: remove priv argument from is_stack
Subject: proc: uninline proc_create()
Subject: fs, proc: unconditional cond_resched when reading smaps
Subject: linux/kernel.h: move DIV_ROUND_DOWN_ULL() macro
Subject: lib/string.c: add multibyte memset functions
Subject: lib/string.c: add testcases for memset16/32/64
Subject: x86: implement memset16, memset32 & memset64
Subject: ARM: implement memset32 & memset64
Subject: alpha: add support for memset16
Subject: drivers/block/zram/zram_drv.c: convert to using memset_l
Subject: drivers/scsi/sym53c8xx_2/sym_hipd.c: convert to use memset32
Subject: vga: optimise console scrolling
Subject: treewide: make "nr_cpu_ids" unsigned
Subject: arch: define CPU_BIG_ENDIAN for all fixed big endian archs
Subject: arch/microblaze: add choice for endianness and update Makefile
Subject: include: warn for inconsistent endian config definition
Subject: bitops: avoid integer overflow in GENMASK(_ULL)
Subject: rbtree: cache leftmost node internally
Subject: rbtree: optimize root-check during rebalancing loop
Subject: rbtree: add some additional comments for rebalancing cases
Subject: lib/rbtree_test.c: make input module parameters
Subject: lib/rbtree_test.c: add (inorder) traversal test
Subject: lib/rbtree_test.c: support rb_root_cached
Subject: sched/fair: replace cfs_rq->rb_leftmost
Subject: sched/deadline: replace earliest dl and rq leftmost caching
Subject: locking/rtmutex: replace top-waiter and pi_waiters leftmost caching
Subject: block/cfq: replace cfq_rb_root leftmost caching
Subject: lib/interval_tree: fast overlap detection
Subject: lib/interval-tree: correct comment wrt generic flavor
Subject: procfs: use faster rb_first_cached()
Subject: fs/epoll: use faster rb_first_cached()
Subject: mem/memcg: cache rightmost node
Subject: block/cfq: cache rightmost rb_node
Subject: lib/hexdump.c: return -EINVAL in case of error in hex2bin()
Subject: lib: add test module for CONFIG_DEBUG_VIRTUAL
Subject: lib/bitmap.c: make bitmap_parselist() thread-safe and much faster
Subject: lib/test_bitmap.c: add test for bitmap_parselist()
Subject: bitmap: introduce BITMAP_FROM_U64()
Subject: lib/rhashtable: fix comment on locks_mul default value
Subject: lib/string.c: check for kmalloc() failure
Subject: lib/cmdline.c: remove meaningless comment
Subject: radix-tree: must check __radix_tree_preload() return value
Subject: lib/oid_registry.c: X.509: fix the buffer overflow in the utility function for OID string
Subject: checkpatch: add --strict check for ifs with unnecessary parentheses
Subject: checkpatch: fix typo in comment
Subject: checkpatch: rename variables to avoid confusion
Subject: checkpatch: add 6 missing types to --list-types
Subject: binfmt_flat: delete two error messages for a failed memory allocation in decompress_exec()
Subject: init: move stack canary initialization after setup_arch
Subject: init/main.c: extract early boot entropy from the passed cmdline
Subject: autofs: fix AT_NO_AUTOMOUNT not being honored
Subject: autofs: make disc device user accessible
Subject: autofs: make dev ioctl version and ismountpoint user accessible
Subject: autofs: remove unused AUTOFS_IOC_EXPIRE_DIRECT/INDIRECT
Subject: autofs: non functional header inclusion cleanup
Subject: autofs: use AUTOFS_DEV_IOCTL_SIZE
Subject: autofs: drop wrong comment
Subject: autofs: use unsigned int/long instead of uint/ulong for ioctl args
Subject: vfat: deduplicate hex2bin()
Subject: test_kmod: remove paranoid UINT_MAX check on uint range processing
Subject: test_kmod: flip INT checks to be consistent
Subject: kmod: split out umh code into its own file
Subject: MAINTAINERS: clarify kmod is just a kernel module loader
Subject: kmod: split off umh headers into its own file
Subject: kmod: move #ifdef CONFIG_MODULES wrapper to Makefile
Subject: cpumask: make cpumask_next() out-of-line
Subject: drivers/pps: aesthetic tweaks to PPS-related content
Subject: drivers/pps: use surrounding "if PPS" to remove numerous dependency checks
Subject: m32r: defconfig: cleanup from old Kconfig options
Subject: mn10300: defconfig: cleanup from old Kconfig options
Subject: sh: defconfig: cleanup from old Kconfig options
Subject: kcov: support compat processes
Subject: ipc: convert ipc_namespace.count from atomic_t to refcount_t
Subject: ipc: convert sem_undo_list.refcnt from atomic_t to refcount_t
Subject: ipc: convert kern_ipc_perm.refcount from atomic_t to refcount_t
Subject: ipc/sem: drop sem_checkid helper
Subject: ipc/sem: play nicer with large nsops allocations
Subject: ipc: optimize semget/shmget/msgget for lots of keys



