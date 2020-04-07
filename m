From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 6 Apr 2020 20:02:54 -0700
Message-ID: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDC4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:02:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org


- a lot more of MM, quite a bit more yet to come.

- various other subsystems



166 patches based on 7e63420847ae5f1036e4f7c42f0b3282e73efbc2.

Subsystems affected by this patch series:

  mm/memcg
  mm/pagemap
  mm/vmalloc
  mm/pagealloc
  mm/migration
  mm/thp
  mm/ksm
  mm/madvise
  mm/virtio
  mm/userfaultfd
  mm/memory-hotplug
  mm/shmem
  mm/rmap
  mm/zswap
  mm/zsmalloc
  mm/cleanups
  procfs
  misc
  MAINTAINERS
  bitops
  lib
  checkpatch
  epoll
  binfmt
  kallsyms
  reiserfs
  kmod
  gcov
  kconfig
  kcov
  ubsan
  fault-injection
  ipc

Subsystem: mm/memcg

    Chris Down <chris@chrisdown.name>:
      mm, memcg: bypass high reclaim iteration for cgroup hierarchy root

Subsystem: mm/pagemap

    Li Xinhai <lixinhai.lxh@gmail.com>:
    Patch series "mm: Fix misuse of parent anon_vma in dup_mmap path":
      mm: don't prepare anon_vma if vma has VM_WIPEONFORK
      Revert "mm/rmap.c: reuse mergeable anon_vma as parent when fork"
      mm: set vm_next and vm_prev to NULL in vm_area_dup()

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm/vma: Use all available wrappers when possible", v2:
      mm/vma: add missing VMA flag readable name for VM_SYNC
      mm/vma: make vma_is_accessible() available for general use
      mm/vma: replace all remaining open encodings with is_vm_hugetlb_page()
      mm/vma: replace all remaining open encodings with vma_is_anonymous()
      mm/vma: append unlikely() while testing VMA access permissions

Subsystem: mm/vmalloc

    Qiujun Huang <hqjagain@gmail.com>:
      mm/vmalloc: fix a typo in comment

Subsystem: mm/pagealloc

    Michal Hocko <mhocko@suse.com>:
      mm: make it clear that gfp reclaim modifiers are valid only for sleepable allocations

Subsystem: mm/migration

    Wei Yang <richardw.yang@linux.intel.com>:
    Patch series "cleanup on do_pages_move()", v5:
      mm/migrate.c: no need to check for i > start in do_pages_move()
      mm/migrate.c: wrap do_move_pages_to_node() and store_status()
      mm/migrate.c: check pagelist in move_pages_and_store_status()
      mm/migrate.c: unify "not queued for migration" handling in do_pages_move()

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm/migrate.c: migrate PG_readahead flag

Subsystem: mm/thp

    David Rientjes <rientjes@google.com>:
      mm, shmem: add vmstat for hugepage fallback
      mm, thp: track fallbacks due to failed memcg charges separately

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      include/linux/pagemap.h: optimise find_subpage for !THP
      mm: remove CONFIG_TRANSPARENT_HUGE_PAGECACHE

Subsystem: mm/ksm

    Li Chen <chenli@uniontech.com>:
      mm/ksm.c: update get_user_pages() argument in comment

Subsystem: mm/madvise

    Huang Ying <ying.huang@intel.com>:
      mm: code cleanup for MADV_FREE

Subsystem: mm/virtio

    Alexander Duyck <alexander.h.duyck@linux.intel.com>:
    Patch series "mm / virtio: Provide support for free page reporting", v17:
      mm: adjust shuffle code to allow for future coalescing
      mm: use zone and order instead of free area in free_list manipulators
      mm: add function __putback_isolated_page
      mm: introduce Reported pages
      virtio-balloon: pull page poisoning config out of free page hinting
      virtio-balloon: add support for providing free page reports to host
      mm/page_reporting: rotate reported pages to the tail of the list
      mm/page_reporting: add budget limit on how many pages can be reported per pass
      mm/page_reporting: add free page reporting documentation

    David Hildenbrand <david@redhat.com>:
      virtio-balloon: switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM

Subsystem: mm/userfaultfd

    Shaohua Li <shli@fb.com>:
    Patch series "userfaultfd: write protection support", v6:
      userfaultfd: wp: add helper for writeprotect check

    Andrea Arcangeli <aarcange@redhat.com>:
      userfaultfd: wp: hook userfault handler to write protection fault
      userfaultfd: wp: add WP pagetable tracking to x86
      userfaultfd: wp: userfaultfd_pte/huge_pmd_wp() helpers
      userfaultfd: wp: add UFFDIO_COPY_MODE_WP

    Peter Xu <peterx@redhat.com>:
      mm: merge parameters for change_protection()
      userfaultfd: wp: apply _PAGE_UFFD_WP bit
      userfaultfd: wp: drop _PAGE_UFFD_WP properly when fork
      userfaultfd: wp: add pmd_swp_*uffd_wp() helpers
      userfaultfd: wp: support swap and page migration
      khugepaged: skip collapse if uffd-wp detected

    Shaohua Li <shli@fb.com>:
      userfaultfd: wp: support write protection for userfault vma range

    Andrea Arcangeli <aarcange@redhat.com>:
      userfaultfd: wp: add the writeprotect API to userfaultfd ioctl

    Shaohua Li <shli@fb.com>:
      userfaultfd: wp: enabled write protection in userfaultfd API

    Peter Xu <peterx@redhat.com>:
      userfaultfd: wp: don't wake up when doing write protect

    Martin Cracauer <cracauer@cons.org>:
      userfaultfd: wp: UFFDIO_REGISTER_MODE_WP documentation update

    Peter Xu <peterx@redhat.com>:
      userfaultfd: wp: declare _UFFDIO_WRITEPROTECT conditionally
      userfaultfd: selftests: refactor statistics
      userfaultfd: selftests: add write-protect test

Subsystem: mm/memory-hotplug

    David Hildenbrand <david@redhat.com>:
    Patch series "mm: drop superfluous section checks when onlining/offlining":
      drivers/base/memory.c: drop section_count
      drivers/base/memory.c: drop pages_correctly_probed()
      mm/page_ext.c: drop pfn_present() check when onlining

    Baoquan He <bhe@redhat.com>:
      mm/memory_hotplug.c: only respect mem= parameter during boot stage

    David Hildenbrand <david@redhat.com>:
      mm/memory_hotplug.c: simplify calculation of number of pages in __remove_pages()
      mm/memory_hotplug.c: cleanup __add_pages()

    Baoquan He <bhe@redhat.com>:
    Patch series "mm/hotplug: Only use subsection map for VMEMMAP", v4:
      mm/sparse.c: introduce new function fill_subsection_map()
      mm/sparse.c: introduce a new function clear_subsection_map()
      mm/sparse.c: only use subsection map in VMEMMAP case
      mm/sparse.c: add note about only VMEMMAP supporting sub-section hotplug
      mm/sparse.c: move subsection_map related functions together

    David Hildenbrand <david@redhat.com>:
    Patch series "mm/memory_hotplug: allow to specify a default online_type", v3:
      drivers/base/memory: rename MMOP_ONLINE_KEEP to MMOP_ONLINE
      drivers/base/memory: map MMOP_OFFLINE to 0
      drivers/base/memory: store mapping between MMOP_* and string in an array
      powernv/memtrace: always online added memory blocks
      hv_balloon: don't check for memhp_auto_online manually
      mm/memory_hotplug: unexport memhp_auto_online
      mm/memory_hotplug: convert memhp_auto_online to store an online_type
      mm/memory_hotplug: allow to specify a default online_type

    chenqiwu <chenqiwu@xiaomi.com>:
      mm/memory_hotplug.c: use __pfn_to_section() instead of open-coding

Subsystem: mm/shmem

    Kees Cook <keescook@chromium.org>:
      mm/shmem.c: distribute switch variables for initialization

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/shmem.c: clean code by removing unnecessary assignment

    Hugh Dickins <hughd@google.com>:
      mm: huge tmpfs: try to split_huge_page() when punching hole

Subsystem: mm/rmap

    Palmer Dabbelt <palmerdabbelt@google.com>:
      mm: prevent a warning when casting void* -> enum

Subsystem: mm/zswap

    "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>:
      mm/zswap: allow setting default status, compressor and allocator in Kconfig

Subsystem: mm/zsmalloc

Subsystem: mm/cleanups

    Jules Irenge <jbi.octave@gmail.com>:
      mm/compaction: add missing annotation for compact_lock_irqsave
      mm/hugetlb: add missing annotation for gather_surplus_pages()
      mm/mempolicy: add missing annotation for queue_pages_pmd()
      mm/slub: add missing annotation for get_map()
      mm/slub: add missing annotation for put_map()
      mm/zsmalloc: add missing annotation for migrate_read_lock()
      mm/zsmalloc: add missing annotation for migrate_read_unlock()
      mm/zsmalloc: add missing annotation for pin_tag()
      mm/zsmalloc: add missing annotation for unpin_tag()

    chenqiwu <chenqiwu@xiaomi.com>:
      mm: fix ambiguous comments for better code readability

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/mm_init.c: clean code. Use BUILD_BUG_ON when comparing compile time constant

    Joe Perches <joe@perches.com>:
      mm: use fallthrough;

    Steven Price <steven.price@arm.com>:
      include/linux/swapops.h: correct guards for non_swap_entry()

    Ira Weiny <ira.weiny@intel.com>:
      include/linux/memremap.h: remove stale comments

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/dmapool.c: micro-optimisation remove unnecessary branch

    Waiman Long <longman@redhat.com>:
      mm: remove dummy struct bootmem_data/bootmem_data_t

Subsystem: procfs

    Jules Irenge <jbi.octave@gmail.com>:
      fs/proc/inode.c: annotate close_pdeo() for sparse

    Alexey Dobriyan <adobriyan@gmail.com>:
      proc: faster open/read/close with "permanent" files
      proc: speed up /proc/*/statm

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      proc: inline vma_stop into m_stop
      proc: remove m_cache_vma
      proc: use ppos instead of m->version
      seq_file: remove m->version
      proc: inline m_next_vma into m_next

Subsystem: misc

    Michal Simek <michal.simek@xilinx.com>:
      asm-generic: fix unistd_32.h generation format

    Nathan Chancellor <natechancellor@gmail.com>:
      kernel/extable.c: use address-of operator on section symbols

    Masahiro Yamada <masahiroy@kernel.org>:
      sparc,x86: vdso: remove meaningless undefining CONFIG_OPTIMIZE_INLINING
      compiler: remove CONFIG_OPTIMIZE_INLINING entirely

    Vegard Nossum <vegard.nossum@oracle.com>:
      compiler.h: fix error in BUILD_BUG_ON() reporting

Subsystem: MAINTAINERS

    Joe Perches <joe@perches.com>:
      MAINTAINERS: list the section entries in the preferred order

Subsystem: bitops

    Josh Poimboeuf <jpoimboe@redhat.com>:
      bitops: always inline sign extension helpers

Subsystem: lib

    Konstantin Khlebnikov <khlebnikov@yandex-team.ru>:
      lib/test_lockup: test module to generate lockups

    Colin Ian King <colin.king@canonical.com>:
      lib/test_lockup.c: fix spelling mistake "iteraions" -> "iterations"

    Konstantin Khlebnikov <khlebnikov@yandex-team.ru>:
      lib/test_lockup.c: add parameters for locking generic vfs locks

    "Gustavo A. R. Silva" <gustavo@embeddedor.com>:
      lib/bch.c: replace zero-length array with flexible-array member
      lib/ts_bm.c: replace zero-length array with flexible-array member
      lib/ts_fsm.c: replace zero-length array with flexible-array member
      lib/ts_kmp.c: replace zero-length array with flexible-array member

    Geert Uytterhoeven <geert+renesas@glider.be>:
      lib/scatterlist: fix sg_copy_buffer() kerneldoc

    Kees Cook <keescook@chromium.org>:
      lib: test_stackinit.c: XFAIL switch variable init tests

    Alexander Potapenko <glider@google.com>:
      lib/stackdepot.c: check depot_index before accessing the stack slab
lib/stackdepot.c: fix a condition in stack_depot_fetch()
      lib/stackdepot.c: build with -fno-builtin
      kasan: stackdepot: move filter_irq_stacks() to stackdepot.c

    Qian Cai <cai@lca.pw>:
      percpu_counter: fix a data race at vm_committed_as

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      lib/test_bitmap.c: make use of EXP2_IN_BITS

    chenqiwu <chenqiwu@xiaomi.com>:
      lib/rbtree: fix coding style of assignments

    Dan Carpenter <dan.carpenter@oracle.com>:
      lib/test_kmod.c: remove a NULL test

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      linux/bits.h: add compile time sanity check of GENMASK inputs

    Chris Wilson <chris@chris-wilson.co.uk>:
      lib/list: prevent compiler reloads inside 'safe' list iteration

    Nathan Chancellor <natechancellor@gmail.com>:
      lib/dynamic_debug.c: use address-of operator on section symbols

Subsystem: checkpatch

    Joe Perches <joe@perches.com>:
      checkpatch: remove email address comment from email address comparisons

    Lubomir Rintel <lkundrak@v3.sk>:
      checkpatch: check SPDX tags in YAML files

    John Hubbard <jhubbard@nvidia.com>:
      checkpatch: support "base-commit:" format

    Joe Perches <joe@perches.com>:
      checkpatch: prefer fallthrough; over fallthrough comments

    Antonio Borneo <borneo.antonio@gmail.com>:
      checkpatch: fix minor typo and mixed space+tab in indentation
      checkpatch: fix multiple const * types
      checkpatch: add command-line option for TAB size

    Joe Perches <joe@perches.com>:
      checkpatch: improve Gerrit Change-Id: test

    Lubomir Rintel <lkundrak@v3.sk>:
      checkpatch: check proper licensing of Devicetree bindings

    Joe Perches <joe@perches.com>:
      checkpatch: avoid warning about uninitialized_var()

Subsystem: epoll

    Roman Penyaev <rpenyaev@suse.de>:
      kselftest: introduce new epoll test case

    Jason Baron <jbaron@akamai.com>:
      fs/epoll: make nesting accounting safe for -rt kernel

Subsystem: binfmt

    Alexey Dobriyan <adobriyan@gmail.com>:
      fs/binfmt_elf.c: delete "loc" variable
      fs/binfmt_elf.c: allocate less for static executable
      fs/binfmt_elf.c: don't free interpreter's ELF pheaders on common path

Subsystem: kallsyms

    Will Deacon <will@kernel.org>:
    Patch series "Unexport kallsyms_lookup_name() and kallsyms_on_each_symbol()":
      samples/hw_breakpoint: drop HW_BREAKPOINT_R when reporting writes
      samples/hw_breakpoint: drop use of kallsyms_lookup_name()
      kallsyms: unexport kallsyms_lookup_name() and kallsyms_on_each_symbol()

Subsystem: reiserfs

    Colin Ian King <colin.king@canonical.com>:
      reiserfs: clean up several indentation issues

Subsystem: kmod

    Qiujun Huang <hqjagain@gmail.com>:
      kernel/kmod.c: fix a typo "assuems" -> "assumes"

Subsystem: gcov

    "Gustavo A. R. Silva" <gustavo@embeddedor.com>:
      gcov: gcc_4_7: replace zero-length array with flexible-array member
      gcov: gcc_3_4: replace zero-length array with flexible-array member
      kernel/gcov/fs.c: replace zero-length array with flexible-array member

Subsystem: kconfig

    Krzysztof Kozlowski <krzk@kernel.org>:
      init/Kconfig: clean up ANON_INODES and old IO schedulers options

Subsystem: kcov

    Andrey Konovalov <andreyknvl@google.com>:
    Patch series "kcov: collect coverage from usb soft interrupts", v4:
      kcov: cleanup debug messages
      kcov: fix potential use-after-free in kcov_remote_start
      kcov: move t->kcov assignments into kcov_start/stop
      kcov: move t->kcov_sequence assignment
      kcov: use t->kcov_mode as enabled indicator
      kcov: collect coverage from interrupts
      usb: core: kcov: collect coverage from usb complete callback

Subsystem: ubsan

    Kees Cook <keescook@chromium.org>:
    Patch series "ubsan: Split out bounds checker", v5:
      ubsan: add trap instrumentation option
      ubsan: split "bounds" checker from other options
      drivers/misc/lkdtm/bugs.c: add arithmetic overflow and array bounds checks
      ubsan: check panic_on_warn
      kasan: unset panic_on_warn before calling panic()
      ubsan: include bug type in report header

Subsystem: fault-injection

    Qiujun Huang <hqjagain@gmail.com>:
      lib/Kconfig.debug: fix a typo "capabilitiy" -> "capability"

Subsystem: ipc

    Somala Swaraj <somalaswaraj@gmail.com>:
      ipc/mqueue.c: fix a brace coding style issue

    Jason Yan <yanaijie@huawei.com>:
      ipc/shm.c: make compat_ksys_shmctl() static

 Documentation/admin-guide/kernel-parameters.txt               |   13 
 Documentation/admin-guide/mm/transhuge.rst                    |   14 
 Documentation/admin-guide/mm/userfaultfd.rst                  |   51 
 Documentation/dev-tools/kcov.rst                              |   17 
 Documentation/vm/free_page_reporting.rst                      |   41 
 Documentation/vm/zswap.rst                                    |   20 
 MAINTAINERS                                                   |   35 
 arch/alpha/include/asm/mmzone.h                               |    2 
 arch/alpha/kernel/syscalls/syscallhdr.sh                      |    2 
 arch/csky/mm/fault.c                                          |    4 
 arch/ia64/kernel/syscalls/syscallhdr.sh                       |    2 
 arch/ia64/kernel/vmlinux.lds.S                                |    2 
 arch/m68k/mm/fault.c                                          |    4 
 arch/microblaze/kernel/syscalls/syscallhdr.sh                 |    2 
 arch/mips/kernel/syscalls/syscallhdr.sh                       |    3 
 arch/mips/mm/fault.c                                          |    4 
 arch/nds32/kernel/vmlinux.lds.S                               |    1 
 arch/parisc/kernel/syscalls/syscallhdr.sh                     |    2 
 arch/powerpc/kernel/syscalls/syscallhdr.sh                    |    3 
 arch/powerpc/kvm/e500_mmu_host.c                              |    2 
 arch/powerpc/mm/fault.c                                       |    2 
 arch/powerpc/platforms/powernv/memtrace.c                     |   14 
 arch/sh/kernel/syscalls/syscallhdr.sh                         |    2 
 arch/sh/mm/fault.c                                            |    2 
 arch/sparc/kernel/syscalls/syscallhdr.sh                      |    2 
 arch/sparc/vdso/vdso32/vclock_gettime.c                       |    4 
 arch/x86/Kconfig                                              |    1 
 arch/x86/configs/i386_defconfig                               |    1 
 arch/x86/configs/x86_64_defconfig                             |    1 
 arch/x86/entry/vdso/vdso32/vclock_gettime.c                   |    4 
 arch/x86/include/asm/pgtable.h                                |   67 +
 arch/x86/include/asm/pgtable_64.h                             |    8 
 arch/x86/include/asm/pgtable_types.h                          |   12 
 arch/x86/mm/fault.c                                           |    2 
 arch/xtensa/kernel/syscalls/syscallhdr.sh                     |    2 
 drivers/base/memory.c                                         |  138 --
 drivers/hv/hv_balloon.c                                       |   25 
 drivers/misc/lkdtm/bugs.c                                     |   75 +
 drivers/misc/lkdtm/core.c                                     |    3 
 drivers/misc/lkdtm/lkdtm.h                                    |    3 
 drivers/usb/core/hcd.c                                        |    3 
 drivers/virtio/Kconfig                                        |    1 
 drivers/virtio/virtio_balloon.c                               |  190 ++-
 fs/binfmt_elf.c                                               |   56 
 fs/eventpoll.c                                                |   64 -
 fs/proc/array.c                                               |   39 
 fs/proc/cpuinfo.c                                             |    1 
 fs/proc/generic.c                                             |   31 
 fs/proc/inode.c                                               |  188 ++-
 fs/proc/internal.h                                            |    6 
 fs/proc/kmsg.c                                                |    1 
 fs/proc/stat.c                                                |    1 
 fs/proc/task_mmu.c                                            |   97 -
 fs/reiserfs/do_balan.c                                        |    2 
 fs/reiserfs/ioctl.c                                           |   11 
 fs/reiserfs/namei.c                                           |   10 
 fs/seq_file.c                                                 |   28 
 fs/userfaultfd.c                                              |  116 +
 include/asm-generic/pgtable.h                                 |    1 
 include/asm-generic/pgtable_uffd.h                            |   66 +
 include/asm-generic/tlb.h                                     |    3 
 include/linux/bitops.h                                        |    4 
 include/linux/bits.h                                          |   22 
 include/linux/compiler.h                                      |    2 
 include/linux/compiler_types.h                                |   11 
 include/linux/gfp.h                                           |    2 
 include/linux/huge_mm.h                                       |    2 
 include/linux/list.h                                          |   50 
 include/linux/memory.h                                        |    1 
 include/linux/memory_hotplug.h                                |   13 
 include/linux/memremap.h                                      |    2 
 include/linux/mm.h                                            |   25 
 include/linux/mm_inline.h                                     |   15 
 include/linux/mm_types.h                                      |    4 
 include/linux/mmzone.h                                        |   47 
 include/linux/page-flags.h                                    |   16 
 include/linux/page_reporting.h                                |   26 
 include/linux/pagemap.h                                       |    4 
 include/linux/percpu_counter.h                                |    4 
 include/linux/proc_fs.h                                       |   17 
 include/linux/sched.h                                         |    3 
 include/linux/seq_file.h                                      |    1 
 include/linux/shmem_fs.h                                      |   10 
 include/linux/stackdepot.h                                    |    2 
 include/linux/swapops.h                                       |    5 
 include/linux/userfaultfd_k.h                                 |   42 
 include/linux/vm_event_item.h                                 |    5 
 include/trace/events/huge_memory.h                            |    1 
 include/trace/events/mmflags.h                                |    1 
 include/trace/events/vmscan.h                                 |    2 
 include/uapi/linux/userfaultfd.h                              |   40 
 include/uapi/linux/virtio_balloon.h                           |    1 
 init/Kconfig                                                  |    8 
 ipc/mqueue.c                                                  |    5 
 ipc/shm.c                                                     |    2 
 ipc/util.c                                                    |    1 
 kernel/configs/tiny.config                                    |    1 
 kernel/events/core.c                                          |    3 
 kernel/extable.c                                              |    3 
 kernel/fork.c                                                 |   10 
 kernel/gcov/fs.c                                              |    2 
 kernel/gcov/gcc_3_4.c                                         |    6 
 kernel/gcov/gcc_4_7.c                                         |    2 
 kernel/kallsyms.c                                             |    2 
 kernel/kcov.c                                                 |  282 +++-
 kernel/kmod.c                                                 |    2 
 kernel/module.c                                               |    1 
 kernel/sched/fair.c                                           |    2 
 lib/Kconfig.debug                                             |   35 
 lib/Kconfig.ubsan                                             |   51 
 lib/Makefile                                                  |    8 
 lib/bch.c                                                     |    2 
 lib/dynamic_debug.c                                           |    2 
 lib/rbtree.c                                                  |    4 
 lib/scatterlist.c                                             |    2 
 lib/stackdepot.c                                              |   39 
 lib/test_bitmap.c                                             |    2 
 lib/test_kmod.c                                               |    2 
 lib/test_lockup.c                                             |  601 +++++++++-
 lib/test_stackinit.c                                          |   28 
 lib/ts_bm.c                                                   |    2 
 lib/ts_fsm.c                                                  |    2 
 lib/ts_kmp.c                                                  |    2 
 lib/ubsan.c                                                   |   47 
 mm/Kconfig                                                    |  135 ++
 mm/Makefile                                                   |    1 
 mm/compaction.c                                               |    3 
 mm/dmapool.c                                                  |    4 
 mm/filemap.c                                                  |   14 
 mm/gup.c                                                      |    9 
 mm/huge_memory.c                                              |   36 
 mm/hugetlb.c                                                  |    1 
 mm/hugetlb_cgroup.c                                           |    6 
 mm/internal.h                                                 |    2 
 mm/kasan/common.c                                             |   23 
 mm/kasan/report.c                                             |   10 
 mm/khugepaged.c                                               |   39 
 mm/ksm.c                                                      |    5 
 mm/list_lru.c                                                 |    2 
 mm/memcontrol.c                                               |    5 
 mm/memory-failure.c                                           |    2 
 mm/memory.c                                                   |   42 
 mm/memory_hotplug.c                                           |   53 
 mm/mempolicy.c                                                |   11 
 mm/migrate.c                                                  |  122 +-
 mm/mm_init.c                                                  |    2 
 mm/mmap.c                                                     |   10 
 mm/mprotect.c                                                 |   76 -
 mm/page_alloc.c                                               |  174 ++
 mm/page_ext.c                                                 |    5 
 mm/page_isolation.c                                           |    6 
 mm/page_reporting.c                                           |  384 ++++++
 mm/page_reporting.h                                           |   54 
 mm/rmap.c                                                     |   23 
 mm/shmem.c                                                    |  168 +-
 mm/shuffle.c                                                  |   12 
 mm/shuffle.h                                                  |    6 
 mm/slab_common.c                                              |    1 
 mm/slub.c                                                     |    3 
 mm/sparse.c                                                   |  236 ++-
 mm/swap.c                                                     |   20 
 mm/swapfile.c                                                 |    1 
 mm/userfaultfd.c                                              |   98 +
 mm/vmalloc.c                                                  |    2 
 mm/vmscan.c                                                   |   12 
 mm/vmstat.c                                                   |    3 
 mm/zsmalloc.c                                                 |   10 
 mm/zswap.c                                                    |   24 
 samples/hw_breakpoint/data_breakpoint.c                       |   11 
 scripts/Makefile.ubsan                                        |   16 
 scripts/checkpatch.pl                                         |  155 +-
 tools/lib/rbtree.c                                            |    4 
 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |   67 +
 tools/testing/selftests/vm/userfaultfd.c                      |  233 +++
 174 files changed, 3990 insertions(+), 1399 deletions(-)
