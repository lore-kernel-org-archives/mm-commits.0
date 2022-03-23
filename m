Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B062C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242839AbiCWXG3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiCWXG2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:06:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E154643A
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D96C4B8214D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D8DC340E8;
        Wed, 23 Mar 2022 23:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076694;
        bh=LdFKW8des/Nka2guPIHeyBOnY9n18eUwWTw5CzLykLs=;
        h=Date:From:To:Cc:Subject:From;
        b=Dd+w+NcgSwTwA3dqpuFPv93Q3kDrRzb6/QKry1YNjWxgdZ6LuKBTvAGP2MBZPpI8p
         qF47YRMuDmpxw+DW+WOh8CdP2tv5XsXPw/fm2uaQ5y8Mlf9VPM+4PrQPooI4897bm4
         STerGZOWjob6dGBj11ajQ8eEqCNfdG3yzdd7/3kk=
Date:   Wed, 23 Mar 2022 16:04:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Various misc subsystems, before getting into the post-linux-next material.

This is all based on v5.17.  I tested applying and compiling against
today's 1bc191051dca28fa6.  One patch required an extra whack, all
looks good.


41 patches, based on f443e374ae131c168a065ea1748feac6b2e76613.

Subsystems affected by this patch series:

  procfs
  misc
  core-kernel
  lib
  checkpatch
  init
  pipe
  minix
  fat
  cgroups
  kexec
  kdump
  taskstats
  panic
  kcov
  resource
  ubsan

Subsystem: procfs

    Hao Lee <haolee.swjtu@gmail.com>:
      proc: alloc PATH_MAX bytes for /proc/${pid}/fd/ symlinks

    David Hildenbrand <david@redhat.com>:
      proc/vmcore: fix possible deadlock on concurrent mmap and read

    Yang Li <yang.lee@linux.alibaba.com>:
      proc/vmcore: fix vmcore_alloc_buf() kernel-doc comment

Subsystem: misc

    Bjorn Helgaas <bhelgaas@google.com>:
      linux/types.h: remove unnecessary __bitwise__
      Documentation/sparse: add hints about __CHECKER__

Subsystem: core-kernel

    Miaohe Lin <linmiaohe@huawei.com>:
      kernel/ksysfs.c: use helper macro __ATTR_RW

Subsystem: lib

    Kees Cook <keescook@chromium.org>:
      Kconfig.debug: make DEBUG_INFO selectable from a choice

    Rasmus Villemoes <linux@rasmusvillemoes.dk>:
      include: drop pointless __compiler_offsetof indirection

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      ilog2: force inlining of __ilog2_u32() and __ilog2_u64()

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      bitfield: add explicit inclusions to the example

    Feng Tang <feng.tang@intel.com>:
      lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option

    Randy Dunlap <rdunlap@infradead.org>:
      lib: bitmap: fix many kernel-doc warnings

Subsystem: checkpatch

    Joe Perches <joe@perches.com>:
      checkpatch: prefer MODULE_LICENSE("GPL") over MODULE_LICENSE("GPL v2")
      checkpatch: add --fix option for some TRAILING_STATEMENTS
      checkpatch: add early_param exception to blank line after struct/function test

    Sagar Patel <sagarmp@cs.unc.edu>:
      checkpatch: use python3 to find codespell dictionary

Subsystem: init

    Mark-PK Tsai <mark-pk.tsai@mediatek.com>:
      init: use ktime_us_delta() to make initcall_debug log more precise

    Randy Dunlap <rdunlap@infradead.org>:
      init.h: improve __setup and early_param documentation
      init/main.c: return 1 from handled __setup() functions

Subsystem: pipe

    Andrei Vagin <avagin@gmail.com>:
      fs/pipe: use kvcalloc to allocate a pipe_buffer array
      fs/pipe.c: local vars have to match types of proper pipe_inode_info fields

Subsystem: minix

    Qinghua Jin <qhjin.dev@gmail.com>:
      minix: fix bug when opening a file with O_DIRECT

Subsystem: fat

    Helge Deller <deller@gmx.de>:
      fat: use pointer to simple type in put_user()

Subsystem: cgroups

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      cgroup: use irqsave in cgroup_rstat_flush_locked().
cgroup: add a comment to cgroup_rstat_flush_locked().

Subsystem: kexec

    Jisheng Zhang <jszhang@kernel.org>:
    Patch series "kexec: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef", v2:
      kexec: make crashk_res, crashk_low_res and crash_notes symbols always visible
      riscv: mm: init: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
      x86/setup: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
      arm64: mm: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef

Subsystem: kdump

    Tiezhu Yang <yangtiezhu@loongson.cn>:
    Patch series "Update doc and fix some issues about kdump", v2:
      docs: kdump: update description about sysfs file system support
      docs: kdump: add scp example to write out the dump file
      panic: unset panic_on_warn inside panic()
      ubsan: no need to unset panic_on_warn in ubsan_epilogue()
      kasan: no need to unset panic_on_warn in end_report()

Subsystem: taskstats

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
      taskstats: remove unneeded dead assignment

Subsystem: panic

    "Guilherme G. Piccoli" <gpiccoli@igalia.com>:
    Patch series "Some improvements on panic_print":
      docs: sysctl/kernel: add missing bit to panic_print
      panic: add option to dump all CPUs backtraces in panic_print
      panic: move panic_print before kmsg dumpers

Subsystem: kcov

    Aleksandr Nogikh <nogikh@google.com>:
    Patch series "kcov: improve mmap processing", v3:
      kcov: split ioctl handling into locked and unlocked parts
      kcov: properly handle subsequent mmap calls

Subsystem: resource

    Miaohe Lin <linmiaohe@huawei.com>:
      kernel/resource: fix kfree() of bootmem memory again

Subsystem: ubsan

    Marco Elver <elver@google.com>:
      Revert "ubsan, kcsan: Don't combine sanitizer with kcov on clang"

 Documentation/admin-guide/kdump/kdump.rst       |   10 +
 Documentation/admin-guide/kernel-parameters.txt |    5 
 Documentation/admin-guide/sysctl/kernel.rst     |    2 
 Documentation/dev-tools/sparse.rst              |    2 
 arch/arm64/mm/init.c                            |    9 -
 arch/riscv/mm/init.c                            |    6 -
 arch/x86/kernel/setup.c                         |   10 -
 fs/fat/dir.c                                    |    2 
 fs/minix/inode.c                                |    3 
 fs/pipe.c                                       |   13 +-
 fs/proc/base.c                                  |    8 -
 fs/proc/vmcore.c                                |   43 +++----
 include/linux/bitfield.h                        |    3 
 include/linux/compiler_types.h                  |    3 
 include/linux/init.h                            |   11 +
 include/linux/kexec.h                           |   12 +-
 include/linux/log2.h                            |    4 
 include/linux/stddef.h                          |    6 -
 include/uapi/linux/types.h                      |    6 -
 init/main.c                                     |   14 +-
 kernel/cgroup/rstat.c                           |   13 +-
 kernel/kcov.c                                   |  102 ++++++++---------
 kernel/ksysfs.c                                 |    3 
 kernel/panic.c                                  |   37 ++++--
 kernel/resource.c                               |   41 +-----
 kernel/taskstats.c                              |    5 
 lib/Kconfig.debug                               |  142 ++++++++++++------------
 lib/Kconfig.kcsan                               |   11 -
 lib/Kconfig.ubsan                               |   12 --
 lib/bitmap.c                                    |   24 ++--
 lib/ubsan.c                                     |   10 -
 mm/kasan/report.c                               |   10 -
 scripts/checkpatch.pl                           |   31 ++++-
 tools/include/linux/types.h                     |    5 
 34 files changed, 313 insertions(+), 305 deletions(-)

