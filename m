Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16E4C3526C
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD09E23BA9
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgLRWBb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgLRWBa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:01:30 -0500
Date:   Fri, 18 Dec 2020 14:00:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608328849;
        bh=V77M/mwdFmQMwMxeLhNhx8KGUkDxXiJPPIBS0lbRcpk=;
        h=From:To:Cc:Subject:From;
        b=IDshQ1fGBbN0BF5lxSx7AikHPhDOpFRP/7fU0rbZJ0tDleV+t6rSq6j5FVLCjXmlf
         bLrCuHsiIu1wggsp57Huhf5ECS4Yxm4cqh2i9sTkgtS/8oyxLnbYJQFFLbRCgWYPpl
         QNoq+Isv5AeaUdJW0GZKdixPxH9WsFAVpRWlo2I8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


78 patches, based on a409ed156a90093a03fe6a93721ddf4c591eac87.

Subsystems affected by this patch series:

  mm/memcg
  epoll
  mm/kasan
  mm/cleanups
  epoll

Subsystem: mm/memcg

    Alex Shi <alex.shi@linux.alibaba.com>:
    Patch series "bail out early for memcg disable":
      mm/memcg: bail early from swap accounting if memcg disabled
      mm/memcg: warning on !memcg after readahead page charged

    Wei Yang <richard.weiyang@gmail.com>:
      mm/memcg: remove unused definitions

    Shakeel Butt <shakeelb@google.com>:
      mm, kvm: account kvm_vcpu_mmap to kmemcg

    Hui Su <sh_def@163.com>:
      mm/memcontrol:rewrite mem_cgroup_page_lruvec()

Subsystem: epoll

    Soheil Hassas Yeganeh <soheil@google.com>:
    Patch series "simplify ep_poll":
      epoll: check for events when removing a timed out thread from the wait queue
      epoll: simplify signal handling
      epoll: pull fatal signal checks into ep_send_events()
      epoll: move eavail next to the list_empty_careful check
      epoll: simplify and optimize busy loop logic
      epoll: pull all code between fetch_events and send_event into the loop
      epoll: replace gotos with a proper loop
      epoll: eliminate unnecessary lock for zero timeout

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
    Patch series "kasan: add hardware tag-based mode for arm64", v11:
      kasan: drop unnecessary GPL text from comment headers
      kasan: KASAN_VMALLOC depends on KASAN_GENERIC
      kasan: group vmalloc code
      kasan: shadow declarations only for software modes
      kasan: rename (un)poison_shadow to (un)poison_range
      kasan: rename KASAN_SHADOW_* to KASAN_GRANULE_*
      kasan: only build init.c for software modes
      kasan: split out shadow.c from common.c
      kasan: define KASAN_MEMORY_PER_SHADOW_PAGE
      kasan: rename report and tags files
      kasan: don't duplicate config dependencies
      kasan: hide invalid free check implementation
      kasan: decode stack frame only with KASAN_STACK_ENABLE
      kasan, arm64: only init shadow for software modes
      kasan, arm64: only use kasan_depth for software modes
      kasan, arm64: move initialization message
      kasan, arm64: rename kasan_init_tags and mark as __init
      kasan: rename addr_has_shadow to addr_has_metadata
      kasan: rename print_shadow_for_address to print_memory_metadata
      kasan: rename SHADOW layout macros to META
      kasan: separate metadata_fetch_row for each mode
      kasan: introduce CONFIG_KASAN_HW_TAGS

    Vincenzo Frascino <vincenzo.frascino@arm.com>:
      arm64: enable armv8.5-a asm-arch option
      arm64: mte: add in-kernel MTE helpers
      arm64: mte: reset the page tag in page->flags
      arm64: mte: add in-kernel tag fault handler
      arm64: kasan: allow enabling in-kernel MTE
      arm64: mte: convert gcr_user into an exclude mask
      arm64: mte: switch GCR_EL1 in kernel entry and exit
      kasan, mm: untag page address in free_reserved_area

    Andrey Konovalov <andreyknvl@google.com>:
      arm64: kasan: align allocations for HW_TAGS
      arm64: kasan: add arch layer for memory tagging helpers
      kasan: define KASAN_GRANULE_SIZE for HW_TAGS
      kasan, x86, s390: update undef CONFIG_KASAN
      kasan, arm64: expand CONFIG_KASAN checks
      kasan, arm64: implement HW_TAGS runtime
      kasan, arm64: print report from tag fault handler
      kasan, mm: reset tags when accessing metadata
      kasan, arm64: enable CONFIG_KASAN_HW_TAGS
      kasan: add documentation for hardware tag-based mode

    Vincenzo Frascino <vincenzo.frascino@arm.com>:
      kselftest/arm64: check GCR_EL1 after context switch

    Andrey Konovalov <andreyknvl@google.com>:
    Patch series "kasan: boot parameters for hardware tag-based mode", v4:
      kasan: simplify quarantine_put call site
      kasan: rename get_alloc/free_info
      kasan: introduce set_alloc_info
      kasan, arm64: unpoison stack only with CONFIG_KASAN_STACK
      kasan: allow VMAP_STACK for HW_TAGS mode
      kasan: remove __kasan_unpoison_stack
      kasan: inline kasan_reset_tag for tag-based modes
      kasan: inline random_tag for HW_TAGS
      kasan: open-code kasan_unpoison_slab
      kasan: inline (un)poison_range and check_invalid_free
      kasan: add and integrate kasan boot parameters
      kasan, mm: check kasan_enabled in annotations
      kasan, mm: rename kasan_poison_kfree
      kasan: don't round_up too much
      kasan: simplify assign_tag and set_tag calls
      kasan: clarify comment in __kasan_kfree_large
      kasan: sanitize objects when metadata doesn't fit
      kasan, mm: allow cache merging with no metadata
      kasan: update documentation

Subsystem: mm/cleanups

    Colin Ian King <colin.king@canonical.com>:
      mm/Kconfig: fix spelling mistake "whats" -> "what's"

Subsystem: epoll

    Willem de Bruijn <willemb@google.com>:
    Patch series "add epoll_pwait2 syscall", v4:
      epoll: convert internal api to timespec64
      epoll: add syscall epoll_pwait2
      epoll: wire up syscall epoll_pwait2
      selftests/filesystems: expand epoll with epoll_pwait2

 Documentation/dev-tools/kasan.rst                             |  274 +-
 arch/Kconfig                                                  |    8 
 arch/alpha/kernel/syscalls/syscall.tbl                        |    1 
 arch/arm/tools/syscall.tbl                                    |    1 
 arch/arm64/Kconfig                                            |    9 
 arch/arm64/Makefile                                           |    7 
 arch/arm64/include/asm/assembler.h                            |    2 
 arch/arm64/include/asm/cache.h                                |    3 
 arch/arm64/include/asm/esr.h                                  |    1 
 arch/arm64/include/asm/kasan.h                                |   17 
 arch/arm64/include/asm/memory.h                               |   15 
 arch/arm64/include/asm/mte-def.h                              |   16 
 arch/arm64/include/asm/mte-kasan.h                            |   67 
 arch/arm64/include/asm/mte.h                                  |   22 
 arch/arm64/include/asm/processor.h                            |    2 
 arch/arm64/include/asm/string.h                               |    5 
 arch/arm64/include/asm/uaccess.h                              |   23 
 arch/arm64/include/asm/unistd.h                               |    2 
 arch/arm64/include/asm/unistd32.h                             |    2 
 arch/arm64/kernel/asm-offsets.c                               |    3 
 arch/arm64/kernel/cpufeature.c                                |    3 
 arch/arm64/kernel/entry.S                                     |   41 
 arch/arm64/kernel/head.S                                      |    2 
 arch/arm64/kernel/hibernate.c                                 |    5 
 arch/arm64/kernel/image-vars.h                                |    2 
 arch/arm64/kernel/kaslr.c                                     |    3 
 arch/arm64/kernel/module.c                                    |    6 
 arch/arm64/kernel/mte.c                                       |  124 +
 arch/arm64/kernel/setup.c                                     |    2 
 arch/arm64/kernel/sleep.S                                     |    2 
 arch/arm64/kernel/smp.c                                       |    2 
 arch/arm64/lib/mte.S                                          |   16 
 arch/arm64/mm/copypage.c                                      |    9 
 arch/arm64/mm/fault.c                                         |   59 
 arch/arm64/mm/kasan_init.c                                    |   41 
 arch/arm64/mm/mteswap.c                                       |    9 
 arch/arm64/mm/proc.S                                          |   23 
 arch/arm64/mm/ptdump.c                                        |    6 
 arch/ia64/kernel/syscalls/syscall.tbl                         |    1 
 arch/m68k/kernel/syscalls/syscall.tbl                         |    1 
 arch/microblaze/kernel/syscalls/syscall.tbl                   |    1 
 arch/mips/kernel/syscalls/syscall_n32.tbl                     |    1 
 arch/mips/kernel/syscalls/syscall_n64.tbl                     |    1 
 arch/mips/kernel/syscalls/syscall_o32.tbl                     |    1 
 arch/parisc/kernel/syscalls/syscall.tbl                       |    1 
 arch/powerpc/kernel/syscalls/syscall.tbl                      |    1 
 arch/s390/boot/string.c                                       |    1 
 arch/s390/kernel/syscalls/syscall.tbl                         |    1 
 arch/sh/kernel/syscalls/syscall.tbl                           |    1 
 arch/sparc/kernel/syscalls/syscall.tbl                        |    1 
 arch/x86/boot/compressed/misc.h                               |    1 
 arch/x86/entry/syscalls/syscall_32.tbl                        |    1 
 arch/x86/entry/syscalls/syscall_64.tbl                        |    1 
 arch/x86/kernel/acpi/wakeup_64.S                              |    2 
 arch/x86/kvm/x86.c                                            |    2 
 arch/xtensa/kernel/syscalls/syscall.tbl                       |    1 
 fs/eventpoll.c                                                |  359 ++-
 include/linux/compat.h                                        |    6 
 include/linux/kasan-checks.h                                  |    2 
 include/linux/kasan.h                                         |  423 ++--
 include/linux/memcontrol.h                                    |  137 -
 include/linux/mm.h                                            |   24 
 include/linux/mmdebug.h                                       |   13 
 include/linux/moduleloader.h                                  |    3 
 include/linux/page-flags-layout.h                             |    2 
 include/linux/sched.h                                         |    2 
 include/linux/string.h                                        |    2 
 include/linux/syscalls.h                                      |    5 
 include/uapi/asm-generic/unistd.h                             |    4 
 init/init_task.c                                              |    2 
 kernel/fork.c                                                 |    4 
 kernel/sys_ni.c                                               |    2 
 lib/Kconfig.kasan                                             |   71 
 lib/test_kasan.c                                              |    2 
 lib/test_kasan_module.c                                       |    2 
 mm/Kconfig                                                    |    2 
 mm/kasan/Makefile                                             |   33 
 mm/kasan/common.c                                             | 1006 ++--------
 mm/kasan/generic.c                                            |   72 
 mm/kasan/generic_report.c                                     |   13 
 mm/kasan/hw_tags.c                                            |  294 ++
 mm/kasan/init.c                                               |   25 
 mm/kasan/kasan.h                                              |  204 +-
 mm/kasan/quarantine.c                                         |   35 
 mm/kasan/report.c                                             |  363 +--
 mm/kasan/report_generic.c                                     |  169 +
 mm/kasan/report_hw_tags.c                                     |   44 
 mm/kasan/report_sw_tags.c                                     |   22 
 mm/kasan/shadow.c                                             |  541 +++++
 mm/kasan/sw_tags.c                                            |   34 
 mm/kasan/tags.c                                               |    7 
 mm/kasan/tags_report.c                                        |    7 
 mm/memcontrol.c                                               |   53 
 mm/mempool.c                                                  |    4 
 mm/page_alloc.c                                               |    9 
 mm/page_poison.c                                              |    2 
 mm/ptdump.c                                                   |   13 
 mm/slab_common.c                                              |    5 
 mm/slub.c                                                     |   29 
 scripts/Makefile.lib                                          |    2 
 tools/testing/selftests/arm64/mte/Makefile                    |    2 
 tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c     |  155 +
 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |   72 
 virt/kvm/coalesced_mmio.c                                     |    2 
 virt/kvm/kvm_main.c                                           |    2 
 105 files changed, 3268 insertions(+), 1873 deletions(-)

