Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8801C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 02:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348593AbiDOCPN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 22:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346792AbiDOCPJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 22:15:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F16B1A393
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 19:12:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B092621FF
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 02:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D4C385A5;
        Fri, 15 Apr 2022 02:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649988761;
        bh=/e+ab53j9rNiRDH+O+eYiuCtN76XohaE88B5PFgCR/A=;
        h=Date:From:To:Cc:Subject:From;
        b=KNHGY/KcRz/8SQuP9rm8FGqkZRNKiMfYsQ8e1rtFXxibwn6Ut4OLifE9+qhUcd76c
         q6sV3gYuU97BzaWLLLSo+csBKag/kVaWcTvkNq+/0cuqsv+pxrbByBM8AOo9Gyq9CJ
         PipfBmY/UMaBHmBmuMa9ZRdhDedSXM4rpHwzgJGA=
Date:   Thu, 14 Apr 2022 19:12:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

14 patches, based on 115acbb56978941bb7537a97dfc303da286106c1.

Subsystems affected by this patch series:

  MAINTAINERS
  mm/tmpfs
  m/secretmem
  mm/kasan
  mm/kfence
  mm/pagealloc
  mm/zram
  mm/compaction
  mm/hugetlb
  binfmt
  mm/vmalloc
  mm/kmemleak

Subsystem: MAINTAINERS

    Joe Perches <joe@perches.com>:
      MAINTAINERS: Broadcom internal lists aren't maintainers

Subsystem: mm/tmpfs

    Hugh Dickins <hughd@google.com>:
      tmpfs: fix regressions from wider use of ZERO_PAGE

Subsystem: m/secretmem

    Axel Rasmussen <axelrasmussen@google.com>:
      mm/secretmem: fix panic when growing a memfd_secret

Subsystem: mm/kasan

    Zqiang <qiang1.zhang@intel.com>:
      irq_work: use kasan_record_aux_stack_noalloc() record callstack

    Vincenzo Frascino <vincenzo.frascino@arm.com>:
      kasan: fix hw tags enablement when KUNIT tests are disabled

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      mm, kfence: support kmem_dump_obj() for KFENCE objects

Subsystem: mm/pagealloc

    Juergen Gross <jgross@suse.com>:
      mm, page_alloc: fix build_zonerefs_node()

Subsystem: mm/zram

    Minchan Kim <minchan@kernel.org>:
      mm: fix unexpected zeroed page mapping with zram swap

Subsystem: mm/compaction

    Charan Teja Kalla <quic_charante@quicinc.com>:
      mm: compaction: fix compiler warning when CONFIG_COMPACTION=n

Subsystem: mm/hugetlb

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlb: do not demote poisoned hugetlb pages

Subsystem: binfmt

    Andrew Morton <akpm@linux-foundation.org>:
      revert "fs/binfmt_elf: fix PT_LOAD p_align values for loaders"
      revert "fs/binfmt_elf: use PT_LOAD p_align values for static PIE"

Subsystem: mm/vmalloc

    Omar Sandoval <osandov@fb.com>:
      mm/vmalloc: fix spinning drain_vmap_work after reading from /proc/vmcore

Subsystem: mm/kmemleak

    Patrick Wang <patrick.wang.shcn@gmail.com>:
      mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

 MAINTAINERS                     |   64 ++++++++++++++++++++--------------------
 arch/x86/include/asm/io.h       |    2 -
 arch/x86/kernel/crash_dump_64.c |    1 
 fs/binfmt_elf.c                 |    6 +--
 include/linux/kfence.h          |   24 +++++++++++++++
 kernel/irq_work.c               |    2 -
 mm/compaction.c                 |   10 +++---
 mm/filemap.c                    |    6 ---
 mm/hugetlb.c                    |   17 ++++++----
 mm/kasan/hw_tags.c              |    5 +--
 mm/kasan/kasan.h                |   10 +++---
 mm/kfence/core.c                |   21 -------------
 mm/kfence/kfence.h              |   21 +++++++++++++
 mm/kfence/report.c              |   47 +++++++++++++++++++++++++++++
 mm/kmemleak.c                   |    8 ++---
 mm/page_alloc.c                 |    2 -
 mm/page_io.c                    |   54 ---------------------------------
 mm/secretmem.c                  |   17 ++++++++++
 mm/shmem.c                      |   31 ++++++++++++-------
 mm/slab.c                       |    2 -
 mm/slab.h                       |    2 -
 mm/slab_common.c                |    9 +++++
 mm/slob.c                       |    2 -
 mm/slub.c                       |    2 -
 mm/vmalloc.c                    |   11 ------
 25 files changed, 207 insertions(+), 169 deletions(-)

