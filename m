From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 3 Jul 2020 15:14:45 -0700
Message-ID: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgGCWOq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 18:14:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org

5 patches, based on cdd3bb54332f82295ed90cd0c09c78cd0c0ee822.

Subsystems affected by this patch series:

  mm/hugetlb
  samples
  mm/cma
  mm/vmalloc
  mm/pagealloc

Subsystem: mm/hugetlb

    Mike Kravetz <mike.kravetz@oracle.com>:
      mm/hugetlb.c: fix pages per hugetlb calculation

Subsystem: samples

    Kees Cook <keescook@chromium.org>:
      samples/vfs: avoid warning in statx override

Subsystem: mm/cma

    Barry Song <song.bao.hua@hisilicon.com>:
      mm/cma.c: use exact_nid true to fix possible per-numa cma leak

Subsystem: mm/vmalloc

    Christoph Hellwig <hch@lst.de>:
      vmalloc: fix the owner argument for the new __vmalloc_node_range callers

Subsystem: mm/pagealloc

    Joel Savitz <jsavitz@redhat.com>:
      mm/page_alloc: fix documentation error

 arch/arm64/kernel/probes/kprobes.c |    2 +-
 arch/x86/hyperv/hv_init.c          |    3 ++-
 kernel/module.c                    |    2 +-
 mm/cma.c                           |    4 ++--
 mm/hugetlb.c                       |    2 +-
 mm/page_alloc.c                    |    2 +-
 samples/vfs/test-statx.c           |    2 ++
 7 files changed, 10 insertions(+), 7 deletions(-)
