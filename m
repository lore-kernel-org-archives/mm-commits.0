From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 30 Jan 2020 22:10:21 -0800
Message-ID: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGKX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:10:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org


Most of -mm and quite a number of other subsystems.

MM is fairly quiet this time.  Holidays, I assume.



119 patches, based on 39bed42de2e7d74686a2d5a45638d6a5d7e7d473:

Subsystems affected by this patch series:

  hotfixes
  scripts
  ocfs2
  mm/slub
  mm/kmemleak
  mm/debug
  mm/pagecache
  mm/gup
  mm/swap
  mm/memcg
  mm/pagemap
  mm/tracing
  mm/kasan
  mm/initialization
  mm/pagealloc
  mm/vmscan
  mm/tools
  mm/memblock
  mm/oom-kill
  mm/hugetlb
  mm/migration
  mm/mmap
  mm/memory-hotplug
  mm/zswap
  mm/cleanups
  mm/zram
  misc
  lib
  binfmt
  init
  reiserfs
  exec
  dma-mapping
  kcov

Subsystem: hotfixes

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      lib/test_bitmap: correct test data offsets for 32-bit

    "Theodore Ts'o" <tytso@mit.edu>:
      memcg: fix a crash in wb_workfn when a device disappears

    Dan Carpenter <dan.carpenter@oracle.com>:
      mm/mempolicy.c: fix out of bounds write in mpol_parse_str()

    Pingfan Liu <kernelfans@gmail.com>:
      mm/sparse.c: reset section's mem_map when fully deactivated

    Wei Yang <richardw.yang@linux.intel.com>:
      mm/migrate.c: also overwrite error when it is bigger than zero

    Dan Williams <dan.j.williams@intel.com>:
      mm/memory_hotplug: fix remove_memory() lockdep splat

    Wei Yang <richardw.yang@linux.intel.com>:
      mm: thp: don't need care deferred split queue in memcg charge move path

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm: move_pages: report the number of non-attempted pages

Subsystem: scripts

    Xiong <xndchn@gmail.com>:
      scripts/spelling.txt: add more spellings to spelling.txt

    Luca Ceresoli <luca@lucaceresoli.net>:
      scripts/spelling.txt: add "issus" typo

Subsystem: ocfs2

    Aditya Pakki <pakki001@umn.edu>:
      fs: ocfs: remove unnecessary assertion in dlm_migrate_lockres

    zhengbin <zhengbin13@huawei.com>:
      ocfs2: remove unneeded semicolons

    Masahiro Yamada <masahiroy@kernel.org>:
      ocfs2: make local header paths relative to C files

    Colin Ian King <colin.king@canonical.com>:
      ocfs2/dlm: remove redundant assignment to ret

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      ocfs2/dlm: move BITS_TO_BYTES() to bitops.h for wider use

    wangyan <wangyan122@huawei.com>:
      ocfs2: fix a NULL pointer dereference when call ocfs2_update_inode_fsync_trans()
      ocfs2: use ocfs2_update_inode_fsync_trans() to access t_tid in handle->h_transaction

Subsystem: mm/slub

    Yu Zhao <yuzhao@google.com>:
      mm/slub.c: avoid slub allocation while holding list_lock

Subsystem: mm/kmemleak

    He Zhe <zhe.he@windriver.com>:
      mm/kmemleak: turn kmemleak_lock and object->lock to raw_spinlock_t

Subsystem: mm/debug

    Vlastimil Babka <vbabka@suse.cz>:
      mm/debug.c: always print flags in dump_page()

Subsystem: mm/pagecache

    Ira Weiny <ira.weiny@intel.com>:
      mm/filemap.c: clean up filemap_write_and_wait()

Subsystem: mm/gup

    Qiujun Huang <hqjagain@gmail.com>:
      mm: fix gup_pud_range

    Wei Yang <richardw.yang@linux.intel.com>:
      mm/gup.c: use is_vm_hugetlb_page() to check whether to follow huge

    John Hubbard <jhubbard@nvidia.com>:
    Patch series "mm/gup: prereqs to track dma-pinned pages: FOLL_PIN", v12:
      mm/gup: factor out duplicate code from four routines
      mm/gup: move try_get_compound_head() to top, fix minor issues

    Dan Williams <dan.j.williams@intel.com>:
      mm: Cleanup __put_devmap_managed_page() vs ->page_free()

    John Hubbard <jhubbard@nvidia.com>:
      mm: devmap: refactor 1-based refcounting for ZONE_DEVICE pages
      goldish_pipe: rename local pin_user_pages() routine
      mm: fix get_user_pages_remote()'s handling of FOLL_LONGTERM
      vfio: fix FOLL_LONGTERM use, simplify get_user_pages_remote() call
      mm/gup: allow FOLL_FORCE for get_user_pages_fast()
      IB/umem: use get_user_pages_fast() to pin DMA pages
      media/v4l2-core: set pages dirty upon releasing DMA buffers
      mm/gup: introduce pin_user_pages*() and FOLL_PIN
      goldish_pipe: convert to pin_user_pages() and put_user_page()
      IB/{core,hw,umem}: set FOLL_PIN via pin_user_pages*(), fix up ODP
      mm/process_vm_access: set FOLL_PIN via pin_user_pages_remote()
      drm/via: set FOLL_PIN via pin_user_pages_fast()
      fs/io_uring: set FOLL_PIN via pin_user_pages()
      net/xdp: set FOLL_PIN via pin_user_pages()
      media/v4l2-core: pin_user_pages (FOLL_PIN) and put_user_page() conversion
      vfio, mm: pin_user_pages (FOLL_PIN) and put_user_page() conversion
      powerpc: book3s64: convert to pin_user_pages() and put_user_page()
      mm/gup_benchmark: use proper FOLL_WRITE flags instead of hard-coding "1"
      mm, tree-wide: rename put_user_page*() to unpin_user_page*()

Subsystem: mm/swap

    Vasily Averin <vvs@virtuozzo.com>:
      mm/swapfile.c: swap_next should increase position index

Subsystem: mm/memcg

    Kaitao Cheng <pilgrimtao@gmail.com>:
      mm/memcontrol.c: cleanup some useless code

Subsystem: mm/pagemap

    Li Xinhai <lixinhai.lxh@gmail.com>:
      mm/page_vma_mapped.c: explicitly compare pfn for normal, hugetlbfs and THP page

Subsystem: mm/tracing

    Junyong Sun <sunjy516@gmail.com>:
      mm, tracing: print symbol name for kmem_alloc_node call_site events

Subsystem: mm/kasan

    "Gustavo A. R. Silva" <gustavo@embeddedor.com>:
      lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()

Subsystem: mm/initialization

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      mm/early_ioremap.c: use %pa to print resource_size_t variables

Subsystem: mm/pagealloc

    "Kirill A. Shutemov" <kirill@shutemov.name>:
      mm/page_alloc: skip non present sections on zone initialization

    David Hildenbrand <david@redhat.com>:
      mm: remove the memory isolate notifier
      mm: remove "count" parameter from has_unmovable_pages()

Subsystem: mm/vmscan

    Liu Song <liu.song11@zte.com.cn>:
      mm/vmscan.c: remove unused return value of shrink_node

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/vmscan: remove prefetch_prev_lru_page
      mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE

Subsystem: mm/tools

    Daniel Wagner <dwagner@suse.de>:
      tools/vm/slabinfo: fix sanity checks enabling

Subsystem: mm/memblock

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/memblock: define memblock_physmem_add()
      memblock: Use __func__ in remaining memblock_dbg() call sites

Subsystem: mm/oom-kill

    David Rientjes <rientjes@google.com>:
      mm, oom: dump stack of victim when reaping failed

Subsystem: mm/hugetlb

    Wei Yang <richardw.yang@linux.intel.com>:
      mm/huge_memory.c: use head to check huge zero page
      mm/huge_memory.c: use head to emphasize the purpose of page
      mm/huge_memory.c: reduce critical section protected by split_queue_lock

Subsystem: mm/migration

    Ralph Campbell <rcampbell@nvidia.com>:
      mm/migrate: remove useless mask of start address
      mm/migrate: clean up some minor coding style
      mm/migrate: add stable check in migrate_vma_insert_page()

    David Rientjes <rientjes@google.com>:
      mm, thp: fix defrag setting if newline is not used

Subsystem: mm/mmap

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/mmap.c: get rid of odd jump labels in find_mergeable_anon_vma()

Subsystem: mm/memory-hotplug

    David Hildenbrand <david@redhat.com>:
    Patch series "mm/memory_hotplug: pass in nid to online_pages()":
      mm/memory_hotplug: pass in nid to online_pages()

    Qian Cai <cai@lca.pw>:
      mm/hotplug: silence a lockdep splat with printk()
      mm/page_isolation: fix potential warning from user

Subsystem: mm/zswap

    Vitaly Wool <vitaly.wool@konsulko.com>:
      mm/zswap.c: add allocation hysteresis if pool limit is hit

    Dan Carpenter <dan.carpenter@oracle.com>:
      zswap: potential NULL dereference on error in init_zswap()

Subsystem: mm/cleanups

    Yu Zhao <yuzhao@google.com>:
      include/linux/mm.h: clean up obsolete check on space in page->flags

    Wei Yang <richardw.yang@linux.intel.com>:
      include/linux/mm.h: remove dead code totalram_pages_set()

    Anshuman Khandual <anshuman.khandual@arm.com>:
      include/linux/memory.h: drop fields 'hw' and 'phys_callback' from struct memory_block

    Hao Lee <haolee.swjtu@gmail.com>:
      mm: fix comments related to node reclaim

Subsystem: mm/zram

    Taejoon Song <taejoon.song@lge.com>:
      zram: try to avoid worst-case scenario on same element pages

    Colin Ian King <colin.king@canonical.com>:
      drivers/block/zram/zram_drv.c: fix error return codes not being returned in writeback_store

Subsystem: misc

    Akinobu Mita <akinobu.mita@gmail.com>:
    Patch series "add header file for kelvin to/from Celsius conversion:
      include/linux/units.h: add helpers for kelvin to/from Celsius conversion
      ACPI: thermal: switch to use <linux/units.h> helpers
      platform/x86: asus-wmi: switch to use <linux/units.h> helpers
      platform/x86: intel_menlow: switch to use <linux/units.h> helpers
      thermal: int340x: switch to use <linux/units.h> helpers
      thermal: intel_pch: switch to use <linux/units.h> helpers
      nvme: hwmon: switch to use <linux/units.h> helpers
      thermal: remove kelvin to/from Celsius conversion helpers from <linux/thermal.h>
      iwlegacy: use <linux/units.h> helpers
      iwlwifi: use <linux/units.h> helpers
      thermal: armada: remove unused TO_MCELSIUS macro
      iio: adc: qcom-vadc-common: use <linux/units.h> helpers

Subsystem: lib

    Mikhail Zaslonko <zaslonko@linux.ibm.com>:
    Patch series "S390 hardware support for kernel zlib", v3:
      lib/zlib: add s390 hardware support for kernel zlib_deflate
      s390/boot: rename HEAP_SIZE due to name collision
      lib/zlib: add s390 hardware support for kernel zlib_inflate
      s390/boot: add dfltcc= kernel command line parameter
      lib/zlib: add zlib_deflate_dfltcc_enabled() function
      btrfs: use larger zlib buffer for s390 hardware compression

    Nathan Chancellor <natechancellor@gmail.com>:
      lib/scatterlist.c: adjust indentation in __sg_alloc_table

    Yury Norov <yury.norov@gmail.com>:
      uapi: rename ext2_swab() to swab() and share globally in swab.h
      lib/find_bit.c: join _find_next_bit{_le}
      lib/find_bit.c: uninline helper _find_next_bit()

Subsystem: binfmt

    Alexey Dobriyan <adobriyan@gmail.com>:
      fs/binfmt_elf.c: smaller code generation around auxv vector fill
      fs/binfmt_elf.c: fix ->start_code calculation
      fs/binfmt_elf.c: don't copy ELF header around
      fs/binfmt_elf.c: better codegen around current->mm
      fs/binfmt_elf.c: make BAD_ADDR() unlikely
      fs/binfmt_elf.c: coredump: allocate core ELF header on stack
      fs/binfmt_elf.c: coredump: delete duplicated overflow check
      fs/binfmt_elf.c: coredump: allow process with empty address space to coredump

Subsystem: init

    Arvind Sankar <nivedita@alum.mit.edu>:
      init/main.c: log arguments and environment passed to init
      init/main.c: remove unnecessary repair_env_string in do_initcall_level
    Patch series "init/main.c: minor cleanup/bugfix of envvar handling", v2:
      init/main.c: fix quoted value handling in unknown_bootoption

    Christophe Leroy <christophe.leroy@c-s.fr>:
      init/main.c: fix misleading "This architecture does not have kernel memory protection" message

Subsystem: reiserfs

    Yunfeng Ye <yeyunfeng@huawei.com>:
      reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()

Subsystem: exec

    Alexey Dobriyan <adobriyan@gmail.com>:
      execve: warn if process starts with executable stack

Subsystem: dma-mapping

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      include/linux/io-mapping.h-mapping: use PHYS_PFN() macro in io_mapping_map_atomic_wc()

Subsystem: kcov

    Dmitry Vyukov <dvyukov@google.com>:
      kcov: ignore fault-inject and stacktrace

 Documentation/admin-guide/kernel-parameters.txt              |   12 
 Documentation/core-api/index.rst                             |    1 
 Documentation/core-api/pin_user_pages.rst                    |  234 +++++
 Documentation/vm/zswap.rst                                   |   13 
 arch/powerpc/mm/book3s64/iommu_api.c                         |   14 
 arch/s390/boot/compressed/decompressor.c                     |    8 
 arch/s390/boot/ipl_parm.c                                    |   14 
 arch/s390/include/asm/setup.h                                |    7 
 arch/s390/kernel/setup.c                                     |   14 
 drivers/acpi/thermal.c                                       |   34 
 drivers/base/memory.c                                        |   25 
 drivers/block/zram/zram_drv.c                                |   10 
 drivers/gpu/drm/via/via_dmablit.c                            |    6 
 drivers/iio/adc/qcom-vadc-common.c                           |    6 
 drivers/iio/adc/qcom-vadc-common.h                           |    1 
 drivers/infiniband/core/umem.c                               |   21 
 drivers/infiniband/core/umem_odp.c                           |   13 
 drivers/infiniband/hw/hfi1/user_pages.c                      |    4 
 drivers/infiniband/hw/mthca/mthca_memfree.c                  |    8 
 drivers/infiniband/hw/qib/qib_user_pages.c                   |    4 
 drivers/infiniband/hw/qib/qib_user_sdma.c                    |    8 
 drivers/infiniband/hw/usnic/usnic_uiom.c                     |    4 
 drivers/infiniband/sw/siw/siw_mem.c                          |    4 
 drivers/media/v4l2-core/videobuf-dma-sg.c                    |   20 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h             |    1 
 drivers/net/wireless/intel/iwlegacy/4965-mac.c               |    3 
 drivers/net/wireless/intel/iwlegacy/4965.c                   |   17 
 drivers/net/wireless/intel/iwlegacy/common.h                 |    3 
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h                 |    5 
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c             |    6 
 drivers/nvdimm/pmem.c                                        |    6 
 drivers/nvme/host/hwmon.c                                    |   13 
 drivers/platform/goldfish/goldfish_pipe.c                    |   39 
 drivers/platform/x86/asus-wmi.c                              |    7 
 drivers/platform/x86/intel_menlow.c                          |    9 
 drivers/thermal/armada_thermal.c                             |    2 
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c |    7 
 drivers/thermal/intel/intel_pch_thermal.c                    |    3 
 drivers/vfio/vfio_iommu_type1.c                              |   39 
 fs/binfmt_elf.c                                              |  154 +--
 fs/btrfs/compression.c                                       |    2 
 fs/btrfs/zlib.c                                              |  135 ++
 fs/exec.c                                                    |    5 
 fs/fs-writeback.c                                            |    2 
 fs/io_uring.c                                                |    6 
 fs/ocfs2/cluster/quorum.c                                    |    2 
 fs/ocfs2/dlm/Makefile                                        |    2 
 fs/ocfs2/dlm/dlmast.c                                        |    8 
 fs/ocfs2/dlm/dlmcommon.h                                     |    4 
 fs/ocfs2/dlm/dlmconvert.c                                    |    8 
 fs/ocfs2/dlm/dlmdebug.c                                      |    8 
 fs/ocfs2/dlm/dlmdomain.c                                     |    8 
 fs/ocfs2/dlm/dlmlock.c                                       |    8 
 fs/ocfs2/dlm/dlmmaster.c                                     |   10 
 fs/ocfs2/dlm/dlmrecovery.c                                   |   10 
 fs/ocfs2/dlm/dlmthread.c                                     |    8 
 fs/ocfs2/dlm/dlmunlock.c                                     |    8 
 fs/ocfs2/dlmfs/Makefile                                      |    2 
 fs/ocfs2/dlmfs/dlmfs.c                                       |    4 
 fs/ocfs2/dlmfs/userdlm.c                                     |    6 
 fs/ocfs2/dlmglue.c                                           |    2 
 fs/ocfs2/journal.h                                           |    8 
 fs/ocfs2/namei.c                                             |    3 
 fs/reiserfs/stree.c                                          |    3 
 include/linux/backing-dev.h                                  |   10 
 include/linux/bitops.h                                       |    1 
 include/linux/fs.h                                           |    6 
 include/linux/io-mapping.h                                   |    5 
 include/linux/memblock.h                                     |    7 
 include/linux/memory.h                                       |   29 
 include/linux/memory_hotplug.h                               |    3 
 include/linux/mm.h                                           |  116 +-
 include/linux/mmzone.h                                       |    2 
 include/linux/page-isolation.h                               |    8 
 include/linux/swab.h                                         |    1 
 include/linux/thermal.h                                      |   11 
 include/linux/units.h                                        |   84 +
 include/linux/zlib.h                                         |    6 
 include/trace/events/kmem.h                                  |    4 
 include/trace/events/writeback.h                             |   37 
 include/uapi/linux/swab.h                                    |   10 
 include/uapi/linux/sysctl.h                                  |    2 
 init/main.c                                                  |   36 
 kernel/Makefile                                              |    1 
 lib/Kconfig                                                  |    7 
 lib/Makefile                                                 |    2 
 lib/decompress_inflate.c                                     |   13 
 lib/find_bit.c                                               |   82 -
 lib/scatterlist.c                                            |    2 
 lib/test_bitmap.c                                            |    9 
 lib/test_kasan.c                                             |    1 
 lib/zlib_deflate/deflate.c                                   |   85 +
 lib/zlib_deflate/deflate_syms.c                              |    1 
 lib/zlib_deflate/deftree.c                                   |   54 -
 lib/zlib_deflate/defutil.h                                   |  134 ++
 lib/zlib_dfltcc/Makefile                                     |   13 
 lib/zlib_dfltcc/dfltcc.c                                     |   57 +
 lib/zlib_dfltcc/dfltcc.h                                     |  155 +++
 lib/zlib_dfltcc/dfltcc_deflate.c                             |  280 ++++++
 lib/zlib_dfltcc/dfltcc_inflate.c                             |  149 +++
 lib/zlib_dfltcc/dfltcc_syms.c                                |   17 
 lib/zlib_dfltcc/dfltcc_util.h                                |  123 ++
 lib/zlib_inflate/inflate.c                                   |   32 
 lib/zlib_inflate/inflate.h                                   |    8 
 lib/zlib_inflate/infutil.h                                   |   18 
 mm/Makefile                                                  |    1 
 mm/backing-dev.c                                             |    1 
 mm/debug.c                                                   |   18 
 mm/early_ioremap.c                                           |    8 
 mm/filemap.c                                                 |   34 
 mm/gup.c                                                     |  503 ++++++-----
 mm/gup_benchmark.c                                           |    9 
 mm/huge_memory.c                                             |   44 
 mm/kmemleak.c                                                |  112 +-
 mm/memblock.c                                                |   22 
 mm/memcontrol.c                                              |   25 
 mm/memory_hotplug.c                                          |   24 
 mm/mempolicy.c                                               |    6 
 mm/memremap.c                                                |   95 --
 mm/migrate.c                                                 |   77 +
 mm/mmap.c                                                    |   30 
 mm/oom_kill.c                                                |    2 
 mm/page_alloc.c                                              |   83 +
 mm/page_isolation.c                                          |   69 -
 mm/page_vma_mapped.c                                         |   12 
 mm/process_vm_access.c                                       |   32 
 mm/slub.c                                                    |   88 +
 mm/sparse.c                                                  |    2 
 mm/swap.c                                                    |   27 
 mm/swapfile.c                                                |    2 
 mm/vmscan.c                                                  |   24 
 mm/zswap.c                                                   |   88 +
 net/xdp/xdp_umem.c                                           |    4 
 scripts/spelling.txt                                         |   14 
 tools/testing/selftests/vm/gup_benchmark.c                   |    6 
 tools/vm/slabinfo.c                                          |    4 
 136 files changed, 2790 insertions(+), 1358 deletions(-)
