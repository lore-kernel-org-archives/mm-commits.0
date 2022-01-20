Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E4EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiATCHS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:07:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40678 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCHR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:07:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B6AB6157F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E51C004E1;
        Thu, 20 Jan 2022 02:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644436;
        bh=mulVBsKU4FSNdSGqNtD+T5V0bApsavOJwKDVB8Yt7zY=;
        h=Date:From:To:Cc:Subject:From;
        b=m/U6pjZ/YaZ2L/0KYD6zatmEyytgv36If/s/rp53Nybz+5Q4g10VOlR41fRuP9I3O
         /lCbkdCSxy0KhSOYD8laCcxQAoYL/c7tX2K3C7HKKRhhI3w5T5gWSqVSR9IfEFFTEO
         73949hr9UB8ocG/T+IZD58UjvfUsdKQxhKk+3Xe0=
Date:   Wed, 19 Jan 2022 18:07:14 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

55 patches, based on df0cc57e057f18e44dac8e6c18aba47ab53202f9 ("Linux 5.16")

Subsystems affected by this patch series:

  percpu
  procfs
  sysctl
  misc
  core-kernel
  get_maintainer
  lib
  checkpatch
  binfmt
  nilfs2
  hfs
  fat
  adfs
  panic
  delayacct
  kconfig
  kcov
  ubsan

Subsystem: percpu

    Kefeng Wang <wangkefeng.wang@huawei.com>:
    Patch series "mm: percpu: Cleanup percpu first chunk function":
      mm: percpu: generalize percpu related config
      mm: percpu: add pcpu_fc_cpu_to_node_fn_t typedef
      mm: percpu: add generic pcpu_fc_alloc/free funciton
      mm: percpu: add generic pcpu_populate_pte() function

Subsystem: procfs

    David Hildenbrand <david@redhat.com>:
      proc/vmcore: don't fake reading zeroes on surprise vmcore_cb unregistration

    Hans de Goede <hdegoede@redhat.com>:
      proc: make the proc_create[_data]() stubs static inlines

    Qi Zheng <zhengqi.arch@bytedance.com>:
      proc: convert the return type of proc_fd_access_allowed() to be boolean

Subsystem: sysctl

    Geert Uytterhoeven <geert+renesas@glider.be>:
      sysctl: fix duplicate path separator in printed entries

    luo penghao <luo.penghao@zte.com.cn>:
      sysctl: remove redundant ret assignment

Subsystem: misc

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      include/linux/unaligned: replace kernel.h with the necessary inclusions
      kernel.h: include a note to discourage people from including it in headers

Subsystem: core-kernel

    Yafang Shao <laoar.shao@gmail.com>:
    Patch series "task comm cleanups", v2:
      fs/exec: replace strlcpy with strscpy_pad in __set_task_comm
      fs/exec: replace strncpy with strscpy_pad in __get_task_comm
      drivers/infiniband: replace open-coded string copy with get_task_comm
      fs/binfmt_elf: replace open-coded string copy with get_task_comm
      samples/bpf/test_overhead_kprobe_kern: replace bpf_probe_read_kernel with bpf_probe_read_kernel_str to get task comm
      tools/bpf/bpftool/skeleton: replace bpf_probe_read_kernel with bpf_probe_read_kernel_str to get task comm
      tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN
      kthread: dynamically allocate memory to store kthread's full name

    Davidlohr Bueso <dave@stgolabs.net>:
      kernel/sys.c: only take tasklist_lock for get/setpriority(PRIO_PGRP)

Subsystem: get_maintainer

    Randy Dunlap <rdunlap@infradead.org>:
      get_maintainer: don't remind about no git repo when --nogit is used

Subsystem: lib

    Alexey Dobriyan <adobriyan@gmail.com>:
      kstrtox: uninline everything

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      list: introduce list_is_head() helper and re-use it in list.h

    Zhen Lei <thunder.leizhen@huawei.com>:
      lib/list_debug.c: print more list debugging context in __list_del_entry_valid()

    Isabella Basso <isabbasso@riseup.net>:
    Patch series "test_hash.c: refactor into KUnit", v3:
      hash.h: remove unused define directive
      test_hash.c: split test_int_hash into arch-specific functions
      test_hash.c: split test_hash_init
      lib/Kconfig.debug: properly split hash test kernel entries
      test_hash.c: refactor into kunit

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      kunit: replace kernel.h with the necessary inclusions
      uuid: discourage people from using UAPI header in new code
      uuid: remove licence boilerplate text from the header

    Andrey Konovalov <andreyknvl@google.com>:
      lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test

Subsystem: checkpatch

    Jerome Forissier <jerome@forissier.org>:
      checkpatch: relax regexp for COMMIT_LOG_LONG_LINE

    Joe Perches <joe@perches.com>:
      checkpatch: improve Kconfig help test

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      const_structs.checkpatch: add frequently used ops structs

Subsystem: binfmt

    "H.J. Lu" <hjl.tools@gmail.com>:
      fs/binfmt_elf: use PT_LOAD p_align values for static PIE

Subsystem: nilfs2

    Colin Ian King <colin.i.king@gmail.com>:
      nilfs2: remove redundant pointer sbufs

Subsystem: hfs

    Kees Cook <keescook@chromium.org>:
      hfsplus: use struct_group_attr() for memcpy() region

Subsystem: fat

    "NeilBrown" <neilb@suse.de>:
       FAT: use io_schedule_timeout() instead of congestion_wait()

Subsystem: adfs

    Minghao Chi <chi.minghao@zte.com.cn>:
      fs/adfs: remove unneeded variable make code cleaner

Subsystem: panic

    Marco Elver <elver@google.com>:
      panic: use error_report_end tracepoint on warnings

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      panic: remove oops_id

Subsystem: delayacct

    Yang Yang <yang.yang29@zte.com.cn>:
      delayacct: support swapin delay accounting for swapping without blkio
      delayacct: fix incomplete disable operation when switch enable to disable
      delayacct: cleanup flags in struct task_delay_info and functions use it

    wangyong <wang.yong12@zte.com.cn>:
      Documentation/accounting/delay-accounting.rst: add thrashing page cache and direct compact
      delayacct: track delays from memory compact

Subsystem: kconfig

    Qian Cai <quic_qiancai@quicinc.com>:
      configs: introduce debug.config for CI-like setup

    Nathan Chancellor <nathan@kernel.org>:
    Patch series "Fix CONFIG_TEST_KMOD with 256kB page size":
      arch/Kconfig: split PAGE_SIZE_LESS_THAN_256KB from PAGE_SIZE_LESS_THAN_64KB
      btrfs: use generic Kconfig option for 256kB page size limit
      lib/Kconfig.debug: make TEST_KMOD depend on PAGE_SIZE_LESS_THAN_256KB

Subsystem: kcov

    Marco Elver <elver@google.com>:
      kcov: fix generic Kconfig dependencies if ARCH_WANTS_NO_INSTR

Subsystem: ubsan

    Kees Cook <keescook@chromium.org>:
      ubsan: remove CONFIG_UBSAN_OBJECT_SIZE

    Colin Ian King <colin.i.king@gmail.com>:
      lib: remove redundant assignment to variable ret

 Documentation/accounting/delay-accounting.rst           |   63 +-
 arch/Kconfig                                            |    4 
 arch/arm64/Kconfig                                      |   20 
 arch/ia64/Kconfig                                       |    9 
 arch/mips/Kconfig                                       |   10 
 arch/mips/mm/init.c                                     |   28 -
 arch/powerpc/Kconfig                                    |   17 
 arch/powerpc/kernel/setup_64.c                          |  113 ----
 arch/riscv/Kconfig                                      |   10 
 arch/sparc/Kconfig                                      |   12 
 arch/sparc/kernel/led.c                                 |    8 
 arch/sparc/kernel/smp_64.c                              |  119 -----
 arch/x86/Kconfig                                        |   19 
 arch/x86/kernel/setup_percpu.c                          |   82 ---
 drivers/base/arch_numa.c                                |   78 ---
 drivers/infiniband/hw/qib/qib.h                         |    2 
 drivers/infiniband/hw/qib/qib_file_ops.c                |    2 
 drivers/infiniband/sw/rxe/rxe_qp.c                      |    3 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c |    2 
 fs/adfs/inode.c                                         |    4 
 fs/binfmt_elf.c                                         |    6 
 fs/btrfs/Kconfig                                        |    3 
 fs/exec.c                                               |    5 
 fs/fat/file.c                                           |    5 
 fs/hfsplus/hfsplus_raw.h                                |   12 
 fs/hfsplus/xattr.c                                      |    4 
 fs/nilfs2/page.c                                        |    4 
 fs/proc/array.c                                         |    3 
 fs/proc/base.c                                          |    4 
 fs/proc/proc_sysctl.c                                   |    9 
 fs/proc/vmcore.c                                        |   10 
 include/kunit/assert.h                                  |    2 
 include/linux/delayacct.h                               |  107 ++--
 include/linux/elfcore-compat.h                          |    5 
 include/linux/elfcore.h                                 |    5 
 include/linux/hash.h                                    |    5 
 include/linux/kernel.h                                  |    9 
 include/linux/kthread.h                                 |    1 
 include/linux/list.h                                    |   36 -
 include/linux/percpu.h                                  |   21 
 include/linux/proc_fs.h                                 |   12 
 include/linux/sched.h                                   |    9 
 include/linux/unaligned/packed_struct.h                 |    2 
 include/trace/events/error_report.h                     |    8 
 include/uapi/linux/taskstats.h                          |    6 
 include/uapi/linux/uuid.h                               |   10 
 kernel/configs/debug.config                             |  105 ++++
 kernel/delayacct.c                                      |   49 +-
 kernel/kthread.c                                        |   32 +
 kernel/panic.c                                          |   21 
 kernel/sys.c                                            |   16 
 lib/Kconfig.debug                                       |   45 +
 lib/Kconfig.ubsan                                       |   13 
 lib/Makefile                                            |    5 
 lib/asn1_encoder.c                                      |    2 
 lib/kstrtox.c                                           |   12 
 lib/list_debug.c                                        |    8 
 lib/lz4/lz4defs.h                                       |    2 
 lib/test_hash.c                                         |  375 +++++++---------
 lib/test_meminit.c                                      |    1 
 lib/test_ubsan.c                                        |   22 
 mm/Kconfig                                              |   12 
 mm/memory.c                                             |    4 
 mm/page_alloc.c                                         |    3 
 mm/page_io.c                                            |    3 
 mm/percpu.c                                             |  168 +++++--
 samples/bpf/offwaketime_kern.c                          |    4 
 samples/bpf/test_overhead_kprobe_kern.c                 |   11 
 samples/bpf/test_overhead_tp_kern.c                     |    5 
 scripts/Makefile.ubsan                                  |    1 
 scripts/checkpatch.pl                                   |   54 +-
 scripts/const_structs.checkpatch                        |   23 
 scripts/get_maintainer.pl                               |    2 
 tools/accounting/getdelays.c                            |    8 
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c               |    4 
 tools/include/linux/hash.h                              |    5 
 tools/testing/selftests/bpf/progs/test_stacktrace_map.c |    6 
 tools/testing/selftests/bpf/progs/test_tracepoint.c     |    6 
 78 files changed, 943 insertions(+), 992 deletions(-)

