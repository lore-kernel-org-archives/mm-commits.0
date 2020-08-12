Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CA3C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A9C82076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195793;
	bh=IZ5G15QMj1opIJMsybSwsGB4ZgOfifQhdx1gFU5pSeY=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=kXkMyXeqI2xcMUDJ7R5hokblo48xlfWuTd/s5hDizYuRyWbTuSC4oXFLYQflX5k4L
	 0ShMRUFPjbuiUt3V0quSnYsIgI7vo05bkuIp1BOC4WP6whX5dAVOCBHxqUpe+3Clwm
	 QdDt+R6nk/OqLlr8akx2PqdfcNMU13xd3kDjHtH8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHLB3x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLB3w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:29:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F6002076C;
        Wed, 12 Aug 2020 01:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195790;
        bh=IZ5G15QMj1opIJMsybSwsGB4ZgOfifQhdx1gFU5pSeY=;
        h=Date:From:To:Cc:Subject:From;
        b=FlWssHr8fV+KrG12OJ6EojP9hlZHlJfxwJXYSOCDC0qaWgwdqvXX5ew4XYl8WaETj
         cvJUJkmwhRWUitWpZUl7wKULoybXv1T0SLDbAYJcoAaP5j+KoCK+SSgPDP8opZTUWl
         dD25oxWx98uSjXydshsZJnMw7+Pa90X4BsuJKBwc=
Date:   Tue, 11 Aug 2020 18:29:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


- Most of the rest of MM

- various other subsystems


165 patches, based on 00e4db51259a5f936fec1424b884f029479d3981.

Subsystems affected by this patch series:

  mm/memcg
  mm/hugetlb
  mm/vmscan
  mm/proc
  mm/compaction
  mm/mempolicy
  mm/oom-kill
  mm/hugetlbfs
  mm/migration
  mm/thp
  mm/cma
  mm/util
  mm/memory-hotplug
  mm/cleanups
  mm/uaccess
  alpha
  misc
  sparse
  bitmap
  lib
  lz4
  bitops
  checkpatch
  autofs
  minix
  nilfs
  ufs
  fat
  signals
  kmod
  coredump
  exec
  kdump
  rapidio
  panic
  kcov
  kgdb
  ipc
  mm/migration
  mm/gup
  mm/pagemap

Subsystem: mm/memcg

    Roman Gushchin <guro@fb.com>:
    Patch series "mm: memcg accounting of percpu memory", v3:
      percpu: return number of released bytes from pcpu_free_area()
      mm: memcg/percpu: account percpu memory to memory cgroups
      mm: memcg/percpu: per-memcg percpu memory statistics
      mm: memcg: charge memcg percpu memory to the parent cgroup
      kselftests: cgroup: add perpcu memory accounting test

Subsystem: mm/hugetlb

    Muchun Song <songmuchun@bytedance.com>:
      mm/hugetlb: add mempolicy check in the reservation routine

Subsystem: mm/vmscan

    Joonsoo Kim <iamjoonsoo.kim@lge.com>:
    Patch series "workingset protection/detection on the anonymous LRU list=
", v7:
      mm/vmscan: make active/inactive ratio as 1:1 for anon lru
      mm/vmscan: protect the workingset on anonymous LRU
      mm/workingset: prepare the workingset detection infrastructure for an=
on LRU
      mm/swapcache: support to handle the shadow entries
      mm/swap: implement workingset detection for anonymous LRU
      mm/vmscan: restore active/inactive ratio for anonymous LRU

Subsystem: mm/proc

    Michal Koutn=FD <mkoutny@suse.com>:
      /proc/PID/smaps: consistent whitespace output format

Subsystem: mm/compaction

    Nitin Gupta <nigupta@nvidia.com>:
      mm: proactive compaction
      mm: fix compile error due to COMPACTION_HPAGE_ORDER
      mm: use unsigned types for fragmentation score

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/compaction: correct the comments of compact_defer_shift

Subsystem: mm/mempolicy

    Krzysztof Kozlowski <krzk@kernel.org>:
      mm: mempolicy: fix kerneldoc of numa_map_to_online_node()

    Wenchao Hao <haowenchao22@gmail.com>:
      mm/mempolicy.c: check parameters first in kernel_get_mempolicy

    Yanfei Xu <yanfei.xu@windriver.com>:
      include/linux/mempolicy.h: fix typo

Subsystem: mm/oom-kill

    Yafang Shao <laoar.shao@gmail.com>:
      mm, oom: make the calculation of oom badness more accurate

    Michal Hocko <mhocko@suse.com>:
      doc, mm: sync up oom_score_adj documentation
      doc, mm: clarify /proc/<pid>/oom_score value range

    Yafang Shao <laoar.shao@gmail.com>:
      mm, oom: show process exiting information in __oom_kill_process()

Subsystem: mm/hugetlbfs

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlbfs: prevent filesystem stacking of hugetlbfs
      hugetlbfs: remove call to huge_pte_alloc without i_mmap_rwsem

Subsystem: mm/migration

    Ralph Campbell <rcampbell@nvidia.com>:
    Patch series "mm/migrate: optimize migrate_vma_setup() for holes":
      mm/migrate: optimize migrate_vma_setup() for holes
      mm/migrate: add migrate-shared test for migrate_vma_*()

Subsystem: mm/thp

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm: thp: remove debug_cow switch

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/vmstat: add events for THP migration without split

Subsystem: mm/cma

    Jianqun Xu <jay.xu@rock-chips.com>:
      mm/cma.c: fix NULL pointer dereference when cma could not be activated

    Barry Song <song.bao.hua@hisilicon.com>:
    Patch series "mm: fix the names of general cma and hugetlb cma", v2:
      mm: cma: fix the name of CMA areas
      mm: hugetlb: fix the name of hugetlb CMA

    Mike Kravetz <mike.kravetz@oracle.com>:
      cma: don't quit at first error when activating reserved areas

Subsystem: mm/util

    Waiman Long <longman@redhat.com>:
      include/linux/sched/mm.h: optimize current_gfp_context()

    Krzysztof Kozlowski <krzk@kernel.org>:
      mm: mmu_notifier: fix and extend kerneldoc

Subsystem: mm/memory-hotplug

    Daniel Jordan <daniel.m.jordan@oracle.com>:
      x86/mm: use max memory block size on bare metal

    Jia He <justin.he@arm.com>:
      mm/memory_hotplug: introduce default dummy memory_add_physaddr_to_nid=
()
      mm/memory_hotplug: fix unpaired mem_hotplug_begin/done

    Charan Teja Reddy <charante@codeaurora.org>:
      mm, memory_hotplug: update pcp lists everytime onlining a memory block

Subsystem: mm/cleanups

    Randy Dunlap <rdunlap@infradead.org>:
      mm: drop duplicated words in <linux/pgtable.h>
      mm: drop duplicated words in <linux/mm.h>
      include/linux/highmem.h: fix duplicated words in a comment
      include/linux/frontswap.h:  drop duplicated word in a comment
      include/linux/memcontrol.h: drop duplicate word and fix spello

    Arvind Sankar <nivedita@alum.mit.edu>:
      sh/mm: drop unused MAX_PHYSADDR_BITS
      sparc: drop unused MAX_PHYSADDR_BITS

    Randy Dunlap <rdunlap@infradead.org>:
      mm/compaction.c: delete duplicated word
      mm/filemap.c: delete duplicated word
      mm/hmm.c: delete duplicated word
      mm/hugetlb.c: delete duplicated words
      mm/memcontrol.c: delete duplicated words
      mm/memory.c: delete duplicated words
      mm/migrate.c: delete duplicated word
      mm/nommu.c: delete duplicated words
      mm/page_alloc.c: delete or fix duplicated words
      mm/shmem.c: delete duplicated word
      mm/slab_common.c: delete duplicated word
      mm/usercopy.c: delete duplicated word
      mm/vmscan.c: delete or fix duplicated words
      mm/zpool.c: delete duplicated word and fix grammar
      mm/zsmalloc.c: fix duplicated words

Subsystem: mm/uaccess

    Christoph Hellwig <hch@lst.de>:
    Patch series "clean up address limit helpers", v2:
      syscalls: use uaccess_kernel in addr_limit_user_check
      nds32: use uaccess_kernel in show_regs
      riscv: include <asm/pgtable.h> in <asm/uaccess.h>
      uaccess: remove segment_eq
      uaccess: add force_uaccess_{begin,end} helpers
      exec: use force_uaccess_begin during exec and exit

Subsystem: alpha

    Luc Van Oostenryck <luc.vanoostenryck@gmail.com>:
      alpha: fix annotation of io{read,write}{16,32}be()

Subsystem: misc

    Randy Dunlap <rdunlap@infradead.org>:
      include/linux/compiler-clang.h: drop duplicated word in a comment
      include/linux/exportfs.h: drop duplicated word in a comment
      include/linux/async_tx.h: drop duplicated word in a comment
      include/linux/xz.h: drop duplicated word

    Christoph Hellwig <hch@lst.de>:
      kernel: add a kernel_wait helper

    Feng Tang <feng.tang@intel.com>:
      ./Makefile: add debug option to enable function aligned on 32 bytes

    Arvind Sankar <nivedita@alum.mit.edu>:
      kernel.h: remove duplicate include of asm/div64.h

    "Alexander A. Klimov" <grandmaster@al2klimov.de>:
      include/: replace HTTP links with HTTPS ones

    Matthew Wilcox <willy@infradead.org>:
      include/linux/poison.h: remove obsolete comment

Subsystem: sparse

    Luc Van Oostenryck <luc.vanoostenryck@gmail.com>:
      sparse: group the defines by functionality

Subsystem: bitmap

    Stefano Brivio <sbrivio@redhat.com>:
    Patch series "lib: Fix bitmap_cut() for overlaps, add test":
      lib/bitmap.c: fix bitmap_cut() for partial overlapping case
      lib/test_bitmap.c: add test for bitmap_cut()

Subsystem: lib

    Luc Van Oostenryck <luc.vanoostenryck@gmail.com>:
      lib/generic-radix-tree.c: remove unneeded __rcu

    Geert Uytterhoeven <geert@linux-m68k.org>:
      lib/test_bitops: do the full test during module init

    Wei Yongjun <weiyongjun1@huawei.com>:
      lib/test_lockup.c: make symbol 'test_works' static

    Tiezhu Yang <yangtiezhu@loongson.cn>:
      lib/Kconfig.debug: make TEST_LOCKUP depend on module
      lib/test_lockup.c: fix return value of test_lockup_init()

    "Alexander A. Klimov" <grandmaster@al2klimov.de>:
      lib/: replace HTTP links with HTTPS ones

    "Kars Mulder" <kerneldev@karsmulder.nl>:
      kstrto*: correct documentation references to simple_strto*()
      kstrto*: do not describe simple_strto*() as obsolete/replaced

Subsystem: lz4

    Nick Terrell <terrelln@fb.com>:
      lz4: fix kernel decompression speed

Subsystem: bitops

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      lib/test_bits.c: add tests of GENMASK

Subsystem: checkpatch

    Joe Perches <joe@perches.com>:
      checkpatch: add test for possible misuse of IS_ENABLED() without CONF=
IG_
      checkpatch: add --fix option for ASSIGN_IN_IF

    Quentin Monnet <quentin@isovalent.com>:
      checkpatch: fix CONST_STRUCT when const_structs.checkpatch is missing

    Joe Perches <joe@perches.com>:
      checkpatch: add test for repeated words
      checkpatch: remove missing switch/case break test

Subsystem: autofs

    Randy Dunlap <rdunlap@infradead.org>:
      autofs: fix doubled word

Subsystem: minix

    Eric Biggers <ebiggers@google.com>:
    Patch series "fs/minix: fix syzbot bugs and set s_maxbytes":
      fs/minix: check return value of sb_getblk()
      fs/minix: don't allow getting deleted inodes
      fs/minix: reject too-large maximum file size
      fs/minix: set s_maxbytes correctly
      fs/minix: fix block limit check for V1 filesystems
      fs/minix: remove expected error message in block_to_path()

Subsystem: nilfs

    Eric Biggers <ebiggers@google.com>:
    Patch series "nilfs2 updates":
      nilfs2: only call unlock_new_inode() if I_NEW

    Joe Perches <joe@perches.com>:
      nilfs2: convert __nilfs_msg to integrate the level and format
      nilfs2: use a more common logging style

Subsystem: ufs

    Colin Ian King <colin.king@canonical.com>:
      fs/ufs: avoid potential u32 multiplication overflow

Subsystem: fat

    Yubo Feng <fengyubo3@huawei.com>:
      fatfs: switch write_lock to read_lock in fat_ioctl_get_attributes

    "Alexander A. Klimov" <grandmaster@al2klimov.de>:
      VFAT/FAT/MSDOS FILESYSTEM: replace HTTP links with HTTPS ones

    OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
      fat: fix fat_ra_init() for data clusters =3D=3D 0

Subsystem: signals

    Helge Deller <deller@gmx.de>:
      fs/signalfd.c: fix inconsistent return codes for signalfd4

Subsystem: kmod

    Tiezhu Yang <yangtiezhu@loongson.cn>:
    Patch series "kmod/umh: a few fixes":
      selftests: kmod: use variable NAME in kmod_test_0001()
      kmod: remove redundant "be an" in the comment
      test_kmod: avoid potential double free in trigger_config_run_type()

Subsystem: coredump

    Lepton Wu <ytht.net@gmail.com>:
      coredump: add %f for executable filename

Subsystem: exec

    Kees Cook <keescook@chromium.org>:
    Patch series "Relocate execve() sanity checks", v2:
      exec: change uselib(2) IS_SREG() failure to EACCES
      exec: move S_ISREG() check earlier
      exec: move path_noexec() check earlier

Subsystem: kdump

    Vijay Balakrishna <vijayb@linux.microsoft.com>:
      kdump: append kernel build-id string to VMCOREINFO

Subsystem: rapidio

    "Gustavo A. R. Silva" <gustavoars@kernel.org>:
      drivers/rapidio/devices/rio_mport_cdev.c: use struct_size() helper
      drivers/rapidio/rio-scan.c: use struct_size() helper
      rapidio/rio_mport_cdev: use array_size() helper in copy_{from,to}_use=
r()

Subsystem: panic

    Tiezhu Yang <yangtiezhu@loongson.cn>:
      kernel/panic.c: make oops_may_print() return bool
      lib/Kconfig.debug: fix typo in the help text of CONFIG_PANIC_TIMEOUT

    Yue Hu <huyue2@yulong.com>:
      panic: make print_oops_end_marker() static

Subsystem: kcov

    Marco Elver <elver@google.com>:
      kcov: unconditionally add -fno-stack-protector to compiler options

    Wei Yongjun <weiyongjun1@huawei.com>:
      kcov: make some symbols static

Subsystem: kgdb

    Nick Desaulniers <ndesaulniers@google.com>:
      scripts/gdb: fix python 3.8 SyntaxWarning

Subsystem: ipc

    Alexey Dobriyan <adobriyan@gmail.com>:
      ipc: uninline functions

    Liao Pingfang <liao.pingfang@zte.com.cn>:
      ipc/shm.c: remove the superfluous break

Subsystem: mm/migration

    Joonsoo Kim <iamjoonsoo.kim@lge.com>:
    Patch series "clean-up the migration target allocation functions", v5:
      mm/page_isolation: prefer the node of the source page
      mm/migrate: move migration helper from .h to .c
      mm/hugetlb: unify migration callbacks
      mm/migrate: clear __GFP_RECLAIM to make the migration callback consis=
tent with regular THP allocations
      mm/migrate: introduce a standard migration target allocation function
      mm/mempolicy: use a standard migration target allocation callback
      mm/page_alloc: remove a wrapper for alloc_migration_target()

Subsystem: mm/gup

    Joonsoo Kim <iamjoonsoo.kim@lge.com>:
      mm/gup: restrict CMA region by using allocation scope API
      mm/hugetlb: make hugetlb migration callback CMA aware
      mm/gup: use a standard migration target allocation callback

Subsystem: mm/pagemap

    Peter Xu <peterx@redhat.com>:
    Patch series "mm: Page fault accounting cleanups", v5:
      mm: do page fault accounting in handle_mm_fault
      mm/alpha: use general page fault accounting
      mm/arc: use general page fault accounting
      mm/arm: use general page fault accounting
      mm/arm64: use general page fault accounting
      mm/csky: use general page fault accounting
      mm/hexagon: use general page fault accounting
      mm/ia64: use general page fault accounting
      mm/m68k: use general page fault accounting
      mm/microblaze: use general page fault accounting
      mm/mips: use general page fault accounting
      mm/nds32: use general page fault accounting
      mm/nios2: use general page fault accounting
      mm/openrisc: use general page fault accounting
      mm/parisc: use general page fault accounting
      mm/powerpc: use general page fault accounting
      mm/riscv: use general page fault accounting
      mm/s390: use general page fault accounting
      mm/sh: use general page fault accounting
      mm/sparc32: use general page fault accounting
      mm/sparc64: use general page fault accounting
      mm/x86: use general page fault accounting
      mm/xtensa: use general page fault accounting
      mm: clean up the last pieces of page fault accountings
      mm/gup: remove task_struct pointer for all gup code

 Documentation/admin-guide/cgroup-v2.rst         |    4=20
 Documentation/admin-guide/sysctl/kernel.rst     |    3=20
 Documentation/admin-guide/sysctl/vm.rst         |   15 +
 Documentation/filesystems/proc.rst              |   11 -
 Documentation/vm/page_migration.rst             |   27 +++
 Makefile                                        |    4=20
 arch/alpha/include/asm/io.h                     |    8=20
 arch/alpha/include/asm/uaccess.h                |    2=20
 arch/alpha/mm/fault.c                           |   10 -
 arch/arc/include/asm/segment.h                  |    3=20
 arch/arc/kernel/process.c                       |    2=20
 arch/arc/mm/fault.c                             |   20 --
 arch/arm/include/asm/uaccess.h                  |    4=20
 arch/arm/kernel/signal.c                        |    2=20
 arch/arm/mm/fault.c                             |   27 ---
 arch/arm64/include/asm/uaccess.h                |    2=20
 arch/arm64/kernel/sdei.c                        |    2=20
 arch/arm64/mm/fault.c                           |   31 ---
 arch/arm64/mm/numa.c                            |   10 -
 arch/csky/include/asm/segment.h                 |    2=20
 arch/csky/mm/fault.c                            |   15 -
 arch/h8300/include/asm/segment.h                |    2=20
 arch/hexagon/mm/vm_fault.c                      |   11 -
 arch/ia64/include/asm/uaccess.h                 |    2=20
 arch/ia64/mm/fault.c                            |   11 -
 arch/ia64/mm/numa.c                             |    2=20
 arch/m68k/include/asm/segment.h                 |    2=20
 arch/m68k/include/asm/tlbflush.h                |    6=20
 arch/m68k/mm/fault.c                            |   16 -
 arch/microblaze/include/asm/uaccess.h           |    2=20
 arch/microblaze/mm/fault.c                      |   11 -
 arch/mips/include/asm/uaccess.h                 |    2=20
 arch/mips/kernel/unaligned.c                    |   27 +--
 arch/mips/mm/fault.c                            |   16 -
 arch/nds32/include/asm/uaccess.h                |    2=20
 arch/nds32/kernel/process.c                     |    2=20
 arch/nds32/mm/alignment.c                       |    7=20
 arch/nds32/mm/fault.c                           |   21 --
 arch/nios2/include/asm/uaccess.h                |    2=20
 arch/nios2/mm/fault.c                           |   16 -
 arch/openrisc/include/asm/uaccess.h             |    2=20
 arch/openrisc/mm/fault.c                        |   11 -
 arch/parisc/include/asm/uaccess.h               |    2=20
 arch/parisc/mm/fault.c                          |   10 -
 arch/powerpc/include/asm/uaccess.h              |    3=20
 arch/powerpc/mm/copro_fault.c                   |    7=20
 arch/powerpc/mm/fault.c                         |   13 -
 arch/riscv/include/asm/uaccess.h                |    6=20
 arch/riscv/mm/fault.c                           |   18 --
 arch/s390/include/asm/uaccess.h                 |    2=20
 arch/s390/kvm/interrupt.c                       |    2=20
 arch/s390/kvm/kvm-s390.c                        |    2=20
 arch/s390/kvm/priv.c                            |    8=20
 arch/s390/mm/fault.c                            |   18 --
 arch/s390/mm/gmap.c                             |    4=20
 arch/sh/include/asm/segment.h                   |    3=20
 arch/sh/include/asm/sparsemem.h                 |    4=20
 arch/sh/kernel/traps_32.c                       |   12 -
 arch/sh/mm/fault.c                              |   13 -
 arch/sh/mm/init.c                               |    9 -
 arch/sparc/include/asm/sparsemem.h              |    1=20
 arch/sparc/include/asm/uaccess_32.h             |    2=20
 arch/sparc/include/asm/uaccess_64.h             |    2=20
 arch/sparc/mm/fault_32.c                        |   15 -
 arch/sparc/mm/fault_64.c                        |   13 -
 arch/um/kernel/trap.c                           |    6=20
 arch/x86/include/asm/uaccess.h                  |    2=20
 arch/x86/mm/fault.c                             |   19 --
 arch/x86/mm/init_64.c                           |    9 +
 arch/x86/mm/numa.c                              |    1=20
 arch/xtensa/include/asm/uaccess.h               |    2=20
 arch/xtensa/mm/fault.c                          |   17 -
 drivers/firmware/arm_sdei.c                     |    5=20
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c     |    2=20
 drivers/infiniband/core/umem_odp.c              |    2=20
 drivers/iommu/amd/iommu_v2.c                    |    2=20
 drivers/iommu/intel/svm.c                       |    3=20
 drivers/rapidio/devices/rio_mport_cdev.c        |    7=20
 drivers/rapidio/rio-scan.c                      |    8=20
 drivers/vfio/vfio_iommu_type1.c                 |    4=20
 fs/coredump.c                                   |   17 +
 fs/exec.c                                       |   38 ++--
 fs/fat/Kconfig                                  |    2=20
 fs/fat/fatent.c                                 |    3=20
 fs/fat/file.c                                   |    4=20
 fs/hugetlbfs/inode.c                            |    6=20
 fs/minix/inode.c                                |   48 ++++-
 fs/minix/itree_common.c                         |    8=20
 fs/minix/itree_v1.c                             |   16 -
 fs/minix/itree_v2.c                             |   15 -
 fs/minix/minix.h                                |    1=20
 fs/namei.c                                      |   10 -
 fs/nilfs2/alloc.c                               |   38 ++--
 fs/nilfs2/btree.c                               |   42 ++--
 fs/nilfs2/cpfile.c                              |   10 -
 fs/nilfs2/dat.c                                 |   14 -
 fs/nilfs2/direct.c                              |   14 -
 fs/nilfs2/gcinode.c                             |    2=20
 fs/nilfs2/ifile.c                               |    4=20
 fs/nilfs2/inode.c                               |   32 +--
 fs/nilfs2/ioctl.c                               |   37 ++--
 fs/nilfs2/mdt.c                                 |    2=20
 fs/nilfs2/namei.c                               |    6=20
 fs/nilfs2/nilfs.h                               |   18 +-
 fs/nilfs2/page.c                                |   11 -
 fs/nilfs2/recovery.c                            |   32 +--
 fs/nilfs2/segbuf.c                              |    2=20
 fs/nilfs2/segment.c                             |   38 ++--
 fs/nilfs2/sufile.c                              |   29 +--
 fs/nilfs2/super.c                               |   73 ++++----
 fs/nilfs2/sysfs.c                               |   29 +--
 fs/nilfs2/the_nilfs.c                           |   85 ++++-----
 fs/open.c                                       |    6=20
 fs/proc/base.c                                  |   11 +
 fs/proc/task_mmu.c                              |    4=20
 fs/signalfd.c                                   |   10 -
 fs/ufs/super.c                                  |    2=20
 include/asm-generic/uaccess.h                   |    4=20
 include/clocksource/timer-ti-dm.h               |    2=20
 include/linux/async_tx.h                        |    2=20
 include/linux/btree.h                           |    2=20
 include/linux/compaction.h                      |    6=20
 include/linux/compiler-clang.h                  |    2=20
 include/linux/compiler_types.h                  |   44 ++---
 include/linux/crash_core.h                      |    6=20
 include/linux/delay.h                           |    2=20
 include/linux/dma/k3-psil.h                     |    2=20
 include/linux/dma/k3-udma-glue.h                |    2=20
 include/linux/dma/ti-cppi5.h                    |    2=20
 include/linux/exportfs.h                        |    2=20
 include/linux/frontswap.h                       |    2=20
 include/linux/fs.h                              |   10 +
 include/linux/generic-radix-tree.h              |    2=20
 include/linux/highmem.h                         |    2=20
 include/linux/huge_mm.h                         |    7=20
 include/linux/hugetlb.h                         |   53 ++++--
 include/linux/irqchip/irq-omap-intc.h           |    2=20
 include/linux/jhash.h                           |    2=20
 include/linux/kernel.h                          |   12 -
 include/linux/leds-ti-lmu-common.h              |    2=20
 include/linux/memcontrol.h                      |   12 +
 include/linux/mempolicy.h                       |   18 +-
 include/linux/migrate.h                         |   42 +---
 include/linux/mm.h                              |   20 +-
 include/linux/mmzone.h                          |   17 +
 include/linux/oom.h                             |    4=20
 include/linux/pgtable.h                         |   12 -
 include/linux/platform_data/davinci-cpufreq.h   |    2=20
 include/linux/platform_data/davinci_asp.h       |    2=20
 include/linux/platform_data/elm.h               |    2=20
 include/linux/platform_data/gpio-davinci.h      |    2=20
 include/linux/platform_data/gpmc-omap.h         |    2=20
 include/linux/platform_data/mtd-davinci-aemif.h |    2=20
 include/linux/platform_data/omap-twl4030.h      |    2=20
 include/linux/platform_data/uio_pruss.h         |    2=20
 include/linux/platform_data/usb-omap.h          |    2=20
 include/linux/poison.h                          |    4=20
 include/linux/sched/mm.h                        |    8=20
 include/linux/sched/task.h                      |    1=20
 include/linux/soc/ti/k3-ringacc.h               |    2=20
 include/linux/soc/ti/knav_qmss.h                |    2=20
 include/linux/soc/ti/ti-msgmgr.h                |    2=20
 include/linux/swap.h                            |   25 ++
 include/linux/syscalls.h                        |    2=20
 include/linux/uaccess.h                         |   20 ++
 include/linux/vm_event_item.h                   |    3=20
 include/linux/wkup_m3_ipc.h                     |    2=20
 include/linux/xxhash.h                          |    2=20
 include/linux/xz.h                              |    4=20
 include/linux/zlib.h                            |    2=20
 include/soc/arc/aux.h                           |    2=20
 include/trace/events/migrate.h                  |   17 +
 include/uapi/linux/auto_dev-ioctl.h             |    2=20
 include/uapi/linux/elf.h                        |    2=20
 include/uapi/linux/map_to_7segment.h            |    2=20
 include/uapi/linux/types.h                      |    2=20
 include/uapi/linux/usb/ch9.h                    |    2=20
 ipc/sem.c                                       |    3=20
 ipc/shm.c                                       |    4=20
 kernel/Makefile                                 |    2=20
 kernel/crash_core.c                             |   50 +++++
 kernel/events/callchain.c                       |    5=20
 kernel/events/core.c                            |    5=20
 kernel/events/uprobes.c                         |    8=20
 kernel/exit.c                                   |   18 +-
 kernel/futex.c                                  |    2=20
 kernel/kcov.c                                   |    6=20
 kernel/kmod.c                                   |    5=20
 kernel/kthread.c                                |    5=20
 kernel/panic.c                                  |    4=20
 kernel/stacktrace.c                             |    5=20
 kernel/sysctl.c                                 |   11 +
 kernel/umh.c                                    |   29 ---
 lib/Kconfig.debug                               |   27 ++-
 lib/Makefile                                    |    1=20
 lib/bitmap.c                                    |    4=20
 lib/crc64.c                                     |    2=20
 lib/decompress_bunzip2.c                        |    2=20
 lib/decompress_unlzma.c                         |    6=20
 lib/kstrtox.c                                   |   20 --
 lib/lz4/lz4_compress.c                          |    4=20
 lib/lz4/lz4_decompress.c                        |   18 +-
 lib/lz4/lz4defs.h                               |   10 +
 lib/lz4/lz4hc_compress.c                        |    2=20
 lib/math/rational.c                             |    2=20
 lib/rbtree.c                                    |    2=20
 lib/test_bitmap.c                               |   58 ++++++
 lib/test_bitops.c                               |   18 +-
 lib/test_bits.c                                 |   75 ++++++++
 lib/test_kmod.c                                 |    2=20
 lib/test_lockup.c                               |    6=20
 lib/ts_bm.c                                     |    2=20
 lib/xxhash.c                                    |    2=20
 lib/xz/xz_crc32.c                               |    2=20
 lib/xz/xz_dec_bcj.c                             |    2=20
 lib/xz/xz_dec_lzma2.c                           |    2=20
 lib/xz/xz_lzma2.h                               |    2=20
 lib/xz/xz_stream.h                              |    2=20
 mm/cma.c                                        |   40 +---
 mm/cma.h                                        |    4=20
 mm/compaction.c                                 |  207 +++++++++++++++++++=
++--
 mm/filemap.c                                    |    2=20
 mm/gup.c                                        |  195 ++++++-------------=
---
 mm/hmm.c                                        |    5=20
 mm/huge_memory.c                                |   23 --
 mm/hugetlb.c                                    |   93 ++++------
 mm/internal.h                                   |    9 -
 mm/khugepaged.c                                 |    2=20
 mm/ksm.c                                        |    3=20
 mm/maccess.c                                    |   22 +-
 mm/memcontrol.c                                 |   42 +++-
 mm/memory-failure.c                             |    7=20
 mm/memory.c                                     |  107 +++++++++---
 mm/memory_hotplug.c                             |   30 ++-
 mm/mempolicy.c                                  |   49 +----
 mm/migrate.c                                    |  151 ++++++++++++++---
 mm/mmu_notifier.c                               |    9 -
 mm/nommu.c                                      |    4=20
 mm/oom_kill.c                                   |   24 +-
 mm/page_alloc.c                                 |   14 +
 mm/page_isolation.c                             |   21 --
 mm/percpu-internal.h                            |   55 ++++++
 mm/percpu-km.c                                  |    5=20
 mm/percpu-stats.c                               |   36 ++--
 mm/percpu-vm.c                                  |    5=20
 mm/percpu.c                                     |  208 +++++++++++++++++++=
++---
 mm/process_vm_access.c                          |    2=20
 mm/rmap.c                                       |    2=20
 mm/shmem.c                                      |    5=20
 mm/slab_common.c                                |    2=20
 mm/swap.c                                       |   13 -
 mm/swap_state.c                                 |   80 +++++++--
 mm/swapfile.c                                   |    4=20
 mm/usercopy.c                                   |    2=20
 mm/userfaultfd.c                                |    2=20
 mm/vmscan.c                                     |   36 ++--
 mm/vmstat.c                                     |   32 +++
 mm/workingset.c                                 |   23 +-
 mm/zpool.c                                      |    8=20
 mm/zsmalloc.c                                   |    2=20
 scripts/checkpatch.pl                           |  116 +++++++++----
 scripts/gdb/linux/rbtree.py                     |    4=20
 security/tomoyo/domain.c                        |    2=20
 tools/testing/selftests/cgroup/test_kmem.c      |   70 +++++++-
 tools/testing/selftests/kmod/kmod.sh            |    4=20
 tools/testing/selftests/vm/hmm-tests.c          |   35 ++++
 virt/kvm/async_pf.c                             |    2=20
 virt/kvm/kvm_main.c                             |    2=20
 268 files changed, 2481 insertions(+), 1551 deletions(-)

