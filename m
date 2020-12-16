Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B83C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BBBC23124
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgLPEmi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgLPEmh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:42:37 -0500
Date:   Tue, 15 Dec 2020 20:41:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093717;
        bh=VIhLP/YucxU1EYD05RaCZEpL7VZN9ahSDVR+nIU9bNQ=;
        h=From:To:Cc:Subject:From;
        b=whtd3ioPkgo374CL3mJzWKUv62vBv6EntXd6mMNfGDDjbSE5QJbyzNJRtTV0+fpf/
         PP5BkQvIJE958X7g4yrIYueK3sQaF9jtyj9yiCn/fxP3OSEG1I4aVFCMBd5m1uu+nC
         S3ADmqTgIGs1zBom15H5Z8lsS+L9E7bXcTk/pWik=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


- lots of little subsystems

- a few post-linux-next MM material.  Most of this awaits more merging
  of other trees.


95 patches, based on 489e9fea66f31086f85d9a18e61e4791d94a56a4.

Subsystems affected by this patch series:

  mm/swap
  mm/memory-hotplug
  alpha
  procfs
  misc
  core-kernel
  bitmap
  lib
  lz4
  bitops
  checkpatch
  nilfs
  kdump
  rapidio
  gcov
  bfs
  relay
  resource
  ubsan
  reboot
  fault-injection
  lzo
  apparmor
  mm/pagemap
  mm/cleanups
  mm/gup

Subsystem: mm/swap

    Zhaoyang Huang <huangzhaoyang@gmail.com>:
      mm: fix a race on nr_swap_pages

Subsystem: mm/memory-hotplug

    Laurent Dufour <ldufour@linux.ibm.com>:
      mm/memory_hotplug: quieting offline operation

Subsystem: alpha

    Thomas Gleixner <tglx@linutronix.de>:
      alpha: replace bogus in_interrupt()

Subsystem: procfs

    Randy Dunlap <rdunlap@infradead.org>:
      procfs: delete duplicated words + other fixes

    Anand K Mistry <amistry@google.com>:
      proc: provide details on indirect branch speculation

    Alexey Dobriyan <adobriyan@gmail.com>:
      proc: fix lookup in /proc/net subdirectories after setns(2)

    Hui Su <sh_def@163.com>:
      fs/proc: make pde_get() return nothing

Subsystem: misc

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      asm-generic: force inlining of get_order() to work around gcc10 poor decision

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      kernel.h: split out mathematical helpers

Subsystem: core-kernel

    Hui Su <sh_def@163.com>:
      kernel/acct.c: use #elif instead of #end and #elif

Subsystem: bitmap

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      include/linux/bitmap.h: convert bitmap_empty() / bitmap_full() to return boolean

    "Ma, Jianpeng" <jianpeng.ma@intel.com>:
      bitmap: remove unused function declaration

Subsystem: lib

    Geert Uytterhoeven <geert@linux-m68k.org>:
      lib/test_free_pages.c: add basic progress indicators

    "Gustavo A. R. Silva" <gustavoars@kernel.org>:
    Patch series "] lib/stackdepot.c: Replace one-element array with flexible-array member":
      lib/stackdepot.c: replace one-element array with flexible-array member
      lib/stackdepot.c: use flex_array_size() helper in memcpy()
      lib/stackdepot.c: use array_size() helper in jhash2()

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      lib/test_lockup.c: minimum fix to get it compiled on PREEMPT_RT

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      lib/list_kunit: follow new file name convention for KUnit tests
      lib/linear_ranges_kunit: follow new file name convention for KUnit tests
      lib/bits_kunit: follow new file name convention for KUnit tests
      lib/cmdline: fix get_option() for strings starting with hyphen
      lib/cmdline: allow NULL to be an output for get_option()
      lib/cmdline_kunit: add a new test suite for cmdline API

    Jakub Jelinek <jakub@redhat.com>:
      ilog2: improve ilog2 for constant arguments

    Nick Desaulniers <ndesaulniers@google.com>:
      lib/string: remove unnecessary #undefs

    Daniel Axtens <dja@axtens.net>:
    Patch series "Fortify strscpy()", v7:
      lib: string.h: detect intra-object overflow in fortified string functions
      lkdtm: tests for FORTIFY_SOURCE

    Francis Laniel <laniel_francis@privacyrequired.com>:
      string.h: add FORTIFY coverage for strscpy()
      drivers/misc/lkdtm: add new file in LKDTM to test fortified strscpy
      drivers/misc/lkdtm/lkdtm.h: correct wrong filenames in comment

    Alexey Dobriyan <adobriyan@gmail.com>:
      lib: cleanup kstrto*() usage

Subsystem: lz4

    Gao Xiang <hsiangkao@redhat.com>:
      lib/lz4: explicitly support in-place decompression

Subsystem: bitops

    Syed Nayyar Waris <syednwaris@gmail.com>:
    Patch series "Introduce the for_each_set_clump macro", v12:
      bitops: introduce the for_each_set_clump macro
      lib/test_bitmap.c: add for_each_set_clump test cases
      gpio: thunderx: utilize for_each_set_clump macro
      gpio: xilinx: utilize generic bitmap_get_value and _set_value

Subsystem: checkpatch

    Dwaipayan Ray <dwaipayanray1@gmail.com>:
      checkpatch: add new exception to repeated word check

    Aditya Srivastava <yashsri421@gmail.com>:
      checkpatch: fix false positives in REPEATED_WORD warning

    Łukasz Stelmach <l.stelmach@samsung.com>:
      checkpatch: ignore generated CamelCase defines and enum values

    Joe Perches <joe@perches.com>:
      checkpatch: prefer static const declarations
      checkpatch: allow --fix removal of unnecessary break statements

    Dwaipayan Ray <dwaipayanray1@gmail.com>:
      checkpatch: extend attributes check to handle more patterns

    Tom Rix <trix@redhat.com>:
      checkpatch: add a fixer for missing newline at eof

    Joe Perches <joe@perches.com>:
      checkpatch: update __attribute__((section("name"))) quote removal

    Aditya Srivastava <yashsri421@gmail.com>:
      checkpatch: add fix option for GERRIT_CHANGE_ID

    Joe Perches <joe@perches.com>:
      checkpatch: add __alias and __weak to suggested __attribute__ conversions

    Dwaipayan Ray <dwaipayanray1@gmail.com>:
      checkpatch: improve email parsing
      checkpatch: fix spelling errors and remove repeated word

    Aditya Srivastava <yashsri421@gmail.com>:
      checkpatch: avoid COMMIT_LOG_LONG_LINE warning for signature tags

    Dwaipayan Ray <dwaipayanray1@gmail.com>:
      checkpatch: fix unescaped left brace

    Aditya Srivastava <yashsri421@gmail.com>:
      checkpatch: add fix option for ASSIGNMENT_CONTINUATIONS
      checkpatch: add fix option for LOGICAL_CONTINUATIONS
      checkpatch: add fix and improve warning msg for non-standard signature

    Dwaipayan Ray <dwaipayanray1@gmail.com>:
      checkpatch: add warning for unnecessary use of %h[xudi] and %hh[xudi]
      checkpatch: add warning for lines starting with a '#' in commit log
      checkpatch: fix TYPO_SPELLING check for words with apostrophe

    Joe Perches <joe@perches.com>:
      checkpatch: add printk_once and printk_ratelimit to prefer pr_<level> warning

Subsystem: nilfs

    Alex Shi <alex.shi@linux.alibaba.com>:
      fs/nilfs2: remove some unused macros to tame gcc

Subsystem: kdump

    Alexander Egorenkov <egorenar@linux.ibm.com>:
      kdump: append uts_namespace.name offset to VMCOREINFO

Subsystem: rapidio

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      rapidio: remove unused rio_get_asm() and rio_get_device()

Subsystem: gcov

    Nick Desaulniers <ndesaulniers@google.com>:
      gcov: remove support for GCC < 4.9

    Alex Shi <alex.shi@linux.alibaba.com>:
      gcov: fix kernel-doc markup issue

Subsystem: bfs

    Randy Dunlap <rdunlap@infradead.org>:
      bfs: don't use WARNING: string when it's just info.

Subsystem: relay

    Jani Nikula <jani.nikula@intel.com>:
    Patch series "relay: cleanup and const callbacks", v2:
      relay: remove unused buf_mapped and buf_unmapped callbacks
      relay: require non-NULL callbacks in relay_open()
      relay: make create_buf_file and remove_buf_file callbacks mandatory
      relay: allow the use of const callback structs
      drm/i915: make relay callbacks const
      ath10k: make relay callbacks const
      ath11k: make relay callbacks const
      ath9k: make relay callbacks const
      blktrace: make relay callbacks const

Subsystem: resource

    Mauro Carvalho Chehab <mchehab+huawei@kernel.org>:
      kernel/resource.c: fix kernel-doc markups

Subsystem: ubsan

    Kees Cook <keescook@chromium.org>:
    Patch series "Clean up UBSAN Makefile", v2:
      ubsan: remove redundant -Wno-maybe-uninitialized
      ubsan: move cc-option tests into Kconfig
      ubsan: disable object-size sanitizer under GCC
      ubsan: disable UBSAN_TRAP for all*config
      ubsan: enable for all*config builds
      ubsan: remove UBSAN_MISC in favor of individual options
      ubsan: expand tests and reporting

    Dmitry Vyukov <dvyukov@google.com>:
      kcov: don't instrument with UBSAN

    Zou Wei <zou_wei@huawei.com>:
      lib/ubsan.c: mark type_check_kinds with static keyword

Subsystem: reboot

    Matteo Croce <mcroce@microsoft.com>:
      reboot: refactor and comment the cpu selection code
      reboot: allow to specify reboot mode via sysfs
      reboot: remove cf9_safe from allowed types and rename cf9_force
    Patch series "reboot: sysfs improvements":
      reboot: allow to override reboot type if quirks are found
      reboot: hide from sysfs not applicable settings

Subsystem: fault-injection

    Barnabás Pőcze <pobrn@protonmail.com>:
      fault-injection: handle EI_ETYPE_TRUE

Subsystem: lzo

    Jason Yan <yanaijie@huawei.com>:
      lib/lzo/lzo1x_compress.c: make lzogeneric1x_1_compress() static

Subsystem: apparmor

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      apparmor: remove duplicate macro list_entry_is_head()

Subsystem: mm/pagemap

    Christoph Hellwig <hch@lst.de>:
    Patch series "simplify follow_pte a bit":
      mm: unexport follow_pte_pmd
      mm: simplify follow_pte{,pmd}

Subsystem: mm/cleanups

    Haitao Shi <shihaitao1@huawei.com>:
      mm: fix some spelling mistakes in comments

Subsystem: mm/gup

    Jann Horn <jannh@google.com>:
      mmap locking API: don't check locking if the mm isn't live yet
      mm/gup: assert that the mmap lock is held in __get_user_pages()

 Documentation/ABI/testing/sysfs-kernel-reboot    |   32 
 Documentation/admin-guide/kdump/vmcoreinfo.rst   |    6 
 Documentation/dev-tools/ubsan.rst                |    1 
 Documentation/filesystems/proc.rst               |    2 
 MAINTAINERS                                      |    5 
 arch/alpha/kernel/process.c                      |    2 
 arch/powerpc/kernel/vmlinux.lds.S                |    4 
 arch/s390/pci/pci_mmio.c                         |    4 
 drivers/gpio/gpio-thunderx.c                     |   11 
 drivers/gpio/gpio-xilinx.c                       |   61 -
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c       |    2 
 drivers/misc/lkdtm/Makefile                      |    1 
 drivers/misc/lkdtm/bugs.c                        |   50 +
 drivers/misc/lkdtm/core.c                        |    3 
 drivers/misc/lkdtm/fortify.c                     |   82 ++
 drivers/misc/lkdtm/lkdtm.h                       |   19 
 drivers/net/wireless/ath/ath10k/spectral.c       |    2 
 drivers/net/wireless/ath/ath11k/spectral.c       |    2 
 drivers/net/wireless/ath/ath9k/common-spectral.c |    2 
 drivers/rapidio/rio.c                            |   81 --
 fs/bfs/inode.c                                   |    2 
 fs/dax.c                                         |    9 
 fs/exec.c                                        |    8 
 fs/nfs/callback_proc.c                           |    5 
 fs/nilfs2/segment.c                              |    5 
 fs/proc/array.c                                  |   28 
 fs/proc/base.c                                   |    2 
 fs/proc/generic.c                                |   24 
 fs/proc/internal.h                               |   10 
 fs/proc/proc_net.c                               |   20 
 include/asm-generic/bitops/find.h                |   19 
 include/asm-generic/getorder.h                   |    2 
 include/linux/bitmap.h                           |   67 +-
 include/linux/bitops.h                           |   24 
 include/linux/dcache.h                           |    1 
 include/linux/iommu-helper.h                     |    4 
 include/linux/kernel.h                           |  173 -----
 include/linux/log2.h                             |    3 
 include/linux/math.h                             |  177 +++++
 include/linux/mm.h                               |    6 
 include/linux/mm_types.h                         |   10 
 include/linux/mmap_lock.h                        |   16 
 include/linux/proc_fs.h                          |    8 
 include/linux/rcu_node_tree.h                    |    2 
 include/linux/relay.h                            |   29 
 include/linux/rio_drv.h                          |    3 
 include/linux/string.h                           |   75 +-
 include/linux/units.h                            |    2 
 kernel/Makefile                                  |    3 
 kernel/acct.c                                    |    7 
 kernel/crash_core.c                              |    1 
 kernel/fail_function.c                           |    6 
 kernel/gcov/gcc_4_7.c                            |   10 
 kernel/reboot.c                                  |  308 ++++++++-
 kernel/relay.c                                   |  111 ---
 kernel/resource.c                                |   24 
 kernel/trace/blktrace.c                          |    2 
 lib/Kconfig.debug                                |   11 
 lib/Kconfig.ubsan                                |  154 +++-
 lib/Makefile                                     |    7 
 lib/bits_kunit.c                                 |   75 ++
 lib/cmdline.c                                    |   20 
 lib/cmdline_kunit.c                              |  100 +++
 lib/errname.c                                    |    1 
 lib/error-inject.c                               |    2 
 lib/errseq.c                                     |    1 
 lib/find_bit.c                                   |   17 
 lib/linear_ranges_kunit.c                        |  228 +++++++
 lib/list-test.c                                  |  748 -----------------------
 lib/list_kunit.c                                 |  748 +++++++++++++++++++++++
 lib/lz4/lz4_decompress.c                         |    6 
 lib/lz4/lz4defs.h                                |    1 
 lib/lzo/lzo1x_compress.c                         |    2 
 lib/math/div64.c                                 |    4 
 lib/math/int_pow.c                               |    2 
 lib/math/int_sqrt.c                              |    3 
 lib/math/reciprocal_div.c                        |    9 
 lib/stackdepot.c                                 |   11 
 lib/string.c                                     |    4 
 lib/test_bitmap.c                                |  143 ++++
 lib/test_bits.c                                  |   75 --
 lib/test_firmware.c                              |    9 
 lib/test_free_pages.c                            |    5 
 lib/test_kmod.c                                  |   26 
 lib/test_linear_ranges.c                         |  228 -------
 lib/test_lockup.c                                |   16 
 lib/test_ubsan.c                                 |   74 ++
 lib/ubsan.c                                      |    2 
 mm/filemap.c                                     |    2 
 mm/gup.c                                         |    2 
 mm/huge_memory.c                                 |    2 
 mm/khugepaged.c                                  |    2 
 mm/memblock.c                                    |    2 
 mm/memory.c                                      |   36 -
 mm/memory_hotplug.c                              |    2 
 mm/migrate.c                                     |    2 
 mm/page_ext.c                                    |    2 
 mm/swapfile.c                                    |   11 
 scripts/Makefile.ubsan                           |   49 -
 scripts/checkpatch.pl                            |  495 +++++++++++----
 security/apparmor/apparmorfs.c                   |    3 
 tools/testing/selftests/lkdtm/tests.txt          |    1 
 102 files changed, 3022 insertions(+), 1899 deletions(-)

