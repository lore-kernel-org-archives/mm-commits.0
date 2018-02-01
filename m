From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 31 Jan 2018 16:13:33 -0800
Message-ID: <20180131161333.942067e01f857096cdb270ba@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753756AbeBAANf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:13:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- misc fixes

- ocfs2 updates

- most of MM

119 patches, based on 7b1cd95d65eb3b1e13f8a90eb757e0ea232c7899:

Subject: fs/dax.c: release PMD lock even when there is no PMD support in DAX
Subject: tools: fix cross-compile var clobbering
Subject: scripts/decodecode: make it take multiline Code line
Subject: scripts/tags.sh: change find_other_sources() for include directories
Subject: m32r: remove abort()
Subject: fs/ocfs2/dlm/dlmmaster.c: clean up dead code
Subject: ocfs2/cluster: neaten a member of o2net_msg_handler
Subject: ocfs2: give an obvious tip for mismatched cluster names
Subject: ocfs2/cluster: close a race that fence can't be triggered
Subject: ocfs2: use the OCFS2_XATTR_ROOT_SIZE macro in ocfs2_reflink_xattr_header()
Subject: ocfs2: clean dead code in suballoc.c
Subject: ocfs2: return -EROFS to mount.ocfs2 if inode block is invalid
Subject: ocfs2: try a blocking lock before return AOP_TRUNCATED_PAGE
Subject: ocfs2/xattr: assign errno to 'ret' in ocfs2_calc_xattr_init()
Subject: ocfs2: clean up dead code in alloc.c
Subject: ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute
Subject: ocfs2: make metadata estimation accurate and clear
Subject: ocfs2: try to reuse extent block in dealloc without meta_alloc
Subject: ocfs2: add trimfs dlm lock resource
Subject: ocfs2: add trimfs lock to avoid duplicated trims in cluster
Subject: ocfs2: add ocfs2_try_rw_lock() and ocfs2_try_inode_lock()
Subject: ocfs2: add ocfs2_overwrite_io()
Subject: ocfs2: nowait aio support
Subject: ocfs2: unlock bh_state if bg check fails
Subject: ocfs2: return error when we attempt to access a dirty bh in jbd2
Subject: mm/slab_common.c: make calculate_alignment() static
Subject: mm/slab.c: remove redundant assignments for slab_state
Subject: mm/slub.c: fix wrong address during slab padding restoration
Subject: slub: remove obsolete comments of put_cpu_partial()
Subject: include/linux/sched/mm.h: uninline mmdrop_async(), etc
Subject: mm: kmemleak: remove unused hardirq.h
Subject: zswap: same-filled pages handling
Subject: mm: relax deferred struct page requirements
Subject: mm/mempolicy: remove redundant check in get_nodes
Subject: mm/mempolicy: fix the check of nodemask from user
Subject: mm/mempolicy: add nodes_empty check in SYSC_migrate_pages
Subject: mm: drop hotplug lock from lru_add_drain_all()
Subject: mm: show total hugetlb memory consumption in /proc/meminfo
Subject: mm: use sc->priority for slab shrink targets
Subject: mm: split deferred_init_range into initializing and freeing parts
Subject: mm/filemap.c: remove include of hardirq.h
Subject: mm: memcontrol: eliminate raw access to stat and event counters
Subject: mm: memcontrol: implement lruvec stat functions on top of each other
Subject: mm: memcontrol: fix excessive complexity in memory.stat reporting
Subject: mm/page_owner.c: use PTR_ERR_OR_ZERO()
Subject: mm/page_alloc.c: fix comment in __get_free_pages()
Subject: mm: do not stall register_shrinker()
Subject: selftests/vm: move 128TB mmap boundary test to generic directory
Subject: mm/interval_tree.c: use vma_pages() helper
Subject: mm: remove unused pgdat_reclaimable_pages()
Subject: mm, hugetlb: remove hugepages_treat_as_movable sysctl
Subject: mm/memory_hotplug.c: remove unnecesary check from register_page_bootmem_info_section()
Subject: mm: update comment describing tlb_gather_mmu
Subject: fs/proc/task_mmu.c: do not show VmExe bigger than total executable virtual memory
Subject: mm: memory_hotplug: remove second __nr_to_section in register_page_bootmem_info_section()
Subject: mm/huge_memory.c: fix comment in __split_huge_pmd_locked
Subject: mm, userfaultfd, THP: avoid waiting when PMD under THP migration
Subject: mm: add unmap_mapping_pages()
Subject: mm: get 7% more pages in a pagevec
Subject: asm-generic: provide generic_pmdp_establish()
Subject: arc: use generic_pmdp_establish as pmdp_establish
Subject: arm/mm: provide pmdp_establish() helper
Subject: arm64: provide pmdp_establish() helper
Subject: mips: use generic_pmdp_establish as pmdp_establish
Subject: powerpc/mm: update pmdp_invalidate to return old pmd value
Subject: s390/mm: modify pmdp_invalidate to return old value.
Subject: sparc64: update pmdp_invalidate() to return old pmd value
Subject: x86/mm: provide pmdp_establish() helper
Subject: mm: do not lose dirty and accessed bits in pmdp_invalidate()
Subject: mm: use updated pmdp_invalidate() interface to track dirty/accessed bits
Subject: mm/thp: remove pmd_huge_split_prepare()
Subject: mm: thp: use down_read_trylock() in khugepaged to avoid long block
Subject: mm, mmu_notifier: annotate mmu notifiers with blockable invalidate callbacks
Subject: mm, oom: avoid reaping only for mm's with blockable invalidate callbacks
Subject: mm/zsmalloc: simplify shrinker init/destroy
Subject: mm: align struct page more aesthetically
Subject: mm: de-indent struct page
Subject: mm: remove misleading alignment claims
Subject: mm: improve comment on page->mapping
Subject: mm: introduce _slub_counter_t
Subject: mm: store compound_dtor / compound_order as bytes
Subject: mm: document how to use struct page
Subject: mm: remove reference to PG_buddy
Subject: shmem: unexport shmem_add_seals()/shmem_get_seals()
Subject: shmem: rename functions that are memfd-related
Subject: hugetlb: expose hugetlbfs_inode_info in header
Subject: hugetlb: implement memfd sealing
Subject: shmem: add sealing support to hugetlb-backed memfd
Subject: memfd-test: test hugetlbfs sealing
Subject: memfd-test: add 'memfd-hugetlb:' prefix when testing hugetlbfs
Subject: memfd-test: move common code to a shared unit
Subject: memfd-test: run fuse test on hugetlb backend memory
Subject: userfaultfd: convert to use anon_inode_getfd()
Subject: mm: pin address_space before dereferencing it while isolating an LRU page
Subject: mm/fadvise: discard partial page if endbyte is also EOF
Subject: zswap: only save zswap header when necessary
Subject: memcg: refactor mem_cgroup_resize_limit()
Subject: mm/page_alloc.c: fix typos in comments
Subject: mm/page_owner.c: clean up init_pages_in_zone()
Subject: zsmalloc: use U suffix for negative literals being shifted
Subject: mm/page_ext.c: make page_ext_init a noop when CONFIG_PAGE_EXTENSION but nothing uses it
Subject: mm/compaction.c: fix comment for try_to_compact_pages()
Subject: include/linux/mmzone.h: fix explanation of lower bits in the SPARSEMEM mem_map pointer
Subject: mm/hmm: fix uninitialized use of 'entry' in hmm_vma_walk_pmd()
Subject: mm/memcontrol.c: make local symbol static
Subject: mm/memcontrol.c: try harder to decrease [memory,memsw].limit_in_bytes
Subject: mm, hugetlb: unify core page allocation accounting and initialization
Subject: mm, hugetlb: integrate giga hugetlb more naturally to the allocation path
Subject: mm, hugetlb: do not rely on overcommit limit during migration
Subject: mm, hugetlb: get rid of surplus page accounting tricks
Subject: mm, hugetlb: further simplify hugetlb allocation API
Subject: hugetlb, mempolicy: fix the mbind hugetlb migration
Subject: hugetlb, mbind: fall back to default policy if vma is NULL
Subject: mm: numa: do not trap faults on shared data section pages.
Subject: mm: correct comments regarding do_fault_around()
Subject: mm, memory_hotplug: fix memmap initialization
Subject: mm/swap.c: make functions and their kernel-doc agree
Subject: tools, vm: new option to specify kpageflags file
Subject: mm: remove PG_highmem description



