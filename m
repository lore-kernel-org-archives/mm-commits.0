Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1566C07E96
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7FB66136E
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhGOE3E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhGOE3D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11B3D61360;
        Thu, 15 Jul 2021 04:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323170;
        bh=cA8Exoss1zcJ8vsqi0+kLWg0UzJGI5oGJKtX223WHLo=;
        h=Date:From:To:Cc:Subject:From;
        b=Z7Vap/dZeDQZUwRWQ/xIlLdUQrvPogPRi+jV29qLnTJamd7wu40RERwih7XaOXHeT
         6QQd7RfcsbP/xQ4mGtj2COCabLf6ytnwKI7fta6vLab96jf0fGZXP6AzFaA333YcCX
         h9uuLRdXYEuF6kxPhE0TCmP7e29hQqEKX7z7j5rI=
Date:   Wed, 14 Jul 2021 21:26:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

13 patches, based on 40226a3d96ef8ab8980f032681c8bfd46d63874e.

Subsystems affected by this patch series:

  mm/kasan
  mm/pagealloc
  mm/rmap
  mm/hmm
  hfs
  mm/hugetlb

Subsystem: mm/kasan

    Marco Elver <elver@google.com>:
      mm: move helper to check slub_debug_enabled

    Yee Lee <yee.lee@mediatek.com>:
      kasan: add memzero init for unaligned size at DEBUG

    Marco Elver <elver@google.com>:
      kasan: fix build by including kernel.h

Subsystem: mm/pagealloc

    Matteo Croce <mcroce@microsoft.com>:
      Revert "mm/page_alloc: make should_fail_alloc_page() static"

    Mel Gorman <mgorman@techsingularity.net>:
      mm/page_alloc: avoid page allocator recursion with pagesets.lock held

    Yanfei Xu <yanfei.xu@windriver.com>:
      mm/page_alloc: correct return value when failing at preparing

    Chuck Lever <chuck.lever@oracle.com>:
      mm/page_alloc: further fix __alloc_pages_bulk() return value

Subsystem: mm/rmap

    Christoph Hellwig <hch@lst.de>:
      mm: fix the try_to_unmap prototype for !CONFIG_MMU

Subsystem: mm/hmm

    Alistair Popple <apopple@nvidia.com>:
      lib/test_hmm: remove set but unused page variable

Subsystem: hfs

    Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>:
    Patch series "hfs: fix various errors", v2:
      hfs: add missing clean-up in hfs_fill_super
      hfs: fix high memory mapping in hfs_bnode_read
      hfs: add lock nesting notation to hfs_find_init

Subsystem: mm/hugetlb

    Joao Martins <joao.m.martins@oracle.com>:
      mm/hugetlb: fix refs calculation from unaligned @vaddr

 fs/hfs/bfind.c        |   14 +++++++++++++-
 fs/hfs/bnode.c        |   25 ++++++++++++++++++++-----
 fs/hfs/btree.h        |    7 +++++++
 fs/hfs/super.c        |   10 +++++-----
 include/linux/kasan.h |    1 +
 include/linux/rmap.h  |    4 +++-
 lib/test_hmm.c        |    2 --
 mm/hugetlb.c          |    5 +++--
 mm/kasan/kasan.h      |   12 ++++++++++++
 mm/page_alloc.c       |   30 ++++++++++++++++++++++--------
 mm/slab.h             |   15 +++++++++++----
 mm/slub.c             |   14 --------------
 12 files changed, 97 insertions(+), 42 deletions(-)

