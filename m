Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A57DC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344601AbhLJWtV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239783AbhLJWtV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:49:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36749C061746
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 14:45:45 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D2BBFCE2D7E
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:45:42 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F8BB60E52;
        Fri, 10 Dec 2021 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176341;
        bh=1mrGD2IglnhFgTRvjfiB3dHpgk/GCyWqvHA0Diy/O2Y=;
        h=Date:From:To:Cc:Subject:From;
        b=JhBIxm42TWrUal8J3JDCguElqh8lK7DNL2ZhKADbQC2KPnPRk9JTAbKVaA6FHb8nE
         EdUnLdofKT4TIT1jxTAZ+IMa9P4B35rBYrtucZ7XQMV52wCwimfs07FemBphvJhrcv
         IgpfHVPIt56Sldaayb/6V22NJt2cuDXyIugTZrMU=
Date:   Fri, 10 Dec 2021 14:45:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

21 patches, based on c741e49150dbb0c0aebe234389f4aa8b47958fa8.

Subsystems affected by this patch series:

  mm/mlock
  MAINTAINERS
  mailmap
  mm/pagecache
  mm/damon
  mm/slub
  mm/memcg
  mm/hugetlb
  mm/pagecache

Subsystem: mm/mlock

    Drew DeVault <sir@cmpwn.com>:
      Increase default MLOCK_LIMIT to 8 MiB

Subsystem: MAINTAINERS

    Dave Young <dyoung@redhat.com>:
      MAINTAINERS: update kdump maintainers

Subsystem: mailmap

    Guo Ren <guoren@linux.alibaba.com>:
      mailmap: update email address for Guo Ren

Subsystem: mm/pagecache

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      filemap: remove PageHWPoison check from next_uptodate_page()

Subsystem: mm/damon

    SeongJae Park <sj@kernel.org>:
    Patch series "mm/damon: Fix fake /proc/loadavg reports", v3:
      timers: implement usleep_idle_range()
      mm/damon/core: fix fake load reports due to uninterruptible sleeps
    Patch series "mm/damon: Trivial fixups and improvements":
      mm/damon/core: use better timer mechanisms selection threshold
      mm/damon/dbgfs: remove an unnecessary error message
      mm/damon/core: remove unnecessary error messages
      mm/damon/vaddr: remove an unnecessary warning message
      mm/damon/vaddr-test: split a test function having >1024 bytes frame size
      mm/damon/vaddr-test: remove unnecessary variables
      selftests/damon: skip test if DAMON is running
      selftests/damon: test DAMON enabling with empty target_ids case
      selftests/damon: test wrong DAMOS condition ranges input
      selftests/damon: test debugfs file reads/writes with huge count
      selftests/damon: split test cases

Subsystem: mm/slub

    Gerald Schaefer <gerald.schaefer@linux.ibm.com>:
      mm/slub: fix endianness bug for alloc/free_traces attributes

Subsystem: mm/memcg

    Waiman Long <longman@redhat.com>:
      mm/memcg: relocate mod_objcg_mlstate(), get_obj_stock() and put_obj_stock()

Subsystem: mm/hugetlb

    Zhenguo Yao <yaozhenguo1@gmail.com>:
      hugetlbfs: fix issue of preallocation of gigantic pages can't work

Subsystem: mm/pagecache

    Manjong Lee <mj0123.lee@samsung.com>:
      mm: bdi: initialize bdi_min_ratio when bdi is unregistered

 .mailmap                                                       |    2 
 MAINTAINERS                                                    |    2 
 include/linux/delay.h                                          |   14 
 include/uapi/linux/resource.h                                  |   13 
 kernel/time/timer.c                                            |   16 -
 mm/backing-dev.c                                               |    7 
 mm/damon/core.c                                                |   20 -
 mm/damon/dbgfs.c                                               |    4 
 mm/damon/vaddr-test.h                                          |   85 ++---
 mm/damon/vaddr.c                                               |    1 
 mm/filemap.c                                                   |    2 
 mm/hugetlb.c                                                   |    2 
 mm/memcontrol.c                                                |  106 +++----
 mm/slub.c                                                      |   15 -
 tools/testing/selftests/damon/.gitignore                       |    2 
 tools/testing/selftests/damon/Makefile                         |    7 
 tools/testing/selftests/damon/_debugfs_common.sh               |   52 +++
 tools/testing/selftests/damon/debugfs_attrs.sh                 |  149 ++--------
 tools/testing/selftests/damon/debugfs_empty_targets.sh         |   13 
 tools/testing/selftests/damon/debugfs_huge_count_read_write.sh |   22 +
 tools/testing/selftests/damon/debugfs_schemes.sh               |   19 +
 tools/testing/selftests/damon/debugfs_target_ids.sh            |   19 +
 tools/testing/selftests/damon/huge_count_read_write.c          |   39 ++
 23 files changed, 363 insertions(+), 248 deletions(-)

