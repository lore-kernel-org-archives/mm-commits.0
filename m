From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 4 Jun 2020 16:45:23 -0700
Message-ID: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgFDXpY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org


- More MM work.  100ish more to go.  Mike's "mm: remove
  __ARCH_HAS_5LEVEL_HACK" series should fix the current ppc issue.

- Various other little subsystems

127 patches, based on 6929f71e46bdddbf1c4d67c2728648176c67c555.


Subsystems affected by this patch series:

  kcov
  mm/pagemap
  mm/vmalloc
  mm/kmap
  mm/util
  mm/memory-hotplug
  mm/cleanups
  mm/zram
  procfs
  core-kernel
  get_maintainer
  lib
  bitops
  checkpatch
  binfmt
  init
  fat
  seq_file
  exec
  rapidio
  relay
  selftests
  ubsan

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

Subsystem: mm/pagemap

    Feng Tang <feng.tang@intel.com>:
      mm/util.c: remove the VM_WARN_ONCE for vm_committed_as underflow check

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "mm: remove __ARCH_HAS_5LEVEL_HACK", v4:
      h8300: remove usage of __ARCH_USE_5LEVEL_HACK
      arm: add support for folded p4d page tables
      arm64: add support for folded p4d page tables
      hexagon: remove __ARCH_USE_5LEVEL_HACK
      ia64: add support for folded p4d page tables
      nios2: add support for folded p4d page tables
      openrisc: add support for folded p4d page tables
      powerpc: add support for folded p4d page tables

    Geert Uytterhoeven <geert+renesas@glider.be>:
      sh: fault: modernize printing of kernel messages

    Mike Rapoport <rppt@linux.ibm.com>:
      sh: drop __pXd_offset() macros that duplicate pXd_index() ones
      sh: add support for folded p4d page tables
      unicore32: remove __ARCH_USE_5LEVEL_HACK
      asm-generic: remove pgtable-nop4d-hack.h
      mm: remove __ARCH_HAS_5LEVEL_HACK and include/asm-generic/5level-fixup.h

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm/debug: Add tests validating architecture page table:
      x86/mm: define mm_p4d_folded()
      mm/debug: add tests validating architecture page table helpers

Subsystem: mm/vmalloc

    Jeongtae Park <jtp.park@samsung.com>:
      mm/vmalloc: fix a typo in comment

Subsystem: mm/kmap

    Ira Weiny <ira.weiny@intel.com>:
    Patch series "Remove duplicated kmap code", v3:
      arch/kmap: remove BUG_ON()
      arch/xtensa: move kmap build bug out of the way
      arch/kmap: remove redundant arch specific kmaps
      arch/kunmap: remove duplicate kunmap implementations
      {x86,powerpc,microblaze}/kmap: move preempt disable
      arch/kmap_atomic: consolidate duplicate code
      arch/kunmap_atomic: consolidate duplicate code
      arch/kmap: ensure kmap_prot visibility
      arch/kmap: don't hard code kmap_prot values
      arch/kmap: define kmap_atomic_prot() for all arch's
      drm: remove drm specific kmap_atomic code
      kmap: remove kmap_atomic_to_page()
      parisc/kmap: remove duplicate kmap code
      sparc: remove unnecessary includes
      kmap: consolidate kmap_prot definitions

Subsystem: mm/util

    Waiman Long <longman@redhat.com>:
      mm: add kvfree_sensitive() for freeing sensitive data objects

Subsystem: mm/memory-hotplug

    Vishal Verma <vishal.l.verma@intel.com>:
      mm/memory_hotplug: refrain from adding memory into an impossible node

    David Hildenbrand <david@redhat.com>:
      powerpc/pseries/hotplug-memory: stop checking is_mem_section_removable()
      mm/memory_hotplug: remove is_mem_section_removable()
    Patch series "mm/memory_hotplug: handle memblocks only with:
      mm/memory_hotplug: set node_start_pfn of hotadded pgdat to 0
      mm/memory_hotplug: handle memblocks only with CONFIG_ARCH_KEEP_MEMBLOCK
    Patch series "mm/memory_hotplug: Interface to add driver-managed system:
      mm/memory_hotplug: introduce add_memory_driver_managed()
      kexec_file: don't place kexec images on IORESOURCE_MEM_DRIVER_MANAGED
      device-dax: add memory via add_memory_driver_managed()

    Michal Hocko <mhocko@kernel.org>:
      mm/memory_hotplug: disable the functionality for 32b

Subsystem: mm/cleanups

    chenqiwu <chenqiwu@xiaomi.com>:
      mm: replace zero-length array with flexible-array member

    Ethon Paul <ethp@qq.com>:
      mm/memory_hotplug: fix a typo in comment "recoreded"->"recorded"
      mm: ksm: fix a typo in comment "alreaady"->"already"
      mm: mmap: fix a typo in comment "compatbility"->"compatibility"
      mm/hugetlb: fix a typos in comments
      mm/vmsan: fix some typos in comment
      mm/compaction: fix a typo in comment "pessemistic"->"pessimistic"
      mm/memblock: fix a typo in comment "implict"->"implicit"
      mm/list_lru: fix a typo in comment "numbesr"->"numbers"
      mm/filemap: fix a typo in comment "unneccssary"->"unnecessary"
      mm/frontswap: fix some typos in frontswap.c
      mm, memcg: fix some typos in memcontrol.c
      mm: fix a typo in comment "strucure"->"structure"
      mm/slub: fix a typo in comment "disambiguiation"->"disambiguation"
      mm/sparse: fix a typo in comment "convienence"->"convenience"
      mm/page-writeback: fix a typo in comment "effictive"->"effective"
      mm/memory: fix a typo in comment "attampt"->"attempt"

    Zou Wei <zou_wei@huawei.com>:
      mm: use false for bool variable

    Jason Yan <yanaijie@huawei.com>:
      include/linux/mm.h: return true in cpupid_pid_unset()

Subsystem: mm/zram

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      zcomp: Use ARRAY_SIZE() for backends list

Subsystem: procfs

    Alexey Dobriyan <adobriyan@gmail.com>:
      proc: rename "catch" function argument

Subsystem: core-kernel

    Jason Yan <yanaijie@huawei.com>:
      user.c: make uidhash_table static

Subsystem: get_maintainer

    Joe Perches <joe@perches.com>:
      get_maintainer: add email addresses from .yaml files
      get_maintainer: fix unexpected behavior for path/to//file (double slashes)

Subsystem: lib

    Christophe JAILLET <christophe.jaillet@wanadoo.fr>:
      lib/math: avoid trailing newline hidden in pr_fmt()

    KP Singh <kpsingh@chromium.org>:
      lib: Add might_fault() to strncpy_from_user.

    Jason Yan <yanaijie@huawei.com>:
      lib/test_lockup.c: make test_inode static

    Jann Horn <jannh@google.com>:
      lib/zlib: remove outdated and incorrect pre-increment optimization

    Joe Perches <joe@perches.com>:
      lib/percpu-refcount.c: use a more common logging style

    Tan Hu <tan.hu@zte.com.cn>:
      lib/flex_proportions.c: cleanup __fprop_inc_percpu_max

    Jesse Brandeburg <jesse.brandeburg@intel.com>:
      lib: make a test module with set/clear bit

Subsystem: bitops

    Arnd Bergmann <arnd@arndb.de>:
      include/linux/bitops.h: avoid clang shift-count-overflow warnings

Subsystem: checkpatch

    Joe Perches <joe@perches.com>:
      checkpatch: additional MAINTAINER section entry ordering checks
      checkpatch: look for c99 comments in ctx_locate_comment
      checkpatch: disallow --git and --file/--fix

    Geert Uytterhoeven <geert+renesas@glider.be>:
      checkpatch: use patch subject when reading from stdin

Subsystem: binfmt

    Anthony Iliopoulos <ailiop@suse.com>:
      fs/binfmt_elf: remove redundant elf_map ifndef

    Nick Desaulniers <ndesaulniers@google.com>:
      elfnote: mark all .note sections SHF_ALLOC

Subsystem: init

    Chris Down <chris@chrisdown.name>:
      init: allow distribution configuration of default init

Subsystem: fat

    OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
      fat: don't allow to mount if the FAT length == 0
      fat: improve the readahead for FAT entries

Subsystem: seq_file

    Joe Perches <joe@perches.com>:
      fs/seq_file.c: seq_read: Update pr_info_ratelimited

    Kefeng Wang <wangkefeng.wang@huawei.com>:
    Patch series "seq_file: Introduce DEFINE_SEQ_ATTRIBUTE() helper macro":
      include/linux/seq_file.h: introduce DEFINE_SEQ_ATTRIBUTE() helper macro
      mm/vmstat.c: convert to use DEFINE_SEQ_ATTRIBUTE macro
      kernel/kprobes.c: convert to use DEFINE_SEQ_ATTRIBUTE macro

Subsystem: exec

    Christoph Hellwig <hch@lst.de>:
      exec: simplify the copy_strings_kernel calling convention
      exec: open code copy_string_kernel

Subsystem: rapidio

    Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>:
      rapidio: avoid data race between file operation callbacks and mport_cdev_add().

    John Hubbard <jhubbard@nvidia.com>:
      rapidio: convert get_user_pages() --> pin_user_pages()

Subsystem: relay

    Daniel Axtens <dja@axtens.net>:
      kernel/relay.c: handle alloc_percpu returning NULL in relay_open

    Pengcheng Yang <yangpc@wangsu.com>:
      kernel/relay.c: fix read_pos error when multiple readers

Subsystem: selftests

    Ram Pai <linuxram@us.ibm.com>:
    Patch series "selftests, powerpc, x86: Memory Protection Keys", v19:
      selftests/x86/pkeys: move selftests to arch-neutral directory
      selftests/vm/pkeys: rename all references to pkru to a generic name
      selftests/vm/pkeys: move generic definitions to header file

    Thiago Jung Bauermann <bauerman@linux.ibm.com>:
      selftests/vm/pkeys: move some definitions to arch-specific header
      selftests/vm/pkeys: make gcc check arguments of sigsafe_printf()

    Sandipan Das <sandipan@linux.ibm.com>:
      selftests: vm: pkeys: Use sane types for pkey register
      selftests: vm: pkeys: add helpers for pkey bits

    Ram Pai <linuxram@us.ibm.com>:
      selftests/vm/pkeys: fix pkey_disable_clear()
      selftests/vm/pkeys: fix assertion in pkey_disable_set/clear()
      selftests/vm/pkeys: fix alloc_random_pkey() to make it really random

    Sandipan Das <sandipan@linux.ibm.com>:
      selftests: vm: pkeys: use the correct huge page size

    Ram Pai <linuxram@us.ibm.com>:
      selftests/vm/pkeys: introduce generic pkey abstractions
      selftests/vm/pkeys: introduce powerpc support

    "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>:
      selftests/vm/pkeys: fix number of reserved powerpc pkeys

    Ram Pai <linuxram@us.ibm.com>:
      selftests/vm/pkeys: fix assertion in test_pkey_alloc_exhaust()
      selftests/vm/pkeys: improve checks to determine pkey support
      selftests/vm/pkeys: associate key on a mapped page and detect access violation
      selftests/vm/pkeys: associate key on a mapped page and detect write violation
      selftests/vm/pkeys: detect write violation on a mapped access-denied-key page
      selftests/vm/pkeys: introduce a sub-page allocator
      selftests/vm/pkeys: test correct behaviour of pkey-0
      selftests/vm/pkeys: override access right definitions on powerpc

    Sandipan Das <sandipan@linux.ibm.com>:
      selftests: vm: pkeys: use the correct page size on powerpc
      selftests: vm: pkeys: fix multilib builds for x86

    Jagadeesh Pagadala <jagdsh.linux@gmail.com>:
      tools/testing/selftests/vm: remove duplicate headers

Subsystem: ubsan

    Arnd Bergmann <arnd@arndb.de>:
      lib/ubsan.c: fix gcc-10 warnings

 Documentation/dev-tools/kcov.rst                               |   17 
 Documentation/features/debug/debug-vm-pgtable/arch-support.txt |   34 
 arch/arc/Kconfig                                               |    1 
 arch/arc/include/asm/highmem.h                                 |   20 
 arch/arc/mm/highmem.c                                          |   34 
 arch/arm/include/asm/highmem.h                                 |    9 
 arch/arm/include/asm/pgtable.h                                 |    1 
 arch/arm/lib/uaccess_with_memcpy.c                             |    7 
 arch/arm/mach-sa1100/assabet.c                                 |    2 
 arch/arm/mm/dump.c                                             |   29 
 arch/arm/mm/fault-armv.c                                       |    7 
 arch/arm/mm/fault.c                                            |   22 
 arch/arm/mm/highmem.c                                          |   41 
 arch/arm/mm/idmap.c                                            |    3 
 arch/arm/mm/init.c                                             |    2 
 arch/arm/mm/ioremap.c                                          |   12 
 arch/arm/mm/mm.h                                               |    2 
 arch/arm/mm/mmu.c                                              |   35 
 arch/arm/mm/pgd.c                                              |   40 
 arch/arm64/Kconfig                                             |    1 
 arch/arm64/include/asm/kvm_mmu.h                               |   10 
 arch/arm64/include/asm/pgalloc.h                               |   10 
 arch/arm64/include/asm/pgtable-types.h                         |    5 
 arch/arm64/include/asm/pgtable.h                               |   37 
 arch/arm64/include/asm/stage2_pgtable.h                        |   48 
 arch/arm64/kernel/hibernate.c                                  |   44 
 arch/arm64/kvm/mmu.c                                           |  209 
 arch/arm64/mm/fault.c                                          |    9 
 arch/arm64/mm/hugetlbpage.c                                    |   15 
 arch/arm64/mm/kasan_init.c                                     |   26 
 arch/arm64/mm/mmu.c                                            |   52 
 arch/arm64/mm/pageattr.c                                       |    7 
 arch/csky/include/asm/highmem.h                                |   12 
 arch/csky/mm/highmem.c                                         |   64 
 arch/h8300/include/asm/pgtable.h                               |    1 
 arch/hexagon/include/asm/fixmap.h                              |    4 
 arch/hexagon/include/asm/pgtable.h                             |    1 
 arch/ia64/include/asm/pgalloc.h                                |    4 
 arch/ia64/include/asm/pgtable.h                                |   17 
 arch/ia64/mm/fault.c                                           |    7 
 arch/ia64/mm/hugetlbpage.c                                     |   18 
 arch/ia64/mm/init.c                                            |   28 
 arch/microblaze/include/asm/highmem.h                          |   55 
 arch/microblaze/mm/highmem.c                                   |   21 
 arch/microblaze/mm/init.c                                      |    3 
 arch/mips/include/asm/highmem.h                                |   11 
 arch/mips/mm/cache.c                                           |    6 
 arch/mips/mm/highmem.c                                         |   62 
 arch/nds32/include/asm/highmem.h                               |    9 
 arch/nds32/mm/highmem.c                                        |   49 
 arch/nios2/include/asm/pgtable.h                               |    3 
 arch/nios2/mm/fault.c                                          |    9 
 arch/nios2/mm/ioremap.c                                        |    6 
 arch/openrisc/include/asm/pgtable.h                            |    1 
 arch/openrisc/mm/fault.c                                       |   10 
 arch/openrisc/mm/init.c                                        |    4 
 arch/parisc/include/asm/cacheflush.h                           |   32 
 arch/powerpc/Kconfig                                           |    1 
 arch/powerpc/include/asm/book3s/32/pgtable.h                   |    1 
 arch/powerpc/include/asm/book3s/64/hash.h                      |    4 
 arch/powerpc/include/asm/book3s/64/pgalloc.h                   |    4 
 arch/powerpc/include/asm/book3s/64/pgtable.h                   |   60 
 arch/powerpc/include/asm/book3s/64/radix.h                     |    6 
 arch/powerpc/include/asm/highmem.h                             |   56 
 arch/powerpc/include/asm/nohash/32/pgtable.h                   |    1 
 arch/powerpc/include/asm/nohash/64/pgalloc.h                   |    2 
 arch/powerpc/include/asm/nohash/64/pgtable-4k.h                |   32 
 arch/powerpc/include/asm/nohash/64/pgtable.h                   |    6 
 arch/powerpc/include/asm/pgtable.h                             |   10 
 arch/powerpc/kvm/book3s_64_mmu_radix.c                         |   32 
 arch/powerpc/lib/code-patching.c                               |    7 
 arch/powerpc/mm/book3s64/hash_pgtable.c                        |    4 
 arch/powerpc/mm/book3s64/radix_pgtable.c                       |   26 
 arch/powerpc/mm/book3s64/subpage_prot.c                        |    6 
 arch/powerpc/mm/highmem.c                                      |   26 
 arch/powerpc/mm/hugetlbpage.c                                  |   28 
 arch/powerpc/mm/kasan/kasan_init_32.c                          |    2 
 arch/powerpc/mm/mem.c                                          |    3 
 arch/powerpc/mm/nohash/book3e_pgtable.c                        |   15 
 arch/powerpc/mm/pgtable.c                                      |   30 
 arch/powerpc/mm/pgtable_64.c                                   |   10 
 arch/powerpc/mm/ptdump/hashpagetable.c                         |   20 
 arch/powerpc/mm/ptdump/ptdump.c                                |   12 
 arch/powerpc/platforms/pseries/hotplug-memory.c                |   26 
 arch/powerpc/xmon/xmon.c                                       |   27 
 arch/s390/Kconfig                                              |    1 
 arch/sh/include/asm/pgtable-2level.h                           |    1 
 arch/sh/include/asm/pgtable-3level.h                           |    1 
 arch/sh/include/asm/pgtable_32.h                               |    5 
 arch/sh/include/asm/pgtable_64.h                               |    5 
 arch/sh/kernel/io_trapped.c                                    |    7 
 arch/sh/mm/cache-sh4.c                                         |    4 
 arch/sh/mm/cache-sh5.c                                         |    7 
 arch/sh/mm/fault.c                                             |   64 
 arch/sh/mm/hugetlbpage.c                                       |   28 
 arch/sh/mm/init.c                                              |   15 
 arch/sh/mm/kmap.c                                              |    2 
 arch/sh/mm/tlbex_32.c                                          |    6 
 arch/sh/mm/tlbex_64.c                                          |    7 
 arch/sparc/include/asm/highmem.h                               |   29 
 arch/sparc/mm/highmem.c                                        |   31 
 arch/sparc/mm/io-unit.c                                        |    1 
 arch/sparc/mm/iommu.c                                          |    1 
 arch/unicore32/include/asm/pgtable.h                           |    1 
 arch/unicore32/kernel/hibernate.c                              |    4 
 arch/x86/Kconfig                                               |    1 
 arch/x86/include/asm/fixmap.h                                  |    1 
 arch/x86/include/asm/highmem.h                                 |   37 
 arch/x86/include/asm/pgtable_64.h                              |    6 
 arch/x86/mm/highmem_32.c                                       |   52 
 arch/xtensa/include/asm/highmem.h                              |   31 
 arch/xtensa/mm/highmem.c                                       |   28 
 drivers/block/zram/zcomp.c                                     |    7 
 drivers/dax/dax-private.h                                      |    1 
 drivers/dax/kmem.c                                             |   28 
 drivers/gpu/drm/ttm/ttm_bo_util.c                              |   56 
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c                           |   17 
 drivers/rapidio/devices/rio_mport_cdev.c                       |   27 
 drivers/usb/core/hcd.c                                         |    3 
 fs/binfmt_elf.c                                                |    4 
 fs/binfmt_em86.c                                               |    6 
 fs/binfmt_misc.c                                               |    4 
 fs/binfmt_script.c                                             |    6 
 fs/exec.c                                                      |   58 
 fs/fat/fatent.c                                                |  103 
 fs/fat/inode.c                                                 |    6 
 fs/proc/array.c                                                |    8 
 fs/seq_file.c                                                  |    7 
 include/asm-generic/5level-fixup.h                             |   59 
 include/asm-generic/pgtable-nop4d-hack.h                       |   64 
 include/asm-generic/pgtable-nopud.h                            |    4 
 include/drm/ttm/ttm_bo_api.h                                   |    4 
 include/linux/binfmts.h                                        |    3 
 include/linux/bitops.h                                         |    2 
 include/linux/elfnote.h                                        |    2 
 include/linux/highmem.h                                        |   89 
 include/linux/ioport.h                                         |    1 
 include/linux/memory_hotplug.h                                 |    9 
 include/linux/mm.h                                             |   12 
 include/linux/sched.h                                          |    3 
 include/linux/seq_file.h                                       |   19 
 init/Kconfig                                                   |   10 
 init/main.c                                                    |   10 
 kernel/kcov.c                                                  |  282 -
 kernel/kexec_file.c                                            |    5 
 kernel/kprobes.c                                               |   34 
 kernel/relay.c                                                 |   22 
 kernel/user.c                                                  |    2 
 lib/Kconfig.debug                                              |   44 
 lib/Makefile                                                   |    2 
 lib/flex_proportions.c                                         |    7 
 lib/math/prime_numbers.c                                       |   10 
 lib/percpu-refcount.c                                          |    6 
 lib/strncpy_from_user.c                                        |    1 
 lib/test_bitops.c                                              |   60 
 lib/test_lockup.c                                              |    2 
 lib/ubsan.c                                                    |   33 
 lib/zlib_inflate/inffast.c                                     |   91 
 mm/Kconfig                                                     |    4 
 mm/Makefile                                                    |    1 
 mm/compaction.c                                                |    2 
 mm/debug_vm_pgtable.c                                          |  382 +
 mm/filemap.c                                                   |    2 
 mm/frontswap.c                                                 |    6 
 mm/huge_memory.c                                               |    2 
 mm/hugetlb.c                                                   |   16 
 mm/internal.h                                                  |    2 
 mm/kasan/init.c                                                |   11 
 mm/ksm.c                                                       |   10 
 mm/list_lru.c                                                  |    2 
 mm/memblock.c                                                  |    2 
 mm/memcontrol.c                                                |    4 
 mm/memory.c                                                    |   10 
 mm/memory_hotplug.c                                            |  179 
 mm/mmap.c                                                      |    2 
 mm/mremap.c                                                    |    2 
 mm/page-writeback.c                                            |    2 
 mm/slub.c                                                      |    2 
 mm/sparse.c                                                    |    2 
 mm/util.c                                                      |   22 
 mm/vmalloc.c                                                   |    2 
 mm/vmscan.c                                                    |    6 
 mm/vmstat.c                                                    |   32 
 mm/zbud.c                                                      |    2 
 scripts/checkpatch.pl                                          |   62 
 scripts/get_maintainer.pl                                      |   46 
 security/keys/internal.h                                       |   11 
 security/keys/keyctl.c                                         |   16 
 tools/testing/selftests/lib/config                             |    1 
 tools/testing/selftests/vm/.gitignore                          |    1 
 tools/testing/selftests/vm/Makefile                            |   75 
 tools/testing/selftests/vm/mremap_dontunmap.c                  |    1 
 tools/testing/selftests/vm/pkey-helpers.h                      |  557 +-
 tools/testing/selftests/vm/pkey-powerpc.h                      |  153 
 tools/testing/selftests/vm/pkey-x86.h                          |  191 
 tools/testing/selftests/vm/protection_keys.c                   | 2370 ++++++++--
 tools/testing/selftests/x86/.gitignore                         |    1 
 tools/testing/selftests/x86/Makefile                           |    2 
 tools/testing/selftests/x86/pkey-helpers.h                     |  219 
 tools/testing/selftests/x86/protection_keys.c                  | 1506 ------
 200 files changed, 5182 insertions(+), 4033 deletions(-)
