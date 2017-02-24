From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 24 Feb 2017 14:55:01 -0800
Message-ID: <20170224145501.d04f0f973ef8752212250864@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWzC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:55:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- almost all of the rest of MM

- misc bits

- KASAN updates

- procfs

- lib/ updates

- checkpatch updates


124 patches, based on f1ef09fde17f9b77ca1435a5b53a28b203afb81c:

Subject: cris: use generic current.h
Subject: mm/ksm: improve deduplication of zero pages with colouring
Subject: mm, oom: header nodemask is NULL when cpusets are disabled
Subject: mm, devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin, done}
Subject: mm: validate device_hotplug is held for memory hotplug
Subject: mm/memory_hotplug.c: unexport __remove_pages()
Subject: memblock: let memblock_type_name know about physmem type
Subject: memblock: also dump physmem list within __memblock_dump_all
Subject: memblock: embed memblock type name within struct memblock_type
Subject: userfaultfd: non-cooperative: rename *EVENT_MADVDONTNEED to *EVENT_REMOVE
Subject: userfaultfd: non-cooperative: add madvise() event for MADV_REMOVE request
Subject: userfaultfd: non-cooperative: selftest: enable REMOVE event test for shmem
Subject: mm: vmscan: scan dirty pages even in laptop mode
Subject: mm: vmscan: kick flushers when we encounter dirty pages on the LRU
Subject: mm: vmscan: remove old flusher wakeup from direct reclaim path
Subject: mm: vmscan: only write dirty pages that the scanner has seen twice
Subject: mm: vmscan: move dirty pages out of the way until they're flushed
Subject: mm, page_alloc: split buffered_rmqueue()
Subject: mm, page_alloc: split alloc_pages_nodemask()
Subject: mm, page_alloc: drain per-cpu pages from workqueue context
Subject: mm, page_alloc: do not depend on cpu hotplug locks inside the allocator
Subject: mm, page_alloc: only use per-cpu allocator for irq-safe requests
Subject: mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf
Subject: mm: fix comments for mmap_init()
Subject: zram: remove waitqueue for IO done
Subject: mm, page_alloc: remove redundant checks from alloc fastpath
Subject: mm, page_alloc: don't check cpuset allowed twice in fast-path
Subject: mm, page_alloc: use static global work_struct for draining per-cpu pages
Subject: mm,fs,dax: change ->pmd_fault to ->huge_fault
Subject: mm, x86: add support for PUD-sized transparent hugepages
Subject: dax: support for transparent PUD pages for device DAX
Subject: mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Subject: mm: fix get_user_pages() vs device-dax pud mappings
Subject: z3fold: make pages_nr atomic
Subject: z3fold: fix header size related issues
Subject: z3fold: extend compaction function
Subject: z3fold: use per-page spinlock
Subject: z3fold: add kref refcounting
Subject: mm/migration: make isolate_movable_page() return int type
Subject: mm/migration: make isolate_movable_page always defined
Subject: HWPOISON: soft offlining for non-lru movable page
Subject: mm/hotplug: enable memory hotplug for non-lru movable pages
Subject: uprobes: split THPs before trying to replace them
Subject: mm: introduce page_vma_mapped_walk()
Subject: mm: fix handling PTE-mapped THPs in page_referenced()
Subject: mm: fix handling PTE-mapped THPs in page_idle_clear_pte_refs()
Subject: mm, rmap: check all VMAs that PTE-mapped THP can be part of
Subject: mm: convert page_mkclean_one() to use page_vma_mapped_walk()
Subject: mm: convert try_to_unmap_one() to use page_vma_mapped_walk()
Subject: mm, ksm: convert write_protect_page() to use page_vma_mapped_walk()
Subject: mm, uprobes: convert __replace_page() to use page_vma_mapped_walk()
Subject: mm: convert page_mapped_in_vma() to use page_vma_mapped_walk()
Subject: mm: drop page_check_address{,_transhuge}
Subject: mm: convert remove_migration_pte() to use page_vma_mapped_walk()
Subject: mm: call vm_munmap in munmap syscall instead of using open coded version
Subject: userfaultfd: non-cooperative: add event for memory unmaps
Subject: userfaultfd: non-cooperative: add event for exit() notification
Subject: userfaultfd: mcopy_atomic: return -ENOENT when no compatible VMA found
Subject: userfaultfd_copy: return -ENOSPC in case mm has gone
Subject: userfaultfd: documentation update
Subject: mm: alloc_contig_range: allow to specify GFP mask
Subject: mm: cma_alloc: allow to specify GFP mask
Subject: mm: wire up GFP flag passing in dma_alloc_from_contiguous
Subject: mm, madvise: fail with ENOMEM when splitting vma will hit max_map_count
Subject: mm: cma: print allocation failure reason and bitmap status
Subject: vmalloc: back off when the current task is killed
Subject: mm/page_alloc.c: remove duplicate inclusion of page_ext.h
Subject: mm/memory.c: use NULL instead of literal 0
Subject: mm: codgin-style fixes
Subject: drm: remove unnecessary fault wrappers
Subject: mm, vmscan: clear PGDAT_WRITEBACK when zone is balanced
Subject: mm/shmem.c: fix unlikely() test of info->seals to test only for WRITE and GROW
Subject: mm/autonuma: don't use set_pte_at when updating protnone ptes
Subject: mm/autonuma: let architecture override how the write bit should be stashed in a protnone pte.
Subject: mm/ksm: handle protnone saved writes when making page write protect
Subject: powerpc/mm/autonuma: switch ppc64 to its own implementation of saved write
Subject: mm/page-writeback.c: place "not" inside of unlikely() statement in wb_domain_writeout_inc()
Subject: zram: extend zero pages to same element pages
Subject: mm/memory_hotplug.c: fix overflow in test_pages_in_a_zone()
Subject: mm/page_alloc: fix nodes for reclaim in fast path
Subject: mm: remove shmem_mapping() shmem_zero_setup() duplicates
Subject: mm: vmpressure: fix sending wrong events on underflow
Subject: mm/zsmalloc: remove redundant SetPagePrivate2 in create_page_chain
Subject: mm/page_alloc.c: remove redundant init code for ZONE_MOVABLE
Subject: mm/zsmalloc: fix comment in zsmalloc
Subject: mm: cleanups for printing phys_addr_t and dma_addr_t
Subject: mm/gup: check for protnone only if it is a PTE entry
Subject: mm/thp/autonuma: use TNF flag instead of vm fault
Subject: mm: do not access page->mapping directly on page_endio
Subject: memory-hotplug: use dev_online for memhp_auto_online
Subject: kasan: drain quarantine of memcg slab objects
Subject: kasan: add memcg kmem_cache test
Subject: arch/frv/mb93090-mb00/pci-frv.c: fix build warning
Subject: alpha: use generic current.h
Subject: proc: use rb_entry()
Subject: proc: less code duplication in /proc/*/cmdline
Subject: procfs: use an enum for possible hidepid values
Subject: uapi: mqueue.h: add missing linux/types.h include
Subject: include/linux/iopoll.h: include <linux/ktime.h> instead of <linux/hrtimer.h>
Subject: compiler-gcc.h: add a new macro to wrap gcc attribute
Subject: m68k: replace gcc specific macros with ones from compiler.h
Subject: bug: switch data corruption check to __must_check
Subject: mm balloon: umount balloon_mnt when removing vb device
Subject: kernel/notifier.c: simplify expression
Subject: kernel/ksysfs.c: add __ro_after_init to bin_attribute structure
Subject: lib: add module support to crc32 tests
Subject: lib: add module support to glob tests
Subject: lib: add module support to atomic64 tests
Subject: lib/find_bit.c: micro-optimise find_next_*_bit
Subject: linux/kernel.h: fix DIV_ROUND_CLOSEST to support negative divisors
Subject: rbtree: use designated initializers
Subject: lib: add CONFIG_TEST_SORT to enable self-test of sort()
Subject: lib/test_sort.c: make it explicitly non-modular
Subject: lib: update LZ4 compressor module
Subject: lib/decompress_unlz4: change module to work with new LZ4 module version
Subject: crypto: change LZ4 modules to work with new LZ4 module version
Subject: fs/pstore: fs/squashfs: change usage of LZ4 to work with new LZ4 version
Subject: lib/lz4: remove back-compat wrappers
Subject: checkpatch: warn on embedded function names
Subject: checkpatch: warn on logging continuations
Subject: checkpatch: update $logFunctions
Subject: checkpatch: add another old address for the FSF
Subject: checkpatch: notice unbalanced else braces in a patch
Subject: checkpatch: remove false unbalanced braces warning



