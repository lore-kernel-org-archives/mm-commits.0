Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F47EC5519F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20C5F2064B
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:51:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MP+RpnHI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgKNGvQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 01:51:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:32850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKNGvQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Nov 2020 01:51:16 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3D372224F;
        Sat, 14 Nov 2020 06:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336676;
        bh=hlNQW9Q/TQ1tyZf43a/OBZWkUjbSmZDYNSOOKVW7hx4=;
        h=Date:From:To:Cc:Subject:From;
        b=MP+RpnHIbWSk39/2rlqzDEhtP73Elp3XaWgq954ZqjlkXvjj7pfHeVgh+yIb17ivM
         GWkyhZPG5ji+HUQ0hf5nyro4D/jgFnGhQvuVU9UDmKT31iIE2Bs/ZW/ZhaFHYr99kf
         fVOKv7qkMWpWHIJ3IumHWs4l+GNfZu/JT1TxJsXU=
Date:   Fri, 13 Nov 2020 22:51:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

14 patches, based on 9e6a39eae450b81c8b2c8cbbfbdf8218e9b40c81.

Subsystems affected by this patch series:

  mm/migration
  mm/vmscan
  mailmap
  mm/slub
  mm/gup
  kbuild
  reboot
  kernel/watchdog
  mm/memcg
  mm/hugetlbfs
  panic
  ocfs2

Subsystem: mm/migration

    Zi Yan <ziy@nvidia.com>:
      mm/compaction: count pages and stop correctly during page isolation
      mm/compaction: stop isolation if too many pages are isolated and we have pages to migrate

Subsystem: mm/vmscan

    Nicholas Piggin <npiggin@gmail.com>:
      mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit

Subsystem: mailmap

    Dmitry Baryshkov <dbaryshkov@gmail.com>:
      mailmap: fix entry for Dmitry Baryshkov/Eremin-Solenikov

Subsystem: mm/slub

    Laurent Dufour <ldufour@linux.ibm.com>:
      mm/slub: fix panic in slab_alloc_node()

Subsystem: mm/gup

    Jason Gunthorpe <jgg@nvidia.com>:
      mm/gup: use unpin_user_pages() in __gup_longterm_locked()

Subsystem: kbuild

    Arvind Sankar <nivedita@alum.mit.edu>:
      compiler.h: fix barrier_data() on clang

Subsystem: reboot

    Matteo Croce <mcroce@microsoft.com>:
    Patch series "fix parsing of reboot= cmdline", v3:
      Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"
      reboot: fix overflow parsing reboot cpu number

Subsystem: kernel/watchdog

    Santosh Sivaraj <santosh@fossix.org>:
      kernel/watchdog: fix watchdog_allowed_mask not used warning

Subsystem: mm/memcg

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: fix missing wakeup polling thread

Subsystem: mm/hugetlbfs

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlbfs: fix anon huge page migration race

Subsystem: panic

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      panic: don't dump stack twice on warn

Subsystem: ocfs2

    Wengang Wang <wen.gang.wang@oracle.com>:
      ocfs2: initialize ip_next_orphan

 .mailmap                       |    5 +-
 fs/ocfs2/super.c               |    1 
 include/asm-generic/barrier.h  |    1 
 include/linux/compiler-clang.h |    6 --
 include/linux/compiler-gcc.h   |   19 --------
 include/linux/compiler.h       |   18 +++++++-
 include/linux/memcontrol.h     |   11 ++++-
 kernel/panic.c                 |    3 -
 kernel/reboot.c                |   28 ++++++------
 kernel/watchdog.c              |    4 -
 mm/compaction.c                |   12 +++--
 mm/gup.c                       |   14 ++++--
 mm/hugetlb.c                   |   90 ++---------------------------------------
 mm/memory-failure.c            |   36 +++++++---------
 mm/migrate.c                   |   46 +++++++++++---------
 mm/rmap.c                      |    5 --
 mm/slub.c                      |    2 
 mm/vmscan.c                    |    5 +-
 18 files changed, 119 insertions(+), 187 deletions(-)

