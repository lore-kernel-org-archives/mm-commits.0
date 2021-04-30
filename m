Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0D9C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CAC6144F
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhD3Fxj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3Fxj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1D8D61424;
        Fri, 30 Apr 2021 05:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619761972;
        bh=Fk2klv83tyIARDKfU4kuBVfqGcQ8vJWVtcOTcCCeOQ8=;
        h=Date:From:To:Cc:Subject:From;
        b=LGjAHHXPoZkZ3lPy2XDNcXfQW6olRU4HgqCzhQ4Qcfehomt9nro0O03hqNwylstJH
         baHE8Ydb/6JRcnz+EljwgunX53nY5bAPQVfJ//9SiSAYJaagVOCQrhiLwEDA9aD2ee
         oikdoNq20kZwKSzr6yZGf/Xm9s/Grfmn0ce6X/s8=
Date:   Thu, 29 Apr 2021 22:52:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


A few misc subsystems and some of MM.


178 patches, based on 8ca5297e7e38f2dc8c753d33a5092e7be181fff0.

Subsystems affected by this patch series:

  ia64
  kbuild
  scripts
  sh
  ocfs2
  kfifo
  vfs
  kernel/watchdog
  mm/slab-generic
  mm/slub
  mm/kmemleak
  mm/debug
  mm/pagecache
  mm/msync
  mm/gup
  mm/memremap
  mm/memcg
  mm/pagemap
  mm/mremap
  mm/dma
  mm/sparsemem
  mm/vmalloc
  mm/documentation
  mm/kasan
  mm/initialization
  mm/pagealloc
  mm/memory-failure

Subsystem: ia64

    Zhang Yunkai <zhang.yunkai@zte.com.cn>:
      arch/ia64/kernel/head.S: remove duplicate include

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      arch/ia64/kernel/fsys.S: fix typos
      arch/ia64/include/asm/pgtable.h: minor typo fixes

    Valentin Schneider <valentin.schneider@arm.com>:
      ia64: ensure proper NUMA distance and possible map initialization

    Sergei Trofimovich <slyfox@gentoo.org>:
      ia64: drop unused IA64_FW_EMU ifdef
      ia64: simplify code flow around swiotlb init

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      ia64: trivial spelling fixes

    Sergei Trofimovich <slyfox@gentoo.org>:
      ia64: fix EFI_DEBUG build
      ia64: mca: always make IA64_MCA_DEBUG an expression
      ia64: drop marked broken DISCONTIGMEM and VIRTUAL_MEM_MAP
      ia64: module: fix symbolizer crash on fdescr

Subsystem: kbuild

    Luc Van Oostenryck <luc.vanoostenryck@gmail.com>:
      include/linux/compiler-gcc.h: sparse can do constant folding of __builtin_bswap*()

Subsystem: scripts

    Tom Saeger <tom.saeger@oracle.com>:
      scripts/spelling.txt: add entries for recent discoveries

    Wan Jiabing <wanjiabing@vivo.com>:
      scripts: a new script for checking duplicate struct declaration

Subsystem: sh

    Zhang Yunkai <zhang.yunkai@zte.com.cn>:
      arch/sh/include/asm/tlb.h: remove duplicate include

Subsystem: ocfs2

    Yang Li <yang.lee@linux.alibaba.com>:
      ocfs2: replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE

    Joseph Qi <joseph.qi@linux.alibaba.com>:
      ocfs2: map flags directly in flags_to_o2dlm()

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      ocfs2: fix a typo

    Jiapeng Chong <jiapeng.chong@linux.alibaba.com>:
      ocfs2/dlm: remove unused function

Subsystem: kfifo

    Dan Carpenter <dan.carpenter@oracle.com>:
      kfifo: fix ternary sign extension bugs

Subsystem: vfs

    Randy Dunlap <rdunlap@infradead.org>:
      vfs: fs_parser: clean up kernel-doc warnings

Subsystem: kernel/watchdog

    Petr Mladek <pmladek@suse.com>:
    Patch series "watchdog/softlockup: Report overall time and some cleanup", v2:
      watchdog: rename __touch_watchdog() to a better descriptive name
      watchdog: explicitly update timestamp when reporting softlockup
      watchdog/softlockup: report the overall time of softlockups
      watchdog/softlockup: remove logic that tried to prevent repeated reports
      watchdog: fix barriers when printing backtraces from all CPUs
      watchdog: cleanup handling of false positives

Subsystem: mm/slab-generic

    Rafael Aquini <aquini@redhat.com>:
      mm/slab_common: provide "slab_merge" option for !IS_ENABLED(CONFIG_SLAB_MERGE_DEFAULT) builds

Subsystem: mm/slub

    Vlastimil Babka <vbabka@suse.cz>:
      mm, slub: enable slub_debug static key when creating cache with explicit debug flags

    Oliver Glitta <glittao@gmail.com>:
      kunit: add a KUnit test for SLUB debugging functionality
      slub: remove resiliency_test() function

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      mm/slub.c: trivial typo fixes

Subsystem: mm/kmemleak

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      mm/kmemleak.c: fix a typo

Subsystem: mm/debug

    Georgi Djakov <georgi.djakov@linaro.org>:
      mm/page_owner: record the timestamp of all pages during free

    zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>:
      mm, page_owner: remove unused parameter in __set_page_owner_handle

    Sergei Trofimovich <slyfox@gentoo.org>:
      mm: page_owner: fetch backtrace only for tracked pages
      mm: page_owner: use kstrtobool() to parse bool option
      mm: page_owner: detect page_owner recursion via task_struct
      mm: page_poison: print page info when corruption is caught

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/memtest: add ARCH_USE_MEMTEST

Subsystem: mm/pagecache

    Jens Axboe <axboe@kernel.dk>:
    Patch series "Improve IOCB_NOWAIT O_DIRECT reads", v3:
      mm: provide filemap_range_needs_writeback() helper
      mm: use filemap_range_needs_writeback() for O_DIRECT reads
      iomap: use filemap_range_needs_writeback() for O_DIRECT reads

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/filemap: use filemap_read_page in filemap_fault
      mm/filemap: drop check for truncated page after I/O

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: page-writeback: simplify memcg handling in test_clear_page_writeback()

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: move page_mapping_file to pagemap.h

    Rui Sun <sunrui26@huawei.com>:
      mm/filemap: update stale comment

Subsystem: mm/msync

    Nikita Ermakov <sh1r4s3@mail.si-head.nl>:
      mm/msync: exit early when the flags is an MS_ASYNC and start < vm_start

Subsystem: mm/gup

    Joao Martins <joao.m.martins@oracle.com>:
    Patch series "mm/gup: page unpining improvements", v4:
      mm/gup: add compound page list iterator
      mm/gup: decrement head page once for group of subpages
      mm/gup: add a range variant of unpin_user_pages_dirty_lock()
      RDMA/umem: batch page unpin in __ib_umem_release()

    Yang Shi <shy828301@gmail.com>:
      mm: gup: remove FOLL_SPLIT

Subsystem: mm/memremap

    Zhiyuan Dai <daizhiyuan@phytium.com.cn>:
      mm/memremap.c: fix improper SPDX comment style

Subsystem: mm/memcg

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: fix kernel stack account

    Shakeel Butt <shakeelb@google.com>:
      memcg: cleanup root memcg checks
      memcg: enable memcg oom-kill for __GFP_NOFAIL

    Johannes Weiner <hannes@cmpxchg.org>:
    Patch series "mm: memcontrol: switch to rstat", v3:
      mm: memcontrol: fix cpuhotplug statistics flushing
      mm: memcontrol: kill mem_cgroup_nodeinfo()
      mm: memcontrol: privatize memcg_page_state query functions
      cgroup: rstat: support cgroup1
      cgroup: rstat: punt root-level optimization to individual controllers
      mm: memcontrol: switch to rstat
      mm: memcontrol: consolidate lruvec stat flushing
      kselftests: cgroup: update kmem test for new vmstat implementation

    Shakeel Butt <shakeelb@google.com>:
      memcg: charge before adding to swapcache on swapin

    Muchun Song <songmuchun@bytedance.com>:
    Patch series "Use obj_cgroup APIs to charge kmem pages", v5:
      mm: memcontrol: slab: fix obtain a reference to a freeing memcg
      mm: memcontrol: introduce obj_cgroup_{un}charge_pages
      mm: memcontrol: directly access page->memcg_data in mm/page_alloc.c
      mm: memcontrol: change ug->dummy_page only if memcg changed
      mm: memcontrol: use obj_cgroup APIs to charge kmem pages
      mm: memcontrol: inline __memcg_kmem_{un}charge() into obj_cgroup_{un}charge_pages()
      mm: memcontrol: move PageMemcgKmem to the scope of CONFIG_MEMCG_KMEM

    Wan Jiabing <wanjiabing@vivo.com>:
      linux/memcontrol.h: remove duplicate struct declaration

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: page_counter: mitigate consequences of a page_counter underflow

Subsystem: mm/pagemap

    Wang Qing <wangqing@vivo.com>:
      mm/memory.c: do_numa_page(): delete bool "migrated"

    Zhiyuan Dai <daizhiyuan@phytium.com.cn>:
      mm/interval_tree: add comments to improve code readability

    Oscar Salvador <osalvador@suse.de>:
    Patch series "Cleanup and fixups for vmemmap handling", v6:
      x86/vmemmap: drop handling of 4K unaligned vmemmap range
      x86/vmemmap: drop handling of 1GB vmemmap ranges
      x86/vmemmap: handle unpopulated sub-pmd ranges
      x86/vmemmap: optimize for consecutive sections in partial populated PMDs

    Ovidiu Panait <ovidiu.panait@windriver.com>:
      mm, tracing: improve rss_stat tracepoint message

    Christoph Hellwig <hch@lst.de>:
    Patch series "add remap_pfn_range_notrack instead of reinventing it in i915", v2:
      mm: add remap_pfn_range_notrack
      mm: add a io_mapping_map_user helper
      i915: use io_mapping_map_user
      i915: fix remap_io_sg to verify the pgprot

    Huang Ying <ying.huang@intel.com>:
      NUMA balancing: reduce TLB flush via delaying mapping on hint page fault

Subsystem: mm/mremap

    Brian Geffon <bgeffon@google.com>:
    Patch series "mm: Extend MREMAP_DONTUNMAP to non-anonymous mappings", v5:
      mm: extend MREMAP_DONTUNMAP to non-anonymous mappings
      Revert "mremap: don't allow MREMAP_DONTUNMAP on special_mappings and aio"
      selftests: add a MREMAP_DONTUNMAP selftest for shmem

Subsystem: mm/dma

    Zhiyuan Dai <daizhiyuan@phytium.com.cn>:
      mm/dmapool: switch from strlcpy to strscpy

Subsystem: mm/sparsemem

    Wang Wensheng <wangwensheng4@huawei.com>:
      mm/sparse: add the missing sparse_buffer_fini() in error branch

Subsystem: mm/vmalloc

    Christoph Hellwig <hch@lst.de>:
    Patch series "remap_vmalloc_range cleanups":
      samples/vfio-mdev/mdpy: use remap_vmalloc_range
      mm: unexport remap_vmalloc_range_partial

    Serapheim Dimitropoulos <serapheim.dimitro@delphix.com>:
      mm/vmalloc: use rb_tree instead of list for vread() lookups

    Nicholas Piggin <npiggin@gmail.com>:
    Patch series "huge vmalloc mappings", v13:
      ARM: mm: add missing pud_page define to 2-level page tables
      mm/vmalloc: fix HUGE_VMAP regression by enabling huge pages in vmalloc_to_page
      mm: apply_to_pte_range warn and fail if a large pte is encountered
      mm/vmalloc: rename vmap_*_range vmap_pages_*_range
      mm/ioremap: rename ioremap_*_range to vmap_*_range
      mm: HUGE_VMAP arch support cleanup
      powerpc: inline huge vmap supported functions
      arm64: inline huge vmap supported functions
      x86: inline huge vmap supported functions
      mm/vmalloc: provide fallback arch huge vmap support functions
      mm: move vmap_range from mm/ioremap.c to mm/vmalloc.c
      mm/vmalloc: add vmap_range_noflush variant
      mm/vmalloc: hugepage vmalloc mappings
    Patch series "mm/vmalloc: cleanup after hugepage series", v2:
      mm/vmalloc: remove map_kernel_range
      kernel/dma: remove unnecessary unmap_kernel_range
      powerpc/xive: remove unnecessary unmap_kernel_range
      mm/vmalloc: remove unmap_kernel_range
      mm/vmalloc: improve allocation failure error messages

    Vijayanand Jitta <vjitta@codeaurora.org>:
      mm: vmalloc: prevent use after free in _vm_unmap_aliases

    "Uladzislau Rezki (Sony)" <urezki@gmail.com>:
      lib/test_vmalloc.c: remove two kvfree_rcu() tests
      lib/test_vmalloc.c: add a new 'nr_threads' parameter
      vm/test_vmalloc.sh: adapt for updated driver interface
      mm/vmalloc: refactor the preloading loagic
      mm/vmalloc: remove an empty line

Subsystem: mm/documentation

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/doc: fix fault_flag_allow_retry_first kerneldoc
      mm/doc: fix page_maybe_dma_pinned kerneldoc
      mm/doc: turn fault flags into an enum
      mm/doc: add mm.h and mm_types.h to the mm-api document

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
    Patch series "kernel-doc and MAINTAINERS clean-up":
      MAINTAINERS: assign pagewalk.h to MEMORY MANAGEMENT
      pagewalk: prefix struct kernel-doc descriptions

Subsystem: mm/kasan

    Zhiyuan Dai <daizhiyuan@phytium.com.cn>:
      mm/kasan: switch from strlcpy to strscpy

    Peter Collingbourne <pcc@google.com>:
      kasan: fix kasan_byte_accessible() to be consistent with actual checks

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: initialize shadow to TAG_INVALID for SW_TAGS
      mm, kasan: don't poison boot memory with tag-based modes
    Patch series "kasan: integrate with init_on_alloc/free", v3:
      arm64: kasan: allow to init memory when setting tags
      kasan: init memory in kasan_(un)poison for HW_TAGS
      kasan, mm: integrate page_alloc init with HW_TAGS
      kasan, mm: integrate slab init_on_alloc with HW_TAGS
      kasan, mm: integrate slab init_on_free with HW_TAGS
      kasan: docs: clean up sections
      kasan: docs: update overview section
      kasan: docs: update usage section
      kasan: docs: update error reports section
      kasan: docs: update boot parameters section
      kasan: docs: update GENERIC implementation details section
      kasan: docs: update SW_TAGS implementation details section
      kasan: docs: update HW_TAGS implementation details section
      kasan: docs: update shadow memory section
      kasan: docs: update ignoring accesses section
      kasan: docs: update tests section

    Walter Wu <walter-zh.wu@mediatek.com>:
      kasan: record task_work_add() call stack

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: detect false-positives in tests

    Zqiang <qiang.zhang@windriver.com>:
      irq_work: record irq_work_queue() call stack

Subsystem: mm/initialization

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      mm: move mem_init_print_info() into mm_init()

Subsystem: mm/pagealloc

    David Hildenbrand <david@redhat.com>:
      mm/page_alloc: drop pr_info_ratelimited() in alloc_contig_range()

    Minchan Kim <minchan@kernel.org>:
      mm: remove lru_add_drain_all in alloc_contig_range

    Yu Zhao <yuzhao@google.com>:
      include/linux/page-flags-layout.h: correctly determine LAST_CPUPID_WIDTH
      include/linux/page-flags-layout.h: cleanups

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Rationalise __alloc_pages wrappers", v3:
      mm/page_alloc: rename alloc_mask to alloc_gfp
      mm/page_alloc: rename gfp_mask to gfp
      mm/page_alloc: combine __alloc_pages and __alloc_pages_nodemask
      mm/mempolicy: rename alloc_pages_current to alloc_pages
      mm/mempolicy: rewrite alloc_pages documentation
      mm/mempolicy: rewrite alloc_pages_vma documentation
      mm/mempolicy: fix mpol_misplaced kernel-doc

    Minchan Kim <minchan@kernel.org>:
      mm: page_alloc: dump migrate-failed pages

    Geert Uytterhoeven <geert@linux-m68k.org>:
      mm/Kconfig: remove default DISCONTIGMEM_MANUAL

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      mm, page_alloc: avoid page_to_pfn() in move_freepages()

    zhouchuangao <zhouchuangao@vivo.com>:
      mm/page_alloc: duplicate include linux/vmalloc.h

    Mel Gorman <mgorman@techsingularity.net>:
    Patch series "Introduce a bulk order-0 page allocator with two in-tree users", v6:
      mm/page_alloc: rename alloced to allocated
      mm/page_alloc: add a bulk page allocator
      mm/page_alloc: add an array-based interface to the bulk page allocator

    Jesper Dangaard Brouer <brouer@redhat.com>:
      mm/page_alloc: optimize code layout for __alloc_pages_bulk
      mm/page_alloc: inline __rmqueue_pcplist

    Chuck Lever <chuck.lever@oracle.com>:
    Patch series "SUNRPC consumer for the bulk page allocator":
      SUNRPC: set rq_page_end differently
      SUNRPC: refresh rq_pages using a bulk page allocator

    Jesper Dangaard Brouer <brouer@redhat.com>:
      net: page_pool: refactor dma_map into own function page_pool_dma_map
      net: page_pool: use alloc_pages_bulk in refill code path

    Sergei Trofimovich <slyfox@gentoo.org>:
      mm: page_alloc: ignore init_on_free=1 for debug_pagealloc=1

    huxiang <huxiang@uniontech.com>:
      mm/page_alloc: redundant definition variables of pfn in for loop

    Mike Rapoport <rppt@linux.ibm.com>:
      mm/mmzone.h: fix existing kernel-doc comments and link them to core-api

Subsystem: mm/memory-failure

    Jane Chu <jane.chu@oracle.com>:
      mm/memory-failure: unnecessary amount of unmapping

 Documentation/admin-guide/kernel-parameters.txt |    7 
 Documentation/admin-guide/mm/transhuge.rst      |    2 
 Documentation/core-api/cachetlb.rst             |    4 
 Documentation/core-api/mm-api.rst               |    6 
 Documentation/dev-tools/kasan.rst               |  355 +++++-----
 Documentation/vm/page_owner.rst                 |    2 
 Documentation/vm/transhuge.rst                  |    5 
 MAINTAINERS                                     |    1 
 arch/Kconfig                                    |   11 
 arch/alpha/mm/init.c                            |    1 
 arch/arc/mm/init.c                              |    1 
 arch/arm/Kconfig                                |    1 
 arch/arm/include/asm/pgtable-3level.h           |    2 
 arch/arm/include/asm/pgtable.h                  |    3 
 arch/arm/mm/copypage-v4mc.c                     |    1 
 arch/arm/mm/copypage-v6.c                       |    1 
 arch/arm/mm/copypage-xscale.c                   |    1 
 arch/arm/mm/init.c                              |    2 
 arch/arm64/Kconfig                              |    1 
 arch/arm64/include/asm/memory.h                 |    4 
 arch/arm64/include/asm/mte-kasan.h              |   39 -
 arch/arm64/include/asm/vmalloc.h                |   38 -
 arch/arm64/mm/init.c                            |    4 
 arch/arm64/mm/mmu.c                             |   36 -
 arch/csky/abiv1/cacheflush.c                    |    1 
 arch/csky/mm/init.c                             |    1 
 arch/h8300/mm/init.c                            |    2 
 arch/hexagon/mm/init.c                          |    1 
 arch/ia64/Kconfig                               |   23 
 arch/ia64/configs/bigsur_defconfig              |    1 
 arch/ia64/include/asm/meminit.h                 |   11 
 arch/ia64/include/asm/module.h                  |    6 
 arch/ia64/include/asm/page.h                    |   25 
 arch/ia64/include/asm/pgtable.h                 |    7 
 arch/ia64/kernel/Makefile                       |    2 
 arch/ia64/kernel/acpi.c                         |    7 
 arch/ia64/kernel/efi.c                          |   11 
 arch/ia64/kernel/fsys.S                         |    4 
 arch/ia64/kernel/head.S                         |    6 
 arch/ia64/kernel/ia64_ksyms.c                   |   12 
 arch/ia64/kernel/machine_kexec.c                |    2 
 arch/ia64/kernel/mca.c                          |    4 
 arch/ia64/kernel/module.c                       |   29 
 arch/ia64/kernel/pal.S                          |    6 
 arch/ia64/mm/Makefile                           |    1 
 arch/ia64/mm/contig.c                           |    4 
 arch/ia64/mm/discontig.c                        |   21 
 arch/ia64/mm/fault.c                            |   15 
 arch/ia64/mm/init.c                             |  221 ------
 arch/m68k/mm/init.c                             |    1 
 arch/microblaze/mm/init.c                       |    1 
 arch/mips/Kconfig                               |    1 
 arch/mips/loongson64/numa.c                     |    1 
 arch/mips/mm/cache.c                            |    1 
 arch/mips/mm/init.c                             |    1 
 arch/mips/sgi-ip27/ip27-memory.c                |    1 
 arch/nds32/mm/init.c                            |    1 
 arch/nios2/mm/cacheflush.c                      |    1 
 arch/nios2/mm/init.c                            |    1 
 arch/openrisc/mm/init.c                         |    2 
 arch/parisc/mm/init.c                           |    2 
 arch/powerpc/Kconfig                            |    1 
 arch/powerpc/include/asm/vmalloc.h              |   34 -
 arch/powerpc/kernel/isa-bridge.c                |    4 
 arch/powerpc/kernel/pci_64.c                    |    2 
 arch/powerpc/mm/book3s64/radix_pgtable.c        |   29 
 arch/powerpc/mm/ioremap.c                       |    2 
 arch/powerpc/mm/mem.c                           |    1 
 arch/powerpc/sysdev/xive/common.c               |    4 
 arch/riscv/mm/init.c                            |    1 
 arch/s390/mm/init.c                             |    2 
 arch/sh/include/asm/tlb.h                       |   10 
 arch/sh/mm/cache-sh4.c                          |    1 
 arch/sh/mm/cache-sh7705.c                       |    1 
 arch/sh/mm/init.c                               |    1 
 arch/sparc/include/asm/pgtable_32.h             |    3 
 arch/sparc/mm/init_32.c                         |    2 
 arch/sparc/mm/init_64.c                         |    1 
 arch/sparc/mm/tlb.c                             |    1 
 arch/um/kernel/mem.c                            |    1 
 arch/x86/Kconfig                                |    1 
 arch/x86/include/asm/vmalloc.h                  |   42 -
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c       |    2 
 arch/x86/mm/init_32.c                           |    2 
 arch/x86/mm/init_64.c                           |  222 ++++--
 arch/x86/mm/ioremap.c                           |   33 
 arch/x86/mm/pgtable.c                           |   13 
 arch/xtensa/Kconfig                             |    1 
 arch/xtensa/mm/init.c                           |    1 
 block/blk-cgroup.c                              |   17 
 drivers/gpu/drm/i915/Kconfig                    |    1 
 drivers/gpu/drm/i915/gem/i915_gem_mman.c        |    9 
 drivers/gpu/drm/i915/i915_drv.h                 |    3 
 drivers/gpu/drm/i915/i915_mm.c                  |  117 ---
 drivers/infiniband/core/umem.c                  |   12 
 drivers/pci/pci.c                               |    2 
 fs/aio.c                                        |    5 
 fs/fs_parser.c                                  |    2 
 fs/iomap/direct-io.c                            |   24 
 fs/ocfs2/blockcheck.c                           |    2 
 fs/ocfs2/dlm/dlmrecovery.c                      |    7 
 fs/ocfs2/stack_o2cb.c                           |   36 -
 fs/ocfs2/stackglue.c                            |    2 
 include/linux/compiler-gcc.h                    |    8 
 include/linux/fs.h                              |    2 
 include/linux/gfp.h                             |   45 -
 include/linux/io-mapping.h                      |    3 
 include/linux/io.h                              |    9 
 include/linux/kasan.h                           |   51 +
 include/linux/memcontrol.h                      |  271 ++++----
 include/linux/mm.h                              |   50 -
 include/linux/mmzone.h                          |   43 -
 include/linux/page-flags-layout.h               |   64 -
 include/linux/pagemap.h                         |   10 
 include/linux/pagewalk.h                        |    4 
 include/linux/sched.h                           |    4 
 include/linux/slab.h                            |    2 
 include/linux/slub_def.h                        |    2 
 include/linux/vmalloc.h                         |   73 +-
 include/linux/vmstat.h                          |   24 
 include/net/page_pool.h                         |    2 
 include/trace/events/kmem.h                     |   24 
 init/main.c                                     |    2 
 kernel/cgroup/cgroup.c                          |   34 -
 kernel/cgroup/rstat.c                           |   61 +
 kernel/dma/remap.c                              |    1 
 kernel/fork.c                                   |   13 
 kernel/irq_work.c                               |    7 
 kernel/task_work.c                              |    3 
 kernel/watchdog.c                               |  102 +--
 lib/Kconfig.debug                               |   14 
 lib/Makefile                                    |    1 
 lib/test_kasan.c                                |   59 -
 lib/test_slub.c                                 |  124 +++
 lib/test_vmalloc.c                              |  128 +--
 mm/Kconfig                                      |    4 
 mm/Makefile                                     |    1 
 mm/debug_vm_pgtable.c                           |    4 
 mm/dmapool.c                                    |    2 
 mm/filemap.c                                    |   61 +
 mm/gup.c                                        |  145 +++-
 mm/hugetlb.c                                    |    2 
 mm/internal.h                                   |   25 
 mm/interval_tree.c                              |    2 
 mm/io-mapping.c                                 |   29 
 mm/ioremap.c                                    |  361 ++--------
 mm/kasan/common.c                               |   53 -
 mm/kasan/generic.c                              |   12 
 mm/kasan/kasan.h                                |   28 
 mm/kasan/report_generic.c                       |    2 
 mm/kasan/shadow.c                               |   10 
 mm/kasan/sw_tags.c                              |   12 
 mm/kmemleak.c                                   |    2 
 mm/memcontrol.c                                 |  798 ++++++++++++------------
 mm/memory-failure.c                             |    2 
 mm/memory.c                                     |  191 +++--
 mm/mempolicy.c                                  |   78 --
 mm/mempool.c                                    |    4 
 mm/memremap.c                                   |    2 
 mm/migrate.c                                    |    2 
 mm/mm_init.c                                    |    4 
 mm/mmap.c                                       |    6 
 mm/mremap.c                                     |    6 
 mm/msync.c                                      |    6 
 mm/page-writeback.c                             |    9 
 mm/page_alloc.c                                 |  430 +++++++++---
 mm/page_counter.c                               |    8 
 mm/page_owner.c                                 |   68 --
 mm/page_poison.c                                |    6 
 mm/percpu-vm.c                                  |    7 
 mm/slab.c                                       |   43 -
 mm/slab.h                                       |   24 
 mm/slab_common.c                                |   10 
 mm/slub.c                                       |  215 ++----
 mm/sparse.c                                     |    1 
 mm/swap_state.c                                 |   13 
 mm/util.c                                       |   10 
 mm/vmalloc.c                                    |  728 ++++++++++++++++-----
 net/core/page_pool.c                            |  127 ++-
 net/sunrpc/svc_xprt.c                           |   38 -
 samples/kfifo/bytestream-example.c              |    8 
 samples/kfifo/inttype-example.c                 |    8 
 samples/kfifo/record-example.c                  |    8 
 samples/vfio-mdev/mdpy.c                        |    4 
 scripts/checkdeclares.pl                        |   53 +
 scripts/spelling.txt                            |   26 
 tools/testing/selftests/cgroup/test_kmem.c      |   22 
 tools/testing/selftests/vm/mremap_dontunmap.c   |   52 +
 tools/testing/selftests/vm/test_vmalloc.sh      |   21 
 189 files changed, 3642 insertions(+), 3013 deletions(-)

