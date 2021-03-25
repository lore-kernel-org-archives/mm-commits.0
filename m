Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FEFC433E4
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D46261A1A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhCYEhM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhCYEgp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Mar 2021 00:36:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0820361A1B;
        Thu, 25 Mar 2021 04:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616647005;
        bh=uTi0OGEMQ5QspIf8O2LO/RhMhAD1jEWOInsB2hwvNE0=;
        h=Date:From:To:Cc:Subject:From;
        b=H4Kt7ZoO7h+vUjgAKdAKyMsyyo049dPcsPmZJUbPFvJPanb3+3WBQfcsILTIJB00C
         Pjh4egspQxy7wDUa9tt+GEK6nU4Gi8iYLNkxmwJcLcj+XK3NQ/cd2vOMwshs9f4R7M
         odMuIQjFoVKOP2qwPj0sxRU6kFvoGjZRGO/XCWvc=
Date:   Wed, 24 Mar 2021 21:36:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210324213644.bf03a529aec4ef9580e17dbc@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


14 patches, based on 7acac4b3196caee5e21fb5ea53f8bc124e6a16fc.

Subsystems affected by this patch series:

  mm/hugetlb
  mm/kasan
  mm/gup
  mm/selftests
  mm/z3fold
  squashfs
  ia64
  gcov
  mm/kfence
  mm/memblock
  mm/highmem
  mailmap

Subsystem: mm/hugetlb

    Miaohe Lin <linmiaohe@huawei.com>:
      hugetlb_cgroup: fix imbalanced css_get and css_put pair for shared mappings

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: fix per-page tags for non-page_alloc pages

Subsystem: mm/gup

    Sean Christopherson <seanjc@google.com>:
      mm/mmu_notifiers: ensure range_end() is paired with range_start()

Subsystem: mm/selftests

    Rong Chen <rong.a.chen@intel.com>:
      selftests/vm: fix out-of-tree build

Subsystem: mm/z3fold

    Thomas Hebb <tommyhebb@gmail.com>:
      z3fold: prevent reclaim/free race for headless pages

Subsystem: squashfs

    Sean Nyekjaer <sean@geanix.com>:
      squashfs: fix inode lookup sanity checks

    Phillip Lougher <phillip@squashfs.org.uk>:
      squashfs: fix xattr id and id lookup sanity checks

Subsystem: ia64

    Sergei Trofimovich <slyfox@gentoo.org>:
      ia64: mca: allocate early mca with GFP_ATOMIC
      ia64: fix format strings for err_inject

Subsystem: gcov

    Nick Desaulniers <ndesaulniers@google.com>:
      gcov: fix clang-11+ support

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      kfence: make compatible with kmemleak

Subsystem: mm/memblock

    Mike Rapoport <rppt@linux.ibm.com>:
      mm: memblock: fix section mismatch warning again

Subsystem: mm/highmem

    Ira Weiny <ira.weiny@intel.com>:
      mm/highmem: fix CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP

Subsystem: mailmap

    Andrey Konovalov <andreyknvl@google.com>:
      mailmap: update Andrey Konovalov's email address

 .mailmap                            |    1 
 arch/ia64/kernel/err_inject.c       |   22 +++++------
 arch/ia64/kernel/mca.c              |    2 -
 fs/squashfs/export.c                |    8 +++-
 fs/squashfs/id.c                    |    6 ++-
 fs/squashfs/squashfs_fs.h           |    1 
 fs/squashfs/xattr_id.c              |    6 ++-
 include/linux/hugetlb_cgroup.h      |   15 ++++++-
 include/linux/memblock.h            |    4 +-
 include/linux/mm.h                  |   18 +++++++--
 include/linux/mmu_notifier.h        |   10 ++---
 kernel/gcov/clang.c                 |   69 ++++++++++++++++++++++++++++++++++++
 mm/highmem.c                        |    4 +-
 mm/hugetlb.c                        |   41 +++++++++++++++++++--
 mm/hugetlb_cgroup.c                 |   10 ++++-
 mm/kfence/core.c                    |    9 ++++
 mm/kmemleak.c                       |    3 +
 mm/mmu_notifier.c                   |   23 ++++++++++++
 mm/z3fold.c                         |   16 +++++++-
 tools/testing/selftests/vm/Makefile |    4 +-
 20 files changed, 230 insertions(+), 42 deletions(-)

