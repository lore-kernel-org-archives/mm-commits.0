Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A3DC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B69D613CD
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhDPWpu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234996AbhDPWpt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 18:45:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3159E6108B;
        Fri, 16 Apr 2021 22:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618613124;
        bh=kBeAWsAZC0MFEdaOHJY11MUV8G/y/hypTczwsAu5ACM=;
        h=Date:From:To:Cc:Subject:From;
        b=S6JgHCp4ULc/RTbqMYQCbwkcUbRCW7wT8XV9Md3oQEBkT4XwmXtLDHixIuhfm3XQs
         frDEy8vUqjY1iPNW6SSgMPV8pzbxkPC9mPt+3x/nz01fFU2FOTlZHjz3PtpixCSd2m
         Dm/JdtRt7S4LejavVTYLDZnEbhUllZzBhVtiSlmw=
Date:   Fri, 16 Apr 2021 15:45:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

12 patches, based on 06c2aac4014c38247256fe49c61b7f55890271e7.

Subsystems affected by this patch series:

  mm/documentation
  mm/kasan
  csky
  ia64
  mm/pagemap
  gcov
  lib

Subsystem: mm/documentation

    Randy Dunlap <rdunlap@infradead.org>:
      mm: eliminate "expecting prototype" kernel-doc warnings

Subsystem: mm/kasan

    Arnd Bergmann <arnd@arndb.de>:
      kasan: fix hwasan build for gcc

    Walter Wu <walter-zh.wu@mediatek.com>:
      kasan: remove redundant config option

Subsystem: csky

    Randy Dunlap <rdunlap@infradead.org>:
      csky: change a Kconfig symbol name to fix e1000 build error

Subsystem: ia64

    Randy Dunlap <rdunlap@infradead.org>:
      ia64: remove duplicate entries in generic_defconfig
      ia64: fix discontig.c section mismatches

    John Paul Adrian Glaubitz <glaubitz () physik ! fu-berlin ! de>:
      ia64: tools: remove inclusion of ia64-specific version of errno.h header

    John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>:
      ia64: tools: remove duplicate definition of ia64_mf() on ia64

Subsystem: mm/pagemap

    Zack Rusin <zackr@vmware.com>:
      mm/mapping_dirty_helpers: guard hugepage pud's usage

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      mm: ptdump: fix build failure

Subsystem: gcov

    Johannes Berg <johannes.berg@intel.com>:
      gcov: clang: fix clang-11+ build

Subsystem: lib

    Randy Dunlap <rdunlap@infradead.org>:
      lib: remove "expecting prototype" kernel-doc warnings

 arch/arm64/kernel/sleep.S             |    2 +-
 arch/csky/Kconfig                     |    2 +-
 arch/csky/include/asm/page.h          |    2 +-
 arch/ia64/configs/generic_defconfig   |    2 --
 arch/ia64/mm/discontig.c              |    6 +++---
 arch/x86/kernel/acpi/wakeup_64.S      |    2 +-
 include/linux/kasan.h                 |    2 +-
 kernel/gcov/clang.c                   |    2 +-
 lib/Kconfig.kasan                     |    9 ++-------
 lib/earlycpio.c                       |    4 ++--
 lib/lru_cache.c                       |    3 ++-
 lib/parman.c                          |    4 ++--
 lib/radix-tree.c                      |   11 ++++++-----
 mm/kasan/common.c                     |    2 +-
 mm/kasan/kasan.h                      |    2 +-
 mm/kasan/report_generic.c             |    2 +-
 mm/mapping_dirty_helpers.c            |    2 ++
 mm/mmu_gather.c                       |   29 +++++++++++++++++++----------
 mm/oom_kill.c                         |    2 +-
 mm/ptdump.c                           |    2 +-
 mm/shuffle.c                          |    4 ++--
 scripts/Makefile.kasan                |   22 ++++++++++++++--------
 security/Kconfig.hardening            |    4 ++--
 tools/arch/ia64/include/asm/barrier.h |    3 ---
 tools/include/uapi/asm/errno.h        |    2 --
 25 files changed, 67 insertions(+), 60 deletions(-)

