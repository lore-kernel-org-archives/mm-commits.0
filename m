Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58313C2B9F2
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A4FA611AB
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhEWAmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 20:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhEWAmj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 20:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B2B6115C;
        Sun, 23 May 2021 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621730473;
        bh=s15kR6gr7NHuuhXRwYyDgsLPrJIzz5X9Cw4nzbhsEek=;
        h=Date:From:To:Cc:Subject:From;
        b=QmPA7pRdeKmXZ4geNDQmpIlfPiOl6Q3iskMt/UIML6Svs0JYThRfPpzoQ+UtT6lKY
         mq0SxA3+ZLTOTm0NSMNjJnJm1GXAcylBpc0V5P0NSdv1sfPrIyxu0NkIa3/7wZrPNO
         +UyJzartHhfda4H7kA0vxLtEzLO+eUx1wxImAedw=
Date:   Sat, 22 May 2021 17:41:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210522174113.47fd4c853c0a1470c57deefa@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

10 patches, based on 4ff2473bdb4cf2bb7d208ccf4418d3d7e6b1652c.

Subsystems affected by this patch series:

  mm/pagealloc
  mm/gup
  ipc
  selftests
  mm/kasan
  kernel/watchdog
  bitmap
  procfs
  lib
  mm/userfaultfd

Subsystem: mm/pagealloc

    Arnd Bergmann <arnd@arndb.de>:
      mm/shuffle: fix section mismatch warning

Subsystem: mm/gup

    Michal Hocko <mhocko@suse.com>:
      Revert "mm/gup: check page posion status for coredump."

Subsystem: ipc

    Varad Gautam <varad.gautam@suse.com>:
      ipc/mqueue, msg, sem: avoid relying on a stack reference past its expiry

Subsystem: selftests

    Yang Yingliang <yangyingliang@huawei.com>:
      tools/testing/selftests/exec: fix link error

Subsystem: mm/kasan

    Alexander Potapenko <glider@google.com>:
      kasan: slab: always reset the tag in get_freepointer_safe()

Subsystem: kernel/watchdog

    Petr Mladek <pmladek@suse.com>:
      watchdog: reliable handling of timestamps

Subsystem: bitmap

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      linux/bits.h: fix compilation error with GENMASK

Subsystem: procfs

    Alexey Dobriyan <adobriyan@gmail.com>:
      proc: remove Alexey from MAINTAINERS

Subsystem: lib

    Zhen Lei <thunder.leizhen@huawei.com>:
      lib: kunit: suppress a compilation warning of frame size

Subsystem: mm/userfaultfd

    Mike Kravetz <mike.kravetz@oracle.com>:
      userfaultfd: hugetlbfs: fix new flag usage in error path

 MAINTAINERS                           |    1 -
 fs/hugetlbfs/inode.c                  |    2 +-
 include/linux/bits.h                  |    2 +-
 include/linux/const.h                 |    8 ++++++++
 include/linux/minmax.h                |   10 ++--------
 ipc/mqueue.c                          |    6 ++++--
 ipc/msg.c                             |    6 ++++--
 ipc/sem.c                             |    6 ++++--
 kernel/watchdog.c                     |   34 ++++++++++++++++++++--------------
 lib/Makefile                          |    1 +
 mm/gup.c                              |    4 ----
 mm/internal.h                         |   20 --------------------
 mm/shuffle.h                          |    4 ++--
 mm/slub.c                             |    1 +
 mm/userfaultfd.c                      |   28 ++++++++++++++--------------
 tools/include/linux/bits.h            |    2 +-
 tools/include/linux/const.h           |    8 ++++++++
 tools/testing/selftests/exec/Makefile |    6 +++---
 18 files changed, 74 insertions(+), 75 deletions(-)

