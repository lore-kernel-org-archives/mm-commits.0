From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 10 Apr 2020 14:30:47 -0700
Message-ID: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVas (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:30:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


Almost all of the rest of MM.  Various other things.

35 patches, based on c0cc271173b2e1c2d8d0ceaef14e4dfa79eefc0d.

Subsystems affected by this patch series:

  hfs
  mm/memcg
  mm/slab-generic
  mm/slab
  mm/pagealloc
  mm/gup
  ocfs2
  mm/hugetlb
  mm/pagemap
  mm/memremap
  kmod
  misc
  seqfile

Subsystem: hfs

    Simon Gander <simon@tuxera.com>:
      hfsplus: fix crash and filesystem corruption when deleting files

Subsystem: mm/memcg

    Jakub Kicinski <kuba@kernel.org>:
      mm, memcg: do not high throttle allocators based on wraparound

Subsystem: mm/slab-generic

    Qiujun Huang <hqjagain@gmail.com>:
      mm, slab_common: fix a typo in comment "eariler"->"earlier"

Subsystem: mm/slab

    Mauro Carvalho Chehab <mchehab+huawei@kernel.org>:
      docs: mm: slab.h: fix a broken cross-reference

Subsystem: mm/pagealloc

    Randy Dunlap <rdunlap@infradead.org>:
      mm/page_alloc.c: fix kernel-doc warning

    Jason Yan <yanaijie@huawei.com>:
      mm/page_alloc: make pcpu_drain_mutex and pcpu_drain static

Subsystem: mm/gup

    Miles Chen <miles.chen@mediatek.com>:
      mm/gup: fix null pointer dereference detected by coverity

Subsystem: ocfs2

    Changwei Ge <chge@linux.alibaba.com>:
      ocfs2: no need try to truncate file beyond i_size

Subsystem: mm/hugetlb

    Aslan Bakirov <aslan@fb.com>:
      mm: cma: NUMA node interface

    Roman Gushchin <guro@fb.com>:
      mm: hugetlb: optionally allocate gigantic hugepages using cma

Subsystem: mm/pagemap

    Jaewon Kim <jaewon31.kim@samsung.com>:
      mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area

    Arjun Roy <arjunroy@google.com>:
      mm/memory.c: refactor insert_page to prepare for batched-lock insert
      mm: bring sparc pte_index() semantics inline with other platforms
      mm: define pte_index as macro for x86
      mm/memory.c: add vm_insert_pages()

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/vma: define a default value for VM_DATA_DEFAULT_FLAGS
      mm/vma: introduce VM_ACCESS_FLAGS
      mm/special: create generic fallbacks for pte_special() and pte_mkspec=
ial()

Subsystem: mm/memremap

    Logan Gunthorpe <logang@deltatee.com>:
    Patch series "Allow setting caching mode in arch_add_memory() for P2PDM=
A", v4:
      mm/memory_hotplug: drop the flags field from struct mhp_restrictions
      mm/memory_hotplug: rename mhp_restrictions to mhp_params
      x86/mm: thread pgprot_t through init_memory_mapping()
      x86/mm: introduce __set_memory_prot()
      powerpc/mm: thread pgprot_t through create_section_mapping()
      mm/memory_hotplug: add pgprot_t to mhp_params
      mm/memremap: set caching mode for PCI P2PDMA memory to WC

Subsystem: kmod

    Eric Biggers <ebiggers@google.com>:
    Patch series "module autoloading fixes and cleanups", v5:
      kmod: make request_module() return an error when autoloading is disab=
led
      fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_onc=
e()
      docs: admin-guide: document the kernel.modprobe sysctl
      selftests: kmod: fix handling test numbers above 9
      selftests: kmod: test disabling module autoloading

Subsystem: misc

    Pali Roh=E1r <pali@kernel.org>:
      change email address for Pali Roh=E1r

    kbuild test robot <lkp@intel.com>:
      drivers/dma/tegra20-apb-dma.c: fix platform_get_irq.cocci warnings

Subsystem: seqfile

    Vasily Averin <vvs@virtuozzo.com>:
    Patch series "seq_file .next functions should increase position index":
      fs/seq_file.c: seq_read(): add info message about buggy .next functio=
ns
      kernel/gcov/fs.c: gcov_seq_next() should increase position index
      ipc/util.c: sysvipc_find_ipc() should increase position index

 Documentation/ABI/testing/sysfs-platform-dell-laptop |    8=20
 Documentation/admin-guide/kernel-parameters.txt      |    8=20
 Documentation/admin-guide/sysctl/kernel.rst          |   21 ++
 MAINTAINERS                                          |   16 -
 arch/alpha/include/asm/page.h                        |    3=20
 arch/alpha/include/asm/pgtable.h                     |    2=20
 arch/arc/include/asm/page.h                          |    2=20
 arch/arm/include/asm/page.h                          |    4=20
 arch/arm/include/asm/pgtable-2level.h                |    2=20
 arch/arm/include/asm/pgtable.h                       |   15 -
 arch/arm/mach-omap2/omap-secure.c                    |    2=20
 arch/arm/mach-omap2/omap-secure.h                    |    2=20
 arch/arm/mach-omap2/omap-smc.S                       |    2=20
 arch/arm/mm/fault.c                                  |    2=20
 arch/arm/mm/mmu.c                                    |   14 +
 arch/arm64/include/asm/page.h                        |    4=20
 arch/arm64/mm/fault.c                                |    2=20
 arch/arm64/mm/init.c                                 |    6=20
 arch/arm64/mm/mmu.c                                  |    7=20
 arch/c6x/include/asm/page.h                          |    5=20
 arch/csky/include/asm/page.h                         |    3=20
 arch/csky/include/asm/pgtable.h                      |    3=20
 arch/h8300/include/asm/page.h                        |    2=20
 arch/hexagon/include/asm/page.h                      |    3=20
 arch/hexagon/include/asm/pgtable.h                   |    2=20
 arch/ia64/include/asm/page.h                         |    5=20
 arch/ia64/include/asm/pgtable.h                      |    2=20
 arch/ia64/mm/init.c                                  |    7=20
 arch/m68k/include/asm/mcf_pgtable.h                  |   10 -
 arch/m68k/include/asm/motorola_pgtable.h             |    2=20
 arch/m68k/include/asm/page.h                         |    3=20
 arch/m68k/include/asm/sun3_pgtable.h                 |    2=20
 arch/microblaze/include/asm/page.h                   |    2=20
 arch/microblaze/include/asm/pgtable.h                |    4=20
 arch/mips/include/asm/page.h                         |    5=20
 arch/mips/include/asm/pgtable.h                      |   44 +++-
 arch/nds32/include/asm/page.h                        |    3=20
 arch/nds32/include/asm/pgtable.h                     |    9 -
 arch/nds32/mm/fault.c                                |    2=20
 arch/nios2/include/asm/page.h                        |    3=20
 arch/nios2/include/asm/pgtable.h                     |    3=20
 arch/openrisc/include/asm/page.h                     |    5=20
 arch/openrisc/include/asm/pgtable.h                  |    2=20
 arch/parisc/include/asm/page.h                       |    3=20
 arch/parisc/include/asm/pgtable.h                    |    2=20
 arch/powerpc/include/asm/book3s/64/hash.h            |    3=20
 arch/powerpc/include/asm/book3s/64/radix.h           |    3=20
 arch/powerpc/include/asm/page.h                      |    9 -
 arch/powerpc/include/asm/page_64.h                   |    7=20
 arch/powerpc/include/asm/sparsemem.h                 |    3=20
 arch/powerpc/mm/book3s64/hash_utils.c                |    5=20
 arch/powerpc/mm/book3s64/pgtable.c                   |    7=20
 arch/powerpc/mm/book3s64/pkeys.c                     |    2=20
 arch/powerpc/mm/book3s64/radix_pgtable.c             |   18 +-
 arch/powerpc/mm/mem.c                                |   12 -
 arch/riscv/include/asm/page.h                        |    3=20
 arch/s390/include/asm/page.h                         |    3=20
 arch/s390/mm/fault.c                                 |    2=20
 arch/s390/mm/init.c                                  |    9 -
 arch/sh/include/asm/page.h                           |    3=20
 arch/sh/mm/init.c                                    |    7=20
 arch/sparc/include/asm/page_32.h                     |    3=20
 arch/sparc/include/asm/page_64.h                     |    3=20
 arch/sparc/include/asm/pgtable_32.h                  |    7=20
 arch/sparc/include/asm/pgtable_64.h                  |   10 -
 arch/um/include/asm/pgtable.h                        |   10 -
 arch/unicore32/include/asm/page.h                    |    3=20
 arch/unicore32/include/asm/pgtable.h                 |    3=20
 arch/unicore32/mm/fault.c                            |    2=20
 arch/x86/include/asm/page_types.h                    |    7=20
 arch/x86/include/asm/pgtable.h                       |    6=20
 arch/x86/include/asm/set_memory.h                    |    1=20
 arch/x86/kernel/amd_gart_64.c                        |    3=20
 arch/x86/kernel/setup.c                              |    4=20
 arch/x86/mm/init.c                                   |    9 -
 arch/x86/mm/init_32.c                                |   19 +-
 arch/x86/mm/init_64.c                                |   42 ++--
 arch/x86/mm/mm_internal.h                            |    3=20
 arch/x86/mm/pat/set_memory.c                         |   13 +
 arch/x86/mm/pkeys.c                                  |    2=20
 arch/x86/platform/uv/bios_uv.c                       |    3=20
 arch/x86/um/asm/vm-flags.h                           |   10 -
 arch/xtensa/include/asm/page.h                       |    3=20
 arch/xtensa/include/asm/pgtable.h                    |    3=20
 drivers/char/hw_random/omap3-rom-rng.c               |    4=20
 drivers/dma/tegra20-apb-dma.c                        |    1=20
 drivers/hwmon/dell-smm-hwmon.c                       |    4=20
 drivers/platform/x86/dell-laptop.c                   |    4=20
 drivers/platform/x86/dell-rbtn.c                     |    4=20
 drivers/platform/x86/dell-rbtn.h                     |    2=20
 drivers/platform/x86/dell-smbios-base.c              |    4=20
 drivers/platform/x86/dell-smbios-smm.c               |    2=20
 drivers/platform/x86/dell-smbios.h                   |    2=20
 drivers/platform/x86/dell-smo8800.c                  |    2=20
 drivers/platform/x86/dell-wmi.c                      |    4=20
 drivers/power/supply/bq2415x_charger.c               |    4=20
 drivers/power/supply/bq27xxx_battery.c               |    2=20
 drivers/power/supply/isp1704_charger.c               |    2=20
 drivers/power/supply/rx51_battery.c                  |    4=20
 drivers/staging/gasket/gasket_core.c                 |    2=20
 fs/filesystems.c                                     |    4=20
 fs/hfsplus/attributes.c                              |    4=20
 fs/ocfs2/alloc.c                                     |    4=20
 fs/seq_file.c                                        |    7=20
 fs/udf/ecma_167.h                                    |    2=20
 fs/udf/osta_udf.h                                    |    2=20
 include/linux/cma.h                                  |   14 +
 include/linux/hugetlb.h                              |   12 +
 include/linux/memblock.h                             |    3=20
 include/linux/memory_hotplug.h                       |   21 +-
 include/linux/mm.h                                   |   34 +++
 include/linux/power/bq2415x_charger.h                |    2=20
 include/linux/slab.h                                 |    2=20
 ipc/util.c                                           |    2=20
 kernel/gcov/fs.c                                     |    2=20
 kernel/kmod.c                                        |    4=20
 mm/cma.c                                             |   16 +
 mm/gup.c                                             |    3=20
 mm/hugetlb.c                                         |  109 ++++++++++++
 mm/memblock.c                                        |    2=20
 mm/memcontrol.c                                      |    3=20
 mm/memory.c                                          |  168 ++++++++++++++=
+++--
 mm/memory_hotplug.c                                  |   13 -
 mm/memremap.c                                        |   17 +
 mm/mmap.c                                            |    4=20
 mm/mprotect.c                                        |    4=20
 mm/page_alloc.c                                      |    5=20
 mm/slab_common.c                                     |    2=20
 tools/laptop/freefall/freefall.c                     |    2=20
 tools/testing/selftests/kmod/kmod.sh                 |   43 ++++
 130 files changed, 710 insertions(+), 370 deletions(-)
