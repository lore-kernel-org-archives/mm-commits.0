Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADA9C48BDF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 01:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC7F6137D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 01:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFPBYz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 21:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhFPBYz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 21:24:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F07861159;
        Wed, 16 Jun 2021 01:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806569;
        bh=pmB55JS2Rt5AXR1Yz0Xo2Ir3kraoGtNJt72qP0z/f7g=;
        h=Date:From:To:Cc:Subject:From;
        b=fKhYRlYZQ13kZlw5W5mDLannJnHFnxEEUDMMiB+TSDRB/TS8wEd5pI73H9be/LlPw
         5Np6FXrHFdsqy2Kq3v5GiFjhS4xNQRuAN1HQ44m31fQgO4wnrMlkx4SkTlB2vP+fG2
         PdErdAeTUwWCdyi9zZ1nA1IRzmvfxK9C9wCxWp68=
Date:   Tue, 15 Jun 2021 18:22:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


18 patches, based on 94f0b2d4a1d0c52035aef425da5e022bd2cb1c71.

Subsystems affected by this patch series:

  mm/memory-failure
  mm/swap
  mm/slub
  mm/hugetlb
  mm/memory-failure
  coredump
  mm/slub
  mm/thp
  mm/sparsemem

Subsystem: mm/memory-failure

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm,hwpoison: fix race with hugetlb page allocation

Subsystem: mm/swap

    Peter Xu <peterx@redhat.com>:
      mm/swap: fix pte_same_as_swp() not removing uffd-wp bit when compare

Subsystem: mm/slub

    Kees Cook <keescook@chromium.org>:
    Patch series "Actually fix freelist pointer vs redzoning", v4:
      mm/slub: clarify verification reporting
      mm/slub: fix redzoning for small allocations
      mm/slub: actually fix freelist pointer vs redzoning

Subsystem: mm/hugetlb

    Mike Kravetz <mike.kravetz@oracle.com>:
      mm/hugetlb: expand restore_reserve_on_error functionality

Subsystem: mm/memory-failure

    yangerkun <yangerkun@huawei.com>:
      mm/memory-failure: make sure wait for page writeback in memory_failure

Subsystem: coredump

    Pingfan Liu <kernelfans@gmail.com>:
      crash_core, vmcoreinfo: append 'SECTION_SIZE_BITS' to vmcoreinfo

Subsystem: mm/slub

    Andrew Morton <akpm@linux-foundation.org>:
      mm/slub.c: include swab.h

Subsystem: mm/thp

    Xu Yu <xuyu@linux.alibaba.com>:
      mm, thp: use head page in __migration_entry_wait()

    Hugh Dickins <hughd@google.com>:
    Patch series "mm/thp: fix THP splitting unmap BUGs and related", v10:
      mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
      mm/thp: make is_huge_zero_pmd() safe and quicker
      mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
      mm/thp: fix vma_address() if virtual address below file offset

    Jue Wang <juew@google.com>:
      mm/thp: fix page_address_in_vma() on file THP tails

    Hugh Dickins <hughd@google.com>:
      mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()

    Yang Shi <shy828301@gmail.com>:
      mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

Subsystem: mm/sparsemem

    Miles Chen <miles.chen@mediatek.com>:
      mm/sparse: fix check_usemap_section_nr warnings

 Documentation/vm/slub.rst |   10 +--
 fs/hugetlbfs/inode.c      |    1 
 include/linux/huge_mm.h   |    8 ++
 include/linux/hugetlb.h   |    8 ++
 include/linux/mm.h        |    3 +
 include/linux/rmap.h      |    1 
 include/linux/swapops.h   |   15 +++--
 kernel/crash_core.c       |    1 
 mm/huge_memory.c          |   58 ++++++++++---------
 mm/hugetlb.c              |  137 +++++++++++++++++++++++++++++++++++++---------
 mm/internal.h             |   51 ++++++++++++-----
 mm/memory-failure.c       |   36 +++++++++++-
 mm/memory.c               |   41 +++++++++++++
 mm/migrate.c              |    1 
 mm/page_vma_mapped.c      |   27 +++++----
 mm/pgtable-generic.c      |    5 -
 mm/rmap.c                 |   41 +++++++++----
 mm/slab_common.c          |    3 -
 mm/slub.c                 |   37 +++++-------
 mm/sparse.c               |   13 +++-
 mm/swapfile.c             |    2 
 mm/truncate.c             |   43 ++++++--------
 22 files changed, 388 insertions(+), 154 deletions(-)

