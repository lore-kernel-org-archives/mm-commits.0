Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74696C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5927A610FA
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbhHTCEH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 22:04:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhHTCEH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 22:04:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E280C610F9;
        Fri, 20 Aug 2021 02:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629425010;
        bh=KAeBQ5AtRz2Mm/PElvr434VUmBO8VB6Rs0nEkm3B/qM=;
        h=Date:From:To:Cc:Subject:From;
        b=wlZN+nKc690gUY+Zt+PoEh+Jd1wMGLldrwYXanmuScb65Vn6tzNpWSjIaRCl2UDpu
         0VM1fxijAU3Eozg5NQB3EKTziE4O1cg+q+AMU056jA//WEh2JalJgkRdzae3Q1nPGQ
         ah/hCYYoK4IiO/0TrYNcbe7U9P9ZYyTkGSL7UAo8=
Date:   Thu, 19 Aug 2021 19:03:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210819190327.14fc4e97102e1af7929e30af@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

10 patches, based on 614cb2751d3150850d459bee596c397f344a7936.

Subsystems affected by this patch series:

  mm/shmem
  mm/pagealloc
  mm/tracing
  MAINTAINERS
  mm/memcg
  mm/memory-failure
  mm/vmscan
  mm/kfence
  mm/hugetlb

Subsystem: mm/shmem

    Yang Shi <shy828301@gmail.com>:
      Revert "mm/shmem: fix shmem_swapin() race with swapoff"
      Revert "mm: swap: check if swap backing device is congested or not"

Subsystem: mm/pagealloc

    Doug Berger <opendmb@gmail.com>:
      mm/page_alloc: don't corrupt pcppage_migratetype

Subsystem: mm/tracing

    Mike Rapoport <rppt@linux.ibm.com>:
      mmflags.h: add missing __GFP_ZEROTAGS and __GFP_SKIP_KASAN_POISON names

Subsystem: MAINTAINERS

    Nathan Chancellor <nathan@kernel.org>:
      MAINTAINERS: update ClangBuiltLinux IRC chat

Subsystem: mm/memcg

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: memcontrol: fix occasional OOMs due to proportional memory.low reclaim

Subsystem: mm/memory-failure

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm/hwpoison: retry with shake_page() for unhandlable pages

Subsystem: mm/vmscan

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: vmscan: fix missing psi annotation for node_reclaim()

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      kfence: fix is_kfence_address() for addresses below KFENCE_POOL_SIZE

Subsystem: mm/hugetlb

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlb: don't pass page cache pages to restore_reserve_on_error

 MAINTAINERS                    |    2 +-
 include/linux/kfence.h         |    7 ++++---
 include/linux/memcontrol.h     |   29 +++++++++++++++--------------
 include/trace/events/mmflags.h |    4 +++-
 mm/hugetlb.c                   |   19 ++++++++++++++-----
 mm/memory-failure.c            |   12 +++++++++---
 mm/page_alloc.c                |   25 ++++++++++++-------------
 mm/shmem.c                     |   14 +-------------
 mm/swap_state.c                |    7 -------
 mm/vmscan.c                    |   30 ++++++++++++++++++++++--------
 10 files changed, 81 insertions(+), 68 deletions(-)

