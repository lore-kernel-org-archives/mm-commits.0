Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225B6C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 23:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00A41610F7
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 23:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbhHMXyS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235659AbhHMXyS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Aug 2021 19:54:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D73C6610EA;
        Fri, 13 Aug 2021 23:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628898830;
        bh=MZOM38UAAAoHO05RgiGCICcKNHjuTWuV9+UtquAZ4Rs=;
        h=Date:From:To:Cc:Subject:From;
        b=ibNQE7oQykJca22KMSag5Y5O8SnGXuvBg9vv0dZxrudNKSzC23zvnE9zFI9sffAUJ
         XhssGto3xDBZkfo2pI6Q3xmDySn8ZsvPtEN6fvCGdgrquxfzGgsA79TYkLwKnJs9LR
         TEv/7Dq2zZRuP44HRlxe93+6Q/1ZNyRknEyRpkpM=
Date:   Fri, 13 Aug 2021 16:53:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210813165350.dc9afa56d27eadbd8ce629c0@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

7 patches, based on f8e6dfc64f6135d1b6c5215c14cd30b9b60a0008.

Subsystems affected by this patch series:

  mm/kasan
  mm/slub
  mm/madvise
  mm/memcg
  lib

Subsystem: mm/kasan

    Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>:
    Patch series "kasan, slub: reset tag when printing address", v3:
      kasan, kmemleak: reset tags when scanning block
      kasan, slub: reset tag when printing address

Subsystem: mm/slub

    Shakeel Butt <shakeelb@google.com>:
      slub: fix kmalloc_pagealloc_invalid_free unit test

    Vlastimil Babka <vbabka@suse.cz>:
      mm: slub: fix slub_debug disabling for list of slabs

Subsystem: mm/madvise

    David Hildenbrand <david@redhat.com>:
      mm/madvise: report SIGBUS as -EFAULT for MADV_POPULATE_(READ|WRITE)

Subsystem: mm/memcg

    Waiman Long <longman@redhat.com>:
      mm/memcg: fix incorrect flushing of lruvec data in obj_stock

Subsystem: lib

    Liang Wang <wangliang101@huawei.com>:
      lib: use PFN_PHYS() in devmem_is_allowed()

 lib/devmem_is_allowed.c |    2 +-
 mm/gup.c                |    7 +++++--
 mm/kmemleak.c           |    6 +++---
 mm/madvise.c            |    4 +++-
 mm/memcontrol.c         |    6 ++++--
 mm/slub.c               |   25 ++++++++++++++-----------
 6 files changed, 30 insertions(+), 20 deletions(-)

