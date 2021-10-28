Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF46C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54EEC610D2
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhJ1Vhh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230498AbhJ1Vhg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 17:37:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19B4A60FF2;
        Thu, 28 Oct 2021 21:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456909;
        bh=u9mGOWRBAB4hjOShzBuJ9vcfwLDcyVNUvUI9RgeA4yI=;
        h=Date:From:To:Cc:Subject:From;
        b=yrWMuAo/PJagRNgOMynXYX8djYlM6reikuEd7oFmnpPOj6IcjA8LKewvMzFqAzuX9
         n7mP9D/vzzTFGpu0iNHt3gxl2uYe+/9vqRnInlQqAbwxtwE3o3G4XeWe87z6BlIVen
         uYCgEhFfOgTqDsaV43DIAS0COWtrhRnb/A/X2v9E=
Date:   Thu, 28 Oct 2021 14:35:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

11 patches, based on 411a44c24a561e449b592ff631b7ae321f1eb559.

Subsystems affected by this patch series:

  mm/memcg
  mm/memory-failure
  mm/oom-kill
  ocfs2
  mm/secretmem
  mm/vmalloc
  mm/hugetlb
  mm/damon
  mm/tools

Subsystem: mm/memcg

    Shakeel Butt <shakeelb@google.com>:
      memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT

Subsystem: mm/memory-failure

    Yang Shi <shy828301@gmail.com>:
      mm: hwpoison: remove the unnecessary THP check
      mm: filemap: check if THP has hwpoisoned subpage for PMD page fault

Subsystem: mm/oom-kill

    Suren Baghdasaryan <surenb@google.com>:
      mm/oom_kill.c: prevent a race between process_mrelease and exit_mmap

Subsystem: ocfs2

    Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>:
      ocfs2: fix race between searching chunks and release journal_head from buffer_head

Subsystem: mm/secretmem

    Kees Cook <keescook@chromium.org>:
      mm/secretmem: avoid letting secretmem_users drop to zero

Subsystem: mm/vmalloc

    Chen Wandun <chenwandun@huawei.com>:
      mm/vmalloc: fix numa spreading for large hash tables

Subsystem: mm/hugetlb

    Rongwei Wang <rongwei.wang@linux.alibaba.com>:
      mm, thp: bail out early in collapse_file for writeback page

    Yang Shi <shy828301@gmail.com>:
      mm: khugepaged: skip huge page collapse for special files

Subsystem: mm/damon

    SeongJae Park <sj@kernel.org>:
      mm/damon/core-test: fix wrong expectations for 'damon_split_regions_of()'

Subsystem: mm/tools

    David Yang <davidcomponentone@gmail.com>:
      tools/testing/selftests/vm/split_huge_page_test.c: fix application of sizeof to pointer

 fs/ocfs2/suballoc.c                               |   22 ++++++++++-------
 include/linux/page-flags.h                        |   23 ++++++++++++++++++
 mm/damon/core-test.h                              |    4 +--
 mm/huge_memory.c                                  |    2 +
 mm/khugepaged.c                                   |   26 +++++++++++++-------
 mm/memory-failure.c                               |   28 +++++++++++-----------
 mm/memory.c                                       |    9 +++++++
 mm/oom_kill.c                                     |   23 +++++++++---------
 mm/page_alloc.c                                   |    8 +++++-
 mm/secretmem.c                                    |    2 -
 mm/vmalloc.c                                      |   15 +++++++----
 tools/testing/selftests/vm/split_huge_page_test.c |    2 -
 12 files changed, 110 insertions(+), 54 deletions(-)

