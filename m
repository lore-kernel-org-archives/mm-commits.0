From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 1 Apr 2020 21:01:55 -0700
Message-ID: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgDBEB6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org


A large amount of MM, plenty more to come.


155 patches, based on GIT 1a323ea5356edbb3073dc59d51b9e6b86908857d

Subsystems affected by this patch series:

  tools
  kthread
  kbuild
  scripts
  ocfs2
  vfs
  mm/slub
  mm/kmemleak
  mm/pagecache
  mm/gup
  mm/swap
  mm/memcg
  mm/pagemap
  mm/mremap
  mm/sparsemem
  mm/kasan
  mm/pagealloc
  mm/vmscan
  mm/compaction
  mm/mempolicy
  mm/hugetlbfs
  mm/hugetlb

Subsystem: tools

    David Ahern <dsahern@kernel.org>:
      tools/accounting/getdelays.c: fix netlink attribute length

Subsystem: kthread

    Petr Mladek <pmladek@suse.com>:
      kthread: mark timer used by delayed kthread works as IRQ safe

Subsystem: kbuild

    Masahiro Yamada <masahiroy@kernel.org>:
      asm-generic: make more kernel-space headers mandatory

Subsystem: scripts

    Jonathan Neusch=E4fer <j.neuschaefer@gmx.net>:
      scripts/spelling.txt: add syfs/sysfs pattern

    Colin Ian King <colin.king@canonical.com>:
      scripts/spelling.txt: add more spellings to spelling.txt

Subsystem: ocfs2

    Alex Shi <alex.shi@linux.alibaba.com>:
      ocfs2: remove FS_OCFS2_NM
      ocfs2: remove unused macros
      ocfs2: use OCFS2_SEC_BITS in macro
      ocfs2: remove dlm_lock_is_remote

    wangyan <wangyan122@huawei.com>:
      ocfs2: there is no need to log twice in several functions
      ocfs2: correct annotation from "l_next_rec" to "l_next_free_rec"

    Alex Shi <alex.shi@linux.alibaba.com>:
      ocfs2: remove useless err

    Jules Irenge <jbi.octave@gmail.com>:
      ocfs2: Add missing annotations for ocfs2_refcount_cache_lock() and oc=
fs2_refcount_cache_unlock()

    "Gustavo A. R. Silva" <gustavo@embeddedor.com>:
      ocfs2: replace zero-length array with flexible-array member
      ocfs2: cluster: replace zero-length array with flexible-array member
      ocfs2: dlm: replace zero-length array with flexible-array member
      ocfs2: ocfs2_fs.h: replace zero-length array with flexible-array memb=
er

    wangjian <wangjian161@huawei.com>:
      ocfs2: roll back the reference count modification of the parent direc=
tory if an error occurs

    Takashi Iwai <tiwai@suse.de>:
      ocfs2: use scnprintf() for avoiding potential buffer overflow

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      ocfs2: use memalloc_nofs_save instead of memalloc_noio_save

Subsystem: vfs

    Kees Cook <keescook@chromium.org>:
      fs_parse: Remove pr_notice() about each validation

Subsystem: mm/slub

    chenqiwu <chenqiwu@xiaomi.com>:
      mm/slub.c: replace cpu_slab->partial with wrapped APIs
      mm/slub.c: replace kmem_cache->cpu_partial with wrapped APIs

    Kees Cook <keescook@chromium.org>:
      slub: improve bit diffusion for freelist ptr obfuscation
      slub: relocate freelist pointer to middle of object

    Vlastimil Babka <vbabka@suse.cz>:
      Revert "topology: add support for node_to_mem_node() to determine the=
 fallback node"

Subsystem: mm/kmemleak

    Nathan Chancellor <natechancellor@gmail.com>:
      mm/kmemleak.c: use address-of operator on section symbols

    Qian Cai <cai@lca.pw>:
      mm/Makefile: disable KCSAN for kmemleak

Subsystem: mm/pagecache

    Jan Kara <jack@suse.cz>:
      mm/filemap.c: don't bother dropping mmap_sem for zero size readahead

    Mauricio Faria de Oliveira <mfo@canonical.com>:
      mm/page-writeback.c: write_cache_pages(): deduplicate identical checks

    Xianting Tian <xianting_tian@126.com>:
      mm/filemap.c: clear page error before actual read

    Souptick Joarder <jrdr.linux@gmail.com>:
      mm/filemap.c: remove unused argument from shrink_readahead_size_eio()

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/filemap.c: use vm_fault error code directly
      include/linux/pagemap.h: rename arguments to find_subpage
      mm/page-writeback.c: use VM_BUG_ON_PAGE in clear_page_dirty_for_io
      mm/filemap.c: unexport find_get_entry
      mm/filemap.c: rewrite pagecache_get_page documentation

Subsystem: mm/gup

    John Hubbard <jhubbard@nvidia.com>:
    Patch series "mm/gup: track FOLL_PIN pages", v6:
      mm/gup: split get_user_pages_remote() into two routines
      mm/gup: pass a flags arg to __gup_device_* functions
      mm: introduce page_ref_sub_return()
      mm/gup: pass gup flags to two more routines
      mm/gup: require FOLL_GET for get_user_pages_fast()
      mm/gup: track FOLL_PIN pages
      mm/gup: page->hpage_pinned_refcount: exact pin counts for huge pages
      mm/gup: /proc/vmstat: pin_user_pages (FOLL_PIN) reporting
      mm/gup_benchmark: support pin_user_pages() and related calls
      selftests/vm: run_vmtests: invoke gup_benchmark with basic FOLL_PIN c=
overage

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: improve dump_page() for compound pages

    John Hubbard <jhubbard@nvidia.com>:
      mm: dump_page(): additional diagnostics for huge pinned pages

    Claudio Imbrenda <imbrenda@linux.ibm.com>:
      mm/gup/writeback: add callbacks for inaccessible pages

    Pingfan Liu <kernelfans@gmail.com>:
      mm/gup: rename nr as nr_pinned in get_user_pages_fast()
      mm/gup: fix omission of check on FOLL_LONGTERM in gup fast path

Subsystem: mm/swap

    Chen Wandun <chenwandun@huawei.com>:
      mm/swapfile.c: fix comments for swapcache_prepare

    Wei Yang <richardw.yang@linux.intel.com>:
      mm/swap.c: not necessary to export __pagevec_lru_add()

    Qian Cai <cai@lca.pw>:
      mm/swapfile: fix data races in try_to_unuse()

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      mm/swap_slots.c: assign|reset cache slot by value directly

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm: swap: make page_evictable() inline
      mm: swap: use smp_mb__after_atomic() to order LRU bit set

    Wei Yang <richard.weiyang@gmail.com>:
      mm/swap_state.c: use the same way to count page in [add_to|delete_fro=
m]_swap_cache

Subsystem: mm/memcg

    Yafang Shao <laoar.shao@gmail.com>:
      mm, memcg: fix build error around the usage of kmem_caches

    Kirill Tkhai <ktkhai@virtuozzo.com>:
      mm/memcontrol.c: allocate shrinker_map on appropriate NUMA node

    Roman Gushchin <guro@fb.com>:
      mm: memcg/slab: use mem_cgroup_from_obj()
    Patch series "mm: memcg: kmem API cleanup", v2:
      mm: kmem: cleanup (__)memcg_kmem_charge_memcg() arguments
      mm: kmem: cleanup memcg_kmem_uncharge_memcg() arguments
      mm: kmem: rename memcg_kmem_(un)charge() into memcg_kmem_(un)charge_p=
age()
      mm: kmem: switch to nr_pages in (__)memcg_kmem_charge_memcg()
      mm: memcg/slab: cache page number in memcg_(un)charge_slab()
      mm: kmem: rename (__)memcg_kmem_(un)charge_memcg() to __memcg_kmem_(u=
n)charge()

    Johannes Weiner <hannes@cmpxchg.org>:
    Patch series "mm: memcontrol: recursive memory.low protection", v3:
      mm: memcontrol: fix memory.low proportional distribution
      mm: memcontrol: clean up and document effective low/min calculations
      mm: memcontrol: recursive memory.low protection

    Shakeel Butt <shakeelb@google.com>:
      memcg: css_tryget_online cleanups

    Vincenzo Frascino <vincenzo.frascino@arm.com>:
      mm/memcontrol.c: make mem_cgroup_id_get_many() __maybe_unused

    Chris Down <chris@chrisdown.name>:
      mm, memcg: prevent memory.high load/store tearing
      mm, memcg: prevent memory.max load tearing
      mm, memcg: prevent memory.low load/store tearing
      mm, memcg: prevent memory.min load/store tearing
      mm, memcg: prevent memory.swap.max load tearing
      mm, memcg: prevent mem_cgroup_protected store tearing

    Roman Gushchin <guro@fb.com>:
      mm: memcg: make memory.oom.group tolerable to task migration

Subsystem: mm/pagemap

    Thomas Hellstrom <thellstrom@vmware.com>:
      mm/mapping_dirty_helpers: Update huge page-table entry callbacks

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm/vma: some more minor changes", v2:
      mm/vma: move VM_NO_KHUGEPAGED into generic header
      mm/vma: make vma_is_foreign() available for general use
      mm/vma: make is_vma_temporary_stack() available for general use

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: add pagemap.h to the fine documentation

    Peter Xu <peterx@redhat.com>:
    Patch series "mm: Page fault enhancements", v6:
      mm/gup: rename "nonblocking" to "locked" where proper
      mm/gup: fix __get_user_pages() on fault retry of hugetlb
      mm: introduce fault_signal_pending()
      x86/mm: use helper fault_signal_pending()
      arc/mm: use helper fault_signal_pending()
      arm64/mm: use helper fault_signal_pending()
      powerpc/mm: use helper fault_signal_pending()
      sh/mm: use helper fault_signal_pending()
      mm: return faster for non-fatal signals in user mode faults
      userfaultfd: don't retake mmap_sem to emulate NOPAGE
      mm: introduce FAULT_FLAG_DEFAULT
      mm: introduce FAULT_FLAG_INTERRUPTIBLE
      mm: allow VM_FAULT_RETRY for multiple times
      mm/gup: allow VM_FAULT_RETRY for multiple times
      mm/gup: allow to react to fatal signals
      mm/userfaultfd: honor FAULT_FLAG_KILLABLE in fault path

    WANG Wenhu <wenhu.wang@vivo.com>:
      mm: clarify a confusing comment for remap_pfn_range()

    Wang Wenhu <wenhu.wang@vivo.com>:
      mm/memory.c: clarify a confusing comment for vm_iomap_memory

    Jaewon Kim <jaewon31.kim@samsung.com>:
    Patch series "mm: mmap: add mmap trace point", v3:
      mmap: remove inline of vm_unmapped_area
      mm: mmap: add trace point of vm_unmapped_area

Subsystem: mm/mremap

    Brian Geffon <bgeffon@google.com>:
      mm/mremap: add MREMAP_DONTUNMAP to mremap()
      selftests: add MREMAP_DONTUNMAP selftest

Subsystem: mm/sparsemem

    Wei Yang <richardw.yang@linux.intel.com>:
      mm/sparsemem: get address to page struct instead of address to pfn

    Pingfan Liu <kernelfans@gmail.com>:
      mm/sparse: rename pfn_present() to pfn_in_present_section()

    Baoquan He <bhe@redhat.com>:
      mm/sparse.c: use kvmalloc/kvfree to alloc/free memmap for the classic=
 sparse
      mm/sparse.c: allocate memmap preferring the given node

Subsystem: mm/kasan

    Walter Wu <walter-zh.wu@mediatek.com>:
    Patch series "fix the missing underflow in memory operation function", =
v4:
      kasan: detect negative size in memory operation function
      kasan: add test for invalid size in memmove

Subsystem: mm/pagealloc

    Joel Savitz <jsavitz@redhat.com>:
      mm/page_alloc: increase default min_free_kbytes bound

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm, pagealloc: micro-optimisation: save two branches on hot page allo=
cation path

    chenqiwu <chenqiwu@xiaomi.com>:
      mm/page_alloc.c: use free_area_empty() instead of open-coding

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/page_alloc.c: micro-optimisation Remove unnecessary branch

    chenqiwu <chenqiwu@xiaomi.com>:
      mm/page_alloc: simplify page_is_buddy() for better code readability

Subsystem: mm/vmscan

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm: vmpressure: don't need call kfree if kstrndup fails
      mm: vmpressure: use mem_cgroup_is_root API
      mm: vmscan: replace open codings to NUMA_NO_NODE

    Wei Yang <richardw.yang@linux.intel.com>:
      mm/vmscan.c: remove cpu online notification for now

    Qian Cai <cai@lca.pw>:
      mm/vmscan.c: fix data races using kswapd_classzone_idx

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/vmscan.c: Clean code by removing unnecessary assignment

    Kirill Tkhai <ktkhai@virtuozzo.com>:
      mm/vmscan.c: make may_enter_fs bool in shrink_page_list()

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/vmscan.c: do_try_to_free_pages(): clean code by removing unnecessa=
ry assignment

    Michal Hocko <mhocko@suse.com>:
      selftests: vm: drop dependencies on page flags from mlock2 tests

Subsystem: mm/compaction

    Rik van Riel <riel@surriel.com>:
    Patch series "fix THP migration for CMA allocations", v2:
      mm,compaction,cma: add alloc_contig flag to compact_control
      mm,thp,compaction,cma: allow THP migration for CMA allocations

    Vlastimil Babka <vbabka@suse.cz>:
      mm, compaction: fully assume capture is not NULL in compact_zone_orde=
r()

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm/compaction: really limit compact_unevictable_allowed to 0 and 1
      mm/compaction: Disable compact_unevictable_allowed on RT

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/compaction.c: clean code by removing unnecessary assignment

Subsystem: mm/mempolicy

    Li Xinhai <lixinhai.lxh@gmail.com>:
      mm/mempolicy: support MPOL_MF_STRICT for huge page mapping
      mm/mempolicy: check hugepage migration is supported by arch in vma_mi=
gratable()

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm: mempolicy: use VM_BUG_ON_VMA in queue_pages_test_walk()

    Randy Dunlap <rdunlap@infradead.org>:
      mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

    Colin Ian King <colin.king@canonical.com>:
      mm/memblock.c: remove redundant assignment to variable max_addr

Subsystem: mm/hugetlbfs

    Mike Kravetz <mike.kravetz@oracle.com>:
    Patch series "hugetlbfs: use i_mmap_rwsem for more synchronization", v2:
      hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization
      hugetlbfs: Use i_mmap_rwsem to address page fault/truncate race

Subsystem: mm/hugetlb

    Mina Almasry <almasrymina@google.com>:
      hugetlb_cgroup: add hugetlb_cgroup reservation counter
      hugetlb_cgroup: add interface for charge/uncharge hugetlb reservations
      mm/hugetlb_cgroup: fix hugetlb_cgroup migration
      hugetlb_cgroup: add reservation accounting for private mappings
      hugetlb: disable region_add file_region coalescing
      hugetlb_cgroup: add accounting for shared mappings
      hugetlb_cgroup: support noreserve mappings
      hugetlb: support file_region coalescing again
      hugetlb_cgroup: add hugetlb_cgroup reservation tests
      hugetlb_cgroup: add hugetlb_cgroup reservation docs

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/hugetlb.c: clean code by removing unnecessary initialization

    Vlastimil Babka <vbabka@suse.cz>:
      mm/hugetlb: remove unnecessary memory fetch in PageHeadHuge()

    Christophe Leroy <christophe.leroy@c-s.fr>:
      selftests/vm: fix map_hugetlb length used for testing read and write
      mm/hugetlb: fix build failure with HUGETLB_PAGE but not HUGEBTLBFS

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      include/linux/huge_mm.h: check PageTail in hpage_nr_pages even when !=
THP

 Documentation/admin-guide/cgroup-v1/hugetlb.rst        |  103 +-
 Documentation/admin-guide/cgroup-v2.rst                |   11=20
 Documentation/admin-guide/sysctl/vm.rst                |    3=20
 Documentation/core-api/mm-api.rst                      |    3=20
 Documentation/core-api/pin_user_pages.rst              |   86 +
 arch/alpha/include/asm/Kbuild                          |   11=20
 arch/alpha/mm/fault.c                                  |    6=20
 arch/arc/include/asm/Kbuild                            |   21=20
 arch/arc/mm/fault.c                                    |   37=20
 arch/arm/include/asm/Kbuild                            |   12=20
 arch/arm/mm/fault.c                                    |    7=20
 arch/arm64/include/asm/Kbuild                          |   18=20
 arch/arm64/mm/fault.c                                  |   26=20
 arch/c6x/include/asm/Kbuild                            |   37=20
 arch/csky/include/asm/Kbuild                           |   36=20
 arch/h8300/include/asm/Kbuild                          |   46=20
 arch/hexagon/include/asm/Kbuild                        |   33=20
 arch/hexagon/mm/vm_fault.c                             |    5=20
 arch/ia64/include/asm/Kbuild                           |    7=20
 arch/ia64/mm/fault.c                                   |    5=20
 arch/m68k/include/asm/Kbuild                           |   24=20
 arch/m68k/mm/fault.c                                   |    7=20
 arch/microblaze/include/asm/Kbuild                     |   29=20
 arch/microblaze/mm/fault.c                             |    5=20
 arch/mips/include/asm/Kbuild                           |   13=20
 arch/mips/mm/fault.c                                   |    5=20
 arch/nds32/include/asm/Kbuild                          |   37=20
 arch/nds32/mm/fault.c                                  |    5=20
 arch/nios2/include/asm/Kbuild                          |   38=20
 arch/nios2/mm/fault.c                                  |    7=20
 arch/openrisc/include/asm/Kbuild                       |   36=20
 arch/openrisc/mm/fault.c                               |    5=20
 arch/parisc/include/asm/Kbuild                         |   18=20
 arch/parisc/mm/fault.c                                 |    8=20
 arch/powerpc/include/asm/Kbuild                        |    4=20
 arch/powerpc/mm/book3s64/pkeys.c                       |   12=20
 arch/powerpc/mm/fault.c                                |   20=20
 arch/powerpc/platforms/pseries/hotplug-memory.c        |    2=20
 arch/riscv/include/asm/Kbuild                          |   28=20
 arch/riscv/mm/fault.c                                  |    9=20
 arch/s390/include/asm/Kbuild                           |   15=20
 arch/s390/mm/fault.c                                   |   10=20
 arch/sh/include/asm/Kbuild                             |   16=20
 arch/sh/mm/fault.c                                     |   13=20
 arch/sparc/include/asm/Kbuild                          |   14=20
 arch/sparc/mm/fault_32.c                               |    5=20
 arch/sparc/mm/fault_64.c                               |    5=20
 arch/um/kernel/trap.c                                  |    3=20
 arch/unicore32/include/asm/Kbuild                      |   34=20
 arch/unicore32/mm/fault.c                              |    8=20
 arch/x86/include/asm/Kbuild                            |    2=20
 arch/x86/include/asm/mmu_context.h                     |   15=20
 arch/x86/mm/fault.c                                    |   32=20
 arch/xtensa/include/asm/Kbuild                         |   26=20
 arch/xtensa/mm/fault.c                                 |    5=20
 drivers/base/node.c                                    |    2=20
 drivers/gpu/drm/ttm/ttm_bo_vm.c                        |   12=20
 fs/fs_parser.c                                         |    2=20
 fs/hugetlbfs/inode.c                                   |   30=20
 fs/ocfs2/alloc.c                                       |    3=20
 fs/ocfs2/cluster/heartbeat.c                           |   12=20
 fs/ocfs2/cluster/netdebug.c                            |    4=20
 fs/ocfs2/cluster/tcp.c                                 |   27=20
 fs/ocfs2/cluster/tcp.h                                 |    2=20
 fs/ocfs2/dir.c                                         |    4=20
 fs/ocfs2/dlm/dlmcommon.h                               |    8=20
 fs/ocfs2/dlm/dlmdebug.c                                |  100 -
 fs/ocfs2/dlm/dlmmaster.c                               |    2=20
 fs/ocfs2/dlm/dlmthread.c                               |    3=20
 fs/ocfs2/dlmglue.c                                     |    2=20
 fs/ocfs2/journal.c                                     |    2=20
 fs/ocfs2/namei.c                                       |   15=20
 fs/ocfs2/ocfs2_fs.h                                    |   18=20
 fs/ocfs2/refcounttree.c                                |    2=20
 fs/ocfs2/reservations.c                                |    3=20
 fs/ocfs2/stackglue.c                                   |    2=20
 fs/ocfs2/suballoc.c                                    |    5=20
 fs/ocfs2/super.c                                       |   46=20
 fs/pipe.c                                              |    2=20
 fs/userfaultfd.c                                       |   64 -
 include/asm-generic/Kbuild                             |   52 +
 include/linux/cgroup-defs.h                            |    5=20
 include/linux/fs.h                                     |    5=20
 include/linux/gfp.h                                    |    6=20
 include/linux/huge_mm.h                                |   10=20
 include/linux/hugetlb.h                                |   76 +
 include/linux/hugetlb_cgroup.h                         |  175 +++
 include/linux/kasan.h                                  |    2=20
 include/linux/kthread.h                                |    3=20
 include/linux/memcontrol.h                             |   66 -
 include/linux/mempolicy.h                              |   29=20
 include/linux/mm.h                                     |  243 +++-
 include/linux/mm_types.h                               |    7=20
 include/linux/mmzone.h                                 |    6=20
 include/linux/page_ref.h                               |    9=20
 include/linux/pagemap.h                                |   29=20
 include/linux/sched/signal.h                           |   18=20
 include/linux/swap.h                                   |    1=20
 include/linux/topology.h                               |   17=20
 include/trace/events/mmap.h                            |   48=20
 include/uapi/linux/mman.h                              |    5=20
 kernel/cgroup/cgroup.c                                 |   17=20
 kernel/fork.c                                          |    9=20
 kernel/sysctl.c                                        |   31=20
 lib/test_kasan.c                                       |   19=20
 mm/Makefile                                            |    1=20
 mm/compaction.c                                        |   31=20
 mm/debug.c                                             |   54 -
 mm/filemap.c                                           |   77 -
 mm/gup.c                                               |  682 ++++++++++---
 mm/gup_benchmark.c                                     |   71 +
 mm/huge_memory.c                                       |   29=20
 mm/hugetlb.c                                           |  866 ++++++++++++=
-----
 mm/hugetlb_cgroup.c                                    |  347 +++++-
 mm/internal.h                                          |   32=20
 mm/kasan/common.c                                      |   26=20
 mm/kasan/generic.c                                     |    9=20
 mm/kasan/generic_report.c                              |   11=20
 mm/kasan/kasan.h                                       |    2=20
 mm/kasan/report.c                                      |    5=20
 mm/kasan/tags.c                                        |    9=20
 mm/kasan/tags_report.c                                 |   11=20
 mm/khugepaged.c                                        |    4=20
 mm/kmemleak.c                                          |    2=20
 mm/list_lru.c                                          |   12=20
 mm/mapping_dirty_helpers.c                             |   42=20
 mm/memblock.c                                          |    2=20
 mm/memcontrol.c                                        |  378 ++++---
 mm/memory-failure.c                                    |   29=20
 mm/memory.c                                            |    4=20
 mm/mempolicy.c                                         |   73 +
 mm/migrate.c                                           |   25=20
 mm/mmap.c                                              |   32=20
 mm/mremap.c                                            |   92 +
 mm/page-writeback.c                                    |   19=20
 mm/page_alloc.c                                        |   82 -
 mm/page_counter.c                                      |   29=20
 mm/page_ext.c                                          |    2=20
 mm/rmap.c                                              |   39=20
 mm/shuffle.c                                           |    2=20
 mm/slab.h                                              |   32=20
 mm/slab_common.c                                       |    2=20
 mm/slub.c                                              |   27=20
 mm/sparse.c                                            |   33=20
 mm/swap.c                                              |    5=20
 mm/swap_slots.c                                        |   12=20
 mm/swap_state.c                                        |    2=20
 mm/swapfile.c                                          |   10=20
 mm/userfaultfd.c                                       |   11=20
 mm/vmpressure.c                                        |    8=20
 mm/vmscan.c                                            |  111 --
 mm/vmstat.c                                            |    2=20
 scripts/spelling.txt                                   |   21=20
 tools/accounting/getdelays.c                           |    2=20
 tools/testing/selftests/vm/.gitignore                  |    1=20
 tools/testing/selftests/vm/Makefile                    |    2=20
 tools/testing/selftests/vm/charge_reserved_hugetlb.sh  |  575 +++++++++++
 tools/testing/selftests/vm/gup_benchmark.c             |   15=20
 tools/testing/selftests/vm/hugetlb_reparenting_test.sh |  244 ++++
 tools/testing/selftests/vm/map_hugetlb.c               |   14=20
 tools/testing/selftests/vm/mlock2-tests.c              |  233 ----
 tools/testing/selftests/vm/mremap_dontunmap.c          |  313 ++++++
 tools/testing/selftests/vm/run_vmtests                 |   37=20
 tools/testing/selftests/vm/write_hugetlb_memory.sh     |   23=20
 tools/testing/selftests/vm/write_to_hugetlbfs.c        |  242 ++++
 165 files changed, 5020 insertions(+), 2376 deletions(-)
