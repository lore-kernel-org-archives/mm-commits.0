Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C9EC433ED
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD86761370
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhEOA1r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 20:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234494AbhEOA1r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 20:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3AC960FEB;
        Sat, 15 May 2021 00:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038395;
        bh=yS4i1RvqQRE0IT8GVGkGFa202/YpWkQmUr30Rc92FR4=;
        h=Date:From:To:Cc:Subject:From;
        b=eHBtDOhe52BaY9mG6ggF6fdAoukO9+Ld5c5fzOF18eDBYZPTemepzewxmbQsTY3HV
         JrGztyZb6tpKkLYHy8Mds43n71a5viq2Vt02BZ8JppYa4cTqHS4JfTG4lwA9AB3V8F
         nqcDk5fsGJDrSxfzmKvlx1rz9O8RX9DutuR5YxYk=
Date:   Fri, 14 May 2021 17:26:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

13 patches, based on bd3c9cdb21a2674dd0db70199df884828e37abd4.

Subsystems affected by this patch series:

  mm/hugetlb
  mm/slub
  resource
  squashfs
  mm/userfaultfd
  mm/ksm
  mm/pagealloc
  mm/kasan
  mm/pagemap
  hfsplus
  modprobe
  mm/ioremap

Subsystem: mm/hugetlb

    Peter Xu <peterx@redhat.com>:
    Patch series "mm/hugetlb: Fix issues on file sealing and fork", v2:
      mm/hugetlb: fix F_SEAL_FUTURE_WRITE
      mm/hugetlb: fix cow where page writtable in child

Subsystem: mm/slub

    Vlastimil Babka <vbabka@suse.cz>:
      mm, slub: move slub_debug static key enabling outside slab_mutex

Subsystem: resource

    Alistair Popple <apopple@nvidia.com>:
      kernel/resource: fix return code check in __request_free_mem_region

Subsystem: squashfs

    Phillip Lougher <phillip@squashfs.org.uk>:
      squashfs: fix divide error in calculate_skip()

Subsystem: mm/userfaultfd

    Axel Rasmussen <axelrasmussen@google.com>:
      userfaultfd: release page in error path to avoid BUG_ON

Subsystem: mm/ksm

    Hugh Dickins <hughd@google.com>:
      ksm: revert "use GET_KSM_PAGE_NOLOCK to get ksm page in remove_rmap_item_from_tree()"

Subsystem: mm/pagealloc

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: fix struct page layout on 32-bit systems

Subsystem: mm/kasan

    Peter Collingbourne <pcc@google.com>:
      kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled

Subsystem: mm/pagemap

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/filemap: fix readahead return types

Subsystem: hfsplus

    Jouni Roivas <jouni.roivas@tuxera.com>:
      hfsplus: prevent corruption in shrinking truncate

Subsystem: modprobe

    Rasmus Villemoes <linux@rasmusvillemoes.dk>:
      docs: admin-guide: update description for kernel.modprobe sysctl

Subsystem: mm/ioremap

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      mm/ioremap: fix iomap_max_page_shift

 Documentation/admin-guide/sysctl/kernel.rst |    9 ++++---
 fs/hfsplus/extents.c                        |    7 +++--
 fs/hugetlbfs/inode.c                        |    5 ++++
 fs/iomap/buffered-io.c                      |    4 +--
 fs/squashfs/file.c                          |    6 ++--
 include/linux/mm.h                          |   32 ++++++++++++++++++++++++++
 include/linux/mm_types.h                    |    4 +--
 include/linux/pagemap.h                     |    6 ++--
 include/net/page_pool.h                     |   12 +++++++++
 kernel/resource.c                           |    2 -
 lib/test_kasan.c                            |   29 ++++++++++++++++++-----
 mm/hugetlb.c                                |    1 
 mm/ioremap.c                                |    6 ++--
 mm/ksm.c                                    |    3 +-
 mm/shmem.c                                  |   34 ++++++++++++----------------
 mm/slab_common.c                            |   10 ++++++++
 mm/slub.c                                   |    9 -------
 net/core/page_pool.c                        |   12 +++++----
 18 files changed, 129 insertions(+), 62 deletions(-)

