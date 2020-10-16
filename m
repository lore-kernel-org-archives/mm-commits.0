Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8C8C4363A
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 694002087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816053;
	bh=WFxNPBmeEOfEz9nOWN036fG4cwch13GXYNap05X8pII=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=nZajE+l1piUSB2Ev7R+SqWGAtKbuJcWizANFNMZWOglnIdPXAJujvrD9jsZIEqFCe
	 fGqXlW6+A6vnVWa+63S8MAD+PPaLKkwIKIUnGLeHSn4LNs0qNl5UNKAkgXPahUb3eI
	 8CA17RpAtQrFy6QXyzfnv46TwaEWEI7BxMFqTgwE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404265AbgJPCkw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404226AbgJPCks (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:40:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5592E208C7;
        Fri, 16 Oct 2020 02:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816044;
        bh=WFxNPBmeEOfEz9nOWN036fG4cwch13GXYNap05X8pII=;
        h=Date:From:To:Cc:Subject:From;
        b=BN4E7T+hu6CCZRm7R9SG4nemNkKSlVLBhCsdvARNrRgNF0LxYpd+zXJPrGYgFdtfx
         UHOdlHAhlNkDmVyfQcTArPDpJYh6KbWIvkPRr4cEQMTnzzB3XxHxzlP7q+XqLtMiuU
         5UwG+gyFY5eGfjxb4OzZH8bREfEsKrIN2RdnrZgc=
Date:   Thu, 15 Oct 2020 19:40:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


- most of the rest of mm/

- various other subsystems

156 patches, based on 578a7155c5a1894a789d4ece181abf9d25dc6b0d.

Subsystems affected by this patch series:

  mm/dax
  mm/debug
  mm/thp
  mm/readahead
  mm/page-poison
  mm/util
  mm/memory-hotplug
  mm/zram
  mm/cleanups
  misc
  core-kernel
  get_maintainer
  MAINTAINERS
  lib
  bitops
  checkpatch
  binfmt
  ramfs
  autofs
  nilfs
  rapidio
  panic
  relay
  kgdb
  ubsan
  romfs
  fault-injection

Subsystem: mm/dax

    Dan Williams <dan.j.williams@intel.com>:
      device-dax/kmem: fix resource release

Subsystem: mm/debug

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
    Patch series "mm/debug_vm_pgtable fixes", v4:
      powerpc/mm: add DEBUG_VM WARN for pmd_clear
      powerpc/mm: move setting pte specific flags to pfn_pte
      mm/debug_vm_pgtable/ppc64: avoid setting top bits in radom value
      mm/debug_vm_pgtables/hugevmap: use the arch helper to identify huge vmap support.
      mm/debug_vm_pgtable/savedwrite: enable savedwrite test with CONFIG_NUMA_BALANCING
      mm/debug_vm_pgtable/THP: mark the pte entry huge before using set_pmd/pud_at
      mm/debug_vm_pgtable/set_pte/pmd/pud: don't use set_*_at to update an existing pte entry
      mm/debug_vm_pgtable/locks: move non page table modifying test together
      mm/debug_vm_pgtable/locks: take correct page table lock
      mm/debug_vm_pgtable/thp: use page table depost/withdraw with THP
      mm/debug_vm_pgtable/pmd_clear: don't use pmd/pud_clear on pte entries
      mm/debug_vm_pgtable/hugetlb: disable hugetlb test on ppc64
      mm/debug_vm_pgtable: avoid none pte in pte_clear_test
      mm/debug_vm_pgtable: avoid doing memory allocation with pgtable_t mapped.

Subsystem: mm/thp

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Fix read-only THP for non-tmpfs filesystems":
      XArray: add xa_get_order
      XArray: add xas_split
      mm/filemap: fix storing to a THP shadow entry
    Patch series "Remove assumptions of THP size":
      mm/filemap: fix page cache removal for arbitrary sized THPs
      mm/memory: remove page fault assumption of compound page size
      mm/page_owner: change split_page_owner to take a count

    "Kirill A. Shutemov" <kirill@shutemov.name>:
      mm/huge_memory: fix total_mapcount assumption of page size
      mm/huge_memory: fix split assumption of page size

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/huge_memory: fix page_trans_huge_mapcount assumption of THP size
      mm/huge_memory: fix can_split_huge_page assumption of THP size
      mm/rmap: fix assumptions of THP size
      mm/truncate: fix truncation for pages of arbitrary size
      mm/page-writeback: support tail pages in wait_for_stable_page
      mm/vmscan: allow arbitrary sized pages to be paged out
      fs: add a filesystem flag for THPs
      fs: do not update nr_thps for mappings which support THPs

    Huang Ying <ying.huang@intel.com>:
      mm: fix a race during THP splitting

Subsystem: mm/readahead

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Readahead patches for 5.9/5.10":
      mm/readahead: add DEFINE_READAHEAD
      mm/readahead: make page_cache_ra_unbounded take a readahead_control
      mm/readahead: make do_page_cache_ra take a readahead_control

    David Howells <dhowells@redhat.com>:
      mm/readahead: make ondemand_readahead take a readahead_control
      mm/readahead: pass readahead_control to force_page_cache_ra

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/readahead: add page_cache_sync_ra and page_cache_async_ra

    David Howells <dhowells@redhat.com>:
      mm/filemap: fold ra_submit into do_sync_mmap_readahead
      mm/readahead: pass a file_ra_state into force_page_cache_ra

Subsystem: mm/page-poison

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
    Patch series "HWPOISON: soft offline rework", v7:
      mm,hwpoison: cleanup unused PageHuge() check
      mm, hwpoison: remove recalculating hpage
      mm,hwpoison-inject: don't pin for hwpoison_filter

    Oscar Salvador <osalvador@suse.de>:
      mm,hwpoison: unexport get_hwpoison_page and make it static
      mm,hwpoison: refactor madvise_inject_error
      mm,hwpoison: kill put_hwpoison_page
      mm,hwpoison: unify THP handling for hard and soft offline
      mm,hwpoison: rework soft offline for free pages
      mm,hwpoison: rework soft offline for in-use pages
      mm,hwpoison: refactor soft_offline_huge_page and __soft_offline_page
      mm,hwpoison: return 0 if the page is already poisoned in soft-offline

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm,hwpoison: introduce MF_MSG_UNSPLIT_THP
      mm,hwpoison: double-check page count in __get_any_page()

    Oscar Salvador <osalvador@suse.de>:
      mm,hwpoison: try to narrow window race for free pages

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/page_poison.c: replace bool variable with static key

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/vmstat.c: use helper macro abs()

Subsystem: mm/util

    Bartosz Golaszewski <bgolaszewski@baylibre.com>:
      mm/util.c: update the kerneldoc for kstrdup_const()

    Jann Horn <jannh@google.com>:
      mm/mmu_notifier: fix mmget() assert in __mmu_interval_notifier_insert

Subsystem: mm/memory-hotplug

    David Hildenbrand <david@redhat.com>:
    Patch series "mm/memory_hotplug: online_pages()/offline_pages() cleanups", v2:
      mm/memory_hotplug: inline __offline_pages() into offline_pages()
      mm/memory_hotplug: enforce section granularity when onlining/offlining
      mm/memory_hotplug: simplify page offlining
      mm/page_alloc: simplify __offline_isolated_pages()
      mm/memory_hotplug: drop nr_isolate_pageblock in offline_pages()
      mm/page_isolation: simplify return value of start_isolate_page_range()
      mm/memory_hotplug: simplify page onlining
      mm/page_alloc: drop stale pageblock comment in memmap_init_zone*()
      mm: pass migratetype into memmap_init_zone() and move_pfn_range_to_zone()
      mm/memory_hotplug: mark pageblocks MIGRATE_ISOLATE while onlining memory
    Patch series "selective merging of system ram resources", v4:
      kernel/resource: make release_mem_region_adjustable() never fail
      kernel/resource: move and rename IORESOURCE_MEM_DRIVER_MANAGED
      mm/memory_hotplug: guard more declarations by CONFIG_MEMORY_HOTPLUG
      mm/memory_hotplug: prepare passing flags to add_memory() and friends
      mm/memory_hotplug: MEMHP_MERGE_RESOURCE to specify merging of System RAM resources
      virtio-mem: try to merge system ram resources
      xen/balloon: try to merge system ram resources
      hv_balloon: try to merge system ram resources
      kernel/resource: make iomem_resource implicit in release_mem_region_adjustable()

    Laurent Dufour <ldufour@linux.ibm.com>:
      mm: don't panic when links can't be created in sysfs

    David Hildenbrand <david@redhat.com>:
    Patch series "mm: place pages to the freelist tail when onlining and undoing isolation", v2:
      mm/page_alloc: convert "report" flag of __free_one_page() to a proper flag
      mm/page_alloc: place pages to tail in __putback_isolated_page()
      mm/page_alloc: move pages to tail in move_to_free_list()
      mm/page_alloc: place pages to tail in __free_pages_core()
      mm/memory_hotplug: update comment regarding zone shuffling

Subsystem: mm/zram

    Douglas Anderson <dianders@chromium.org>:
      zram: failing to decompress is WARN_ON worthy

Subsystem: mm/cleanups

    YueHaibing <yuehaibing@huawei.com>:
      mm/slab.h: remove duplicate include

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      mm/page_reporting.c: drop stale list head check in page_reporting_cycle

    Ira Weiny <ira.weiny@intel.com>:
      mm/highmem.c: clean up endif comments

    Yu Zhao <yuzhao@google.com>:
      mm: use self-explanatory macros rather than "2"

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: fix some broken comments

    Chen Tao <chentao3@hotmail.com>:
      mm: fix some comments formatting

    Xiaofei Tan <tanxiaofei@huawei.com>:
      mm/workingset.c: fix some doc warnings

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: use helper function put_write_access()

    Mike Rapoport <rppt@linux.ibm.com>:
      include/linux/mmzone.h: remove unused early_pfn_valid()

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: rename page_order() to buddy_order()

Subsystem: misc

    Randy Dunlap <rdunlap@infradead.org>:
      fs: configfs: delete repeated words in comments

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      kernel.h: split out min()/max() et al. helpers

Subsystem: core-kernel

    Liao Pingfang <liao.pingfang@zte.com.cn>:
      kernel/sys.c: replace do_brk with do_brk_flags in comment of prctl_set_mm_map()

    Randy Dunlap <rdunlap@infradead.org>:
      kernel/: fix repeated words in comments
      kernel: acct.c: fix some kernel-doc nits

Subsystem: get_maintainer

    Joe Perches <joe@perches.com>:
      get_maintainer: add test for file in VCS

Subsystem: MAINTAINERS

    Joe Perches <joe@perches.com>:
      get_maintainer: exclude MAINTAINERS file(s) from --git-fallback

    Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>:
      MAINTAINERS: jarkko.sakkinen@linux.intel.com -> jarkko@kernel.org

Subsystem: lib

    Randy Dunlap <rdunlap@infradead.org>:
      lib: bitmap: delete duplicated words
      lib: libcrc32c: delete duplicated words
      lib: decompress_bunzip2: delete duplicated words
      lib: dynamic_queue_limits: delete duplicated words + fix typo
      lib: earlycpio: delete duplicated words
      lib: radix-tree: delete duplicated words
      lib: syscall: delete duplicated words
      lib: test_sysctl: delete duplicated words
      lib/mpi/mpi-bit.c: fix spello of "functions"

    Stephen Boyd <swboyd@chromium.org>:
      lib/idr.c: document calling context for IDA APIs mustn't use locks
      lib/idr.c: document that ida_simple_{get,remove}() are deprecated

    Christophe JAILLET <christophe.jaillet@wanadoo.fr>:
      lib/scatterlist.c: avoid a double memset

    Miaohe Lin <linmiaohe@huawei.com>:
      lib/percpu_counter.c: use helper macro abs()

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      include/linux/list.h: add a macro to test if entry is pointing to the head

    Dan Carpenter <dan.carpenter@oracle.com>:
      lib/test_hmm.c: fix an error code in dmirror_allocate_chunk()

    Tobias Jordan <kernel@cdqe.de>:
      lib/crc32.c: fix trivial typo in preprocessor condition

Subsystem: bitops

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      bitops: simplify get_count_order_long()
      bitops: use the same mechanism for get_count_order[_long]

Subsystem: checkpatch

    Jerome Forissier <jerome@forissier.org>:
      checkpatch: add --kconfig-prefix

    Joe Perches <joe@perches.com>:
      checkpatch: move repeated word test
      checkpatch: add test for comma use that should be semicolon

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      const_structs.checkpatch: add phy_ops

    Nicolas Boichat <drinkcat@chromium.org>:
      checkpatch: warn if trace_printk and friends are called

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      const_structs.checkpatch: add pinctrl_ops and pinmux_ops

    Joe Perches <joe@perches.com>:
      checkpatch: warn on self-assignments
      checkpatch: allow not using -f with files that are in git

    Dwaipayan Ray <dwaipayanray1@gmail.com>:
      checkpatch: extend author Signed-off-by check for split From: header

    Joe Perches <joe@perches.com>:
      checkpatch: emit a warning on embedded filenames

    Dwaipayan Ray <dwaipayanray1@gmail.com>:
      checkpatch: fix multi-statement macro checks for while blocks.

    Łukasz Stelmach <l.stelmach@samsung.com>:
      checkpatch: fix false positive on empty block comment lines

    Dwaipayan Ray <dwaipayanray1@gmail.com>:
      checkpatch: add new warnings to author signoff checks.

Subsystem: binfmt

    Chris Kennelly <ckennelly@google.com>:
    Patch series "Selecting Load Addresses According to p_align", v3:
      fs/binfmt_elf: use PT_LOAD p_align values for suitable start address
      tools/testing/selftests: add self-test for verifying load alignment

    Jann Horn <jannh@google.com>:
    Patch series "Fix ELF / FDPIC ELF core dumping, and use mmap_lock properly in there", v5:
      binfmt_elf_fdpic: stop using dump_emit() on user pointers on !MMU
      coredump: let dump_emit() bail out on short writes
      coredump: refactor page range dumping into common helper
      coredump: rework elf/elf_fdpic vma_dump_size() into common helper
      binfmt_elf, binfmt_elf_fdpic: use a VMA list snapshot
      mm/gup: take mmap_lock in get_dump_page()
      mm: remove the now-unnecessary mmget_still_valid() hack

Subsystem: ramfs

    Matthew Wilcox (Oracle) <willy@infradead.org>:
      ramfs: fix nommu mmap with gaps in the page cache

Subsystem: autofs

    Matthew Wilcox <willy@infradead.org>:
      autofs: harden ioctl table

Subsystem: nilfs

    Wang Hai <wanghai38@huawei.com>:
      nilfs2: fix some kernel-doc warnings for nilfs2

Subsystem: rapidio

    Souptick Joarder <jrdr.linux@gmail.com>:
      rapidio: fix error handling path

    Jing Xiangfeng <jingxiangfeng@huawei.com>:
      rapidio: fix the missed put_device() for rio_mport_add_riodev

Subsystem: panic

    Alexey Kardashevskiy <aik@ozlabs.ru>:
      panic: dump registers on panic_on_warn

Subsystem: relay

    Sudip Mukherjee <sudipm.mukherjee@gmail.com>:
      kernel/relay.c: drop unneeded initialization

Subsystem: kgdb

    Ritesh Harjani <riteshh@linux.ibm.com>:
      scripts/gdb/proc: add struct mount & struct super_block addr in lx-mounts command
      scripts/gdb/tasks: add headers and improve spacing format

Subsystem: ubsan

    Elena Petrova <lenaptr@google.com>:
      sched.h: drop in_ubsan field when UBSAN is in trap mode

    George Popescu <georgepope@android.com>:
      ubsan: introduce CONFIG_UBSAN_LOCAL_BOUNDS for Clang

Subsystem: romfs

    Libing Zhou <libing.zhou@nokia-sbell.com>:
      ROMFS: support inode blocks calculation

Subsystem: fault-injection

    Albert van der Linde <alinde@google.com>:
    Patch series "add fault injection to user memory access", v3:
      lib, include/linux: add usercopy failure capability
      lib, uaccess: add failure injection to usercopy functions

 .mailmap                                          |    1 
 Documentation/admin-guide/kernel-parameters.txt   |    1 
 Documentation/core-api/xarray.rst                 |   14 
 Documentation/fault-injection/fault-injection.rst |    7 
 MAINTAINERS                                       |    6 
 arch/ia64/mm/init.c                               |    4 
 arch/powerpc/include/asm/book3s/64/pgtable.h      |   29 +
 arch/powerpc/include/asm/nohash/pgtable.h         |    5 
 arch/powerpc/mm/pgtable.c                         |    5 
 arch/powerpc/platforms/powernv/memtrace.c         |    2 
 arch/powerpc/platforms/pseries/hotplug-memory.c   |    2 
 drivers/acpi/acpi_memhotplug.c                    |    3 
 drivers/base/memory.c                             |    3 
 drivers/base/node.c                               |   33 +-
 drivers/block/zram/zram_drv.c                     |    2 
 drivers/dax/kmem.c                                |   50 ++-
 drivers/hv/hv_balloon.c                           |    4 
 drivers/infiniband/core/uverbs_main.c             |    3 
 drivers/rapidio/devices/rio_mport_cdev.c          |   18 -
 drivers/s390/char/sclp_cmd.c                      |    2 
 drivers/vfio/pci/vfio_pci.c                       |   38 +-
 drivers/virtio/virtio_mem.c                       |    5 
 drivers/xen/balloon.c                             |    4 
 fs/autofs/dev-ioctl.c                             |    8 
 fs/binfmt_elf.c                                   |  267 +++-------------
 fs/binfmt_elf_fdpic.c                             |  176 ++--------
 fs/configfs/dir.c                                 |    2 
 fs/configfs/file.c                                |    2 
 fs/coredump.c                                     |  238 +++++++++++++-
 fs/ext4/verity.c                                  |    4 
 fs/f2fs/verity.c                                  |    4 
 fs/inode.c                                        |    2 
 fs/nilfs2/bmap.c                                  |    2 
 fs/nilfs2/cpfile.c                                |    6 
 fs/nilfs2/page.c                                  |    1 
 fs/nilfs2/sufile.c                                |    4 
 fs/proc/task_mmu.c                                |   18 -
 fs/ramfs/file-nommu.c                             |    2 
 fs/romfs/super.c                                  |    1 
 fs/userfaultfd.c                                  |   28 -
 include/linux/bitops.h                            |   13 
 include/linux/blkdev.h                            |    1 
 include/linux/bvec.h                              |    6 
 include/linux/coredump.h                          |   13 
 include/linux/fault-inject-usercopy.h             |   22 +
 include/linux/fs.h                                |   28 -
 include/linux/idr.h                               |   13 
 include/linux/ioport.h                            |   15 
 include/linux/jiffies.h                           |    3 
 include/linux/kernel.h                            |  150 ---------
 include/linux/list.h                              |   29 +
 include/linux/memory_hotplug.h                    |   42 +-
 include/linux/minmax.h                            |  153 +++++++++
 include/linux/mm.h                                |    5 
 include/linux/mmzone.h                            |   17 -
 include/linux/node.h                              |   16 
 include/linux/nodemask.h                          |    2 
 include/linux/page-flags.h                        |    6 
 include/linux/page_owner.h                        |    6 
 include/linux/pagemap.h                           |  111 ++++++
 include/linux/sched.h                             |    2 
 include/linux/sched/mm.h                          |   25 -
 include/linux/uaccess.h                           |   12 
 include/linux/vmstat.h                            |    2 
 include/linux/xarray.h                            |   22 +
 include/ras/ras_event.h                           |    3 
 kernel/acct.c                                     |   10 
 kernel/cgroup/cpuset.c                            |    2 
 kernel/dma/direct.c                               |    2 
 kernel/fork.c                                     |    4 
 kernel/futex.c                                    |    2 
 kernel/irq/timings.c                              |    2 
 kernel/jump_label.c                               |    2 
 kernel/kcsan/encoding.h                           |    2 
 kernel/kexec_core.c                               |    2 
 kernel/kexec_file.c                               |    2 
 kernel/kthread.c                                  |    2 
 kernel/livepatch/state.c                          |    2 
 kernel/panic.c                                    |   12 
 kernel/pid_namespace.c                            |    2 
 kernel/power/snapshot.c                           |    2 
 kernel/range.c                                    |    3 
 kernel/relay.c                                    |    2 
 kernel/resource.c                                 |  114 +++++--
 kernel/smp.c                                      |    2 
 kernel/sys.c                                      |    2 
 kernel/user_namespace.c                           |    2 
 lib/Kconfig.debug                                 |    7 
 lib/Kconfig.ubsan                                 |   14 
 lib/Makefile                                      |    1 
 lib/bitmap.c                                      |    2 
 lib/crc32.c                                       |    2 
 lib/decompress_bunzip2.c                          |    2 
 lib/dynamic_queue_limits.c                        |    4 
 lib/earlycpio.c                                   |    2 
 lib/fault-inject-usercopy.c                       |   39 ++
 lib/find_bit.c                                    |    1 
 lib/hexdump.c                                     |    1 
 lib/idr.c                                         |    9 
 lib/iov_iter.c                                    |    5 
 lib/libcrc32c.c                                   |    2 
 lib/math/rational.c                               |    2 
 lib/math/reciprocal_div.c                         |    1 
 lib/mpi/mpi-bit.c                                 |    2 
 lib/percpu_counter.c                              |    2 
 lib/radix-tree.c                                  |    2 
 lib/scatterlist.c                                 |    2 
 lib/strncpy_from_user.c                           |    3 
 lib/syscall.c                                     |    2 
 lib/test_hmm.c                                    |    2 
 lib/test_sysctl.c                                 |    2 
 lib/test_xarray.c                                 |   65 ++++
 lib/usercopy.c                                    |    5 
 lib/xarray.c                                      |  208 ++++++++++++
 mm/Kconfig                                        |    2 
 mm/compaction.c                                   |    6 
 mm/debug_vm_pgtable.c                             |  267 ++++++++--------
 mm/filemap.c                                      |   58 ++-
 mm/gup.c                                          |   73 ++--
 mm/highmem.c                                      |    4 
 mm/huge_memory.c                                  |   47 +-
 mm/hwpoison-inject.c                              |   18 -
 mm/internal.h                                     |   47 +-
 mm/khugepaged.c                                   |    2 
 mm/madvise.c                                      |   52 ---
 mm/memory-failure.c                               |  357 ++++++++++------------
 mm/memory.c                                       |    7 
 mm/memory_hotplug.c                               |  223 +++++--------
 mm/memremap.c                                     |    3 
 mm/migrate.c                                      |   11 
 mm/mmap.c                                         |    7 
 mm/mmu_notifier.c                                 |    2 
 mm/page-writeback.c                               |    1 
 mm/page_alloc.c                                   |  289 +++++++++++------
 mm/page_isolation.c                               |   16 
 mm/page_owner.c                                   |   10 
 mm/page_poison.c                                  |   20 -
 mm/page_reporting.c                               |    4 
 mm/readahead.c                                    |  174 ++++------
 mm/rmap.c                                         |   10 
 mm/shmem.c                                        |    2 
 mm/shuffle.c                                      |    2 
 mm/slab.c                                         |    2 
 mm/slab.h                                         |    1 
 mm/slub.c                                         |    2 
 mm/sparse.c                                       |    2 
 mm/swap_state.c                                   |    2 
 mm/truncate.c                                     |    6 
 mm/util.c                                         |    3 
 mm/vmscan.c                                       |    5 
 mm/vmstat.c                                       |    8 
 mm/workingset.c                                   |    2 
 scripts/Makefile.ubsan                            |   10 
 scripts/checkpatch.pl                             |  238 ++++++++++----
 scripts/const_structs.checkpatch                  |    3 
 scripts/gdb/linux/proc.py                         |   15 
 scripts/gdb/linux/tasks.py                        |    9 
 scripts/get_maintainer.pl                         |    9 
 tools/testing/selftests/exec/.gitignore           |    1 
 tools/testing/selftests/exec/Makefile             |    9 
 tools/testing/selftests/exec/load_address.c       |   68 ++++
 161 files changed, 2532 insertions(+), 1864 deletions(-)

