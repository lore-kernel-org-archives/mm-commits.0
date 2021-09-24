Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F582C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56B9E61019
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhIXWob (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhIXWob (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:44:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3F07610C7;
        Fri, 24 Sep 2021 22:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523377;
        bh=RbDnKYU0MRXfNDw/YjldD7s5XkKhka/hygyyBaMlTsY=;
        h=Date:From:To:Cc:Subject:From;
        b=IovNfmF0qqIZnrb8XTleBNBczD+LUgpjxMZ/ShXmU1MnxBQrCLmcADlOXzWYg2Ks7
         G9y00VZyiR5XWOGy0C3nBuONJV40+P7qnzTl2YNRKepWOMkJyrexGwNi/wrL1l2E2Z
         sl8uC+iweuADf6QELQ9xQNrgW/DYB7YcH7/rHJto=
Date:   Fri, 24 Sep 2021 15:42:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

16 patches, based on 7d42e98182586f57f376406d033f05fe135edb75.

Subsystems affected by this patch series:

  mm/memory-failure
  mm/kasan
  mm/damon
  xtensa
  mm/shmem
  ocfs2
  scripts
  mm/tools
  lib
  mm/pagecache
  mm/debug
  sh
  mm/kasan
  mm/memory-failure
  mm/pagemap

Subsystem: mm/memory-failure

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm, hwpoison: add is_free_buddy_page() in HWPoisonHandlable()

Subsystem: mm/kasan

    Marco Elver <elver@google.com>:
      kasan: fix Kconfig check of CC_HAS_WORKING_NOSANITIZE_ADDRESS

Subsystem: mm/damon

    Adam Borowski <kilobyte@angband.pl>:
      mm/damon: don't use strnlen() with known-bogus source length

Subsystem: xtensa

    Guenter Roeck <linux@roeck-us.net>:
      xtensa: increase size of gcc stack frame check

Subsystem: mm/shmem

    Liu Yuntao <liuyuntao10@huawei.com>:
      mm/shmem.c: fix judgment error in shmem_is_huge()

Subsystem: ocfs2

    Wengang Wang <wen.gang.wang@oracle.com>:
      ocfs2: drop acl cache for directories too

Subsystem: scripts

    Miles Chen <miles.chen@mediatek.com>:
      scripts/sorttable: riscv: fix undeclared identifier 'EM_RISCV' error

Subsystem: mm/tools

    Changbin Du <changbin.du@gmail.com>:
      tools/vm/page-types: remove dependency on opt_file for idle page tracking

Subsystem: lib

    Paul Menzel <pmenzel@molgen.mpg.de>:
      lib/zlib_inflate/inffast: check config in C to avoid unused function warning

Subsystem: mm/pagecache

    Minchan Kim <minchan@kernel.org>:
      mm: fs: invalidate bh_lrus for only cold path

Subsystem: mm/debug

    Weizhao Ouyang <o451686892@gmail.com>:
      mm/debug: sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN
      mm/debug: sync up latest migrate_reason to migrate_reason_names

Subsystem: sh

    Geert Uytterhoeven <geert+renesas@glider.be>:
      sh: pgtable-3level: fix cast to pointer from integer of different size

Subsystem: mm/kasan

    Nathan Chancellor <nathan@kernel.org>:
      kasan: always respect CONFIG_KASAN_STACK

Subsystem: mm/memory-failure

    Qi Zheng <zhengqi.arch@bytedance.com>:
      mm/memory_failure: fix the missing pte_unmap() call

Subsystem: mm/pagemap

    Chen Jun <chenjun102@huawei.com>:
      mm: fix uninitialized use in overcommit_policy_handler

 arch/sh/include/asm/pgtable-3level.h |    2 +-
 fs/buffer.c                          |    8 ++++++--
 fs/ocfs2/dlmglue.c                   |    3 ++-
 include/linux/buffer_head.h          |    4 ++--
 include/linux/migrate.h              |    6 +++++-
 lib/Kconfig.debug                    |    2 +-
 lib/Kconfig.kasan                    |    2 ++
 lib/zlib_inflate/inffast.c           |   13 ++++++-------
 mm/damon/dbgfs-test.h                |   16 ++++++++--------
 mm/debug.c                           |    4 +++-
 mm/memory-failure.c                  |   12 ++++++------
 mm/shmem.c                           |    4 ++--
 mm/swap.c                            |   19 ++++++++++++++++---
 mm/util.c                            |    4 ++--
 scripts/Makefile.kasan               |    3 ++-
 scripts/sorttable.c                  |    4 ++++
 tools/vm/page-types.c                |    2 +-
 17 files changed, 69 insertions(+), 39 deletions(-)

