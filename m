Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC00C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbiAVGK0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbiAVGKZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:10:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2ACC06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F6E460C5D
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62887C004E1;
        Sat, 22 Jan 2022 06:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831823;
        bh=FjZptSEPgZD+nI3Ptg0M8+GHgUU49bhtpAb8PfwaETA=;
        h=Date:From:To:Cc:Subject:From;
        b=kZYSz3yc+LGFXokRUweCoasv17QTGo+MhPfuttB3Tf6aYnV6WqZgSDtzBPBuDHGPu
         ZkJVPeIM0rm3N2Krz+ySq+NY6Sc8QQECCZU62r1fS9w9psYCpQvEd9ljYd7bsO1xs1
         lTp6FHqfYPurfvVGqEJ8zInWCRnzvDpPmi5Uwgf4=
Date:   Fri, 21 Jan 2022 22:10:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


This is the post-linux-next queue.  Material which was based on or
dependent upon material which was in -next.

69 patches, based on 9b57f458985742bd1c585f4c7f36d04634ce1143.

Subsystems affected by this patch series:

  mm/migration
  sysctl
  mm/zsmalloc
  proc
  lib

Subsystem: mm/migration

    Alistair Popple <apopple@nvidia.com>:
      mm/migrate.c: rework migration_entry_wait() to not take a pageref

Subsystem: sysctl

    Xiaoming Ni <nixiaoming@huawei.com>:
    Patch series "sysctl: first set of kernel/sysctl cleanups", v2:
      sysctl: add a new register_sysctl_init() interface
      sysctl: move some boundary constants from sysctl.c to sysctl_vals
      hung_task: move hung_task sysctl interface to hung_task.c
      watchdog: move watchdog sysctl interface to watchdog.c

    Stephen Kitt <steve@sk2.org>:
      sysctl: make ngroups_max const

    Xiaoming Ni <nixiaoming@huawei.com>:
      sysctl: use const for typically used max/min proc sysctls
      sysctl: use SYSCTL_ZERO to replace some static int zero uses
      aio: move aio sysctl to aio.c
      dnotify: move dnotify sysctl to dnotify.c

    Luis Chamberlain <mcgrof@kernel.org>:
    Patch series "sysctl: second set of kernel/sysctl cleanups", v2:
      hpet: simplify subdirectory registration with register_sysctl()
      i915: simplify subdirectory registration with register_sysctl()
      macintosh/mac_hid.c: simplify subdirectory registration with register_sysctl()
      ocfs2: simplify subdirectory registration with register_sysctl()
      test_sysctl: simplify subdirectory registration with register_sysctl()

    Xiaoming Ni <nixiaoming@huawei.com>:
      inotify: simplify subdirectory registration with register_sysctl()

    Luis Chamberlain <mcgrof@kernel.org>:
      cdrom: simplify subdirectory registration with register_sysctl()

    Xiaoming Ni <nixiaoming@huawei.com>:
      eventpoll: simplify sysctl declaration with register_sysctl()
    Patch series "sysctl: 3rd set of kernel/sysctl cleanups", v2:
      firmware_loader: move firmware sysctl to its own files
      random: move the random sysctl declarations to its own file

    Luis Chamberlain <mcgrof@kernel.org>:
      sysctl: add helper to register a sysctl mount point
      fs: move binfmt_misc sysctl to its own file

    Xiaoming Ni <nixiaoming@huawei.com>:
      printk: move printk sysctl to printk/sysctl.c
      scsi/sg: move sg-big-buff sysctl to scsi/sg.c
      stackleak: move stack_erasing sysctl to stackleak.c

    Luis Chamberlain <mcgrof@kernel.org>:
      sysctl: share unsigned long const values
    Patch series "sysctl: 4th set of kernel/sysctl cleanups":
      fs: move inode sysctls to its own file
      fs: move fs stat sysctls to file_table.c
      fs: move dcache sysctls to its own file
      sysctl: move maxolduid as a sysctl specific const
      fs: move shared sysctls to fs/sysctls.c
      fs: move locking sysctls where they are used
      fs: move namei sysctls to its own file
      fs: move fs/exec.c sysctls into its own file
      fs: move pipe sysctls to is own file
    Patch series "sysctl: add and use base directory declarer and registration helper":
      sysctl: add and use base directory declarer and registration helper
      fs: move namespace sysctls and declare fs base directory
      kernel/sysctl.c: rename sysctl_init() to sysctl_init_bases()

    Xiaoming Ni <nixiaoming@huawei.com>:
      printk: fix build warning when CONFIG_PRINTK=n
      fs/coredump: move coredump sysctls into its own file
      kprobe: move sysctl_kprobes_optimization to kprobes.c

    Colin Ian King <colin.i.king@gmail.com>:
      kernel/sysctl.c: remove unused variable ten_thousand

    Baokun Li <libaokun1@huawei.com>:
      sysctl: returns -EINVAL when a negative value is passed to proc_doulongvec_minmax

Subsystem: mm/zsmalloc

    Minchan Kim <minchan@kernel.org>:
    Patch series "zsmalloc: remove bit_spin_lock", v2:
      zsmalloc: introduce some helper functions
      zsmalloc: rename zs_stat_type to class_stat_type
      zsmalloc: decouple class actions from zspage works
      zsmalloc: introduce obj_allocated
      zsmalloc: move huge compressed obj from page to zspage
      zsmalloc: remove zspage isolation for migration
      locking/rwlocks: introduce write_lock_nested
      zsmalloc: replace per zpage lock with pool->migrate_lock

    Mike Galbraith <umgwanakikbuti@gmail.com>:
      zsmalloc: replace get_cpu_var with local_lock

Subsystem: proc

    Muchun Song <songmuchun@bytedance.com>:
      fs: proc: store PDE()->data into inode->i_private
      proc: remove PDE_DATA() completely

Subsystem: lib

    Vlastimil Babka <vbabka@suse.cz>:
      lib/stackdepot: allow optional init and stack_table allocation by kvmalloc()
lib/stackdepot: fix spelling mistake and grammar in pr_err message
lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup
lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup3
lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup4

    Marco Elver <elver@google.com>:
      lib/stackdepot: always do filter_irq_stacks() in stack_depot_save()

    Christoph Hellwig <hch@lst.de>:
    Patch series "remove Xen tmem leftovers":
      mm: remove cleancache
      frontswap: remove frontswap_writethrough
      frontswap: remove frontswap_tmem_exclusive_gets
      frontswap: remove frontswap_shrink
      frontswap: remove frontswap_curr_pages
      frontswap: simplify frontswap_init
      frontswap: remove the frontswap exports
      mm: simplify try_to_unuse
      frontswap: remove frontswap_test
      frontswap: simplify frontswap_register_ops
      mm: mark swap_lock and swap_active_head static
      frontswap: remove support for multiple ops
      mm: hide the FRONTSWAP Kconfig symbol

 Documentation/vm/cleancache.rst                        |  296 ------
 Documentation/vm/frontswap.rst                         |   31 
 Documentation/vm/index.rst                             |    1 
 MAINTAINERS                                            |    7 
 arch/alpha/kernel/srm_env.c                            |    4 
 arch/arm/configs/bcm2835_defconfig                     |    1 
 arch/arm/configs/qcom_defconfig                        |    1 
 arch/arm/kernel/atags_proc.c                           |    2 
 arch/arm/mm/alignment.c                                |    2 
 arch/ia64/kernel/salinfo.c                             |   10 
 arch/m68k/configs/amiga_defconfig                      |    1 
 arch/m68k/configs/apollo_defconfig                     |    1 
 arch/m68k/configs/atari_defconfig                      |    1 
 arch/m68k/configs/bvme6000_defconfig                   |    1 
 arch/m68k/configs/hp300_defconfig                      |    1 
 arch/m68k/configs/mac_defconfig                        |    1 
 arch/m68k/configs/multi_defconfig                      |    1 
 arch/m68k/configs/mvme147_defconfig                    |    1 
 arch/m68k/configs/mvme16x_defconfig                    |    1 
 arch/m68k/configs/q40_defconfig                        |    1 
 arch/m68k/configs/sun3_defconfig                       |    1 
 arch/m68k/configs/sun3x_defconfig                      |    1 
 arch/powerpc/kernel/proc_powerpc.c                     |    4 
 arch/s390/configs/debug_defconfig                      |    1 
 arch/s390/configs/defconfig                            |    1 
 arch/sh/mm/alignment.c                                 |    4 
 arch/xtensa/platforms/iss/simdisk.c                    |    4 
 block/bdev.c                                           |    5 
 drivers/acpi/proc.c                                    |    2 
 drivers/base/firmware_loader/fallback.c                |    7 
 drivers/base/firmware_loader/fallback.h                |   11 
 drivers/base/firmware_loader/fallback_table.c          |   25 
 drivers/cdrom/cdrom.c                                  |   23 
 drivers/char/hpet.c                                    |   22 
 drivers/char/random.c                                  |   14 
 drivers/gpu/drm/drm_dp_mst_topology.c                  |    1 
 drivers/gpu/drm/drm_mm.c                               |    4 
 drivers/gpu/drm/drm_modeset_lock.c                     |    9 
 drivers/gpu/drm/i915/i915_perf.c                       |   22 
 drivers/gpu/drm/i915/intel_runtime_pm.c                |    3 
 drivers/hwmon/dell-smm-hwmon.c                         |    4 
 drivers/macintosh/mac_hid.c                            |   24 
 drivers/net/bonding/bond_procfs.c                      |    8 
 drivers/net/wireless/cisco/airo.c                      |   22 
 drivers/net/wireless/intersil/hostap/hostap_ap.c       |   16 
 drivers/net/wireless/intersil/hostap/hostap_download.c |    2 
 drivers/net/wireless/intersil/hostap/hostap_proc.c     |   24 
 drivers/net/wireless/ray_cs.c                          |    2 
 drivers/nubus/proc.c                                   |   36 
 drivers/parisc/led.c                                   |    4 
 drivers/pci/proc.c                                     |   10 
 drivers/platform/x86/thinkpad_acpi.c                   |    4 
 drivers/platform/x86/toshiba_acpi.c                    |   16 
 drivers/pnp/isapnp/proc.c                              |    2 
 drivers/pnp/pnpbios/proc.c                             |    4 
 drivers/scsi/scsi_proc.c                               |    4 
 drivers/scsi/sg.c                                      |   35 
 drivers/usb/gadget/function/rndis.c                    |    4 
 drivers/zorro/proc.c                                   |    2 
 fs/Makefile                                            |    4 
 fs/afs/proc.c                                          |    6 
 fs/aio.c                                               |   31 
 fs/binfmt_misc.c                                       |    6 
 fs/btrfs/extent_io.c                                   |   10 
 fs/btrfs/super.c                                       |    2 
 fs/coredump.c                                          |   66 +
 fs/dcache.c                                            |   37 
 fs/eventpoll.c                                         |   10 
 fs/exec.c                                              |  145 +--
 fs/ext4/mballoc.c                                      |   14 
 fs/ext4/readpage.c                                     |    6 
 fs/ext4/super.c                                        |    3 
 fs/f2fs/data.c                                         |   13 
 fs/file_table.c                                        |   47 -
 fs/inode.c                                             |   39 
 fs/jbd2/journal.c                                      |    2 
 fs/locks.c                                             |   34 
 fs/mpage.c                                             |    7 
 fs/namei.c                                             |   58 +
 fs/namespace.c                                         |   24 
 fs/notify/dnotify/dnotify.c                            |   21 
 fs/notify/fanotify/fanotify_user.c                     |   10 
 fs/notify/inotify/inotify_user.c                       |   11 
 fs/ntfs3/ntfs_fs.h                                     |    1 
 fs/ocfs2/stackglue.c                                   |   25 
 fs/ocfs2/super.c                                       |    2 
 fs/pipe.c                                              |   64 +
 fs/proc/generic.c                                      |    6 
 fs/proc/inode.c                                        |    1 
 fs/proc/internal.h                                     |    5 
 fs/proc/proc_net.c                                     |    8 
 fs/proc/proc_sysctl.c                                  |   67 +
 fs/super.c                                             |    3 
 fs/sysctls.c                                           |   47 -
 include/linux/aio.h                                    |    4 
 include/linux/cleancache.h                             |  124 --
 include/linux/coredump.h                               |   10 
 include/linux/dcache.h                                 |   10 
 include/linux/dnotify.h                                |    1 
 include/linux/fanotify.h                               |    2 
 include/linux/frontswap.h                              |   35 
 include/linux/fs.h                                     |   18 
 include/linux/inotify.h                                |    3 
 include/linux/kprobes.h                                |    6 
 include/linux/migrate.h                                |    2 
 include/linux/mount.h                                  |    3 
 include/linux/pipe_fs_i.h                              |    4 
 include/linux/poll.h                                   |    2 
 include/linux/printk.h                                 |    4 
 include/linux/proc_fs.h                                |   17 
 include/linux/ref_tracker.h                            |    2 
 include/linux/rwlock.h                                 |    6 
 include/linux/rwlock_api_smp.h                         |    8 
 include/linux/rwlock_rt.h                              |   10 
 include/linux/sched/sysctl.h                           |   14 
 include/linux/seq_file.h                               |    2 
 include/linux/shmem_fs.h                               |    3 
 include/linux/spinlock_api_up.h                        |    1 
 include/linux/stackdepot.h                             |   25 
 include/linux/stackleak.h                              |    5 
 include/linux/swapfile.h                               |    3 
 include/linux/sysctl.h                                 |   67 +
 include/scsi/sg.h                                      |    4 
 init/main.c                                            |    9 
 ipc/util.c                                             |    2 
 kernel/hung_task.c                                     |   81 +
 kernel/irq/proc.c                                      |    8 
 kernel/kprobes.c                                       |   30 
 kernel/locking/spinlock.c                              |   10 
 kernel/locking/spinlock_rt.c                           |   12 
 kernel/printk/Makefile                                 |    5 
 kernel/printk/internal.h                               |    8 
 kernel/printk/printk.c                                 |    4 
 kernel/printk/sysctl.c                                 |   85 +
 kernel/resource.c                                      |    4 
 kernel/stackleak.c                                     |   26 
 kernel/sysctl.c                                        |  790 +----------------
 kernel/watchdog.c                                      |  101 ++
 lib/Kconfig                                            |    4 
 lib/Kconfig.kasan                                      |    2 
 lib/stackdepot.c                                       |   46 
 lib/test_sysctl.c                                      |   22 
 mm/Kconfig                                             |   40 
 mm/Makefile                                            |    1 
 mm/cleancache.c                                        |  315 ------
 mm/filemap.c                                           |  102 +-
 mm/frontswap.c                                         |  259 -----
 mm/kasan/common.c                                      |    1 
 mm/migrate.c                                           |   38 
 mm/page_owner.c                                        |    2 
 mm/shmem.c                                             |   33 
 mm/swapfile.c                                          |   90 -
 mm/truncate.c                                          |   15 
 mm/zsmalloc.c                                          |  557 ++++-------
 mm/zswap.c                                             |    8 
 net/atm/proc.c                                         |    4 
 net/bluetooth/af_bluetooth.c                           |    8 
 net/can/bcm.c                                          |    2 
 net/can/proc.c                                         |    2 
 net/core/neighbour.c                                   |    6 
 net/core/pktgen.c                                      |    6 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                     |    6 
 net/ipv4/raw.c                                         |    8 
 net/ipv4/tcp_ipv4.c                                    |    2 
 net/ipv4/udp.c                                         |    6 
 net/netfilter/x_tables.c                               |   10 
 net/netfilter/xt_hashlimit.c                           |   18 
 net/netfilter/xt_recent.c                              |    4 
 net/sunrpc/auth_gss/svcauth_gss.c                      |    4 
 net/sunrpc/cache.c                                     |   24 
 net/sunrpc/stats.c                                     |    2 
 sound/core/info.c                                      |    4 
 172 files changed, 1877 insertions(+), 2931 deletions(-)

