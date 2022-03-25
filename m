Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393F1C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345632AbiCYBJf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349976AbiCYBJf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:09:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CAFBBE3B
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AC2561841
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5597CC340EC;
        Fri, 25 Mar 2022 01:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170479;
        bh=UbKPN32PaUc08mgKv9KlC+TVSmIOwqntYsfsjlQojl8=;
        h=Date:From:To:Cc:Subject:From;
        b=sF6/7bo8UVoFsSGpvDW0QT2FIzXVQE5HgrCJ650auUpS4zPcRELacBDkEinQvrUPq
         U+MMw827/o1UKRNQC8w9+39PCFsgw04WNSlakZRoc6Fi8afaq/INF2xKxl7OfFrJQx
         rIdsCjDOmUaoFZ+uiaO3kZGjGtMsvcMYU88ViwLw=
Date:   Thu, 24 Mar 2022 18:07:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


This is the material which was staged after willystuff in linux-next. 
Everything applied seamlessly on your latest, all looks well.



114 patches, based on 52deda9551a01879b3562e7b41748e85c591f14c.

Subsystems affected by this patch series:

  mm/debug
  mm/selftests
  mm/pagecache
  mm/thp
  mm/rmap
  mm/migration
  mm/kasan
  mm/hugetlb
  mm/pagemap
  mm/madvise
  selftests

Subsystem: mm/debug

    Sean Anderson <seanga2@gmail.com>:
      tools/vm/page_owner_sort.c: sort by stacktrace before culling
      tools/vm/page_owner_sort.c: support sorting by stack trace

    Yinan Zhang <zhangyinan2019@email.szu.edu.cn>:
      tools/vm/page_owner_sort.c: add switch between culling by stacktrace and txt

    Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>:
      tools/vm/page_owner_sort.c: support sorting pid and time

    Shenghong Han <hanshenghong2019@email.szu.edu.cn>:
      tools/vm/page_owner_sort.c: two trivial fixes

    Yixuan Cao <caoyixuan2019@email.szu.edu.cn>:
      tools/vm/page_owner_sort.c: delete invalid duplicate code

    Shenghong Han <hanshenghong2019@email.szu.edu.cn>:
      Documentation/vm/page_owner.rst: update the documentation

    Shuah Khan <skhan@linuxfoundation.org>:
      Documentation/vm/page_owner.rst: fix unexpected indentation warns

    Waiman Long <longman@redhat.com>:
    Patch series "mm/page_owner: Extend page_owner to show memcg information", v4:
      lib/vsprintf: avoid redundant work with 0 size
      mm/page_owner: use scnprintf() to avoid excessive buffer overrun check
      mm/page_owner: print memcg information
      mm/page_owner: record task command name

    Yixuan Cao <caoyixuan2019@email.szu.edu.cn>:
      mm/page_owner.c: record tgid
      tools/vm/page_owner_sort.c: fix the instructions for use

    Jiajian Ye <yejiajian2018@email.szu.edu.cn>:
      tools/vm/page_owner_sort.c: fix comments
      tools/vm/page_owner_sort.c: add a security check
      tools/vm/page_owner_sort.c: support sorting by tgid and update documentation
      tools/vm/page_owner_sort: fix three trivival places
      tools/vm/page_owner_sort: support for sorting by task command name
      tools/vm/page_owner_sort.c: support for selecting by PID, TGID or task command name
      tools/vm/page_owner_sort.c: support for user-defined culling rules

    Christoph Hellwig <hch@lst.de>:
      mm: unexport page_init_poison

Subsystem: mm/selftests

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      selftest/vm: add util.h and and move helper functions there

    Mike Rapoport <rppt@kernel.org>:
      selftest/vm: add helpers to detect PAGE_SIZE and PAGE_SHIFT

Subsystem: mm/pagecache

    Hugh Dickins <hughd@google.com>:
      mm: delete __ClearPageWaiters()
      mm: filemap_unaccount_folio() large skip mapcount fixup

Subsystem: mm/thp

    Hugh Dickins <hughd@google.com>:
      mm/thp: fix NR_FILE_MAPPED accounting in page_*_file_rmap()

Subsystem: mm/rmap

Subsystem: mm/migration

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm/migration: Add trace events", v3:
      mm/migration: add trace events for THP migrations
      mm/migration: add trace events for base page and HugeTLB migrations

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
    Patch series "kasan, vmalloc, arm64: add vmalloc tagging support for SW/HW_TAGS", v6:
      kasan, page_alloc: deduplicate should_skip_kasan_poison
      kasan, page_alloc: move tag_clear_highpage out of kernel_init_free_pages
      kasan, page_alloc: merge kasan_free_pages into free_pages_prepare
      kasan, page_alloc: simplify kasan_poison_pages call site
      kasan, page_alloc: init memory of skipped pages on free
      kasan: drop skip_kasan_poison variable in free_pages_prepare
      mm: clarify __GFP_ZEROTAGS comment
      kasan: only apply __GFP_ZEROTAGS when memory is zeroed
      kasan, page_alloc: refactor init checks in post_alloc_hook
      kasan, page_alloc: merge kasan_alloc_pages into post_alloc_hook
      kasan, page_alloc: combine tag_clear_highpage calls in post_alloc_hook
      kasan, page_alloc: move SetPageSkipKASanPoison in post_alloc_hook
      kasan, page_alloc: move kernel_init_free_pages in post_alloc_hook
      kasan, page_alloc: rework kasan_unpoison_pages call site
      kasan: clean up metadata byte definitions
      kasan: define KASAN_VMALLOC_INVALID for SW_TAGS
      kasan, x86, arm64, s390: rename functions for modules shadow
      kasan, vmalloc: drop outdated VM_KASAN comment
      kasan: reorder vmalloc hooks
      kasan: add wrappers for vmalloc hooks
      kasan, vmalloc: reset tags in vmalloc functions
      kasan, fork: reset pointer tags of vmapped stacks
      kasan, arm64: reset pointer tags of vmapped stacks
      kasan, vmalloc: add vmalloc tagging for SW_TAGS
      kasan, vmalloc, arm64: mark vmalloc mappings as pgprot_tagged
      kasan, vmalloc: unpoison VM_ALLOC pages after mapping
      kasan, mm: only define ___GFP_SKIP_KASAN_POISON with HW_TAGS
      kasan, page_alloc: allow skipping unpoisoning for HW_TAGS
      kasan, page_alloc: allow skipping memory init for HW_TAGS
      kasan, vmalloc: add vmalloc tagging for HW_TAGS
      kasan, vmalloc: only tag normal vmalloc allocations
      kasan, arm64: don't tag executable vmalloc allocations
      kasan: mark kasan_arg_stacktrace as __initdata
      kasan: clean up feature flags for HW_TAGS mode
      kasan: add kasan.vmalloc command line flag
      kasan: allow enabling KASAN_VMALLOC and SW/HW_TAGS
      arm64: select KASAN_VMALLOC for SW/HW_TAGS modes
      kasan: documentation updates
      kasan: improve vmalloc tests
      kasan: test: support async (again) and asymm modes for HW_TAGS

    tangmeng <tangmeng@uniontech.com>:
      mm/kasan: remove unnecessary CONFIG_KASAN option

    Peter Collingbourne <pcc@google.com>:
      kasan: update function name in comments

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: print virtual mapping info in reports
    Patch series "kasan: report clean-ups and improvements":
      kasan: drop addr check from describe_object_addr
      kasan: more line breaks in reports
      kasan: rearrange stack frame info in reports
      kasan: improve stack frame info in reports
      kasan: print basic stack frame info for SW_TAGS
      kasan: simplify async check in end_report()
      kasan: simplify kasan_update_kunit_status() and call sites
      kasan: check CONFIG_KASAN_KUNIT_TEST instead of CONFIG_KUNIT
      kasan: move update_kunit_status to start_report
      kasan: move disable_trace_on_warning to start_report
      kasan: split out print_report from __kasan_report
      kasan: simplify kasan_find_first_bad_addr call sites
      kasan: restructure kasan_report
      kasan: merge __kasan_report into kasan_report
      kasan: call print_report from kasan_report_invalid_free
      kasan: move and simplify kasan_report_async
      kasan: rename kasan_access_info to kasan_report_info
      kasan: add comment about UACCESS regions to kasan_report
      kasan: respect KASAN_BIT_REPORTED in all reporting routines
      kasan: reorder reporting functions
      kasan: move and hide kasan_save_enable/restore_multi_shot
      kasan: disable LOCKDEP when printing reports

Subsystem: mm/hugetlb

    Mike Kravetz <mike.kravetz@oracle.com>:
    Patch series "Add hugetlb MADV_DONTNEED support", v3:
      mm: enable MADV_DONTNEED for hugetlb mappings
      selftests/vm: add hugetlb madvise MADV_DONTNEED MADV_REMOVE test
      userfaultfd/selftests: enable hugetlb remap and remove event testing

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/huge_memory: make is_transparent_hugepage() static

Subsystem: mm/pagemap

    David Hildenbrand <david@redhat.com>:
    Patch series "mm: COW fixes part 1: fix the COW security issue for THP and swap", v3:
      mm: optimize do_wp_page() for exclusive pages in the swapcache
      mm: optimize do_wp_page() for fresh pages in local LRU pagevecs
      mm: slightly clarify KSM logic in do_swap_page()
      mm: streamline COW logic in do_swap_page()
      mm/huge_memory: streamline COW logic in do_huge_pmd_wp_page()
      mm/khugepaged: remove reuse_swap_page() usage
      mm/swapfile: remove stale reuse_swap_page()
      mm/huge_memory: remove stale page_trans_huge_mapcount()
      mm/huge_memory: remove stale locking logic from __split_huge_pmd()

    Hugh Dickins <hughd@google.com>:
      mm: warn on deleting redirtied only if accounted
      mm: unmap_mapping_range_tree() with i_mmap_rwsem shared

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm: generalize ARCH_HAS_FILTER_PGPROT

Subsystem: mm/madvise

    Mauricio Faria de Oliveira <mfo@canonical.com>:
      mm: fix race between MADV_FREE reclaim and blkdev direct IO read

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: madvise: MADV_DONTNEED_LOCKED

Subsystem: selftests

    Muhammad Usama Anjum <usama.anjum@collabora.com>:
      selftests: vm: remove dependecy from internal kernel macros

    Kees Cook <keescook@chromium.org>:
      selftests: kselftest framework: provide "finished" helper

 Documentation/dev-tools/kasan.rst             |   17 
 Documentation/vm/page_owner.rst               |   72 ++
 arch/alpha/include/uapi/asm/mman.h            |    2 
 arch/arm64/Kconfig                            |    2 
 arch/arm64/include/asm/vmalloc.h              |    6 
 arch/arm64/include/asm/vmap_stack.h           |    5 
 arch/arm64/kernel/module.c                    |    5 
 arch/arm64/mm/pageattr.c                      |    2 
 arch/arm64/net/bpf_jit_comp.c                 |    3 
 arch/mips/include/uapi/asm/mman.h             |    2 
 arch/parisc/include/uapi/asm/mman.h           |    2 
 arch/powerpc/mm/book3s64/trace.c              |    1 
 arch/s390/kernel/module.c                     |    2 
 arch/x86/Kconfig                              |    3 
 arch/x86/kernel/module.c                      |    2 
 arch/x86/mm/init.c                            |    1 
 arch/xtensa/include/uapi/asm/mman.h           |    2 
 include/linux/gfp.h                           |   53 +-
 include/linux/huge_mm.h                       |    6 
 include/linux/kasan.h                         |  136 +++--
 include/linux/mm.h                            |    5 
 include/linux/page-flags.h                    |    2 
 include/linux/pagemap.h                       |    3 
 include/linux/swap.h                          |    4 
 include/linux/vmalloc.h                       |   18 
 include/trace/events/huge_memory.h            |    1 
 include/trace/events/migrate.h                |   31 +
 include/trace/events/mmflags.h                |   18 
 include/trace/events/thp.h                    |   27 +
 include/uapi/asm-generic/mman-common.h        |    2 
 kernel/fork.c                                 |   13 
 kernel/scs.c                                  |   16 
 lib/Kconfig.kasan                             |   18 
 lib/test_kasan.c                              |  239 ++++++++-
 lib/vsprintf.c                                |    8 
 mm/Kconfig                                    |    3 
 mm/debug.c                                    |    1 
 mm/filemap.c                                  |   63 +-
 mm/huge_memory.c                              |  109 ----
 mm/kasan/Makefile                             |    2 
 mm/kasan/common.c                             |    4 
 mm/kasan/hw_tags.c                            |  243 +++++++---
 mm/kasan/kasan.h                              |   76 ++-
 mm/kasan/report.c                             |  516 +++++++++++----------
 mm/kasan/report_generic.c                     |   34 -
 mm/kasan/report_hw_tags.c                     |    1 
 mm/kasan/report_sw_tags.c                     |   16 
 mm/kasan/report_tags.c                        |    2 
 mm/kasan/shadow.c                             |   76 +--
 mm/khugepaged.c                               |   11 
 mm/madvise.c                                  |   57 +-
 mm/memory.c                                   |  129 +++--
 mm/memremap.c                                 |    2 
 mm/migrate.c                                  |    4 
 mm/page-writeback.c                           |   18 
 mm/page_alloc.c                               |  270 ++++++-----
 mm/page_owner.c                               |   86 ++-
 mm/rmap.c                                     |   62 +-
 mm/swap.c                                     |    4 
 mm/swapfile.c                                 |  104 ----
 mm/vmalloc.c                                  |  167 ++++--
 tools/testing/selftests/kselftest.h           |   10 
 tools/testing/selftests/vm/.gitignore         |    1 
 tools/testing/selftests/vm/Makefile           |    1 
 tools/testing/selftests/vm/gup_test.c         |    3 
 tools/testing/selftests/vm/hugetlb-madvise.c  |  410 ++++++++++++++++
 tools/testing/selftests/vm/ksm_tests.c        |   38 -
 tools/testing/selftests/vm/memfd_secret.c     |    2 
 tools/testing/selftests/vm/run_vmtests.sh     |   15 
 tools/testing/selftests/vm/transhuge-stress.c |   41 -
 tools/testing/selftests/vm/userfaultfd.c      |   72 +-
 tools/testing/selftests/vm/util.h             |   75 ++-
 tools/vm/page_owner_sort.c                    |  628 +++++++++++++++++++++-----
 73 files changed, 2797 insertions(+), 1288 deletions(-)

