Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C113EC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351007AbiDAS3d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349076AbiDAS3c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA541AC732
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2106160DDF
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642FAC2BBE4;
        Fri,  1 Apr 2022 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837661;
        bh=gEPbvk9tmneMqjUIw2yexjgi3dPXWjjb/dk4zbG9Mx0=;
        h=Date:From:To:Cc:Subject:From;
        b=TbXO2j8IcKBJeUsmTNYXa03pZVMjyWSxxi2IkwALFq6VPGuXuJURs36qPQ/4xWlY5
         7otHVnoqNwrxwye9JQJ1gh258w7KL6nf/x+Lok7gwQQsIvWz6eJGFnjo2KVDoAROyi
         3ZGXw4n0vy7hLwIEpck7zpS5/SZqIhpgO0i00rE8=
Date:   Fri, 1 Apr 2022 11:27:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

16 patches, based on e8b767f5e04097aaedcd6e06e2270f9fe5282696.

Subsystems affected by this patch series:

  mm/madvise
  ofs2
  nilfs2
  mm/mlock
  mm/mfence
  mailmap
  mm/memory-failure
  mm/kasan
  mm/debug
  mm/kmemleak
  mm/damon

Subsystem: mm/madvise

    Charan Teja Kalla <quic_charante@quicinc.com>:
      Revert "mm: madvise: skip unmapped vma holes passed to process_madvise"

Subsystem: ofs2

    Joseph Qi <joseph.qi@linux.alibaba.com>:
      ocfs2: fix crash when mount with quota enabled

Subsystem: nilfs2

    Ryusuke Konishi <konishi.ryusuke@gmail.com>:
    Patch series "nilfs2 lockdep warning fixes":
      nilfs2: fix lockdep warnings in page operations for btree nodes
      nilfs2: fix lockdep warnings during disk space reclamation
      nilfs2: get rid of nilfs_mapping_init()

Subsystem: mm/mlock

    Hugh Dickins <hughd@google.com>:
      mm/munlock: add lru_add_drain() to fix memcg_stat_test
      mm/munlock: update Documentation/vm/unevictable-lru.rst

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm/munlock: protect the per-CPU pagevec by a local_lock_t

Subsystem: mm/kfence

    Muchun Song <songmuchun@bytedance.com>:
      mm: kfence: fix objcgs vector allocation

Subsystem: mailmap

    Kirill Tkhai <kirill.tkhai@openvz.org>:
      mailmap: update Kirill's email

Subsystem: mm/memory-failure

    Rik van Riel <riel@surriel.com>:
      mm,hwpoison: unmap poisoned page before invalidation

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
      mm, kasan: fix __GFP_BITS_SHIFT definition breaking LOCKDEP

Subsystem: mm/debug

    Yinan Zhang <zhangyinan2019@email.szu.edu.cn>:
      tools/vm/page_owner_sort.c: remove -c option
      doc/vm/page_owner.rst: remove content related to -c option

Subsystem: mm/kmemleak

    Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>:
      mm/kmemleak: reset tag when compare object pointer

Subsystem: mm/damon

    Jonghyeon Kim <tome01@ajou.ac.kr>:
      mm/damon: prevent activated scheme from sleeping by deactivated schemes

 .mailmap                             |    1 
 Documentation/vm/page_owner.rst      |    1 
 Documentation/vm/unevictable-lru.rst |  473 +++++++++++++++--------------------
 fs/nilfs2/btnode.c                   |   23 +
 fs/nilfs2/btnode.h                   |    1 
 fs/nilfs2/btree.c                    |   27 +
 fs/nilfs2/dat.c                      |    4 
 fs/nilfs2/gcinode.c                  |    7 
 fs/nilfs2/inode.c                    |  167 +++++++++++-
 fs/nilfs2/mdt.c                      |   45 ++-
 fs/nilfs2/mdt.h                      |    6 
 fs/nilfs2/nilfs.h                    |   16 -
 fs/nilfs2/page.c                     |   16 -
 fs/nilfs2/page.h                     |    1 
 fs/nilfs2/segment.c                  |    9 
 fs/nilfs2/super.c                    |    5 
 fs/ocfs2/quota_global.c              |   23 -
 fs/ocfs2/quota_local.c               |    2 
 include/linux/gfp.h                  |    4 
 mm/damon/core.c                      |    5 
 mm/gup.c                             |   10 
 mm/internal.h                        |    6 
 mm/kfence/core.c                     |   11 
 mm/kfence/kfence.h                   |    3 
 mm/kmemleak.c                        |    9 
 mm/madvise.c                         |    9 
 mm/memory.c                          |   12 
 mm/migrate.c                         |    2 
 mm/mlock.c                           |   46 ++-
 mm/page_alloc.c                      |    1 
 mm/rmap.c                            |    4 
 mm/swap.c                            |    4 
 tools/vm/page_owner_sort.c           |    6 
 33 files changed, 560 insertions(+), 399 deletions(-)

