Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0CAC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 01:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22E6661164
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 01:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348957AbhIIBKI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 21:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbhIIBKI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 21:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D22C61158;
        Thu,  9 Sep 2021 01:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631149740;
        bh=10wTEHBk7YdVhh1zxYWzn9X6TrjdiRWw8GAwuZcQrdk=;
        h=Date:From:To:Cc:Subject:From;
        b=wbX1ycHA4BQdSusS/diP0G3cgGuatww7UbPK3KtZl17TN3oVYl88FeWIJ8IC7kDOo
         xmkc0dhqV2zPMhEmKM9XPLHsGchW/Jubn26T29nYkQ+YvxKHoNqxSPqRe+BTRYaJMQ
         nJiDqSBGGEHUAw7fTBmc2LF5ZHtTy3G6VYH9d7gk=
Date:   Wed, 8 Sep 2021 18:08:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210908180859.d523d4bb4ad8eec11c61500d@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


A bunch of hotfixes, mostly cc:stable.


8 patches, based on 2d338201d5311bcd79d42f66df4cecbcbc5f4f2c.

Subsystems affected by this patch series:

  mm/hmm
  mm/hugetlb
  mm/vmscan
  mm/pagealloc
  mm/pagemap
  mm/kmemleak
  mm/mempolicy
  mm/memblock

Subsystem: mm/hmm

    Li Zhijian <lizhijian@cn.fujitsu.com>:
      mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled

Subsystem: mm/hugetlb

    Liu Zixian <liuzixian4@huawei.com>:
      mm/hugetlb: initialize hugetlb_usage in mm_init

Subsystem: mm/vmscan

    Rik van Riel <riel@surriel.com>:
      mm,vmscan: fix divide by zero in get_scan_count

Subsystem: mm/pagealloc

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/page_alloc.c: avoid accessing uninitialized pcp page migratetype

Subsystem: mm/pagemap

    Liam Howlett <liam.howlett@oracle.com>:
      mmap_lock: change trace and locking order

Subsystem: mm/kmemleak

    Naohiro Aota <naohiro.aota@wdc.com>:
      mm/kmemleak: allow __GFP_NOLOCKDEP passed to kmemleak's gfp

Subsystem: mm/mempolicy

    yanghui <yanghui.def@bytedance.com>:
      mm/mempolicy: fix a race between offset_il_node and mpol_rebind_task

Subsystem: mm/memblock

    Mike Rapoport <rppt@linux.ibm.com>:
      nds32/setup: remove unused memblock_region variable in setup_memory()

 arch/nds32/kernel/setup.c |    1 -
 include/linux/hugetlb.h   |    9 +++++++++
 include/linux/mmap_lock.h |    8 ++++----
 kernel/fork.c             |    1 +
 mm/hmm.c                  |    5 ++++-
 mm/kmemleak.c             |    3 ++-
 mm/mempolicy.c            |   17 +++++++++++++----
 mm/page_alloc.c           |    4 +++-
 mm/vmscan.c               |    2 +-
 9 files changed, 37 insertions(+), 13 deletions(-)

