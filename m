Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF05C432BE
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C14C60F23
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhGWWIz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 18:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhGWWIz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 18:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F36CA60EB5;
        Fri, 23 Jul 2021 22:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080568;
        bh=j9QUUjD9+gI6EqZfOIzJoXVuo/GLZLj6gXI7wG/rm8o=;
        h=Date:From:To:Cc:Subject:From;
        b=1Y8J804lSeJoXVSZibZgmyEodeVvUr3N8uOgQKSPK6k6/V+Lt3m5WBRkpPXEz86tA
         OHD7//UFLGOaQFIzvxP126mKf2nxPPaUGwyCNJE0KhFEMmgMwlaq1VjMB0sKdyp40K
         U/25vGS1e09oB7/8rEvF7YE/82NLqRHpKPh88dN8=
Date:   Fri, 23 Jul 2021 15:49:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

15 patches, based on 704f4cba43d4ed31ef4beb422313f1263d87bc55.

Subsystems affected by this patch series:

  mm/userfaultfd
  mm/kfence
  mm/highmem
  mm/pagealloc
  mm/memblock
  mm/pagecache
  mm/secretmem
  mm/pagemap
  mm/hugetlbfs

Subsystem: mm/userfaultfd

    Peter Collingbourne <pcc@google.com>:
    Patch series "userfaultfd: do not untag user pointers", v5:
      userfaultfd: do not untag user pointers
      selftest: use mmap instead of posix_memalign to allocate memory

Subsystem: mm/kfence

    Weizhao Ouyang <o451686892@gmail.com>:
      kfence: defer kfence_test_init to ensure that kunit debugfs is created

    Alexander Potapenko <glider@google.com>:
      kfence: move the size check to the beginning of __kfence_alloc()
      kfence: skip all GFP_ZONEMASK allocations

Subsystem: mm/highmem

    Christoph Hellwig <hch@lst.de>:
      mm: call flush_dcache_page() in memcpy_to_page() and memzero_page()
      mm: use kmap_local_page in memzero_page

Subsystem: mm/pagealloc

    Sergei Trofimovich <slyfox@gentoo.org>:
      mm: page_alloc: fix page_poison=1 / INIT_ON_ALLOC_DEFAULT_ON interaction

Subsystem: mm/memblock

    Mike Rapoport <rppt@linux.ibm.com>:
      memblock: make for_each_mem_range() traverse MEMBLOCK_HOTPLUG regions

Subsystem: mm/pagecache

    Roman Gushchin <guro@fb.com>:
      writeback, cgroup: remove wb from offline list before releasing refcnt
      writeback, cgroup: do not reparent dax inodes

Subsystem: mm/secretmem

    Mike Rapoport <rppt@linux.ibm.com>:
      mm/secretmem: wire up ->set_page_dirty

Subsystem: mm/pagemap

    Muchun Song <songmuchun@bytedance.com>:
      mm: mmap_lock: fix disabling preemption directly

    Qi Zheng <zhengqi.arch@bytedance.com>:
      mm: fix the deadlock in finish_fault()

Subsystem: mm/hugetlbfs

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlbfs: fix mount mode command line processing

 Documentation/arm64/tagged-address-abi.rst |   26 ++++++++++++++++++--------
 fs/fs-writeback.c                          |    3 +++
 fs/hugetlbfs/inode.c                       |    2 +-
 fs/userfaultfd.c                           |   26 ++++++++++++--------------
 include/linux/highmem.h                    |    6 ++++--
 include/linux/memblock.h                   |    4 ++--
 mm/backing-dev.c                           |    2 +-
 mm/kfence/core.c                           |   19 ++++++++++++++++---
 mm/kfence/kfence_test.c                    |    2 +-
 mm/memblock.c                              |    3 ++-
 mm/memory.c                                |   11 ++++++++++-
 mm/mmap_lock.c                             |    4 ++--
 mm/page_alloc.c                            |   29 ++++++++++++++++-------------
 mm/secretmem.c                             |    1 +
 tools/testing/selftests/vm/userfaultfd.c   |    6 ++++--
 15 files changed, 93 insertions(+), 51 deletions(-)

