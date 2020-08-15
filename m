Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD90C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B689C2065C
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529438;
	bh=ld+uh/rBn5w0s8NkGFPmRnq/zr05V9rZJcoYYyKxTFg=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=0DXp5nZeaxYfOnwcNORp42Pnl0ZtwpNoDt39XzloKpOg1aTQ1ez/osvknpYjUahis
	 6/Pz29tbZYwxDGT/AiBmtMvBlSWkz1IYEFeEY8naQQ2LR4Q/LEBGhmbfUlVYKhabtQ
	 jIZU56QmsORceDxQfHMHz32AYqwy3HwaJms9rO2A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgHOWKh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729448AbgHOWKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44ACD2074D;
        Sat, 15 Aug 2020 00:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451380;
        bh=ld+uh/rBn5w0s8NkGFPmRnq/zr05V9rZJcoYYyKxTFg=;
        h=Date:From:To:Cc:Subject:From;
        b=GxI0/LMI80CvDkPZ3snJWHdvHR/v6lx8gw8pIEaBJEo2VjLg9esO4sv8WR55gZPDw
         3teLqQjqxeLhYAptDTCw9cT998gEPY7wGVHrUI6PTsI0d+jDUoN2AJWtTLc3kpe+Gu
         8ZIiLYe0OjjHqhoSEW2258ChPw+qK6pgScpc5BcE=
Date:   Fri, 14 Aug 2020 17:29:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


39 patches, based on b923f1247b72fc100b87792fd2129d026bb10e66.

Subsystems affected by this patch series:

  mm/hotfixes
  lz4
  exec
  mailmap
  mm/thp
  autofs
  mm/madvise
  sysctl
  mm/kmemleak
  mm/misc
  lib

Subsystem: mm/hotfixes

    Mike Rapoport <rppt@linux.ibm.com>:
      asm-generic: pgalloc.h: use correct #ifdef to enable pud_alloc_one()

    Baoquan He <bhe@redhat.com>:
      Revert "mm/vmstat.c: do not show lowmem reserve protection information of empty zone"

Subsystem: lz4

    Nick Terrell <terrelln@fb.com>:
      lz4: fix kernel decompression speed

Subsystem: exec

    Kees Cook <keescook@chromium.org>:
    Patch series "Fix S_ISDIR execve() errno":
      exec: restore EACCES of S_ISDIR execve()
      selftests/exec: add file type errno tests

Subsystem: mailmap

    Greg Kurz <groug@kaod.org>:
      mailmap: add entry for Greg Kurz

Subsystem: mm/thp

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "THP prep patches":
      mm: store compound_nr as well as compound_order
      mm: move page-flags include to top of file
      mm: add thp_order
      mm: add thp_size
      mm: replace hpage_nr_pages with thp_nr_pages
      mm: add thp_head
      mm: introduce offset_in_thp

Subsystem: autofs

    Randy Dunlap <rdunlap@infradead.org>:
      fs: autofs: delete repeated words in comments

Subsystem: mm/madvise

    Minchan Kim <minchan@kernel.org>:
    Patch series "introduce memory hinting API for external process", v8:
      mm/madvise: pass task and mm to do_madvise
      pid: move pidfd_get_pid() to pid.c
      mm/madvise: introduce process_madvise() syscall: an external memory hinting API
      mm/madvise: check fatal signal pending of target process

Subsystem: sysctl

    Xiaoming Ni <nixiaoming@huawei.com>:
      all arch: remove system call sys_sysctl

Subsystem: mm/kmemleak

    Qian Cai <cai@lca.pw>:
      mm/kmemleak: silence KCSAN splats in checksum

Subsystem: mm/misc

    Qian Cai <cai@lca.pw>:
      mm/frontswap: mark various intentional data races
      mm/page_io: mark various intentional data races
      mm/swap_state: mark various intentional data races

    Kirill A. Shutemov <kirill@shutemov.name>:
      mm/filemap.c: fix a data race in filemap_fault()

    Qian Cai <cai@lca.pw>:
      mm/swapfile: fix and annotate various data races
      mm/page_counter: fix various data races at memsw
      mm/memcontrol: fix a data race in scan count
      mm/list_lru: fix a data race in list_lru_count_one
      mm/mempool: fix a data race in mempool_free()
      mm/rmap: annotate a data race at tlb_flush_batched
      mm/swap.c: annotate data races for lru_rotate_pvecs
      mm: annotate a data race in page_zonenum()

    Romain Naour <romain.naour@gmail.com>:
      include/asm-generic/vmlinux.lds.h: align ro_after_init

    Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>:
      sh: clkfwk: remove r8/r16/r32
      sh: use generic strncpy()

Subsystem: lib

    Krzysztof Kozlowski <krzk@kernel.org>:
    Patch series "iomap: Constify ioreadX() iomem argument", v3:
      iomap: constify ioreadX() iomem argument (as in generic implementation)
      rtl818x: constify ioreadX() iomem argument (as in generic implementation)
      ntb: intel: constify ioreadX() iomem argument (as in generic implementation)
      virtio: pci: constify ioreadX() iomem argument (as in generic implementation)

 .mailmap                                               |    1 
 arch/alpha/include/asm/core_apecs.h                    |    6 
 arch/alpha/include/asm/core_cia.h                      |    6 
 arch/alpha/include/asm/core_lca.h                      |    6 
 arch/alpha/include/asm/core_marvel.h                   |    4 
 arch/alpha/include/asm/core_mcpcia.h                   |    6 
 arch/alpha/include/asm/core_t2.h                       |    2 
 arch/alpha/include/asm/io.h                            |   12 -
 arch/alpha/include/asm/io_trivial.h                    |   16 -
 arch/alpha/include/asm/jensen.h                        |    2 
 arch/alpha/include/asm/machvec.h                       |    6 
 arch/alpha/kernel/core_marvel.c                        |    2 
 arch/alpha/kernel/io.c                                 |   12 -
 arch/alpha/kernel/syscalls/syscall.tbl                 |    3 
 arch/arm/configs/am200epdkit_defconfig                 |    1 
 arch/arm/tools/syscall.tbl                             |    3 
 arch/arm64/include/asm/unistd.h                        |    2 
 arch/arm64/include/asm/unistd32.h                      |    6 
 arch/ia64/kernel/syscalls/syscall.tbl                  |    3 
 arch/m68k/kernel/syscalls/syscall.tbl                  |    3 
 arch/microblaze/kernel/syscalls/syscall.tbl            |    3 
 arch/mips/configs/cu1000-neo_defconfig                 |    1 
 arch/mips/kernel/syscalls/syscall_n32.tbl              |    3 
 arch/mips/kernel/syscalls/syscall_n64.tbl              |    3 
 arch/mips/kernel/syscalls/syscall_o32.tbl              |    3 
 arch/parisc/include/asm/io.h                           |    4 
 arch/parisc/kernel/syscalls/syscall.tbl                |    3 
 arch/parisc/lib/iomap.c                                |   72 +++---
 arch/powerpc/kernel/iomap.c                            |   28 +-
 arch/powerpc/kernel/syscalls/syscall.tbl               |    3 
 arch/s390/kernel/syscalls/syscall.tbl                  |    3 
 arch/sh/configs/dreamcast_defconfig                    |    1 
 arch/sh/configs/espt_defconfig                         |    1 
 arch/sh/configs/hp6xx_defconfig                        |    1 
 arch/sh/configs/landisk_defconfig                      |    1 
 arch/sh/configs/lboxre2_defconfig                      |    1 
 arch/sh/configs/microdev_defconfig                     |    1 
 arch/sh/configs/migor_defconfig                        |    1 
 arch/sh/configs/r7780mp_defconfig                      |    1 
 arch/sh/configs/r7785rp_defconfig                      |    1 
 arch/sh/configs/rts7751r2d1_defconfig                  |    1 
 arch/sh/configs/rts7751r2dplus_defconfig               |    1 
 arch/sh/configs/se7206_defconfig                       |    1 
 arch/sh/configs/se7343_defconfig                       |    1 
 arch/sh/configs/se7619_defconfig                       |    1 
 arch/sh/configs/se7705_defconfig                       |    1 
 arch/sh/configs/se7750_defconfig                       |    1 
 arch/sh/configs/se7751_defconfig                       |    1 
 arch/sh/configs/secureedge5410_defconfig               |    1 
 arch/sh/configs/sh03_defconfig                         |    1 
 arch/sh/configs/sh7710voipgw_defconfig                 |    1 
 arch/sh/configs/sh7757lcr_defconfig                    |    1 
 arch/sh/configs/sh7763rdp_defconfig                    |    1 
 arch/sh/configs/shmin_defconfig                        |    1 
 arch/sh/configs/titan_defconfig                        |    1 
 arch/sh/include/asm/string_32.h                        |   26 --
 arch/sh/kernel/iomap.c                                 |   22 -
 arch/sh/kernel/syscalls/syscall.tbl                    |    3 
 arch/sparc/kernel/syscalls/syscall.tbl                 |    3 
 arch/x86/entry/syscalls/syscall_32.tbl                 |    3 
 arch/x86/entry/syscalls/syscall_64.tbl                 |    4 
 arch/xtensa/kernel/syscalls/syscall.tbl                |    3 
 drivers/mailbox/bcm-pdc-mailbox.c                      |    2 
 drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8180.h |    6 
 drivers/ntb/hw/intel/ntb_hw_gen1.c                     |    2 
 drivers/ntb/hw/intel/ntb_hw_gen3.h                     |    2 
 drivers/ntb/hw/intel/ntb_hw_intel.h                    |    2 
 drivers/nvdimm/btt.c                                   |    4 
 drivers/nvdimm/pmem.c                                  |    6 
 drivers/sh/clk/cpg.c                                   |   25 --
 drivers/virtio/virtio_pci_modern.c                     |    6 
 fs/autofs/dev-ioctl.c                                  |    4 
 fs/io_uring.c                                          |    2 
 fs/namei.c                                             |    4 
 include/asm-generic/iomap.h                            |   28 +-
 include/asm-generic/pgalloc.h                          |    2 
 include/asm-generic/vmlinux.lds.h                      |    1 
 include/linux/compat.h                                 |    5 
 include/linux/huge_mm.h                                |   58 ++++-
 include/linux/io-64-nonatomic-hi-lo.h                  |    4 
 include/linux/io-64-nonatomic-lo-hi.h                  |    4 
 include/linux/memcontrol.h                             |    2 
 include/linux/mm.h                                     |   16 -
 include/linux/mm_inline.h                              |    6 
 include/linux/mm_types.h                               |    1 
 include/linux/pagemap.h                                |    6 
 include/linux/pid.h                                    |    1 
 include/linux/syscalls.h                               |    4 
 include/linux/sysctl.h                                 |    6 
 include/uapi/asm-generic/unistd.h                      |    4 
 kernel/Makefile                                        |    2 
 kernel/exit.c                                          |   17 -
 kernel/pid.c                                           |   17 +
 kernel/sys_ni.c                                        |    3 
 kernel/sysctl_binary.c                                 |  171 --------------
 lib/iomap.c                                            |   30 +-
 lib/lz4/lz4_compress.c                                 |    4 
 lib/lz4/lz4_decompress.c                               |   18 -
 lib/lz4/lz4defs.h                                      |   10 
 lib/lz4/lz4hc_compress.c                               |    2 
 mm/compaction.c                                        |    2 
 mm/filemap.c                                           |   22 +
 mm/frontswap.c                                         |    8 
 mm/gup.c                                               |    2 
 mm/internal.h                                          |    4 
 mm/kmemleak.c                                          |    2 
 mm/list_lru.c                                          |    2 
 mm/madvise.c                                           |  190 ++++++++++++++--
 mm/memcontrol.c                                        |   10 
 mm/memory.c                                            |    4 
 mm/memory_hotplug.c                                    |    7 
 mm/mempolicy.c                                         |    2 
 mm/mempool.c                                           |    2 
 mm/migrate.c                                           |   18 -
 mm/mlock.c                                             |    9 
 mm/page_alloc.c                                        |    5 
 mm/page_counter.c                                      |   13 -
 mm/page_io.c                                           |   12 -
 mm/page_vma_mapped.c                                   |    6 
 mm/rmap.c                                              |   10 
 mm/swap.c                                              |   21 -
 mm/swap_state.c                                        |   10 
 mm/swapfile.c                                          |   33 +-
 mm/vmscan.c                                            |    6 
 mm/vmstat.c                                            |   12 -
 mm/workingset.c                                        |    6 
 tools/perf/arch/powerpc/entry/syscalls/syscall.tbl     |    2 
 tools/perf/arch/s390/entry/syscalls/syscall.tbl        |    2 
 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl      |    2 
 tools/testing/selftests/exec/.gitignore                |    1 
 tools/testing/selftests/exec/Makefile                  |    5 
 tools/testing/selftests/exec/non-regular.c             |  196 +++++++++++++++++
 132 files changed, 815 insertions(+), 614 deletions(-)

