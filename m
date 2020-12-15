Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6E7C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD61222BB
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgLOUhJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 15:37:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728518AbgLOUde (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 15:33:34 -0500
Date:   Tue, 15 Dec 2020 12:32:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608064374;
        bh=+mwwWWyXE0xTZVDQFtKVgq+37w3z616Suyx3zi3UyaM=;
        h=From:To:Cc:Subject:From;
        b=zh5Z8QAtyFxlbkjTGkUbChCIilyCP787F0KuAHaUkdGBfLPE9fTYnj626c9mykzfU
         Hg6HjQ4jimSmc2V0mmIppvl9VCvnUMC5kL/R1AWTfUT8v7IccGgLwzkl747TbNmmWc
         6BMJ4rqpcls5FUKUrRttpUIzJKmVDbsVmO2xRdz4=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


- more MM work: a memcg scalability improvememt

19 patches, based on 148842c98a24e508aecb929718818fbf4c2a6ff3.

Subsystems affected by this patch series:


    Alex Shi <alex.shi@linux.alibaba.com>:
    Patch series "per memcg lru lock", v21:
      mm/thp: move lru_add_page_tail() to huge_memory.c
      mm/thp: use head for head page in lru_add_page_tail()
      mm/thp: simplify lru_add_page_tail()
      mm/thp: narrow lru locking
      mm/vmscan: remove unnecessary lruvec adding
      mm/rmap: stop store reordering issue on page->mapping

    Hugh Dickins <hughd@google.com>:
      mm: page_idle_get_page() does not need lru_lock

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/memcg: add debug checking in lock_page_memcg
      mm/swap.c: fold vm event PGROTATED into pagevec_move_tail_fn
      mm/lru: move lock into lru_note_cost
      mm/vmscan: remove lruvec reget in move_pages_to_lru
      mm/mlock: remove lru_lock on TestClearPageMlocked
      mm/mlock: remove __munlock_isolate_lru_page()
      mm/lru: introduce TestClearPageLRU()
      mm/compaction: do page isolation first in compaction
      mm/swap.c: serialize memcg changes in pagevec_lru_move_fn
      mm/lru: replace pgdat lru_lock with lruvec lock

    Alexander Duyck <alexander.h.duyck@linux.intel.com>:
      mm/lru: introduce relock_page_lruvec()

    Hugh Dickins <hughd@google.com>:
      mm/lru: revise the comments of lru_lock

 Documentation/admin-guide/cgroup-v1/memcg_test.rst |   15 -
 Documentation/admin-guide/cgroup-v1/memory.rst     |   23 -
 Documentation/trace/events-kmem.rst                |    2 
 Documentation/vm/unevictable-lru.rst               |   22 -
 include/linux/memcontrol.h                         |  110 +++++++
 include/linux/mm_types.h                           |    2 
 include/linux/mmzone.h                             |    6 
 include/linux/page-flags.h                         |    1 
 include/linux/swap.h                               |    4 
 mm/compaction.c                                    |   98 ++++---
 mm/filemap.c                                       |    4 
 mm/huge_memory.c                                   |  109 ++++---
 mm/memcontrol.c                                    |   84 +++++-
 mm/mlock.c                                         |   93 ++----
 mm/mmzone.c                                        |    1 
 mm/page_alloc.c                                    |    1 
 mm/page_idle.c                                     |    4 
 mm/rmap.c                                          |   12 
 mm/swap.c                                          |  292 ++++++++-------------
 mm/vmscan.c                                        |  239 ++++++++---------
 mm/workingset.c                                    |    2 
 21 files changed, 644 insertions(+), 480 deletions(-)

