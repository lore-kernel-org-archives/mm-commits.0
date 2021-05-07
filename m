Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C64C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E5D2611EE
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhEGBC0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEGBC0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14C80610FA;
        Fri,  7 May 2021 01:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349287;
        bh=EDsrpcIJ+TCqulK46OIqtgKsBOrMNcKbIEAfqevnGXM=;
        h=Date:From:To:Cc:Subject:From;
        b=fczNhTVbAALSp8+pM1Xk7SZBfBvTdBXtCrVaPgTpFYNS6gXFCrhaCyPc4yULqBEGh
         HDBeS8PNW0Znlxekord38ADNzPJnJaCsQFqwm02qK2lOI+u0rwqLgcHzB0SW9JmU8M
         cjWwymnxkvFn0+Fr/lS2icBdeXQUm8DMmxjvlAXM=
Date:   Thu, 6 May 2021 18:01:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


This is everything else from -mm for this merge window, with the
possible exception of Mike Rapoport's "secretmem" syscall patch series
(https://lkml.kernel.org/r/20210303162209.8609-1-rppt@kernel.org).

I've been wobbly about the secretmem patches due to doubts about
whether the feature is sufficiently useful to justify inclusion, but
developers are now weighing in with helpful information and I've asked Mike
for an extensively updated [0/n] changelog.  This will take a few days
to play out so it is possible that I will prevail upon you for a post-rc1
merge.  If that's a problem, there's always 5.13-rc1.

91 patches, based on 8ca5297e7e38f2dc8c753d33a5092e7be181fff0, plus
previously sent patches.

Thanks.



Subsystems affected by this patch series:

  alpha
  procfs
  sysctl
  misc
  core-kernel
  bitmap
  lib
  compat
  checkpatch
  epoll
  isofs
  nilfs2
  hpfs
  exit
  fork
  kexec
  gcov
  panic
  delayacct
  gdb
  resource
  selftests
  async
  initramfs
  ipc
  mm/cleanups
  drivers/char
  mm/slub
  spelling

Subsystem: alpha

    Randy Dunlap <rdunlap@infradead.org>:
      alpha: eliminate old-style function definitions
      alpha: csum_partial_copy.c: add function prototypes from <net/checksum.h>

Subsystem: procfs

    Colin Ian King <colin.king@canonical.com>:
      fs/proc/generic.c: fix incorrect pde_is_permanent check

    Alexey Dobriyan <adobriyan@gmail.com>:
      proc: save LOC in __xlate_proc_name()
      proc: mandate ->proc_lseek in "struct proc_ops"
      proc: delete redundant subset=pid check
      selftests: proc: test subset=pid

Subsystem: sysctl

    zhouchuangao <zhouchuangao@vivo.com>:
      proc/sysctl: fix function name error in comments

Subsystem: misc

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      include: remove pagemap.h from blkdev.h

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      kernel.h: drop inclusion in bitmap.h

    Wan Jiabing <wanjiabing@vivo.com>:
      linux/profile.h: remove unnecessary declaration

Subsystem: core-kernel

    Rasmus Villemoes <linux@rasmusvillemoes.dk>:
      kernel/async.c: fix pr_debug statement
      kernel/cred.c: make init_groups static

Subsystem: bitmap

    Yury Norov <yury.norov@gmail.com>:
    Patch series "lib/find_bit: fast path for small bitmaps", v6:
      tools: disable -Wno-type-limits
      tools: bitmap: sync function declarations with the kernel
      tools: sync BITMAP_LAST_WORD_MASK() macro with the kernel
      arch: rearrange headers inclusion order in asm/bitops for m68k, sh and h8300
      lib: extend the scope of small_const_nbits() macro
      tools: sync small_const_nbits() macro with the kernel
      lib: inline _find_next_bit() wrappers
      tools: sync find_next_bit implementation
      lib: add fast path for find_next_*_bit()
      lib: add fast path for find_first_*_bit() and find_last_bit()
      tools: sync lib/find_bit implementation
      MAINTAINERS: add entry for the bitmap API

Subsystem: lib

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      lib/bch.c: fix a typo in the file bch.c

    Wang Qing <wangqing@vivo.com>:
      lib: fix inconsistent indenting in process_bit1()

    ToastC <mrtoastcheng@gmail.com>:
      lib/list_sort.c: fix typo in function description

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      lib/genalloc.c: Fix a typo

    Richard Fitzgerald <rf@opensource.cirrus.com>:
      lib: crc8: pointer to data block should be const

    Zqiang <qiang.zhang@windriver.com>:
      lib: stackdepot: turn depot_lock spinlock to raw_spinlock

    Alex Shi <alexs@kernel.org>:
      lib/percpu_counter: tame kernel-doc compile warning
      lib/genalloc: add parameter description to fix doc compile warning

    Randy Dunlap <rdunlap@infradead.org>:
      lib: parser: clean up kernel-doc

Subsystem: compat

    Masahiro Yamada <masahiroy@kernel.org>:
      include/linux/compat.h: remove unneeded declaration from COMPAT_SYSCALL_DEFINEx()

Subsystem: checkpatch

    Joe Perches <joe@perches.com>:
      checkpatch: warn when missing newline in return sysfs_emit() formats

    Vincent Mailhol <mailhol.vincent@wanadoo.fr>:
      checkpatch: exclude four preprocessor sub-expressions from MACRO_ARG_REUSE

    Christophe JAILLET <christophe.jaillet@wanadoo.fr>:
      checkpatch: improve ALLOC_ARRAY_ARGS test

Subsystem: epoll

    Davidlohr Bueso <dave@stgolabs.net>:
    Patch series "fs/epoll: restore user-visible behavior upon event ready":
      kselftest: introduce new epoll test case
      fs/epoll: restore waking from ep_done_scan()

Subsystem: isofs

    "Gustavo A. R. Silva" <gustavoars@kernel.org>:
      isofs: fix fall-through warnings for Clang

Subsystem: nilfs2

    Liu xuzhi <liu.xuzhi@zte.com.cn>:
      fs/nilfs2: fix misspellings using codespell tool

    Lu Jialin <lujialin4@huawei.com>:
      nilfs2: fix typos in comments

Subsystem: hpfs

    "Gustavo A. R. Silva" <gustavoars@kernel.org>:
      hpfs: replace one-element array with flexible-array member

Subsystem: exit

    Jim Newsome <jnewsome@torproject.org>:
      do_wait: make PIDTYPE_PID case O(1) instead of O(n)

Subsystem: fork

    Rolf Eike Beer <eb@emlix.com>:
      kernel/fork.c: simplify copy_mm()

    Xiaofeng Cao <cxfcosmos@gmail.com>:
      kernel/fork.c: fix typos

Subsystem: kexec

    Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>:
      kernel/crash_core: add crashkernel=auto for vmcore creation

    Joe LeVeque <jolevequ@microsoft.com>:
      kexec: Add kexec reboot string

    Jia-Ju Bai <baijiaju1990@gmail.com>:
      kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

    Pavel Tatashin <pasha.tatashin@soleen.com>:
      kexec: dump kmessage before machine_kexec

Subsystem: gcov

    Johannes Berg <johannes.berg@intel.com>:
      gcov: combine common code
      gcov: simplify buffer allocation
      gcov: use kvmalloc()

    Nick Desaulniers <ndesaulniers@google.com>:
      gcov: clang: drop support for clang-10 and older

Subsystem: panic

    He Ying <heying24@huawei.com>:
      smp: kernel/panic.c - silence warnings

Subsystem: delayacct

    Yafang Shao <laoar.shao@gmail.com>:
      delayacct: clear right task's flag after blkio completes

Subsystem: gdb

    Johannes Berg <johannes.berg@intel.com>:
      gdb: lx-symbols: store the abspath()

    Barry Song <song.bao.hua@hisilicon.com>:
    Patch series "scripts/gdb: clarify the platforms supporting lx_current and add arm64 support", v2:
      scripts/gdb: document lx_current is only supported by x86
      scripts/gdb: add lx_current support for arm64

Subsystem: resource

    David Hildenbrand <david@redhat.com>:
    Patch series "kernel/resource: make walk_system_ram_res() and walk_mem_res() search the whole tree", v2:
      kernel/resource: make walk_system_ram_res() find all busy IORESOURCE_SYSTEM_RAM resources
      kernel/resource: make walk_mem_res() find all busy IORESOURCE_MEM resources
      kernel/resource: remove first_lvl / siblings_only logic

    Alistair Popple <apopple@nvidia.com>:
      kernel/resource: allow region_intersects users to hold resource_lock
      kernel/resource: refactor __request_region to allow external locking
      kernel/resource: fix locking in request_free_mem_region

Subsystem: selftests

    Zhang Yunkai <zhang.yunkai@zte.com.cn>:
      selftests: remove duplicate include

Subsystem: async

    Rasmus Villemoes <linux@rasmusvillemoes.dk>:
      kernel/async.c: stop guarding pr_debug() statements
      kernel/async.c: remove async_unregister_domain()

Subsystem: initramfs

    Rasmus Villemoes <linux@rasmusvillemoes.dk>:
    Patch series "background initramfs unpacking, and CONFIG_MODPROBE_PATH", v3:
      init/initramfs.c: do unpacking asynchronously
      modules: add CONFIG_MODPROBE_PATH

Subsystem: ipc

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      ipc/sem.c: mundane typo fixes

Subsystem: mm/cleanups

    Shijie Luo <luoshijie1@huawei.com>:
      mm: fix some typos and code style problems

Subsystem: drivers/char

    David Hildenbrand <david@redhat.com>:
    Patch series "drivers/char: remove /dev/kmem for good":
      drivers/char: remove /dev/kmem for good
      mm: remove xlate_dev_kmem_ptr()
      mm/vmalloc: remove vwrite()

Subsystem: mm/slub

    Maninder Singh <maninder1.s@samsung.com>:
      arm: print alloc free paths for address in registers

Subsystem: spelling

    Drew Fustini <drew@beagleboard.org>:
      scripts/spelling.txt: add "overlfow"

    zuoqilin <zuoqilin@yulong.com>:
      scripts/spelling.txt: Add "diabled" typo

    Drew Fustini <drew@beagleboard.org>:
      scripts/spelling.txt: add "overflw"

    Colin Ian King <colin.king@canonical.com>:
      mm/slab.c: fix spelling mistake "disired" -> "desired"

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      include/linux/pgtable.h: few spelling fixes

    zhouchuangao <zhouchuangao@vivo.com>:
      kernel/umh.c: fix some spelling mistakes

    Xiaofeng Cao <cxfcosmos@gmail.com>:
      kernel/user_namespace.c: fix typos

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      kernel/up.c: fix typo

    Xiaofeng Cao <caoxiaofeng@yulong.com>:
      kernel/sys.c: fix typo

    dingsenjie <dingsenjie@yulong.com>:
      fs: fat: fix spelling typo of values

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      ipc/sem.c: spelling fix

    Masahiro Yamada <masahiroy@kernel.org>:
      treewide: remove editor modelines and cruft

    Ingo Molnar <mingo@kernel.org>:
      mm: fix typos in comments

    Lu Jialin <lujialin4@huawei.com>:
      mm: fix typos in comments

 Documentation/admin-guide/devices.txt                         |    2 
 Documentation/admin-guide/kdump/kdump.rst                     |    3 
 Documentation/admin-guide/kernel-parameters.txt               |   18 
 Documentation/dev-tools/gdb-kernel-debugging.rst              |    4 
 MAINTAINERS                                                   |   16 
 arch/Kconfig                                                  |   20 
 arch/alpha/include/asm/io.h                                   |    5 
 arch/alpha/kernel/pc873xx.c                                   |    4 
 arch/alpha/lib/csum_partial_copy.c                            |    1 
 arch/arm/configs/dove_defconfig                               |    1 
 arch/arm/configs/magician_defconfig                           |    1 
 arch/arm/configs/moxart_defconfig                             |    1 
 arch/arm/configs/mps2_defconfig                               |    1 
 arch/arm/configs/mvebu_v5_defconfig                           |    1 
 arch/arm/configs/xcep_defconfig                               |    1 
 arch/arm/include/asm/bug.h                                    |    1 
 arch/arm/include/asm/io.h                                     |    5 
 arch/arm/kernel/process.c                                     |   11 
 arch/arm/kernel/traps.c                                       |    1 
 arch/h8300/include/asm/bitops.h                               |    8 
 arch/hexagon/configs/comet_defconfig                          |    1 
 arch/hexagon/include/asm/io.h                                 |    1 
 arch/ia64/include/asm/io.h                                    |    1 
 arch/ia64/include/asm/uaccess.h                               |   18 
 arch/m68k/atari/time.c                                        |    7 
 arch/m68k/configs/amcore_defconfig                            |    1 
 arch/m68k/include/asm/bitops.h                                |    6 
 arch/m68k/include/asm/io_mm.h                                 |    5 
 arch/mips/include/asm/io.h                                    |    5 
 arch/openrisc/configs/or1ksim_defconfig                       |    1 
 arch/parisc/include/asm/io.h                                  |    5 
 arch/parisc/include/asm/pdc_chassis.h                         |    1 
 arch/powerpc/include/asm/io.h                                 |    5 
 arch/s390/include/asm/io.h                                    |    5 
 arch/sh/configs/edosk7705_defconfig                           |    1 
 arch/sh/configs/se7206_defconfig                              |    1 
 arch/sh/configs/sh2007_defconfig                              |    1 
 arch/sh/configs/sh7724_generic_defconfig                      |    1 
 arch/sh/configs/sh7770_generic_defconfig                      |    1 
 arch/sh/configs/sh7785lcr_32bit_defconfig                     |    1 
 arch/sh/include/asm/bitops.h                                  |    5 
 arch/sh/include/asm/io.h                                      |    5 
 arch/sparc/configs/sparc64_defconfig                          |    1 
 arch/sparc/include/asm/io_64.h                                |    5 
 arch/um/drivers/cow.h                                         |    7 
 arch/xtensa/configs/xip_kc705_defconfig                       |    1 
 block/blk-settings.c                                          |    1 
 drivers/auxdisplay/panel.c                                    |    7 
 drivers/base/firmware_loader/main.c                           |    2 
 drivers/block/brd.c                                           |    1 
 drivers/block/loop.c                                          |    1 
 drivers/char/Kconfig                                          |   10 
 drivers/char/mem.c                                            |  231 --------
 drivers/gpu/drm/qxl/qxl_drv.c                                 |    1 
 drivers/isdn/capi/kcapi_proc.c                                |    1 
 drivers/md/bcache/super.c                                     |    1 
 drivers/media/usb/pwc/pwc-uncompress.c                        |    3 
 drivers/net/ethernet/adaptec/starfire.c                       |    8 
 drivers/net/ethernet/amd/atarilance.c                         |    8 
 drivers/net/ethernet/amd/pcnet32.c                            |    7 
 drivers/net/wireless/intersil/hostap/hostap_proc.c            |    1 
 drivers/net/wireless/intersil/orinoco/orinoco_nortel.c        |    8 
 drivers/net/wireless/intersil/orinoco/orinoco_pci.c           |    8 
 drivers/net/wireless/intersil/orinoco/orinoco_plx.c           |    8 
 drivers/net/wireless/intersil/orinoco/orinoco_tmd.c           |    8 
 drivers/nvdimm/btt.c                                          |    1 
 drivers/nvdimm/pmem.c                                         |    1 
 drivers/parport/parport_ip32.c                                |   12 
 drivers/platform/x86/dell/dell_rbu.c                          |    3 
 drivers/scsi/53c700.c                                         |    1 
 drivers/scsi/53c700.h                                         |    1 
 drivers/scsi/ch.c                                             |    6 
 drivers/scsi/esas2r/esas2r_main.c                             |    1 
 drivers/scsi/ips.c                                            |   20 
 drivers/scsi/ips.h                                            |   20 
 drivers/scsi/lasi700.c                                        |    1 
 drivers/scsi/megaraid/mbox_defs.h                             |    2 
 drivers/scsi/megaraid/mega_common.h                           |    2 
 drivers/scsi/megaraid/megaraid_mbox.c                         |    2 
 drivers/scsi/megaraid/megaraid_mbox.h                         |    2 
 drivers/scsi/qla1280.c                                        |   12 
 drivers/scsi/scsicam.c                                        |    1 
 drivers/scsi/sni_53c710.c                                     |    1 
 drivers/video/fbdev/matrox/matroxfb_base.c                    |    9 
 drivers/video/fbdev/vga16fb.c                                 |   10 
 fs/configfs/configfs_internal.h                               |    4 
 fs/configfs/dir.c                                             |    4 
 fs/configfs/file.c                                            |    4 
 fs/configfs/inode.c                                           |    4 
 fs/configfs/item.c                                            |    4 
 fs/configfs/mount.c                                           |    4 
 fs/configfs/symlink.c                                         |    4 
 fs/eventpoll.c                                                |    6 
 fs/fat/fatent.c                                               |    2 
 fs/hpfs/hpfs.h                                                |    3 
 fs/isofs/rock.c                                               |    1 
 fs/nfs/dir.c                                                  |    7 
 fs/nfs/nfs4proc.c                                             |    6 
 fs/nfs/nfs4renewd.c                                           |    6 
 fs/nfs/nfs4state.c                                            |    6 
 fs/nfs/nfs4xdr.c                                              |    6 
 fs/nfsd/nfs4proc.c                                            |    6 
 fs/nfsd/nfs4xdr.c                                             |    6 
 fs/nfsd/xdr4.h                                                |    6 
 fs/nilfs2/cpfile.c                                            |    2 
 fs/nilfs2/ioctl.c                                             |    4 
 fs/nilfs2/segment.c                                           |    4 
 fs/nilfs2/the_nilfs.c                                         |    2 
 fs/ocfs2/acl.c                                                |    4 
 fs/ocfs2/acl.h                                                |    4 
 fs/ocfs2/alloc.c                                              |    4 
 fs/ocfs2/alloc.h                                              |    4 
 fs/ocfs2/aops.c                                               |    4 
 fs/ocfs2/aops.h                                               |    4 
 fs/ocfs2/blockcheck.c                                         |    4 
 fs/ocfs2/blockcheck.h                                         |    4 
 fs/ocfs2/buffer_head_io.c                                     |    4 
 fs/ocfs2/buffer_head_io.h                                     |    4 
 fs/ocfs2/cluster/heartbeat.c                                  |    4 
 fs/ocfs2/cluster/heartbeat.h                                  |    4 
 fs/ocfs2/cluster/masklog.c                                    |    4 
 fs/ocfs2/cluster/masklog.h                                    |    4 
 fs/ocfs2/cluster/netdebug.c                                   |    4 
 fs/ocfs2/cluster/nodemanager.c                                |    4 
 fs/ocfs2/cluster/nodemanager.h                                |    4 
 fs/ocfs2/cluster/ocfs2_heartbeat.h                            |    4 
 fs/ocfs2/cluster/ocfs2_nodemanager.h                          |    4 
 fs/ocfs2/cluster/quorum.c                                     |    4 
 fs/ocfs2/cluster/quorum.h                                     |    4 
 fs/ocfs2/cluster/sys.c                                        |    4 
 fs/ocfs2/cluster/sys.h                                        |    4 
 fs/ocfs2/cluster/tcp.c                                        |    4 
 fs/ocfs2/cluster/tcp.h                                        |    4 
 fs/ocfs2/cluster/tcp_internal.h                               |    4 
 fs/ocfs2/dcache.c                                             |    4 
 fs/ocfs2/dcache.h                                             |    4 
 fs/ocfs2/dir.c                                                |    4 
 fs/ocfs2/dir.h                                                |    4 
 fs/ocfs2/dlm/dlmapi.h                                         |    4 
 fs/ocfs2/dlm/dlmast.c                                         |    4 
 fs/ocfs2/dlm/dlmcommon.h                                      |    4 
 fs/ocfs2/dlm/dlmconvert.c                                     |    4 
 fs/ocfs2/dlm/dlmconvert.h                                     |    4 
 fs/ocfs2/dlm/dlmdebug.c                                       |    4 
 fs/ocfs2/dlm/dlmdebug.h                                       |    4 
 fs/ocfs2/dlm/dlmdomain.c                                      |    4 
 fs/ocfs2/dlm/dlmdomain.h                                      |    4 
 fs/ocfs2/dlm/dlmlock.c                                        |    4 
 fs/ocfs2/dlm/dlmmaster.c                                      |    4 
 fs/ocfs2/dlm/dlmrecovery.c                                    |    4 
 fs/ocfs2/dlm/dlmthread.c                                      |    4 
 fs/ocfs2/dlm/dlmunlock.c                                      |    4 
 fs/ocfs2/dlmfs/dlmfs.c                                        |    4 
 fs/ocfs2/dlmfs/userdlm.c                                      |    4 
 fs/ocfs2/dlmfs/userdlm.h                                      |    4 
 fs/ocfs2/dlmglue.c                                            |    4 
 fs/ocfs2/dlmglue.h                                            |    4 
 fs/ocfs2/export.c                                             |    4 
 fs/ocfs2/export.h                                             |    4 
 fs/ocfs2/extent_map.c                                         |    4 
 fs/ocfs2/extent_map.h                                         |    4 
 fs/ocfs2/file.c                                               |    4 
 fs/ocfs2/file.h                                               |    4 
 fs/ocfs2/filecheck.c                                          |    4 
 fs/ocfs2/filecheck.h                                          |    4 
 fs/ocfs2/heartbeat.c                                          |    4 
 fs/ocfs2/heartbeat.h                                          |    4 
 fs/ocfs2/inode.c                                              |    4 
 fs/ocfs2/inode.h                                              |    4 
 fs/ocfs2/journal.c                                            |    4 
 fs/ocfs2/journal.h                                            |    4 
 fs/ocfs2/localalloc.c                                         |    4 
 fs/ocfs2/localalloc.h                                         |    4 
 fs/ocfs2/locks.c                                              |    4 
 fs/ocfs2/locks.h                                              |    4 
 fs/ocfs2/mmap.c                                               |    4 
 fs/ocfs2/move_extents.c                                       |    4 
 fs/ocfs2/move_extents.h                                       |    4 
 fs/ocfs2/namei.c                                              |    4 
 fs/ocfs2/namei.h                                              |    4 
 fs/ocfs2/ocfs1_fs_compat.h                                    |    4 
 fs/ocfs2/ocfs2.h                                              |    4 
 fs/ocfs2/ocfs2_fs.h                                           |    4 
 fs/ocfs2/ocfs2_ioctl.h                                        |    4 
 fs/ocfs2/ocfs2_lockid.h                                       |    4 
 fs/ocfs2/ocfs2_lockingver.h                                   |    4 
 fs/ocfs2/refcounttree.c                                       |    4 
 fs/ocfs2/refcounttree.h                                       |    4 
 fs/ocfs2/reservations.c                                       |    4 
 fs/ocfs2/reservations.h                                       |    4 
 fs/ocfs2/resize.c                                             |    4 
 fs/ocfs2/resize.h                                             |    4 
 fs/ocfs2/slot_map.c                                           |    4 
 fs/ocfs2/slot_map.h                                           |    4 
 fs/ocfs2/stack_o2cb.c                                         |    4 
 fs/ocfs2/stack_user.c                                         |    4 
 fs/ocfs2/stackglue.c                                          |    4 
 fs/ocfs2/stackglue.h                                          |    4 
 fs/ocfs2/suballoc.c                                           |    4 
 fs/ocfs2/suballoc.h                                           |    4 
 fs/ocfs2/super.c                                              |    4 
 fs/ocfs2/super.h                                              |    4 
 fs/ocfs2/symlink.c                                            |    4 
 fs/ocfs2/symlink.h                                            |    4 
 fs/ocfs2/sysfile.c                                            |    4 
 fs/ocfs2/sysfile.h                                            |    4 
 fs/ocfs2/uptodate.c                                           |    4 
 fs/ocfs2/uptodate.h                                           |    4 
 fs/ocfs2/xattr.c                                              |    4 
 fs/ocfs2/xattr.h                                              |    4 
 fs/proc/generic.c                                             |   13 
 fs/proc/inode.c                                               |   18 
 fs/proc/proc_sysctl.c                                         |    2 
 fs/reiserfs/procfs.c                                          |   10 
 include/asm-generic/bitops/find.h                             |  108 +++
 include/asm-generic/bitops/le.h                               |   38 +
 include/asm-generic/bitsperlong.h                             |   12 
 include/asm-generic/io.h                                      |   11 
 include/linux/align.h                                         |   15 
 include/linux/async.h                                         |    1 
 include/linux/bitmap.h                                        |   11 
 include/linux/bitops.h                                        |   12 
 include/linux/blkdev.h                                        |    1 
 include/linux/compat.h                                        |    1 
 include/linux/configfs.h                                      |    4 
 include/linux/crc8.h                                          |    2 
 include/linux/cred.h                                          |    1 
 include/linux/delayacct.h                                     |   20 
 include/linux/fs.h                                            |    2 
 include/linux/genl_magic_func.h                               |    1 
 include/linux/genl_magic_struct.h                             |    1 
 include/linux/gfp.h                                           |    2 
 include/linux/init_task.h                                     |    1 
 include/linux/initrd.h                                        |    2 
 include/linux/kernel.h                                        |    9 
 include/linux/mm.h                                            |    2 
 include/linux/mmzone.h                                        |    2 
 include/linux/pgtable.h                                       |   10 
 include/linux/proc_fs.h                                       |    1 
 include/linux/profile.h                                       |    3 
 include/linux/smp.h                                           |    8 
 include/linux/swap.h                                          |    1 
 include/linux/vmalloc.h                                       |    7 
 include/uapi/linux/if_bonding.h                               |   11 
 include/uapi/linux/nfs4.h                                     |    6 
 include/xen/interface/elfnote.h                               |   10 
 include/xen/interface/hvm/hvm_vcpu.h                          |   10 
 include/xen/interface/io/xenbus.h                             |   10 
 init/Kconfig                                                  |   12 
 init/initramfs.c                                              |   38 +
 init/main.c                                                   |    1 
 ipc/sem.c                                                     |   12 
 kernel/async.c                                                |   68 --
 kernel/configs/android-base.config                            |    1 
 kernel/crash_core.c                                           |    7 
 kernel/cred.c                                                 |    2 
 kernel/exit.c                                                 |   67 ++
 kernel/fork.c                                                 |   23 
 kernel/gcov/Kconfig                                           |    1 
 kernel/gcov/base.c                                            |   49 +
 kernel/gcov/clang.c                                           |  282 ----------
 kernel/gcov/fs.c                                              |  146 ++++-
 kernel/gcov/gcc_4_7.c                                         |  173 ------
 kernel/gcov/gcov.h                                            |   14 
 kernel/kexec_core.c                                           |    4 
 kernel/kexec_file.c                                           |    4 
 kernel/kmod.c                                                 |    2 
 kernel/resource.c                                             |  198 ++++---
 kernel/sys.c                                                  |   14 
 kernel/umh.c                                                  |    8 
 kernel/up.c                                                   |    2 
 kernel/user_namespace.c                                       |    6 
 lib/bch.c                                                     |    2 
 lib/crc8.c                                                    |    2 
 lib/decompress_unlzma.c                                       |    2 
 lib/find_bit.c                                                |   68 --
 lib/genalloc.c                                                |    7 
 lib/list_sort.c                                               |    2 
 lib/parser.c                                                  |   61 +-
 lib/percpu_counter.c                                          |    2 
 lib/stackdepot.c                                              |    6 
 mm/balloon_compaction.c                                       |    4 
 mm/compaction.c                                               |    4 
 mm/filemap.c                                                  |    2 
 mm/gup.c                                                      |    2 
 mm/highmem.c                                                  |    2 
 mm/huge_memory.c                                              |    6 
 mm/hugetlb.c                                                  |    6 
 mm/internal.h                                                 |    2 
 mm/kasan/kasan.h                                              |    8 
 mm/kasan/quarantine.c                                         |    4 
 mm/kasan/shadow.c                                             |    4 
 mm/kfence/report.c                                            |    2 
 mm/khugepaged.c                                               |    2 
 mm/ksm.c                                                      |    6 
 mm/madvise.c                                                  |    4 
 mm/memcontrol.c                                               |   18 
 mm/memory-failure.c                                           |    2 
 mm/memory.c                                                   |   18 
 mm/mempolicy.c                                                |    6 
 mm/migrate.c                                                  |    8 
 mm/mmap.c                                                     |    4 
 mm/mprotect.c                                                 |    2 
 mm/mremap.c                                                   |    2 
 mm/nommu.c                                                    |   10 
 mm/oom_kill.c                                                 |    2 
 mm/page-writeback.c                                           |    4 
 mm/page_alloc.c                                               |   16 
 mm/page_owner.c                                               |    2 
 mm/page_vma_mapped.c                                          |    2 
 mm/percpu-internal.h                                          |    2 
 mm/percpu.c                                                   |    2 
 mm/pgalloc-track.h                                            |    6 
 mm/rmap.c                                                     |    2 
 mm/slab.c                                                     |    8 
 mm/slub.c                                                     |    2 
 mm/swap.c                                                     |    4 
 mm/swap_slots.c                                               |    2 
 mm/swap_state.c                                               |    2 
 mm/vmalloc.c                                                  |  124 ----
 mm/vmstat.c                                                   |    2 
 mm/z3fold.c                                                   |    2 
 mm/zpool.c                                                    |    2 
 mm/zsmalloc.c                                                 |    6 
 samples/configfs/configfs_sample.c                            |    2 
 scripts/checkpatch.pl                                         |   15 
 scripts/gdb/linux/cpus.py                                     |   23 
 scripts/gdb/linux/symbols.py                                  |    3 
 scripts/spelling.txt                                          |    3 
 tools/include/asm-generic/bitops/find.h                       |   85 ++-
 tools/include/asm-generic/bitsperlong.h                       |    3 
 tools/include/linux/bitmap.h                                  |   18 
 tools/lib/bitmap.c                                            |    4 
 tools/lib/find_bit.c                                          |   56 -
 tools/scripts/Makefile.include                                |    1 
 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |   44 +
 tools/testing/selftests/kvm/lib/sparsebit.c                   |    1 
 tools/testing/selftests/mincore/mincore_selftest.c            |    1 
 tools/testing/selftests/powerpc/mm/tlbie_test.c               |    1 
 tools/testing/selftests/proc/Makefile                         |    1 
 tools/testing/selftests/proc/proc-subset-pid.c                |  121 ++++
 tools/testing/selftests/proc/read.c                           |    4 
 tools/usb/hcd-tests.sh                                        |    2 
 343 files changed, 1383 insertions(+), 2119 deletions(-)

