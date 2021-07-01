Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD827C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F3861469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhGABsz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABsz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:48:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62AEE61466;
        Thu,  1 Jul 2021 01:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625103985;
        bh=IiOaxI16BGgtIDcjQr3xYM9i0YBaPlW/EPnGOw4rEmU=;
        h=Date:From:To:Cc:Subject:From;
        b=J9tdKLbXEsOewrTBvOxREP6q6xRTnhMLPFzIp+0MVXFQSdycqI2e4/m1ptvfrc1PT
         gR2nNekGo19LHzXsbaiIvudTFteS5DJHRbe5vNC7jRGGYUFcBroFbSiX/jYdQFLja/
         wJRkohkkqxfiTxXNELOX8nHq9qY9qGZMc61+GeBQ=
Date:   Wed, 30 Jun 2021 18:46:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


This is the rest of the -mm tree, less 66 patches which are dependent on
things which are (or were recently) in linux-next.  I'll trickle that
material over next week.


192 patches, based on 7cf3dead1ad70c72edb03e2d98e1f3dcd332cdb2 plus the
June 28 sendings.

Subsystems affected by this patch series:

  mm/hugetlb
  mm/userfaultfd
  mm/vmscan
  mm/kconfig
  mm/proc
  mm/z3fold
  mm/zbud
  mm/ras
  mm/mempolicy
  mm/memblock
  mm/migration
  mm/thp
  mm/nommu
  mm/kconfig
  mm/madvise
  mm/memory-hotplug
  mm/zswap
  mm/zsmalloc
  mm/zram
  mm/cleanups
  mm/kfence
  mm/hmm
  procfs
  sysctl
  misc
  core-kernel
  lib
  lz4
  checkpatch
  init
  kprobes
  nilfs2
  hfs
  signals
  exec
  kcov
  selftests
  compress/decompress
  ipc

Subsystem: mm/hugetlb

    Muchun Song <songmuchun@bytedance.com>:
    Patch series "Free some vmemmap pages of HugeTLB page", v23:
      mm: memory_hotplug: factor out bootmem core functions to bootmem_info.c
      mm: hugetlb: introduce a new config HUGETLB_PAGE_FREE_VMEMMAP
      mm: hugetlb: gather discrete indexes of tail page
      mm: hugetlb: free the vmemmap pages associated with each HugeTLB page
      mm: hugetlb: defer freeing of HugeTLB pages
      mm: hugetlb: alloc the vmemmap pages associated with each HugeTLB page
      mm: hugetlb: add a kernel parameter hugetlb_free_vmemmap
      mm: memory_hotplug: disable memmap_on_memory when hugetlb_free_vmemmap enabled
      mm: hugetlb: introduce nr_free_vmemmap_pages in the struct hstate

    Shixin Liu <liushixin2@huawei.com>:
      mm/debug_vm_pgtable: move {pmd/pud}_huge_tests out of CONFIG_TRANSPARENT_HUGEPAGE
      mm/debug_vm_pgtable: remove redundant pfn_{pmd/pte}() and fix one comment mistake

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup and fixup for huge_memory:, v3:
      mm/huge_memory.c: remove dedicated macro HPAGE_CACHE_INDEX_MASK
      mm/huge_memory.c: use page->deferred_list
      mm/huge_memory.c: add missing read-only THP checking in transparent_hugepage_enabled()
      mm/huge_memory.c: remove unnecessary tlb_remove_page_size() for huge zero pmd
      mm/huge_memory.c: don't discard hugepage if other processes are mapping it

    Christophe Leroy <christophe.leroy@csgroup.eu>:
    Patch series "Subject: [PATCH v2 0/5] Implement huge VMAP and VMALLOC on powerpc 8xx", v2:
      mm/hugetlb: change parameters of arch_make_huge_pte()
      mm/pgtable: add stubs for {pmd/pub}_{set/clear}_huge
      mm/vmalloc: enable mapping of huge pages at pte level in vmap
      mm/vmalloc: enable mapping of huge pages at pte level in vmalloc
      powerpc/8xx: add support for huge pages on VMAP and VMALLOC

    Nanyong Sun <sunnanyong@huawei.com>:
      khugepaged: selftests: remove debug_cow

    Mina Almasry <almasrymina@google.com>:
      mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY

    Muchun Song <songmuchun@bytedance.com>:
    Patch series "Split huge PMD mapping of vmemmap pages", v4:
      mm: sparsemem: split the huge PMD mapping of vmemmap pages
      mm: sparsemem: use huge PMD mapping for vmemmap pages
      mm: hugetlb: introduce CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON

    Mike Kravetz <mike.kravetz@oracle.com>:
    Patch series "Fix prep_compound_gigantic_page ref count adjustment":
      hugetlb: remove prep_compound_huge_page cleanup
      hugetlb: address ref count racing in prep_compound_gigantic_page

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm/hwpoison: disable pcp for page_handle_poison()

Subsystem: mm/userfaultfd

    Peter Xu <peterx@redhat.com>:
    Patch series "userfaultfd/selftests: A few cleanups", v2:
      userfaultfd/selftests: use user mode only
      userfaultfd/selftests: remove the time() check on delayed uffd
      userfaultfd/selftests: dropping VERIFY check in locking_thread
      userfaultfd/selftests: only dump counts if mode enabled
      userfaultfd/selftests: unify error handling
    Patch series "mm/uffd: Misc fix for uffd-wp and one more test":
      mm/thp: simplify copying of huge zero page pmd when fork
      mm/userfaultfd: fix uffd-wp special cases for fork()
      mm/userfaultfd: fail uffd-wp registration if not supported
      mm/pagemap: export uffd-wp protection information
      userfaultfd/selftests: add pagemap uffd-wp test

    Axel Rasmussen <axelrasmussen@google.com>:
    Patch series "userfaultfd: add minor fault handling for shmem", v6:
      userfaultfd/shmem: combine shmem_{mcopy_atomic,mfill_zeropage}_pte
      userfaultfd/shmem: support minor fault registration for shmem
      userfaultfd/shmem: support UFFDIO_CONTINUE for shmem
      userfaultfd/shmem: advertise shmem minor fault support
      userfaultfd/shmem: modify shmem_mfill_atomic_pte to use install_pte()
      userfaultfd/selftests: use memfd_create for shmem test type
      userfaultfd/selftests: create alias mappings in the shmem test
      userfaultfd/selftests: reinitialize test context in each test
      userfaultfd/selftests: exercise minor fault handling shmem support

Subsystem: mm/vmscan

    Yu Zhao <yuzhao@google.com>:
      mm/vmscan.c: fix potential deadlock in reclaim_pages()
      include/trace/events/vmscan.h: remove mm_vmscan_inactive_list_is_low

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: workingset: define macro WORKINGSET_SHIFT

Subsystem: mm/kconfig

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      mm/kconfig: move HOLES_IN_ZONE into mm

Subsystem: mm/proc

    Mike Rapoport <rppt@linux.ibm.com>:
      docs: proc.rst: meminfo: briefly describe gaps in memory accounting

    David Hildenbrand <david@redhat.com>:
    Patch series "fs/proc/kcore: don't read offline sections, logically offline pages and hwpoisoned pages", v3:
      fs/proc/kcore: drop KCORE_REMAP and KCORE_OTHER
      fs/proc/kcore: pfn_is_ram check only applies to KCORE_RAM
      fs/proc/kcore: don't read offline sections, logically offline pages and hwpoisoned pages
      mm: introduce page_offline_(begin|end|freeze|thaw) to synchronize setting PageOffline()
      virtio-mem: use page_offline_(start|end) when setting PageOffline()
      fs/proc/kcore: use page_offline_(freeze|thaw)

Subsystem: mm/z3fold

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup and fixup for z3fold":
      mm/z3fold: define macro NCHUNKS as TOTAL_CHUNKS - ZHDR_CHUNKS
      mm/z3fold: avoid possible underflow in z3fold_alloc()
      mm/z3fold: remove magic number in z3fold_create_pool()
      mm/z3fold: remove unused function handle_to_z3fold_header()
      mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
      mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page

Subsystem: mm/zbud

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanups for zbud", v2:
      mm/zbud: reuse unbuddied[0] as buddied in zbud_pool
      mm/zbud: don't export any zbud API

Subsystem: mm/ras

    YueHaibing <yuehaibing@huawei.com>:
      mm/compaction: use DEVICE_ATTR_WO macro

    Liu Xiang <liu.xiang@zlingsmart.com>:
      mm: compaction: remove duplicate !list_empty(&sublist) check

    Wonhyuk Yang <vvghjk1234@gmail.com>:
      mm/compaction: fix 'limit' in fast_isolate_freepages

Subsystem: mm/mempolicy

    Feng Tang <feng.tang@intel.com>:
    Patch series "mm/mempolicy: some fix and semantics cleanup", v4:
      mm/mempolicy: cleanup nodemask intersection check for oom
      mm/mempolicy: don't handle MPOL_LOCAL like a fake MPOL_PREFERRED policy
      mm/mempolicy: unify the parameter sanity check for mbind and set_mempolicy

    Yang Shi <shy828301@gmail.com>:
      mm: mempolicy: don't have to split pmd for huge zero page

    Ben Widawsky <ben.widawsky@intel.com>:
      mm/mempolicy: use unified 'nodes' for bind/interleave/prefer policies

Subsystem: mm/memblock

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "arm64: drop pfn_valid_within() and simplify pfn_valid()", v4:
      include/linux/mmzone.h: add documentation for pfn_valid()
      memblock: update initialization of reserved pages
      arm64: decouple check whether pfn is in linear map from pfn_valid()
      arm64: drop pfn_valid_within() and simplify pfn_valid()

    Anshuman Khandual <anshuman.khandual@arm.com>:
      arm64/mm: drop HAVE_ARCH_PFN_VALID

Subsystem: mm/migration

    Muchun Song <songmuchun@bytedance.com>:
      mm: migrate: fix missing update page_private to hugetlb_page_subpool

Subsystem: mm/thp

    Collin Fijalkovich <cfijalkovich@google.com>:
      mm, thp: relax the VM_DENYWRITE constraint on file-backed THPs

    Yang Shi <shy828301@gmail.com>:
      mm: memory: add orig_pmd to struct vm_fault
      mm: memory: make numa_migrate_prep() non-static
      mm: thp: refactor NUMA fault handling
      mm: migrate: account THP NUMA migration counters correctly
      mm: migrate: don't split THP for misplaced NUMA page
      mm: migrate: check mapcount for THP instead of refcount
      mm: thp: skip make PMD PROT_NONE if THP migration is not supported

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/thp: make ARCH_ENABLE_SPLIT_PMD_PTLOCK dependent on PGTABLE_LEVELS > 2

    Yang Shi <shy828301@gmail.com>:
      mm: rmap: make try_to_unmap() void function

    Hugh Dickins <hughd@google.com>:
      mm/thp: remap_page() is only needed on anonymous THP
      mm: hwpoison_user_mappings() try_to_unmap() with TTU_SYNC

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/thp: fix strncpy warning

Subsystem: mm/nommu

    Chen Li <chenli@uniontech.com>:
      nommu: remove __GFP_HIGHMEM in vmalloc/vzalloc

    Liam Howlett <liam.howlett@oracle.com>:
      mm/nommu: unexport do_munmap()

Subsystem: mm/kconfig

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      mm: generalize ZONE_[DMA|DMA32]

Subsystem: mm/madvise

    David Hildenbrand <david@redhat.com>:
    Patch series "mm/madvise: introduce MADV_POPULATE_(READ|WRITE) to prefault page tables", v2:
      mm: make variable names for populate_vma_page_range() consistent
      mm/madvise: introduce MADV_POPULATE_(READ|WRITE) to prefault page tables
      MAINTAINERS: add tools/testing/selftests/vm/ to MEMORY MANAGEMENT
      selftests/vm: add protection_keys_32 / protection_keys_64 to gitignore
      selftests/vm: add test for MADV_POPULATE_(READ|WRITE)

Subsystem: mm/memory-hotplug

    Liam Mark <lmark@codeaurora.org>:
      mm/memory_hotplug: rate limit page migration warnings

    Oscar Salvador <osalvador@suse.de>:
      mm,memory_hotplug: drop unneeded locking

Subsystem: mm/zswap

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup and fixup for zswap":
      mm/zswap.c: remove unused function zswap_debugfs_exit()
      mm/zswap.c: avoid unnecessary copy-in at map time
      mm/zswap.c: fix two bugs in zswap_writeback_entry()

Subsystem: mm/zsmalloc

    Zhaoyang Huang <zhaoyang.huang@unisoc.com>:
      mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup for zsmalloc":
      mm/zsmalloc.c: remove confusing code in obj_free()
      mm/zsmalloc.c: improve readability for async_free_zspage()

Subsystem: mm/zram

    Yue Hu <huyue2@yulong.com>:
      zram: move backing_dev under macro CONFIG_ZRAM_WRITEBACK

Subsystem: mm/cleanups

    Hyeonggon Yoo <42.hyeyoo@gmail.com>:
      mm: fix typos and grammar error in comments

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm: define default value for FIRST_USER_ADDRESS

    Zhen Lei <thunder.leizhen@huawei.com>:
      mm: fix spelling mistakes

    Mel Gorman <mgorman@techsingularity.net>:
    Patch series "Clean W=1 build warnings for mm/":
      mm/vmscan: remove kerneldoc-like comment from isolate_lru_pages
      mm/vmalloc: include header for prototype of set_iounmap_nonlazy
      mm/page_alloc: make should_fail_alloc_page() static
      mm/mapping_dirty_helpers: remove double Note in kerneldoc
      mm/memcontrol.c: fix kerneldoc comment for mem_cgroup_calculate_protection
      mm/memory_hotplug: fix kerneldoc comment for __try_online_node
      mm/memory_hotplug: fix kerneldoc comment for __remove_memory
      mm/zbud: add kerneldoc fields for zbud_pool
      mm/z3fold: add kerneldoc fields for z3fold_pool
      mm/swap: make swap_address_space an inline function
      mm/mmap_lock: remove dead code for !CONFIG_TRACING configurations
      mm/page_alloc: move prototype for find_suitable_fallback
      mm/swap: make NODE_DATA an inline function on CONFIG_FLATMEM

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/thp: define default pmd_pgtable()

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      kfence: unconditionally use unbound work queue

Subsystem: mm/hmm

    Alistair Popple <apopple@nvidia.com>:
    Patch series "Add support for SVM atomics in Nouveau", v11:
      mm: remove special swap entry functions
      mm/swapops: rework swap entry manipulation code
      mm/rmap: split try_to_munlock from try_to_unmap
      mm/rmap: split migration into its own function
      mm: rename migrate_pgmap_owner
      mm/memory.c: allow different return codes for copy_nonpresent_pte()
      mm: device exclusive memory access
      mm: selftests for exclusive device memory
      nouveau/svm: refactor nouveau_range_fault
      nouveau/svm: implement atomic SVM access

Subsystem: procfs

    Marcelo Henrique Cerri <marcelo.cerri@canonical.com>:
      proc: Avoid mixing integer types in mem_rw()

    ZHOUFENG <zhoufeng.zf@bytedance.com>:
      fs/proc/kcore.c: add mmap interface

    Kalesh Singh <kaleshsingh@google.com>:
      procfs: allow reading fdinfo with PTRACE_MODE_READ
      procfs/dmabuf: add inode number to /proc/*/fdinfo

Subsystem: sysctl

    Jiapeng Chong <jiapeng.chong@linux.alibaba.com>:
      sysctl: remove redundant assignment to first

Subsystem: misc

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      drm: include only needed headers in ascii85.h

Subsystem: core-kernel

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      kernel.h: split out panic and oops helpers

Subsystem: lib

    Zhen Lei <thunder.leizhen@huawei.com>:
      lib: decompress_bunzip2: remove an unneeded semicolon

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
    Patch series "lib/string_helpers: get rid of ugly *_escape_mem_ascii()", v3:
      lib/string_helpers: switch to use BIT() macro
      lib/string_helpers: move ESCAPE_NP check inside 'else' branch in a loop
      lib/string_helpers: drop indentation level in string_escape_mem()
      lib/string_helpers: introduce ESCAPE_NA for escaping non-ASCII
      lib/string_helpers: introduce ESCAPE_NAP to escape non-ASCII and non-printable
      lib/string_helpers: allow to append additional characters to be escaped
      lib/test-string_helpers: print flags in hexadecimal format
      lib/test-string_helpers: get rid of trailing comma in terminators
      lib/test-string_helpers: add test cases for new features
      MAINTAINERS: add myself as designated reviewer for generic string library
      seq_file: introduce seq_escape_mem()
      seq_file: add seq_escape_str() as replica of string_escape_str()
      seq_file: convert seq_escape() to use seq_escape_str()
      nfsd: avoid non-flexible API in seq_quote_mem()
      seq_file: drop unused *_escape_mem_ascii()

    Trent Piepho <tpiepho@gmail.com>:
      lib/math/rational.c: fix divide by zero
      lib/math/rational: add Kunit test cases

    Zhen Lei <thunder.leizhen@huawei.com>:
      lib/decompressors: fix spelling mistakes
      lib/mpi: fix spelling mistakes

    Alexey Dobriyan <adobriyan@gmail.com>:
      lib: memscan() fixlet
      lib: uninline simple_strtoull()

    Matteo Croce <mcroce@microsoft.com>:
      lib/test_string.c: allow module removal

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      kernel.h: split out kstrtox() and simple_strtox() to a separate header

Subsystem: lz4

    Rajat Asthana <thisisrast7@gmail.com>:
      lz4_decompress: declare LZ4_decompress_safe_withPrefix64k static

    Dimitri John Ledkov <dimitri.ledkov@canonical.com>:
      lib/decompress_unlz4.c: correctly handle zero-padding around initrds.

Subsystem: checkpatch

    Guenter Roeck <linux@roeck-us.net>:
      checkpatch: scripts/spdxcheck.py now requires python3

    Joe Perches <joe@perches.com>:
      checkpatch: improve the indented label test

    Guenter Roeck <linux@roeck-us.net>:
      checkpatch: do not complain about positive return values starting with EPOLL

Subsystem: init

    Andrew Halaney <ahalaney@redhat.com>:
      init: print out unknown kernel parameters

Subsystem: kprobes

    Barry Song <song.bao.hua@hisilicon.com>:
      kprobes: remove duplicated strong free_insn_page in x86 and s390

Subsystem: nilfs2

    Colin Ian King <colin.king@canonical.com>:
      nilfs2: remove redundant continue statement in a while-loop

Subsystem: hfs

    Zhen Lei <thunder.leizhen@huawei.com>:
      hfsplus: remove unnecessary oom message

    Chung-Chiang Cheng <shepjeng@gmail.com>:
      hfsplus: report create_date to kstat.btime

Subsystem: signals

    Al Viro <viro@zeniv.linux.org.uk>:
      x86: signal: don't do sas_ss_reset() until we are certain that sigframe won't be abandoned

Subsystem: exec

    Alexey Dobriyan <adobriyan@gmail.com>:
      exec: remove checks in __register_bimfmt()

Subsystem: kcov

    Marco Elver <elver@google.com>:
      kcov: add __no_sanitize_coverage to fix noinstr for all architectures

Subsystem: selftests

    Dave Hansen <dave.hansen@linux.intel.com>:
    Patch series "selftests/vm/pkeys: Bug fixes and a new test":
      selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really random
      selftests/vm/pkeys: handle negative sys_pkey_alloc() return code
      selftests/vm/pkeys: refill shadow register after implicit kernel write
      selftests/vm/pkeys: exercise x86 XSAVE init state

Subsystem: compress/decompress

    Yu Kuai <yukuai3@huawei.com>:
      lib/decompressors: remove set but not used variabled 'level'

Subsystem: ipc

    Vasily Averin <vvs@virtuozzo.com>:
    Patch series "ipc: allocations cleanup", v2:
      ipc sem: use kvmalloc for sem_undo allocation
      ipc: use kmalloc for msg_queue and shmid_kernel

    Manfred Spraul <manfred@colorfullife.com>:
      ipc/sem.c: use READ_ONCE()/WRITE_ONCE() for use_global_lock
      ipc/util.c: use binary search for max_idx

 Documentation/admin-guide/kernel-parameters.txt    |   35 
 Documentation/admin-guide/mm/hugetlbpage.rst       |   11 
 Documentation/admin-guide/mm/memory-hotplug.rst    |   13 
 Documentation/admin-guide/mm/pagemap.rst           |    2 
 Documentation/admin-guide/mm/userfaultfd.rst       |    3 
 Documentation/core-api/kernel-api.rst              |    7 
 Documentation/filesystems/proc.rst                 |   48 
 Documentation/vm/hmm.rst                           |   19 
 Documentation/vm/unevictable-lru.rst               |   33 
 MAINTAINERS                                        |   10 
 arch/alpha/Kconfig                                 |    5 
 arch/alpha/include/asm/pgalloc.h                   |    1 
 arch/alpha/include/asm/pgtable.h                   |    1 
 arch/alpha/include/uapi/asm/mman.h                 |    3 
 arch/alpha/kernel/setup.c                          |    2 
 arch/arc/include/asm/pgalloc.h                     |    2 
 arch/arc/include/asm/pgtable.h                     |    8 
 arch/arm/Kconfig                                   |    3 
 arch/arm/include/asm/pgalloc.h                     |    1 
 arch/arm64/Kconfig                                 |   15 
 arch/arm64/include/asm/hugetlb.h                   |    3 
 arch/arm64/include/asm/memory.h                    |    2 
 arch/arm64/include/asm/page.h                      |    4 
 arch/arm64/include/asm/pgalloc.h                   |    1 
 arch/arm64/include/asm/pgtable.h                   |    2 
 arch/arm64/kernel/setup.c                          |    1 
 arch/arm64/kvm/mmu.c                               |    2 
 arch/arm64/mm/hugetlbpage.c                        |    5 
 arch/arm64/mm/init.c                               |   51 
 arch/arm64/mm/ioremap.c                            |    4 
 arch/arm64/mm/mmu.c                                |   22 
 arch/csky/include/asm/pgalloc.h                    |    2 
 arch/csky/include/asm/pgtable.h                    |    1 
 arch/hexagon/include/asm/pgtable.h                 |    4 
 arch/ia64/Kconfig                                  |    7 
 arch/ia64/include/asm/pal.h                        |    1 
 arch/ia64/include/asm/pgalloc.h                    |    1 
 arch/ia64/include/asm/pgtable.h                    |    1 
 arch/m68k/Kconfig                                  |    5 
 arch/m68k/include/asm/mcf_pgalloc.h                |    2 
 arch/m68k/include/asm/mcf_pgtable.h                |    2 
 arch/m68k/include/asm/motorola_pgalloc.h           |    1 
 arch/m68k/include/asm/motorola_pgtable.h           |    2 
 arch/m68k/include/asm/pgtable_mm.h                 |    1 
 arch/m68k/include/asm/sun3_pgalloc.h               |    1 
 arch/microblaze/Kconfig                            |    4 
 arch/microblaze/include/asm/pgalloc.h              |    2 
 arch/microblaze/include/asm/pgtable.h              |    2 
 arch/mips/Kconfig                                  |   10 
 arch/mips/include/asm/pgalloc.h                    |    1 
 arch/mips/include/asm/pgtable-32.h                 |    1 
 arch/mips/include/asm/pgtable-64.h                 |    1 
 arch/mips/include/uapi/asm/mman.h                  |    3 
 arch/mips/kernel/relocate.c                        |    1 
 arch/mips/sgi-ip22/ip22-reset.c                    |    1 
 arch/mips/sgi-ip32/ip32-reset.c                    |    1 
 arch/nds32/include/asm/pgalloc.h                   |    5 
 arch/nios2/include/asm/pgalloc.h                   |    1 
 arch/nios2/include/asm/pgtable.h                   |    2 
 arch/openrisc/include/asm/pgalloc.h                |    2 
 arch/openrisc/include/asm/pgtable.h                |    1 
 arch/parisc/include/asm/pgalloc.h                  |    1 
 arch/parisc/include/asm/pgtable.h                  |    2 
 arch/parisc/include/uapi/asm/mman.h                |    3 
 arch/parisc/kernel/pdc_chassis.c                   |    1 
 arch/powerpc/Kconfig                               |    6 
 arch/powerpc/include/asm/book3s/pgtable.h          |    1 
 arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h   |    5 
 arch/powerpc/include/asm/nohash/32/mmu-8xx.h       |   43 
 arch/powerpc/include/asm/nohash/32/pgtable.h       |    1 
 arch/powerpc/include/asm/nohash/64/pgtable.h       |    2 
 arch/powerpc/include/asm/pgalloc.h                 |    5 
 arch/powerpc/include/asm/pgtable.h                 |    6 
 arch/powerpc/kernel/setup-common.c                 |    1 
 arch/powerpc/platforms/Kconfig.cputype             |    1 
 arch/riscv/Kconfig                                 |    5 
 arch/riscv/include/asm/pgalloc.h                   |    2 
 arch/riscv/include/asm/pgtable.h                   |    2 
 arch/s390/Kconfig                                  |    6 
 arch/s390/include/asm/pgalloc.h                    |    3 
 arch/s390/include/asm/pgtable.h                    |    5 
 arch/s390/kernel/ipl.c                             |    1 
 arch/s390/kernel/kprobes.c                         |    5 
 arch/s390/mm/pgtable.c                             |    2 
 arch/sh/include/asm/pgalloc.h                      |    1 
 arch/sh/include/asm/pgtable.h                      |    2 
 arch/sparc/Kconfig                                 |    5 
 arch/sparc/include/asm/pgalloc_32.h                |    1 
 arch/sparc/include/asm/pgalloc_64.h                |    1 
 arch/sparc/include/asm/pgtable_32.h                |    3 
 arch/sparc/include/asm/pgtable_64.h                |    8 
 arch/sparc/kernel/sstate.c                         |    1 
 arch/sparc/mm/hugetlbpage.c                        |    6 
 arch/sparc/mm/init_64.c                            |    1 
 arch/um/drivers/mconsole_kern.c                    |    1 
 arch/um/include/asm/pgalloc.h                      |    1 
 arch/um/include/asm/pgtable-2level.h               |    1 
 arch/um/include/asm/pgtable-3level.h               |    1 
 arch/um/kernel/um_arch.c                           |    1 
 arch/x86/Kconfig                                   |   17 
 arch/x86/include/asm/desc.h                        |    1 
 arch/x86/include/asm/pgalloc.h                     |    2 
 arch/x86/include/asm/pgtable_types.h               |    2 
 arch/x86/kernel/cpu/mshyperv.c                     |    1 
 arch/x86/kernel/kprobes/core.c                     |    6 
 arch/x86/kernel/setup.c                            |    1 
 arch/x86/mm/init_64.c                              |   21 
 arch/x86/mm/pgtable.c                              |   34 
 arch/x86/purgatory/purgatory.c                     |    2 
 arch/x86/xen/enlighten.c                           |    1 
 arch/xtensa/include/asm/pgalloc.h                  |    2 
 arch/xtensa/include/asm/pgtable.h                  |    1 
 arch/xtensa/include/uapi/asm/mman.h                |    3 
 arch/xtensa/platforms/iss/setup.c                  |    1 
 drivers/block/zram/zram_drv.h                      |    2 
 drivers/bus/brcmstb_gisb.c                         |    1 
 drivers/char/ipmi/ipmi_msghandler.c                |    1 
 drivers/clk/analogbits/wrpll-cln28hpc.c            |    4 
 drivers/edac/altera_edac.c                         |    1 
 drivers/firmware/google/gsmi.c                     |    1 
 drivers/gpu/drm/nouveau/include/nvif/if000c.h      |    1 
 drivers/gpu/drm/nouveau/nouveau_svm.c              |  162 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h      |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c |    6 
 drivers/hv/vmbus_drv.c                             |    1 
 drivers/hwtracing/coresight/coresight-cpu-debug.c  |    1 
 drivers/leds/trigger/ledtrig-activity.c            |    1 
 drivers/leds/trigger/ledtrig-heartbeat.c           |    1 
 drivers/leds/trigger/ledtrig-panic.c               |    1 
 drivers/misc/bcm-vk/bcm_vk_dev.c                   |    1 
 drivers/misc/ibmasm/heartbeat.c                    |    1 
 drivers/misc/pvpanic/pvpanic.c                     |    1 
 drivers/net/ipa/ipa_smp2p.c                        |    1 
 drivers/parisc/power.c                             |    1 
 drivers/power/reset/ltc2952-poweroff.c             |    1 
 drivers/remoteproc/remoteproc_core.c               |    1 
 drivers/s390/char/con3215.c                        |    1 
 drivers/s390/char/con3270.c                        |    1 
 drivers/s390/char/sclp.c                           |    1 
 drivers/s390/char/sclp_con.c                       |    1 
 drivers/s390/char/sclp_vt220.c                     |    1 
 drivers/s390/char/zcore.c                          |    1 
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                |    1 
 drivers/staging/olpc_dcon/olpc_dcon.c              |    1 
 drivers/video/fbdev/hyperv_fb.c                    |    1 
 drivers/virtio/virtio_mem.c                        |    2 
 fs/Kconfig                                         |   15 
 fs/exec.c                                          |    3 
 fs/hfsplus/inode.c                                 |    5 
 fs/hfsplus/xattr.c                                 |    1 
 fs/nfsd/nfs4state.c                                |    2 
 fs/nilfs2/btree.c                                  |    1 
 fs/open.c                                          |   13 
 fs/proc/base.c                                     |    6 
 fs/proc/fd.c                                       |   20 
 fs/proc/kcore.c                                    |  136 ++
 fs/proc/task_mmu.c                                 |   34 
 fs/seq_file.c                                      |   43 
 fs/userfaultfd.c                                   |   15 
 include/asm-generic/bug.h                          |    3 
 include/linux/ascii85.h                            |    3 
 include/linux/bootmem_info.h                       |   68 +
 include/linux/compat.h                             |    2 
 include/linux/compiler-clang.h                     |   17 
 include/linux/compiler-gcc.h                       |    6 
 include/linux/compiler_types.h                     |    2 
 include/linux/huge_mm.h                            |   74 -
 include/linux/hugetlb.h                            |   80 +
 include/linux/hugetlb_cgroup.h                     |   19 
 include/linux/kcore.h                              |    3 
 include/linux/kernel.h                             |  227 ----
 include/linux/kprobes.h                            |    1 
 include/linux/kstrtox.h                            |  155 ++
 include/linux/memblock.h                           |    4 
 include/linux/memory_hotplug.h                     |   27 
 include/linux/mempolicy.h                          |    9 
 include/linux/memremap.h                           |    2 
 include/linux/migrate.h                            |   27 
 include/linux/mm.h                                 |   18 
 include/linux/mm_types.h                           |    2 
 include/linux/mmu_notifier.h                       |   26 
 include/linux/mmzone.h                             |   27 
 include/linux/mpi.h                                |    4 
 include/linux/page-flags.h                         |   22 
 include/linux/panic.h                              |   98 +
 include/linux/panic_notifier.h                     |   12 
 include/linux/pgtable.h                            |   44 
 include/linux/rmap.h                               |   13 
 include/linux/seq_file.h                           |   10 
 include/linux/shmem_fs.h                           |   19 
 include/linux/signal.h                             |    2 
 include/linux/string.h                             |    7 
 include/linux/string_helpers.h                     |   31 
 include/linux/sunrpc/cache.h                       |    1 
 include/linux/swap.h                               |   19 
 include/linux/swapops.h                            |  171 +--
 include/linux/thread_info.h                        |    1 
 include/linux/userfaultfd_k.h                      |    5 
 include/linux/vmalloc.h                            |   15 
 include/linux/zbud.h                               |   23 
 include/trace/events/vmscan.h                      |   41 
 include/uapi/asm-generic/mman-common.h             |    3 
 include/uapi/linux/mempolicy.h                     |    1 
 include/uapi/linux/userfaultfd.h                   |    7 
 init/main.c                                        |   42 
 ipc/msg.c                                          |    6 
 ipc/sem.c                                          |   25 
 ipc/shm.c                                          |    6 
 ipc/util.c                                         |   44 
 ipc/util.h                                         |    3 
 kernel/hung_task.c                                 |    1 
 kernel/kexec_core.c                                |    1 
 kernel/kprobes.c                                   |    2 
 kernel/panic.c                                     |    1 
 kernel/rcu/tree.c                                  |    2 
 kernel/signal.c                                    |   14 
 kernel/sysctl.c                                    |    4 
 kernel/trace/trace.c                               |    1 
 lib/Kconfig.debug                                  |   12 
 lib/decompress_bunzip2.c                           |    6 
 lib/decompress_unlz4.c                             |    8 
 lib/decompress_unlzo.c                             |    3 
 lib/decompress_unxz.c                              |    2 
 lib/decompress_unzstd.c                            |    4 
 lib/kstrtox.c                                      |    5 
 lib/lz4/lz4_decompress.c                           |    2 
 lib/math/Makefile                                  |    1 
 lib/math/rational-test.c                           |   56 +
 lib/math/rational.c                                |   16 
 lib/mpi/longlong.h                                 |    4 
 lib/mpi/mpicoder.c                                 |    6 
 lib/mpi/mpiutil.c                                  |    2 
 lib/parser.c                                       |    1 
 lib/string.c                                       |    2 
 lib/string_helpers.c                               |  142 +-
 lib/test-string_helpers.c                          |  157 ++-
 lib/test_hmm.c                                     |  127 ++
 lib/test_hmm_uapi.h                                |    2 
 lib/test_string.c                                  |    5 
 lib/vsprintf.c                                     |    1 
 lib/xz/xz_dec_bcj.c                                |    2 
 lib/xz/xz_dec_lzma2.c                              |    8 
 lib/zlib_inflate/inffast.c                         |    2 
 lib/zstd/huf.h                                     |    2 
 mm/Kconfig                                         |   16 
 mm/Makefile                                        |    2 
 mm/bootmem_info.c                                  |  127 ++
 mm/compaction.c                                    |   20 
 mm/debug_vm_pgtable.c                              |  109 --
 mm/gup.c                                           |   58 +
 mm/hmm.c                                           |   12 
 mm/huge_memory.c                                   |  269 ++---
 mm/hugetlb.c                                       |  369 +++++--
 mm/hugetlb_vmemmap.c                               |  332 ++++++
 mm/hugetlb_vmemmap.h                               |   53 -
 mm/internal.h                                      |   29 
 mm/kfence/core.c                                   |    4 
 mm/khugepaged.c                                    |   20 
 mm/madvise.c                                       |   66 +
 mm/mapping_dirty_helpers.c                         |    2 
 mm/memblock.c                                      |   28 
 mm/memcontrol.c                                    |    4 
 mm/memory-failure.c                                |   38 
 mm/memory.c                                        |  239 +++-
 mm/memory_hotplug.c                                |  161 ---
 mm/mempolicy.c                                     |  323 ++----
 mm/migrate.c                                       |  268 +----
 mm/mlock.c                                         |   12 
 mm/mmap_lock.c                                     |   59 -
 mm/mprotect.c                                      |   18 
 mm/nommu.c                                         |    5 
 mm/oom_kill.c                                      |    2 
 mm/page_alloc.c                                    |    5 
 mm/page_vma_mapped.c                               |   15 
 mm/rmap.c                                          |  644 +++++++++---
 mm/shmem.c                                         |  125 --
 mm/sparse-vmemmap.c                                |  432 +++++++-
 mm/sparse.c                                        |    1 
 mm/swap.c                                          |    2 
 mm/swapfile.c                                      |    2 
 mm/userfaultfd.c                                   |  249 ++--
 mm/util.c                                          |   40 
 mm/vmalloc.c                                       |   37 
 mm/vmscan.c                                        |   20 
 mm/workingset.c                                    |   10 
 mm/z3fold.c                                        |   39 
 mm/zbud.c                                          |  235 ++--
 mm/zsmalloc.c                                      |    5 
 mm/zswap.c                                         |   26 
 scripts/checkpatch.pl                              |   16 
 tools/testing/selftests/vm/.gitignore              |    3 
 tools/testing/selftests/vm/Makefile                |    5 
 tools/testing/selftests/vm/hmm-tests.c             |  158 +++
 tools/testing/selftests/vm/khugepaged.c            |    4 
 tools/testing/selftests/vm/madv_populate.c         |  342 ++++++
 tools/testing/selftests/vm/pkey-x86.h              |    1 
 tools/testing/selftests/vm/protection_keys.c       |   85 +
 tools/testing/selftests/vm/run_vmtests.sh          |   16 
 tools/testing/selftests/vm/userfaultfd.c           | 1094 ++++++++++-----------
 299 files changed, 6277 insertions(+), 3183 deletions(-)

