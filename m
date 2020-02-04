From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 3 Feb 2020 17:33:11 -0800
Message-ID: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBdO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:33:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


The rest of MM and the rest of everything else.


Subsystems affected by this patch series:

  hotfixes
  mm/pagealloc
  mm/memory-hotplug
  ipc
  misc
  mm/cleanups
  mm/pagemap
  procfs
  lib
  cleanups
  arm

Subsystem: hotfixes

    Gang He <GHe@suse.com>:
      ocfs2: fix oops when writing cloned file

    David Hildenbrand <david@redhat.com>:
    Patch series "mm: fix max_pfn not falling on section boundary", v2:
      mm/page_alloc.c: fix uninitialized memmaps on a partially populated last section
      fs/proc/page.c: allow inspection of last section and fix end detection
      mm/page_alloc.c: initialize memmap of unavailable memory directly

Subsystem: mm/pagealloc

    David Hildenbrand <david@redhat.com>:
      mm/page_alloc: fix and rework pfn handling in memmap_init_zone()
      mm: factor out next_present_section_nr()

Subsystem: mm/memory-hotplug

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
    Patch series "mm/memory_hotplug: Shrink zones before removing memory", v6:
      mm/memmap_init: update variable name in memmap_init_zone

    David Hildenbrand <david@redhat.com>:
      mm/memory_hotplug: poison memmap in remove_pfn_range_from_zone()
      mm/memory_hotplug: we always have a zone in find_(smallest|biggest)_section_pfn
      mm/memory_hotplug: don't check for "all holes" in shrink_zone_span()
      mm/memory_hotplug: drop local variables in shrink_zone_span()
      mm/memory_hotplug: cleanup __remove_pages()
      mm/memory_hotplug: drop valid_start/valid_end from test_pages_in_a_zone()

Subsystem: ipc

    Manfred Spraul <manfred@colorfullife.com>:
      smp_mb__{before,after}_atomic(): update Documentation

    Davidlohr Bueso <dave@stgolabs.net>:
      ipc/mqueue.c: remove duplicated code

    Manfred Spraul <manfred@colorfullife.com>:
      ipc/mqueue.c: update/document memory barriers
      ipc/msg.c: update and document memory barriers
      ipc/sem.c: document and update memory barriers

    Lu Shuaibing <shuaibinglu@126.com>:
      ipc/msg.c: consolidate all xxxctl_down() functions
drivers/block/null_blk_main.c: fix layout

Subsystem: misc

    Andrew Morton <akpm@linux-foundation.org>:
      drivers/block/null_blk_main.c: fix layout
      drivers/block/null_blk_main.c: fix uninitialized var warnings

    Randy Dunlap <rdunlap@infradead.org>:
      pinctrl: fix pxa2xx.c build warnings

Subsystem: mm/cleanups

    Florian Westphal <fw@strlen.de>:
      mm: remove __krealloc

Subsystem: mm/pagemap

    Steven Price <steven.price@arm.com>:
    Patch series "Generic page walk and ptdump", v17:
      mm: add generic p?d_leaf() macros
      arc: mm: add p?d_leaf() definitions
      arm: mm: add p?d_leaf() definitions
      arm64: mm: add p?d_leaf() definitions
      mips: mm: add p?d_leaf() definitions
      powerpc: mm: add p?d_leaf() definitions
      riscv: mm: add p?d_leaf() definitions
      s390: mm: add p?d_leaf() definitions
      sparc: mm: add p?d_leaf() definitions
      x86: mm: add p?d_leaf() definitions
      mm: pagewalk: add p4d_entry() and pgd_entry()
      mm: pagewalk: allow walking without vma
      mm: pagewalk: don't lock PTEs for walk_page_range_novma()
      mm: pagewalk: fix termination condition in walk_pte_range()
      mm: pagewalk: add 'depth' parameter to pte_hole
      x86: mm: point to struct seq_file from struct pg_state
      x86: mm+efi: convert ptdump_walk_pgd_level() to take a mm_struct
      x86: mm: convert ptdump_walk_pgd_level_debugfs() to take an mm_struct
      mm: add generic ptdump
      x86: mm: convert dump_pagetables to use walk_page_range
      arm64: mm: convert mm/dump.c to use walk_page_range()
      arm64: mm: display non-present entries in ptdump
      mm: ptdump: reduce level numbers by 1 in note_page()
      x86: mm: avoid allocating struct mm_struct on the stack

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
    Patch series "Fixup page directory freeing", v4:
      powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case

    Peter Zijlstra <peterz@infradead.org>:
      mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush
      asm-generic/tlb: avoid potential double flush
      asm-gemeric/tlb: remove stray function declarations
      asm-generic/tlb: add missing CONFIG symbol
      asm-generic/tlb: rename HAVE_RCU_TABLE_FREE
      asm-generic/tlb: rename HAVE_MMU_GATHER_PAGE_SIZE
      asm-generic/tlb: rename HAVE_MMU_GATHER_NO_GATHER
      asm-generic/tlb: provide MMU_GATHER_TABLE_FREE

Subsystem: procfs

    Alexey Dobriyan <adobriyan@gmail.com>:
      proc: decouple proc from VFS with "struct proc_ops"
      proc: convert everything to "struct proc_ops"

Subsystem: lib

    Yury Norov <yury.norov@gmail.com>:
    Patch series "lib: rework bitmap_parse", v5:
      lib/string: add strnchrnul()
      bitops: more BITS_TO_* macros
      lib: add test for bitmap_parse()
      lib: make bitmap_parse_user a wrapper on bitmap_parse
      lib: rework bitmap_parse()
      lib: new testcases for bitmap_parse{_user}
      include/linux/cpumask.h: don't calculate length of the input string

Subsystem: cleanups

    Masahiro Yamada <masahiroy@kernel.org>:
      treewide: remove redundant IS_ERR() before error code check

Subsystem: arm

    Chen-Yu Tsai <wens@csie.org>:
      ARM: dma-api: fix max_pfn off-by-one error in __dma_supported()

 Documentation/memory-barriers.txt                     |   14 
 arch/Kconfig                                          |   17 
 arch/alpha/kernel/srm_env.c                           |   17 
 arch/arc/include/asm/pgtable.h                        |    1 
 arch/arm/Kconfig                                      |    2 
 arch/arm/include/asm/pgtable-2level.h                 |    1 
 arch/arm/include/asm/pgtable-3level.h                 |    1 
 arch/arm/include/asm/tlb.h                            |    6 
 arch/arm/kernel/atags_proc.c                          |    8 
 arch/arm/mm/alignment.c                               |   14 
 arch/arm/mm/dma-mapping.c                             |    2 
 arch/arm64/Kconfig                                    |    3 
 arch/arm64/Kconfig.debug                              |   19 
 arch/arm64/include/asm/pgtable.h                      |    2 
 arch/arm64/include/asm/ptdump.h                       |    8 
 arch/arm64/mm/Makefile                                |    4 
 arch/arm64/mm/dump.c                                  |  152 ++----
 arch/arm64/mm/mmu.c                                   |    4 
 arch/arm64/mm/ptdump_debugfs.c                        |    2 
 arch/ia64/kernel/salinfo.c                            |   24 -
 arch/m68k/kernel/bootinfo_proc.c                      |    8 
 arch/mips/include/asm/pgtable.h                       |    5 
 arch/mips/lasat/picvue_proc.c                         |   31 -
 arch/powerpc/Kconfig                                  |    7 
 arch/powerpc/include/asm/book3s/32/pgalloc.h          |    8 
 arch/powerpc/include/asm/book3s/64/pgalloc.h          |    2 
 arch/powerpc/include/asm/book3s/64/pgtable.h          |    3 
 arch/powerpc/include/asm/nohash/pgalloc.h             |    8 
 arch/powerpc/include/asm/tlb.h                        |   11 
 arch/powerpc/kernel/proc_powerpc.c                    |   10 
 arch/powerpc/kernel/rtas-proc.c                       |   70 +--
 arch/powerpc/kernel/rtas_flash.c                      |   34 -
 arch/powerpc/kernel/rtasd.c                           |   14 
 arch/powerpc/mm/book3s64/pgtable.c                    |    7 
 arch/powerpc/mm/numa.c                                |   12 
 arch/powerpc/platforms/pseries/lpar.c                 |   24 -
 arch/powerpc/platforms/pseries/lparcfg.c              |   14 
 arch/powerpc/platforms/pseries/reconfig.c             |    8 
 arch/powerpc/platforms/pseries/scanlog.c              |   15 
 arch/riscv/include/asm/pgtable-64.h                   |    7 
 arch/riscv/include/asm/pgtable.h                      |    7 
 arch/s390/Kconfig                                     |    4 
 arch/s390/include/asm/pgtable.h                       |    2 
 arch/sh/mm/alignment.c                                |   17 
 arch/sparc/Kconfig                                    |    3 
 arch/sparc/include/asm/pgtable_64.h                   |    2 
 arch/sparc/include/asm/tlb_64.h                       |   11 
 arch/sparc/kernel/led.c                               |   15 
 arch/um/drivers/mconsole_kern.c                       |    9 
 arch/um/kernel/exitcode.c                             |   15 
 arch/um/kernel/process.c                              |   15 
 arch/x86/Kconfig                                      |    3 
 arch/x86/Kconfig.debug                                |   20 
 arch/x86/include/asm/pgtable.h                        |   10 
 arch/x86/include/asm/tlb.h                            |    4 
 arch/x86/kernel/cpu/mtrr/if.c                         |   21 
 arch/x86/mm/Makefile                                  |    4 
 arch/x86/mm/debug_pagetables.c                        |   18 
 arch/x86/mm/dump_pagetables.c                         |  418 +++++-------------
 arch/x86/platform/efi/efi_32.c                        |    2 
 arch/x86/platform/efi/efi_64.c                        |    4 
 arch/x86/platform/uv/tlb_uv.c                         |   14 
 arch/xtensa/platforms/iss/simdisk.c                   |   10 
 crypto/af_alg.c                                       |    2 
 drivers/acpi/battery.c                                |   15 
 drivers/acpi/proc.c                                   |   15 
 drivers/acpi/scan.c                                   |    2 
 drivers/base/memory.c                                 |    9 
 drivers/block/null_blk_main.c                         |   58 +-
 drivers/char/hw_random/bcm2835-rng.c                  |    2 
 drivers/char/hw_random/omap-rng.c                     |    4 
 drivers/clk/clk.c                                     |    2 
 drivers/dma/mv_xor_v2.c                               |    2 
 drivers/firmware/efi/arm-runtime.c                    |    2 
 drivers/gpio/gpiolib-devres.c                         |    2 
 drivers/gpio/gpiolib-of.c                             |    8 
 drivers/gpio/gpiolib.c                                |    2 
 drivers/hwmon/dell-smm-hwmon.c                        |   15 
 drivers/i2c/busses/i2c-mv64xxx.c                      |    5 
 drivers/i2c/busses/i2c-synquacer.c                    |    2 
 drivers/ide/ide-proc.c                                |   19 
 drivers/input/input.c                                 |   28 -
 drivers/isdn/capi/kcapi_proc.c                        |    6 
 drivers/macintosh/via-pmu.c                           |   17 
 drivers/md/md.c                                       |   15 
 drivers/misc/sgi-gru/gruprocfs.c                      |   42 -
 drivers/mtd/ubi/build.c                               |    2 
 drivers/net/wireless/cisco/airo.c                     |  126 ++---
 drivers/net/wireless/intel/ipw2x00/libipw_module.c    |   15 
 drivers/net/wireless/intersil/hostap/hostap_hw.c      |    4 
 drivers/net/wireless/intersil/hostap/hostap_proc.c    |   14 
 drivers/net/wireless/intersil/hostap/hostap_wlan.h    |    2 
 drivers/net/wireless/ray_cs.c                         |   20 
 drivers/of/device.c                                   |    2 
 drivers/parisc/led.c                                  |   17 
 drivers/pci/controller/pci-tegra.c                    |    2 
 drivers/pci/proc.c                                    |   25 -
 drivers/phy/phy-core.c                                |    4 
 drivers/pinctrl/pxa/pinctrl-pxa2xx.c                  |    1 
 drivers/platform/x86/thinkpad_acpi.c                  |   15 
 drivers/platform/x86/toshiba_acpi.c                   |   60 +-
 drivers/pnp/isapnp/proc.c                             |    9 
 drivers/pnp/pnpbios/proc.c                            |   17 
 drivers/s390/block/dasd_proc.c                        |   15 
 drivers/s390/cio/blacklist.c                          |   14 
 drivers/s390/cio/css.c                                |   11 
 drivers/scsi/esas2r/esas2r_main.c                     |    9 
 drivers/scsi/scsi_devinfo.c                           |   15 
 drivers/scsi/scsi_proc.c                              |   29 -
 drivers/scsi/sg.c                                     |   30 -
 drivers/spi/spi-orion.c                               |    3 
 drivers/staging/rtl8192u/ieee80211/ieee80211_module.c |   14 
 drivers/tty/sysrq.c                                   |    8 
 drivers/usb/gadget/function/rndis.c                   |   17 
 drivers/video/fbdev/imxfb.c                           |    2 
 drivers/video/fbdev/via/viafbdev.c                    |  105 ++--
 drivers/zorro/proc.c                                  |    9 
 fs/cifs/cifs_debug.c                                  |  108 ++--
 fs/cifs/dfs_cache.c                                   |   13 
 fs/cifs/dfs_cache.h                                   |    2 
 fs/ext4/super.c                                       |    2 
 fs/f2fs/node.c                                        |    2 
 fs/fscache/internal.h                                 |    2 
 fs/fscache/object-list.c                              |   11 
 fs/fscache/proc.c                                     |    2 
 fs/jbd2/journal.c                                     |   13 
 fs/jfs/jfs_debug.c                                    |   14 
 fs/lockd/procfs.c                                     |   12 
 fs/nfsd/nfsctl.c                                      |   13 
 fs/nfsd/stats.c                                       |   12 
 fs/ocfs2/file.c                                       |   14 
 fs/ocfs2/suballoc.c                                   |    2 
 fs/proc/cpuinfo.c                                     |   12 
 fs/proc/generic.c                                     |   38 -
 fs/proc/inode.c                                       |   76 +--
 fs/proc/internal.h                                    |    5 
 fs/proc/kcore.c                                       |   13 
 fs/proc/kmsg.c                                        |   14 
 fs/proc/page.c                                        |   54 +-
 fs/proc/proc_net.c                                    |   32 -
 fs/proc/proc_sysctl.c                                 |    2 
 fs/proc/root.c                                        |    2 
 fs/proc/stat.c                                        |   12 
 fs/proc/task_mmu.c                                    |    4 
 fs/proc/vmcore.c                                      |   10 
 fs/sysfs/group.c                                      |    2 
 include/asm-generic/pgtable.h                         |   20 
 include/asm-generic/tlb.h                             |  138 +++--
 include/linux/bitmap.h                                |    8 
 include/linux/bitops.h                                |    4 
 include/linux/cpumask.h                               |    4 
 include/linux/memory_hotplug.h                        |    4 
 include/linux/mm.h                                    |    6 
 include/linux/mmzone.h                                |   10 
 include/linux/pagewalk.h                              |   49 +-
 include/linux/proc_fs.h                               |   23 
 include/linux/ptdump.h                                |   24 -
 include/linux/seq_file.h                              |   13 
 include/linux/slab.h                                  |    1 
 include/linux/string.h                                |    1 
 include/linux/sunrpc/stats.h                          |    4 
 ipc/mqueue.c                                          |  123 ++++-
 ipc/msg.c                                             |   62 +-
 ipc/sem.c                                             |   66 +-
 ipc/util.c                                            |   14 
 kernel/configs.c                                      |    9 
 kernel/irq/proc.c                                     |   42 -
 kernel/kallsyms.c                                     |   12 
 kernel/latencytop.c                                   |   14 
 kernel/locking/lockdep_proc.c                         |   15 
 kernel/module.c                                       |   12 
 kernel/profile.c                                      |   24 -
 kernel/sched/psi.c                                    |   48 +-
 lib/bitmap.c                                          |  195 ++++----
 lib/string.c                                          |   17 
 lib/test_bitmap.c                                     |  105 ++++
 mm/Kconfig.debug                                      |   21 
 mm/Makefile                                           |    1 
 mm/gup.c                                              |    2 
 mm/hmm.c                                              |   66 +-
 mm/memory_hotplug.c                                   |  104 +---
 mm/memremap.c                                         |    2 
 mm/migrate.c                                          |    5 
 mm/mincore.c                                          |    1 
 mm/mmu_gather.c                                       |  158 ++++--
 mm/page_alloc.c                                       |   75 +--
 mm/pagewalk.c                                         |  167 +++++--
 mm/ptdump.c                                           |  159 ++++++
 mm/slab_common.c                                      |   37 -
 mm/sparse.c                                           |   10 
 mm/swapfile.c                                         |   14 
 net/atm/mpoa_proc.c                                   |   17 
 net/atm/proc.c                                        |    8 
 net/core/dev.c                                        |    2 
 net/core/filter.c                                     |    2 
 net/core/pktgen.c                                     |   44 -
 net/ipv4/ipconfig.c                                   |   10 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                    |   16 
 net/ipv4/route.c                                      |   24 -
 net/netfilter/xt_recent.c                             |   17 
 net/sunrpc/auth_gss/svcauth_gss.c                     |   10 
 net/sunrpc/cache.c                                    |   45 -
 net/sunrpc/stats.c                                    |   21 
 net/xfrm/xfrm_policy.c                                |    2 
 samples/kfifo/bytestream-example.c                    |   11 
 samples/kfifo/inttype-example.c                       |   11 
 samples/kfifo/record-example.c                        |   11 
 scripts/coccinelle/free/devm_free.cocci               |    4 
 sound/core/info.c                                     |   34 -
 sound/soc/codecs/ak4104.c                             |    3 
 sound/soc/codecs/cs4270.c                             |    3 
 sound/soc/codecs/tlv320aic32x4.c                      |    6 
 sound/soc/sunxi/sun4i-spdif.c                         |    2 
 tools/include/linux/bitops.h                          |    9 
 214 files changed, 2589 insertions(+), 2227 deletions(-)
