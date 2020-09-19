Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B39C43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EEEF21D43
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489168;
	bh=y/2RKh7AQVLahh2AO4WjOeOE0zquyjzDvuyOghtlybs=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=hVv5KIDLwBceXdYAEfSJYvaeKs4MWxLdEPQqLF0dBdkn5algbVsnPONVPStufL30e
	 YyYDvcYalPAY4ouewvlPpK3JRel/QTpp7i/GwCO/oehCNWy+Q1HKdwb+GjoT2p1BjQ
	 glvHXlz8MpdBwMiBg60544Ii1lZQz0d0KQD+9Z+I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgISET1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:19:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISET1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:19:27 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A07A320874;
        Sat, 19 Sep 2020 04:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489166;
        bh=y/2RKh7AQVLahh2AO4WjOeOE0zquyjzDvuyOghtlybs=;
        h=Date:From:To:Cc:Subject:From;
        b=lmo1+ws+qwbd5QkP4wEt/nDBr/C9zW0fpzkyxY3lxGJIJslO8LIod4KRi0gb+7iz2
         KU9SuSBZvrCT9XiuxdiTf1plWO9GhKzQumV34N+1VyD7O2x+Av316Flo7J+AdpAonj
         cbW0LZIMJqDeqcj7aKQaaopbuM4lTjxSClQ6Bu3w=
Date:   Fri, 18 Sep 2020 21:19:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

15 patches, based on 92ab97adeefccf375de7ebaad9d5b75d4125fe8b.

Subsystems affected by this patch series:

  mailmap
  mm/hotfixes
  mm/thp
  mm/memory-hotplug
  misc
  kcsan

Subsystem: mailmap

    Kees Cook <keescook@chromium.org>:
      mailmap: add older email addresses for Kees Cook

Subsystem: mm/hotfixes

    Hugh Dickins <hughd@google.com>:
    Patch series "mm: fixes to past from future testing":
      ksm: reinstate memcg charge on copied pages
      mm: migration of hugetlbfs page skip memcg
      shmem: shmem_writepage() split unlikely i915 THP
      mm: fix check_move_unevictable_pages() on THP
      mlock: fix unevictable_pgs event counts on THP

    Byron Stanoszek <gandalf@winds.org>:
      tmpfs: restore functionality of nr_inodes=0

    Muchun Song <songmuchun@bytedance.com>:
      kprobes: fix kill kprobe which has been marked as gone

Subsystem: mm/thp

    Ralph Campbell <rcampbell@nvidia.com>:
      mm/thp: fix __split_huge_pmd_locked() for migration PMD

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      selftests/vm: fix display of page size in map_hugetlb

Subsystem: mm/memory-hotplug

    Pavel Tatashin <pasha.tatashin@soleen.com>:
      mm/memory_hotplug: drain per-cpu pages again during memory offline

Subsystem: misc

    Tobias Klauser <tklauser@distanz.ch>:
      ftrace: let ftrace_enable_sysctl take a kernel pointer buffer
      stackleak: let stack_erasing_sysctl take a kernel pointer buffer
      fs/fs-writeback.c: adjust dirtytime_interval_handler definition to match prototype

Subsystem: kcsan

    Changbin Du <changbin.du@gmail.com>:
      kcsan: kconfig: move to menu 'Generic Kernel Debugging Instruments'

 .mailmap                                 |    4 ++
 fs/fs-writeback.c                        |    2 -
 include/linux/ftrace.h                   |    3 --
 include/linux/stackleak.h                |    2 -
 kernel/kprobes.c                         |    9 +++++-
 kernel/stackleak.c                       |    2 -
 kernel/trace/ftrace.c                    |    3 --
 lib/Kconfig.debug                        |    4 --
 mm/huge_memory.c                         |   42 ++++++++++++++++---------------
 mm/ksm.c                                 |    4 ++
 mm/memory_hotplug.c                      |   14 ++++++++++
 mm/migrate.c                             |    3 +-
 mm/mlock.c                               |   24 +++++++++++------
 mm/page_isolation.c                      |    8 +++++
 mm/shmem.c                               |   20 +++++++++++---
 mm/swap.c                                |    6 ++--
 mm/vmscan.c                              |   10 +++++--
 tools/testing/selftests/vm/map_hugetlb.c |    2 -
 18 files changed, 111 insertions(+), 51 deletions(-)

