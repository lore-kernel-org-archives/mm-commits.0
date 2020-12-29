Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53790C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3349A223DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgL2XOb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:14:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgL2XOb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:14:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6719520771;
        Tue, 29 Dec 2020 23:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283630;
        bh=7jZO7lK/ShAiwXS9L0PgHS0G9a/hPzufx30lRF/2epw=;
        h=Date:From:To:Cc:Subject:From;
        b=Nn+Tmv7fxPEL7xyjbNGvkVPDoFarS+kJ0B1jU8NTey77l/wAa6rW7L5SZG41cdPC9
         SMugkjaGPEdtvJTzgcmPIcr1CmhDUHvwVsjNtgeupeNoWpIIGEMAYED3402IfhM+15
         RB8Q/wNqwGzr6BESyLfVKIc+PGWXVmUl9yTtLeIA=
Date:   Tue, 29 Dec 2020 15:13:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20201229151349.3285926ec0d1f65a27ac8534@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

16 patches, based on dea8dcf2a9fa8cc540136a6cd885c3beece16ec3.

Subsystems affected by this patch series:

  mm/selftests
  mm/hugetlb
  kbuild
  checkpatch
  mm/pagecache
  mm/mremap
  mm/kasan
  misc
  lib
  mm/slub

Subsystem: mm/selftests

    Harish <harish@linux.ibm.com>:
      selftests/vm: fix building protection keys test

Subsystem: mm/hugetlb

    Mike Kravetz <mike.kravetz@oracle.com>:
      mm/hugetlb: fix deadlock in hugetlb_cow error path

Subsystem: kbuild

    Masahiro Yamada <masahiroy@kernel.org>:
      Revert "kbuild: avoid static_assert for genksyms"

Subsystem: checkpatch

    Joe Perches <joe@perches.com>:
      checkpatch: prefer strscpy to strlcpy

Subsystem: mm/pagecache

    Souptick Joarder <jrdr.linux@gmail.com>:
      mm: add prototype for __add_to_page_cache_locked()

    Baoquan He <bhe@redhat.com>:
      mm: memmap defer init doesn't work as expected

Subsystem: mm/mremap

    Kalesh Singh <kaleshsingh@google.com>:
      mm/mremap.c: fix extent calculation

    Nicholas Piggin <npiggin@gmail.com>:
      mm: generalise COW SMC TLB flushing race comment

Subsystem: mm/kasan

    Walter Wu <walter-zh.wu@mediatek.com>:
      kasan: fix null pointer dereference in kasan_record_aux_stack

Subsystem: misc

    Randy Dunlap <rdunlap@infradead.org>:
      local64.h: make <asm/local64.h> mandatory

    Huang Shijie <sjhuang@iluvatar.ai>:
      sizes.h: add SZ_8G/SZ_16G/SZ_32G macros

    Josh Poimboeuf <jpoimboe@redhat.com>:
      kdev_t: always inline major/minor helper functions

Subsystem: lib

    Huang Shijie <sjhuang@iluvatar.ai>:
      lib/genalloc: fix the overflow when size is too big

    Ilya Leoshkevich <iii@linux.ibm.com>:
      lib/zlib: fix inflating zlib streams on s390

    Randy Dunlap <rdunlap@infradead.org>:
      zlib: move EXPORT_SYMBOL() and MODULE_LICENSE() out of dfltcc_syms.c

Subsystem: mm/slub

    Roman Gushchin <guro@fb.com>:
      mm: slub: call account_slab_page() after slab page initialization

 arch/alpha/include/asm/local64.h    |    1 -
 arch/arc/include/asm/Kbuild         |    1 -
 arch/arm/include/asm/Kbuild         |    1 -
 arch/arm64/include/asm/Kbuild       |    1 -
 arch/csky/include/asm/Kbuild        |    1 -
 arch/h8300/include/asm/Kbuild       |    1 -
 arch/hexagon/include/asm/Kbuild     |    1 -
 arch/ia64/include/asm/local64.h     |    1 -
 arch/ia64/mm/init.c                 |    4 ++--
 arch/m68k/include/asm/Kbuild        |    1 -
 arch/microblaze/include/asm/Kbuild  |    1 -
 arch/mips/include/asm/Kbuild        |    1 -
 arch/nds32/include/asm/Kbuild       |    1 -
 arch/openrisc/include/asm/Kbuild    |    1 -
 arch/parisc/include/asm/Kbuild      |    1 -
 arch/powerpc/include/asm/Kbuild     |    1 -
 arch/riscv/include/asm/Kbuild       |    1 -
 arch/s390/include/asm/Kbuild        |    1 -
 arch/sh/include/asm/Kbuild          |    1 -
 arch/sparc/include/asm/Kbuild       |    1 -
 arch/x86/include/asm/local64.h      |    1 -
 arch/xtensa/include/asm/Kbuild      |    1 -
 include/asm-generic/Kbuild          |    1 +
 include/linux/build_bug.h           |    5 -----
 include/linux/kdev_t.h              |   22 +++++++++++-----------
 include/linux/mm.h                  |   12 ++++++++++--
 include/linux/sizes.h               |    3 +++
 lib/genalloc.c                      |   25 +++++++++++++------------
 lib/zlib_dfltcc/Makefile            |    2 +-
 lib/zlib_dfltcc/dfltcc.c            |    6 +++++-
 lib/zlib_dfltcc/dfltcc_deflate.c    |    3 +++
 lib/zlib_dfltcc/dfltcc_inflate.c    |    4 ++--
 lib/zlib_dfltcc/dfltcc_syms.c       |   17 -----------------
 mm/hugetlb.c                        |   22 +++++++++++++++++++++-
 mm/kasan/generic.c                  |    2 ++
 mm/memory.c                         |    8 +++++---
 mm/memory_hotplug.c                 |    2 +-
 mm/mremap.c                         |    4 +++-
 mm/page_alloc.c                     |    8 +++++---
 mm/slub.c                           |    5 ++---
 scripts/checkpatch.pl               |    6 ++++++
 tools/testing/selftests/vm/Makefile |   10 +++++-----
 42 files changed, 101 insertions(+), 91 deletions(-)

